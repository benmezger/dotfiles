#!/usr/bin/env python
# -*- coding: utf-8 -*-
# -------------------------------------------------------------------------------
# Gitline
# by Markus Engelbrecht
#
# Credits
# * git-radar (https://github.com/michaeldfallen/git-radar)
# * gitHUD (https://github.com/gbataille/gitHUD)
#
# MIT License
# -------------------------------------------------------------------------------

from argparse import ArgumentParser
from string import Template
from subprocess import Popen, PIPE
from threading import Thread

from os import chdir, devnull, getenv, path

# Constants {{{

bash_fish_colors = {'gray': '\033[30m', 'red': '\033[31m', 'green': '\033[32m', 'yellow': '\033[33m',
                    'blue': '\033[34m', 'magenta': '\033[35m', 'cyan': '\033[36m', 'white': '\033[37m',
                    'reset': '\033[0m'}

zsh_colors = {'gray': '%F{gray}', 'red': '%F{red}', 'green': '%F{green}', 'yellow': '%F{yellow}', 'blue': '%F{blue}',
              'magenta': '%F{magenta}', 'cyan': '%F{cyan}', 'white': '%F{white}', 'reset': '%f'}


# }}}

# Utility functions {{{

def execute(cmd):
    with open(devnull) as DEVNULL:
        return Popen(cmd, stdout=PIPE, stderr=DEVNULL, universal_newlines=True).communicate()[0].rstrip()


def read_file(filename):
    try:
        with open(filename, 'r') as f:
            return f.read().rstrip()
    except IOError:
        return ''


def parse_int(s):
    try:
        return int(s)
    except ValueError:
        return 0


def parallel(tasks):
    threads = [Thread(target=task) for task in tasks]
    for thread in threads:
        thread.start()
    for thread in threads:
        thread.join()


def extract_branch_name(spec, replacement):
    spec = spec.replace('refs/heads/', '')
    return replacement + '/' + spec if replacement else spec


# }}}

# Repository parsing {{{

class Repository:
    def __init__(self):
        self.directory = ''
        self.git_directory = ''
        self.branch = ''
        self.remote = ''
        self.remote_tracking_branch = ''
        self.commit_hash = ''
        self.commit_tag = ''
        self.action = ''
        self.action_step = 0
        self.action_total = 0
        self.local_commits_to_pull = 0
        self.local_commits_to_push = 0
        self.remote_commits_to_pull = 0
        self.remote_commits_to_push = 0
        self.staged_added = 0
        self.staged_modified = 0
        self.staged_deleted = 0
        self.staged_renamed = 0
        self.staged_copied = 0
        self.unstaged_modified = 0
        self.unstaged_deleted = 0
        self.untracked = 0
        self.unmerged = 0
        self.stashes = 0


