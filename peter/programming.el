(require 'align-cljlet)
(require 'datomic-snippets)
(require 'clj-refactor)
(require 'dockerfile-mode)
(require 'aggressive-indent)

(add-hook 'emacs-lisp-mode-hook #'aggressive-indent-mode)
(add-hook 'clojure-mode-hook #'aggressive-indent-mode)
(add-hook 'css-mode-hook #'aggressive-indent-mode)

(add-hook 'clojure-mode-hook
          (lambda ()
            (clj-refactor-mode 1)
            (cljr-add-keybindings-with-prefix "s-r")))

(add-hook 'clojure-mode-hook
 (lambda ()
  (font-lock-add-keywords nil '(("\\<\\(FIXME\\|TODO\\|BUG\\|spy/d\\|spy/p\\|spy/t\\)" 1
                                 font-lock-warning-face t)))))

(defun magit-commit-mode-init ()
  (when (looking-at "\n")
    (open-line 1)))
(add-hook 'git-commit-mode-hook 'magit-commit-mode-init)

(require 'cider)
(defun cider-repl-reset ()
  (interactive)
  (save-some-buffers)
  (with-current-buffer (cider-current-repl-buffer)
    (goto-char (point-max))
    (insert "(user/reset)")
    (cider-repl-return)))

(setq cider-known-endpoints '(("peter-is-the-best.com" "4343")
			      ("peter-is-the-best.com" "4344")
			      ("localhost" "9991")
                              ("nr-t1" "9980")
                              ("nr-t2" "9981")
                              ("nr-t3" "9982")
                              ("nr-t4" "9983")
                              ("nr-t5" "9984")
                              ("nr-prod" "9995")))

(yas-global-mode 1)

(setq-default whitespace-line-column 90)
(global-whitespace-mode 1)
(add-hook 'before-save-hook 'whitespace-cleanup)

(defun kill-whitespace ()
          "Kill the whitespace between two non-whitespace characters"
          (interactive "*")
          (save-excursion
            (save-restriction
              (save-match-data
                (progn
                  (re-search-backward "[^ \t\r\n]" nil t)
                  (re-search-forward "[ \t\r\n]+" nil t)
                  (replace-match "" nil nil))))))
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; Teach compile the syntax of the kibit output
(require 'compile)
(add-to-list 'compilation-error-regexp-alist-alist
         '(kibit "At \\([^:]+\\):\\([[:digit:]]+\\):" 1 2 nil 0))
(add-to-list 'compilation-error-regexp-alist 'kibit)

;; A convenient command to run "lein kibit" in the project to which
;; the current emacs buffer belongs to.
(defun kibit ()
  "Run kibit on the current project.
Display the results in a hyperlinked *compilation* buffer."
  (interactive)
  (compile "lein kibit"))

(defun kibit-current-file ()
  "Run kibit on the current file.
Display the results in a hyperlinked *compilation* buffer."
  (interactive)
  (compile (concat "lein kibit " buffer-file-name)))

;; Dockerfile-mode
(add-to-list 'auto-mode-alist '("Dockerfile\\'" . dockerfile-mode))
