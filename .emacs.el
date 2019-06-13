(defvar my-org-root-dir)

(let ((path "~/.emacs_local_pre_custom.el"))
  (if (file-exists-p path)
    (load-file path)))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(auto-save-file-name-transforms (backquote ((".*" "~/.emacs.d/auto-save/" t))))
 '(backup-directory-alist (quote ((".*" . "~/.emacs.d/backup"))))
 '(column-number-mode t)
 '(custom-safe-themes
   (quote
    ("41c8c11f649ba2832347fe16fe85cf66dafe5213ff4d659182e25378f9cfc183" default)))
 '(debug-on-error t)
 '(default-frame-alist (quote ((fullscreen . maximized))))
 '(desktop-save t)
 '(desktop-save-mode t)
 '(enable-remote-dir-locals t)
 '(exec-path-from-shell-check-startup-files nil)
 '(global-hl-line-mode t)
 '(global-linum-mode t)
 '(helm-command-prefix-key "C-x h")
 '(helm-swoop-move-to-line-cycle t)
 '(helm-swoop-speed-or-color t)
 '(helm-swoop-split-direction 'split-window-vertically)
 '(helm-swoop-split-with-multiple-windows nil)
 '(helm-swoop-use-fuzzy-match t)
 '(helm-swoop-use-line-number-face t)
 '(indent-tabs-mode nil)
 '(js-indent-level 2)
 '(js2-basic-offset 2)
 '(js2-bounce-indent-p t)
 '(ledger-post-amount-alignment-column 80)
 '(mail-user-agent 'mu4e-user-agent)
 '(message-kill-buffer-on-exit t)
 '(mu4e-get-mail-command "offlineimap")
 '(mu4e-headers-date-format "%FT%T(%Z)")
 '(mu4e-headers-fields
   (quote
    ((:date . 24)
     (:flags . 6)
     (:mailing-list . 10)
     (:from . 22)
     (:subject))))
 '(mu4e-html2text-command "w3m -dump -cols 80 -T text/html")
 '(mu4e-update-interval 300)
 '(mu4e-view-show-images t)
 '(nrepl-log-messages t)
 `(org-agenda-files
   (quote
    (,(concat my-org-root-dir "TODO_habit.org")
     ,(concat my-org-root-dir "TODO.org")
     ;; "~/tmp/.emacs.d/org-gcal/gcal-me.org"
     ;; "~/tmp/.emacs.d/org-gcal/gcal-w-cel.org"
     ;; "~/tmp/.emacs.d/org-gcal/gcal-w-qbz.org"
     )))
 '(org-agenda-skip-deadline-if-done t)
 '(org-agenda-skip-scheduled-if-deadline-is-shown t)
 '(org-agenda-skip-scheduled-if-done t)
 '(org-agenda-skip-timestamp-if-done t)
 '(org-agenda-sorting-strategy
   (quote
    ((agenda priority-down user-defined-up category-keep)
     (todo priority-down category-keep)
     (tags priority-down category-keep)
     (search category-keep))))
 '(org-agenda-start-on-weekday 0)
 '(org-agenda-use-time-grid nil)
 '(org-babel-load-languages (quote ((emacs-lisp . t) (shell . t))))
 `(org-capture-templates
   (quote
    (("t" "TODO" entry
      (file ,(concat my-org-root-dir "TODO.org"))
      "** TODO %?
   SCHEDULED: %t"
      :empty-lines 1))))
 '(org-catch-invisible-edits (quote show-and-error))
 `(org-default-notes-file ,(concat my-org-root-dir "TODO.org"))
 '(org-default-priority 67)
 '(org-goto-auto-isearch nil)
 '(org-habit-following-days 2)
 '(org-habit-graph-column 72)
 '(org-habit-preceding-days 7)
 '(org-id-link-to-org-use-id (quote create-if-interactive-and-no-custom-id))
 '(org-log-done (quote time))
 '(org-log-into-drawer t)
 '(org-lowest-priority 69)
 '(org-modules
   (quote
    (org-bbdb org-bibtex org-docview org-gnus org-habit org-id org-info org-irc org-mhe org-rmail org-w3m)))
 '(org-priority-faces
   (quote
    ((65 :foreground "red")
     (66 :foreground "yellow"))))
 '(projectile-completion-system (quote helm))
 '(projectile-keymap-prefix (kbd "C-c M-c M-p"))
 '(savehist-mode t)
 '(show-trailing-whitespace t)
 '(truncate-lines t)
 '(visible-bell nil)
 '(web-mode-code-indent-offset 2)
 '(web-mode-css-indent-offset 2)
 '(web-mode-markup-indent-offset 2)
 '(web-mode-script-padding 2)
 '(web-mode-attr-indent-offset 2))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(defalias 'yes-or-no-p 'y-or-n-p)
(make-directory (expand-file-name "desktop/" user-emacs-directory) :parents)
(make-directory (expand-file-name "auto-save/" user-emacs-directory) :parents)

(require 'package)
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (proto (if no-ssl "http" "https")))
  (setq package-archives '())
  ;; Comment/uncomment these two lines to enable/disable MELPA and MELPA Stable as desired
  (add-to-list 'package-archives (cons "melpa" (concat proto "://melpa.org/packages/")) t)
  ;;(add-to-list 'package-archives (cons "melpa-stable" (concat proto "://stable.melpa.org/packages/")) t)
  (add-to-list 'package-archives (cons "gnu" (concat proto "://elpa.gnu.org/packages/")) t)
  (setq package-archive-priorities '((melpa . 10)
                                     (gnu . 5))))
(package-initialize)

(when (not (package-installed-p 'use-package))
  (package-refresh-contents)
  (package-install 'use-package))
(eval-when-compile
  (require 'use-package))
(defmacro use-package-customize-load-path (name load-path-fn &rest args)
  `(use-package ,name
     ,@(let ((load-path load-path-fn))
         (if load-path
             '(:load-path load-path)
           '()))
     ,@args))

(use-package benchmark-init
  :ensure t
  :demand t
  :hook (after-init . benchmark-init/deactivate))

(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(add-hook 'dired-load-hook
          (lambda ()
            (load "dired-x")))
(add-hook 'dired-mode-hook
          (lambda ()))

(use-package exec-path-from-shell
  :ensure t
  :demand t
  :config
  (exec-path-from-shell-initialize)
  (exec-path-from-shell-copy-env "MANPATH")
  (exec-path-from-shell-copy-env "GOPATH"))

(use-package epg
  :ensure t)
(let ((path "~/.emacs_secret.el"))
  (if (file-exists-p path)
    (load-file path)))

(use-package epkg
  :ensure t)

(use-package visual-fill-column
  :ensure t
  :hook (visual-line-mode))

(use-package woman
  :ensure t
  :config (setq woman-path (woman-parse-colon-path (getenv "MANPATH"))))

(use-package async
  :ensure t
  :config (dired-async-mode 1))

(use-package request
  :ensure t)

(use-package projectile
  :ensure t
  :demand t
  :config
  (projectile-mode 1))

;; Org
(use-package org
  :straight t
  :ensure t
  :commands (org-store-link org-agenda org-capture org-switchb)
  :init
  (require 'cl-extra)
  :config
  (require 'org-id)
  (defun my-org-agenda-cmp (a b)
    (cond ((< a b) -1)
          ((= a b) 0)
          (t 1)))
  (defun my-org-agenda-cmp-time-truncated (time-1 time-2)
    (let ((cmp-seq (mapcar* #'my-org-agenda-cmp time-1 time-2)))
      (seq-reduce (lambda (v e)
                    (if (not (= v 0))
                        v
                      e))
                  cmp-seq
                  0)))
  (defun my-org-agenda-cmp-time (time-1 time-2)
    (let* ((time-1-len (if time-1
                           (length time-1)
                         0))
           (time-2-len (if time-2
                           (length time-2)
                         0)))
      (cond ((not time-1) 1)
            ((not time-2) -1)
            (t (let ((cmp (my-org-agenda-cmp-time-truncated time-1 time-2)))
                 (cond ((< cmp 0) -1)
                       ((= cmp 0) (my-org-agenda-cmp time-2-len time-1-len))
                       (t 1)))))))
  (defun my-org-agenda-cmp-user-defined (a b)
    (let* ((a-pos (get-text-property 0 'org-marker a))
           (b-pos (get-text-property 0 'org-marker b))
           (a-deadline-time (org-get-deadline-time a-pos))
           (a-scheduled-time (org-get-scheduled-time a-pos))
           (b-deadline-time (org-get-deadline-time b-pos))
           (b-scheduled-time (org-get-scheduled-time b-pos))
           (a-time (if (<= (my-org-agenda-cmp-time a-deadline-time a-scheduled-time) 0)
                       a-deadline-time
                     a-scheduled-time))
           (b-time (if (<= (my-org-agenda-cmp-time b-deadline-time b-scheduled-time) 0)
                       b-deadline-time
                     b-scheduled-time)))
      (my-org-agenda-cmp-time a-time b-time)))
  (setq org-agenda-cmp-user-defined #'my-org-agenda-cmp-user-defined)
  (defun my-org-agenda-color (tag-re foreground)
    ""
    (interactive)
    (save-excursion
      (goto-char (point-min))
      (while (re-search-forward tag-re nil t)
        (add-text-properties
         (match-beginning 0) (match-end 0)
         `(face (:foreground ,foreground))))))
  (define-key org-mode-map (kbd "C-c M-c") nil)
  :hook
  (org-agenda-finalize . (lambda ()
                           (my-org-agenda-color "^  TODO: +" "chartreuse4")
                           (my-org-agenda-color "^  TODO_habit: +" "IndianRed3")))
  :bind (("C-c l" . org-store-link)
         ("C-c a" . org-agenda)
         ("C-c c" . org-capture)
         ("C-c b" . org-switchb)
         ("C-c o r" . org-revert-all-org-buffers)))

;; Calendar
(use-package org-gcal
  :ensure t
  :commands (org-gcal-fetch)
  :config
  (setq org-gcal-client-id "896903804596-eh9eeb30bmnkgfm839gkpem3pkr43ei1.apps.googleusercontent.com")
  (setq org-gcal-file-alist
        '(("me@alyssackwan.name" . "~/tmp/.emacs.d/org-gcal/gcal-me.org")
          ("alyssa.kwan@infallisys.com" . "~/tmp/.emacs.d/org-gcal/gcal-w-cel.org")
          ("alyssa@qbizinc.com" . "~/tmp/.emacs.d/org-gcal/gcal-w-qbz.org")))
  ;; :hook
  ;; (org-agenda-mode . org-gcal-fetch)
  )
(use-package calfw
  :ensure t
  :demand t
  :config
  (defun my-cfw-open-calendar ()
    (interactive)
    (cfw:open-calendar-buffer
     :contents-sources (list (cfw:org-create-source "IndianRed"))))
  :bind (("C-c M-c M-c" . my-cfw-open-calendar)))
(use-package calfw-org
  :ensure t
  :demand t
  :after (calfw))

;; Edit Server
(use-package edit-server
  :ensure t
  :demand t
  :config (edit-server-start))

(use-package gmail-message-mode
  :ensure t
  :demand t
  :after (edit-server)
  :hook (gmail-message-mode . turn-on-visual-line-mode))

;; Company
(use-package company
  :ensure t
  :demand t
  :commands (company-complete)
  :config (global-company-mode)
  :bind (("C-<tab>" . company-complete)))

;; Helm
(use-package helm
  :ensure t
  :demand t
  :commands (helm-M-x helm-show-kill-ring helm-mini helm-find-files helm-occur helm-all-mark-rings)
  :config (helm-mode 1)
  :bind (("M-x" . helm-M-x)
         ("M-y" . helm-show-kill-ring)
         ("C-x b" . helm-mini)
         ("C-x C-f" . helm-find-files)
         ("C-c h o" . helm-occur)
         ("C-h <spc>" . helm-all-mark-rings)))

(use-package helm-projectile
  :ensure t
  :demand t
  :after (helm)
  :config (helm-projectile-on))

(use-package helm-company
  :ensure t
  :demand t
  :after (helm company))

(use-package helm-swoop
  :ensure t
  :demand t
  :after (helm)
  :config
  (setq helm-multi-swoop-edit-save t)
  (define-key isearch-mode-map (kbd "C-h") 'helm-swoop-from-isearch)
  (define-key helm-swoop-map (kbd "M-S") 'helm-multi-swoop-all-from-helm-swoop)
  (define-key helm-swoop-map (kbd "C-s") 'helm-next-line)
  (define-key helm-swoop-map (kbd "C-r") 'helm-previous-line)
  (define-key helm-multi-swoop-map (kbd "C-s") 'helm-next-line)
  (define-key helm-multi-swoop-map (kbd "C-r") 'helm-previous-line)
  :bind (("C-c C-s" . helm-swoop)
         ("C-c C-r" . helm-show-back-to-last-point)
         ("C-c M-s" . helm-multi-swoop)
         ("C-c M-S" . helm-multi-swoop-all)))

;; Flycheck
(use-package flycheck
  :ensure t
  :demand t
  :config (global-flycheck-mode))

;; Magit
(use-package magit
  :ensure t
  :commands (magit-status magit-dispatch-popup)
  :bind (("C-x g" . magit-status)
         ("C-x M-g" . magit-dispatch-popup)))

(use-package lsp-mode
  :ensure t
  :demand t)
(use-package lsp-ui
  :ensure t
  :demand t
  :after (lsp-mode))
(use-package company-lsp
  :ensure t
  :demand t
  :after (lsp-mode company))

;; Clojure
;; Cider
(use-package clojure-mode
  :ensure t)
(use-package cider
  :ensure t
  :demand t
  :after (clojure-mode company-mode)
  :hook ((cider-repl-mode-hook . company-mode)
         (cider-mode-hook . company-mode))
  :config
  (define-key cider-mode-map (kbd "C-c M-c") nil)
  (cider-register-cljs-repl-type
   'figwheel--chestnut
   "(do (user/go) (user/cljs-repl))"
   'cider-check-figwheel-requirements))
(use-package midje-mode
  :ensure t
  :after (clojure-mode)
  :hook (clojure-mode)
  :config
  (let ((prefix-map (lookup-key midje-mode-map (kbd "C-c"))))
    (define-key midje-mode-map (kbd "C-c") nil)
    (define-key midje-mode-map (kbd "C-c C-m") prefix-map)))

;; Paredit
(use-package paredit
  :ensure t
  :commands (paredit-mode)
  :hook ((eval-expression-minibuffer-setup
          ielm-mode
          lisp-mode
          lisp-interaction-mode
          scheme-mode
          clojure-mode
          cider-repl-mode
          emacs-lisp-mode)
         . paredit-mode))

;; Haskell
(use-package haskell-mode
  :ensure t)
(use-package intero
  :ensure t
  :hook (haskell-mode . intero-mode))

;; Go
(use-package go-mode
  :ensure t
  :bind (:map
         go-mode-map
         ("M-." . godef-jump)
         ("M-*" . pop-tag-mark))
  :hook (go-mode-hook . (lambda ()
                          (make-local-variable 'before-save-hook)
                          (add-hook 'before-save-hook #'gofmt-before-save)))
  :config
  (if (not (string-match "go" compile-command))
      (set (make-local-variable 'compile-command)
           "go build -v && go test -v && go vet")))
(use-package company-go
  :ensure t
  :after (go-mode)
  :hook (go-mode . (lambda ()
                     (set (make-local-variable 'company-backends) '(company-go))))
  :commands (company-go))

;; Python
(use-package pyenv-mode-auto
  :ensure t)
;; (use-package lsp-python
;;   :ensure t
;;   :commands (lsp-python-enable)
;;   :hook (python-mode . lsp-python-enable))

;; Java
(use-package lsp-java
  :ensure t
  :commands (lsp-java-enable)
  :hook (java-mode . lsp-java-enable))

;; JavaScript
(use-package js2-mode
  :ensure t)
(use-package rjsx-mode
  :ensure t)

;; Web
(use-package web-mode
  :ensure t
  :mode ("\\.jsx?\\'"
         "\\.phtml\\'"
         "\\.tpl\\.php\\'"
         "\\.[agj]sp\\'"
         "\\.as[cp]x\\'"
         "\\.erb\\'"
         "\\.mustache\\'"
         "\\.djhtml\\'"
         "\\.html?\\'")
  :hook (web-mode . (lambda ()
                      (when (equal web-mode-content-type "javascript")
                        (web-mode-set-content-type "jsx"))
                      (company-mode))))

(use-package company-tern
  :ensure t
  :hook ((js2-mode . (lambda ()
                       (set (make-local-variable 'company-backends) '(company-tern))))
         (rjsx-mode . (lambda ()
                        (set (make-local-variable 'company-backends) '(company-tern))))
         (web-mode . (lambda ()
                       (set (make-local-variable 'company-backends) '(company-tern)))))
  :commands (company-tern))

(use-package company-web
  :ensure t)

(defadvice company-tern (before web-mode-set-up-ac-sources activate)
  "Set `tern-mode' based on current language before running company-tern."
  (if (equal major-mode 'web-mode)
      (let ((web-mode-cur-language
             (web-mode-language-at-pos)))
        (if (or (string= web-mode-cur-language "jsx")
                (string= web-mode-cur-language "javascript"))
            (unless tern-mode (tern-mode))
          (if tern-mode (tern-mode))))))

;; Ruby
(use-package groovy-mode
  :ensure t)
(use-package rhtml-mode
  :ensure t
  :mode ("\\.html\\.erb\\'"))
(use-package rinari
  :hook (rhtml-mode . rinari-launch)
  :commands (rinari-launch))

;; Agda
(use-package agda2-mode
  :mode ("\\.agda'"))

;; YAML
(use-package yaml-mode
  :ensure t)

;; TeX
(use-package tex
  :ensure auctex
  :init
  (setq TeX-auto-save t)
  (setq TeX-parse-self t)
  (setq-default TeX-master nil))
(use-package company-auctex
  :ensure t
  :after (tex company)
  :hook (TeX . company-auctex))

(use-package vagrant-tramp
  :ensure t
  :demand t)

;; pass
(use-package pass
  :ensure t
  :commands (pass))
(use-package lastpass
  :ensure t
  :config
  (setq lastpass-user "me@alyssackwan.name"))

;; Email
(use-package w3m
  :ensure t)
(use-package smtpmail
  :ensure t
  :config
  (setq message-send-mail-function 'smtpmail-send-it))
(use-package-customize-load-path
 mu4e
 (lambda ()
   (when (memq system-type '(darwin))
     "~/opt/homebrew/Cellar/mu/1.0/share/emacs/site-lisp/mu/mu4e/"))
 :after (w3m)
 :config
 (imagemagick-register-types)
 (add-to-list 'mu4e-view-actions '("ViewInBrowser" . mu4e-action-view-in-browser) t)
 (setq mail-user-agent 'mu4e-user-agent
       mu4e-maildir "~/.offlineimap.d/maildir"
       mu4e-contexts `(,(make-mu4e-context
                         :name "_ jennykwan@countermail.com"
                         :vars '((mu4e-drafts-folder . "/jennykwan@countermail.com/Drafts")
                                 (mu4e-sent-folder . "/jennykwan@countermail.com/Sent")
                                 (mu4e-trash-folder . "/jennykwan@countermail.com/Trash")
                                 (mu4e-sent-messages-behavior . 'delete)
                                 (user-mail-address . "jennykwan@countermail.com")
                                 (user-full-name  . "Jenny Kwan")))
                       ,(make-mu4e-context
                         :name "- me@jennykwan.org"
                         :vars '((mu4e-drafts-folder . "/me@jennykwan.org/[Gmail].Drafts")
                                 (mu4e-sent-folder . "/me@jennykwan.org/[Gmail].Sent Mail")
                                 (mu4e-trash-folder . "/me@jennykwan.org/[Gmail].Trash")
                                 (mu4e-sent-messages-behavior . 'delete)
                                 (user-mail-address . "me@jennykwan.org")
                                 (user-full-name  . "Jenny Kwan")
                                 (starttls-use-gnutls . t)
                                 (smtpmail-starttls-credentials . '(("smtp.gmail.com" 587 nil nil)))
                                 (smtpmail-auth-credentials . '(("smtp.gmail.com" 587 "me@jennykwan.org" nil)))
                                 (smtpmail-default-smtp-server . "smtp.gmail.com")
                                 (smtpmail-smtp-server . "smtp.gmail.com")
                                 (smtpmail-smtp-service . 587)))
                       ,(make-mu4e-context
                         :name "w jenny.kwan@woodlamp.tech"
                         :vars '((mu4e-drafts-folder . "/jenny.kwan@woodlamp.tech/[Gmail].Drafts")
                                 (mu4e-sent-folder . "/jenny.kwan@woodlamp.tech/[Gmail].Sent Mail")
                                 (mu4e-trash-folder . "/jenny.kwan@woodlamp.tech/[Gmail].Trash")
                                 (mu4e-sent-messages-behavior . 'delete)
                                 (user-mail-address . "jenny.kwan@woodlamp.tech")
                                 (user-full-name  . "Jenny Kwan")
                                 (starttls-use-gnutls . t)
                                 (smtpmail-starttls-credentials . '(("smtp.gmail.com" 587 nil nil)))
                                 (smtpmail-auth-credentials . '(("smtp.gmail.com" 587 "jenny.kwan@woodlamp.tech" nil)))
                                 (smtpmail-default-smtp-server . "smtp.gmail.com")
                                 (smtpmail-smtp-server . "smtp.gmail.com")
                                 (smtpmail-smtp-service . 587)))
                       ,(make-mu4e-context
                         :name "a alyssackwan@hushmail.com"
                         :vars '((mu4e-drafts-folder . "/alyssackwan@hushmail.com/Drafts")
                                 (mu4e-sent-folder . "/alyssackwan@hushmail.com/Sent")
                                 (mu4e-trash-folder . "/alyssackwan@hushmail.com/Trash")
                                 (mu4e-sent-messages-behavior . 'delete)
                                 (user-mail-address . "alyssackwan@hushmail.com")
                                 (user-full-name  . "Alyssa Kwan")
                                 (starttls-use-gnutls . t)
                                 (smtpmail-starttls-credentials . '(("smtp.hushmail.com" 465 nil nil)))
                                 (smtpmail-auth-credentials . '(("smtp.hushmail.com" 465 "me@alyssackwan.name" nil)))
                                 (smtpmail-default-smtp-server . "smtp.hushmail.com")
                                 (smtpmail-smtp-server . "smtp.hushmail.com")
                                 (smtpmail-smtp-service . 465)))
                       ,(make-mu4e-context
                         :name "s superadmin@alyssackwan.name"
                         :vars '((mu4e-drafts-folder . "/superadmin@alyssackwan.name/[Gmail].Drafts")
                                 (mu4e-sent-folder . "/superadmin@alyssackwan.name/[Gmail].Sent Mail")
                                 (mu4e-trash-folder . "/superadmin@alyssackwan.name/[Gmail].Trash")
                                 (mu4e-sent-messages-behavior . 'delete)
                                 (user-mail-address . "superadmin@alyssackwan.name")
                                 (user-full-name  . "Alyssa Kwan")
                                 (starttls-use-gnutls . t)
                                 (smtpmail-starttls-credentials . '(("smtp.gmail.com" 587 nil nil)))
                                 (smtpmail-auth-credentials . '(("smtp.gmail.com" 587 "superadmin@alyssackwan.name" nil)))
                                 (smtpmail-default-smtp-server . "smtp.gmail.com")
                                 (smtpmail-smtp-server . "smtp.gmail.com")
                                 (smtpmail-smtp-service . 587)))
                       ,(make-mu4e-context
                         :name "A alyssa.c.kwan@gmail.com"
                         :vars '((mu4e-drafts-folder . "/alyssa.c.kwan@gmail.com/[Gmail].Drafts")
                                 (mu4e-sent-folder . "/alyssa.c.kwan@gmail.com/[Gmail].Sent Mail")
                                 (mu4e-trash-folder . "/alyssa.c.kwan@gmail.com/[Gmail].Trash")
                                 (mu4e-sent-messages-behavior . 'delete)
                                 (user-mail-address . "alyssa.c.kwan@gmail.com")
                                 (user-full-name  . "Alyssa Kwan")
                                 (starttls-use-gnutls . t)
                                 (smtpmail-starttls-credentials . '(("smtp.gmail.com" 587 nil nil)))
                                 (smtpmail-auth-credentials . '(("smtp.gmail.com" 587 "alyssa.c.kwan@gmail.com" nil)))
                                 (smtpmail-default-smtp-server . "smtp.gmail.com")
                                 (smtpmail-smtp-server . "smtp.gmail.com")
                                 (smtpmail-smtp-service . 587)))))
 :hook ((mu4e-compose-mode . (lambda ()
                               (set-fill-column 72)
                               (flyspell-mode)))))

;; Beancount
(use-package beancount
  :load-path "~/.beancount/editors/emacs"
  :mode
  ("\\.beancount\\'" . beancount-mode)
  ("\\.beancount\\.org\\'" . beancount-mode)
  :config (setq beancount-install-dir "~/.pyenv/versions/3.7.0"))

;; (use-package darcula-theme
;;   :ensure t)
(use-package moe-theme
  :ensure t)

(let ((path "~/setup/.emacs_secret.el.gpg"))
  (if (file-exists-p path)
    (load-file path)))

(let ((path "~/.emacs_local.el"))
  (if (file-exists-p path)
    (load-file path)))

(let ((path "~/.emacs_custom_set.el"))
  (if (file-exists-p path)
    (delete-file path))
  (setq custom-file path)
  (customize-save-customized))
(load custom-file)