class RepositoryParser:
    def __init__(self):
        self.repo = Repository()

    @staticmethod
    def parse():
        return RepositoryParser()._parse()

    def _directory(self):
        self.repo.directory = execute(['git', 'rev-parse', '--show-toplevel'])

    def _git_directory(self):
        self.repo.git_directory = execute(['git', 'rev-parse', '--git-dir'])

    def _status(self):
        for code in [x[0:2] for x in execute(['git', 'status', '-z']).split('\0')]:
            if code in ["A ", "AD", "AM"]:
                self.repo.staged_added += 1
            if code in [" M", "AM", "CM", "RM"]:
                self.repo.unstaged_modified += 1
            if code in ["M ", "MD", "MM"]:
                self.repo.staged_modified += 1
            if code in [" D", "AD", "CD", "MD", "RD"]:
                self.repo.unstaged_deleted += 1
            if code in ["D ", "DM"]:
                self.repo.staged_deleted += 1
            if code in ["R ", "RD", "RM"]:
                self.repo.staged_renamed += 1
            if code in ["C ", "CA", "CD", "CM", "CR"]:
                self.repo.staged_copied += 1
            if code in ["AA", "AU", "DD", "DU", "UU", "UA", "UD"]:
                self.repo.unmerged += 1
            if code == "??":
                self.repo.untracked += 1

    def _branch(self):
        self.repo.branch = execute(['git', 'symbolic-ref', '--short', 'HEAD'])

    def _stashes(self):
        self.repo.stashes = len(list(filter(bool, execute(['git', 'stash', 'list']).splitlines())))

    def _commit_hash(self):
        self.repo.commit_hash = execute(['git', 'rev-parse', '--short', 'HEAD'])

    def _commit_tag(self):
        self.repo.commit_tag = execute(['git', 'describe', '--exact-match', '--tags'])

    def _action(self):
        git_dir = self.repo.git_directory
        rebase_merge_dir = path.join(git_dir, 'rebase-merge')
        if path.isdir(rebase_merge_dir):
            self.repo.action_step = parse_int(read_file(path.join(rebase_merge_dir, 'msgnum')))
            self.repo.action_total = parse_int(read_file(path.join(rebase_merge_dir, 'end')))
            self.repo.branch = extract_branch_name(read_file(path.join(rebase_merge_dir, 'head-name')), '')
            self.repo.action = 'rebase -i' if path.isfile(path.join(rebase_merge_dir, 'interactive')) else 'rebase -m'
            return

        rebase_apply_dir = path.join(git_dir, 'rebase-apply')
        if path.isdir(rebase_apply_dir):
            self.repo.action_step = parse_int(read_file(path.join(rebase_apply_dir, 'msgnum')))
            self.repo.action_total = parse_int(read_file(path.join(rebase_apply_dir, 'end')))
            if path.isfile(path.join(rebase_apply_dir, 'rebasing')):
                self.repo.branch = extract_branch_name(read_file(path.join(rebase_apply_dir, 'head-name')), '')
                self.repo.action = 'rebase'
            elif path.isfile(path.join(rebase_apply_dir, 'applying')):
                self.repo.action = 'am'
            else:
                self.repo.action = 'am/rebase'
            return

        if path.isfile(path.join(git_dir, 'MERGE_HEAD')):
            self.repo.action = 'merge'
            return

        if path.isfile(path.join(git_dir, 'CHERRY_PICK_HEAD')):
            self.repo.action = 'cherry-pick'
            return

        if path.isfile(path.join(git_dir, 'BISECT_LOG')):
            self.repo.action = 'bisect'
            return

        if path.isfile(path.join(git_dir, 'REVERT_HEAD')):
            self.repo.action = 'revert'
            return

    def _remote(self):
        self.repo.remote = execute(['git', 'config', '--get', 'branch.' + self.repo.branch + '.remote'])

    def _remote_tracking_branch(self):
        self.repo.remote_tracking_branch = extract_branch_name(
            execute(['git', 'config', '--get', 'branch.' + self.repo.branch + '.merge']), self.repo.remote)

    @staticmethod
    def _commits_to_pull(source, dest):
        return parse_int(
            execute(['git', 'rev-list', '--no-merges', '--left-only', '--count', source + '...' + dest]))

    @staticmethod
    def _commits_to_push(source, dest):
        return parse_int(
            execute(['git', 'rev-list', '--no-merges', '--right-only', '--count', source + '...' + dest]))

    def _local_commits_to_pull(self):
        self.repo.local_commits_to_pull = self._commits_to_pull(self.repo.remote_tracking_branch, 'HEAD')

    def _local_commits_to_push(self):
        self.repo.local_commits_to_push = self._commits_to_push(self.repo.remote_tracking_branch, 'HEAD')

    def _remote_commits_to_pull(self):
        self.repo.remote_commits_to_pull = self._commits_to_pull('origin/master', self.repo.remote_tracking_branch)

    def _remote_commits_to_push(self):
        self.repo.remote_commits_to_push = self._commits_to_push('origin/master', self.repo.remote_tracking_branch)

    def _merge_base(self):
        return execute(['git', 'merge-base', self.repo.remote_tracking_branch, 'origin/master'])

    def _parse(self):
        self._directory()
        if not self.repo.directory:
            return None

        parallel([self._status, self._git_directory, self._branch, self._stashes, self._commit_hash, self._commit_tag])
        self._action()  # Can change branch name
        self._remote()  # Depends on branch name
        self._remote_tracking_branch()  # Depends on remote name

        # Depend on remote tracking branch
        parallel([self._local_commits_to_pull, self._local_commits_to_push] +
                 ([self._remote_commits_to_pull, self._remote_commits_to_push] if self._merge_base() else []))
        return self.repo


# }}}

# Prompt building {{{

