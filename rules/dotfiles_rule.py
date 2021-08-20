# -*- coding: utf-8 -*-

import pathlib
from gitlint.rules import CommitRule, RuleViolation


REMAPS = {"emacs": True, "chezmoi": True}


class DotfileStart(CommitRule):
    name = "commit-title-should-start-with-dir-name"
    id = "UC1"

    def exists(self, config_name):
        for f in pathlib.Path().absolute().iterdir():
            filename = f.name.lstrip("dot_").lstrip(".")
            if (f.is_dir() or f.is_file()) and (
                filename == config_name or REMAPS.get(config_name, False)
            ):
                return True
        return False

    def validate(self, commit):
        title = commit.message.title.split(" ")
        config_name = (
            title[0].split(":")[0]
            if len(title) and len(title[0].split(":")) == 2
            else None
        )

        if config_name and self.exists(config_name):
            return

        msg = "Commit title does not comply with <config-name>: <message>"
        return [RuleViolation(self.id, msg, line_nr=0)]


class EnsureLower(CommitRule):
    name = "commit-title-should-be-lower-case"
    id = "UC2"

    def validate(self, commit):
        return (
            None
            if not all(
                (x.islower() or x.isspace() or x == ":") for x in commit.message.title
            )
            else [
                RuleViolation(
                    self.id, "Commit title should be all in lowercase", line_nr=0
                )
            ]
        )
