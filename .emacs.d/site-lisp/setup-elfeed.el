;; elfeed
(require 'elfeed)

(global-set-key (kbd "C-x w") 'elfeed)

(setq elfeed-feeds
      '(("https://feeds.feedburner.com/justinlilly" blog computer-science)
        ("https://feeds.feedburner.com/tweakers/mixed" tweakers tech news)
        ("http://rss.cnn.com/rss/edition.rss" cnn top-stories news)
        ("http://rss.cnn.com/rss/edition_world.rss" cnn world news)
        ("http://rss.cnn.com/rss/edition_europe.rss" cnn europe news)
        ("http://www.cartacapital.com.br/atom.xml" carta-capital news)
        ("http://feeds.sciencedaily.com/sciencedaily" daily-science news science)
        ("http://export.arxiv.org/rss/cs" computer-science news arxiv)
        ("https://www.schneier.com/blog/atom.xml" computer-science security news)
        ))
(setf url-queue-timeout 30)

(provide 'setup-elfeed)