class PromptBuilder:
    def __init__(self, colors, repo):
        self.data = {}
        self.data.update(colors)
        self.data.update(vars(repo))
        self.sections = []
        self.current_section = []

    def add(self, env_key, env_default):
        self.current_section.append(Template(getenv('GITLINE_' + env_key, env_default)).substitute(self.data))

    def add_section(self):
        self.sections.append(self.current_section)
        self.current_section = []

    def build(self):
        self.add_section()
        return ' '.join(''.join(part) for part in self.sections if part)


def build_prompt(colors, repo):
    pb = PromptBuilder(colors, repo)
    pb.add_section()
    pb.add('REPO_INDICATOR', '${reset}ᚴ')

    pb.add_section()
    if repo.action:
        if repo.action_step and repo.action_total:
            pb.add('ACTION_STEPS',
                   '${yellow}${action}${reset} ${blue}${action_step}${reset}/${green}${action_total}${reset}')
        else:
            pb.add('ACTION', '${yellow}${action}${reset}')

    pb.add_section()
    if not repo.remote_tracking_branch and not repo.commit_tag:
        pb.add('NO_TRACKED_UPSTREAM', 'upstream ${red}⚡${reset}')

    pb.add_section()
    if repo.remote_commits_to_push and repo.remote_commits_to_pull:
        pb.add('REMOTE_COMMITS_PUSH_PULL', '𝘮 ${remote_commits_to_pull} ${yellow}⇄${reset} ${remote_commits_to_push}')
    elif repo.remote_commits_to_push:
        pb.add('REMOTE_COMMITS_PUSH', '𝘮 ${green}←${reset}${remote_commits_to_push}')
    elif repo.remote_commits_to_pull:
        pb.add('REMOTE_COMMITS_PULL', '𝘮 ${red}→${reset}${remote_commits_to_pull}')

    pb.add_section()
    if repo.branch:
        pb.add('BRANCH', '${branch}')
    elif repo.commit_tag:
        pb.add('COMMIT_TAG', '${commit_tag}')
    else:
        pb.add('DETACHED', '${red}detached@${commit_hash}${reset}')

    pb.add_section()
    if repo.local_commits_to_pull and repo.local_commits_to_push:
        pb.add('LOCAL_COMMITS_PUSH_PULL', '${local_commits_to_pull} ${yellow}⥯${reset} ${local_commits_to_push}')
    elif repo.local_commits_to_push:
        pb.add('LOCAL_COMMITS_PUSH', '${local_commits_to_push}${green}↑${reset}')
    elif repo.local_commits_to_pull:
        pb.add('LOCAL_COMMITS_PULL', '${local_commits_to_pull}${red}↓${reset}')

    pb.add_section()
    if repo.staged_added:
        pb.add('STAGED_ADDED', '${staged_added}${green}A${reset}')
    if repo.staged_modified:
        pb.add('STAGED_MODIFIED', '${staged_modified}${green}M${reset}')
    if repo.staged_deleted:
        pb.add('STAGED_DELETED', '${staged_deleted}${green}D${reset}')
    if repo.staged_renamed:
        pb.add('STAGED_RENAMED', '${staged_renamed}${green}R${reset}')
    if repo.staged_copied:
        pb.add('STAGED_COPIED', '${staged_copied}${green}C${reset}')

    pb.add_section()
    if repo.unstaged_modified:
        pb.add('UNSTAGED_MODIFIED', '${unstaged_modified}${red}M${reset}')
    if repo.unstaged_deleted:
        pb.add('UNSTAGED_DELETED', '${unstaged_deleted}${red}D${reset}')

    pb.add_section()
    if repo.untracked:
        pb.add('UNTRACKED', '${untracked}${white}A${reset}')

    pb.add_section()
    if repo.unmerged:
        pb.add('UNMERGED', '${unmerged}${yellow}U${reset}')

    pb.add_section()
    if repo.stashes:
        pb.add('STASHES', '${stashes}${yellow}≡${reset}')

    return pb.build()


# }}}

if __name__ == '__main__':
    parser = ArgumentParser()
    parser.add_argument('directory', nargs='?', help='directory to display git info for')
    parser.add_argument('--shell', default='bash', choices=['bash', 'fish', 'zsh'],
                        help='the shell output format to use')
    args = parser.parse_args()
    if args.directory:
        chdir(args.directory)

    r = RepositoryParser.parse()
    if r:
        print(build_prompt(zsh_colors if args.shell == 'zsh' else bash_fish_colors, r))
