(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(backup-directory-alist (quote ((".*" . "~/.emacs.d/backup"))))
 '(column-number-mode t)
 '(debug-on-error t)
 '(default-frame-alist (quote ((fullscreen . maximized))))
 '(desktop-dirname "~/.emacs.d/desktop")
 '(desktop-save t)
 '(desktop-save-mode t)
 '(enable-remote-dir-locals t)
 '(exec-path-from-shell-check-startup-files nil)
 '(helm-command-prefix-key "C-x h")
 '(indent-tabs-mode nil)
 '(js-indent-level 2)
 '(js2-basic-offset 2)
 '(js2-bounce-indent-p t)
 '(org-agenda-skip-deadline-if-done t)
 '(org-agenda-skip-scheduled-if-deadline-is-shown (quote repeated-after-deadline))
 '(org-agenda-skip-scheduled-if-done t)
 '(org-agenda-sorting-strategy
   (quote
    ((agenda user-defined-up)
     (todo priority-down category-keep)
     (tags priority-down category-keep)
     (search category-keep))))
 '(org-agenda-start-on-weekday 0)
 '(org-agenda-use-time-grid nil)
 '(org-capture-templates
   (quote
    (("t" "TODO" entry
      (id "E2751D7F-DF21-48B4-9456-D7583FFD3510")
      "** TODO %?\n   DEADLINE: %t SCHEDULED: %t"
      :empty-lines 1))))
 '(org-catch-invisible-edits (quote show-and-error))
 '(org-goto-auto-isearch nil)
 '(org-id-link-to-org-use-id (quote create-if-interactive-and-no-custom-id))
 '(org-log-done (quote time))
 '(org-log-into-drawer t)
 '(projectile-completion-system (quote helm))
 '(projectile-keymap-prefix (kbd "C-c C-p"))
 '(savehist-mode t)
 '(show-trailing-whitespace t)
 '(truncate-lines t)
 '(visible-bell nil)
 '(web-mode-markup-indent-offset 2))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(require 'package)
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (proto (if no-ssl "http" "https")))
  (setq package-archives '())
  ;; Comment/uncomment these two lines to enable/disable MELPA and MELPA Stable as desired
  (add-to-list 'package-archives (cons "melpa" (concat proto "://melpa.org/packages/")) t)
  ;;(add-to-list 'package-archives (cons "melpa-stable" (concat proto "://stable.melpa.org/packages/")) t)
  (when (< emacs-major-version 24)
    ;; For important compatibility libraries like cl-lib
    (add-to-list 'package-archives '("gnu" . (concat proto "://elpa.gnu.org/packages/")))))
(package-initialize)

(when (not (package-installed-p 'use-package))
  (package-install 'use-package))
(eval-when-compile
  (require 'use-package))

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

(use-package exec-path-from-shell
  :ensure t
  :demand t
  :config (when (memq window-system '(mac ns))
            (exec-path-from-shell-initialize)
            (exec-path-from-shell-copy-env "MANPATH")
            (exec-path-from-shell-copy-env "GOPATH")))

(use-package visual-fill-column
  :ensure t
  :hook (visual-line-mode . visual-fill-column-mode))

(use-package woman
  :ensure t
  :config (setq woman-path (woman-parse-colon-path (getenv "MANPATH"))))

(use-package projectile
  :ensure t
  :demand t
  :config (projectile-mode 1))

;; Org
(use-package org
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
  :bind (("C-c l" . org-store-link)
         ("C-c a" . org-agenda)
         ("C-c c" . org-capture)
         ("C-c b" . org-switchb)
         ("C-c o r" . org-revert-all-org-buffers)))

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
  :bind (("M-<tab>" . company-complete)))

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
  :after (clojure-mode))
(use-package midje-mode
  :ensure t
  :after (clojure-mode)
  :config (let ((prefix-map (lookup-key midje-mode-map (kbd "C-c"))))
            (define-key midje-mode-map (kbd "C-c") nil)
            (define-key midje-mode-map (kbd "C-c C-m") prefix-map))
  :hook (clojure-mode))

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
(use-package lsp-python
  :ensure t
  :commands (lsp-python-enable)
  :hook (python-mode . lsp-python-enable))

;; Java
(use-package lsp-java
  :ensure t
  :commands (lsp-java-enable)
  :hook (java-mode . lsp-java-enable))

;; JavaScript
(use-package js2-mode
  :ensure t
  :mode ("\\.js\\'"))
(use-package company-tern
  :ensure t
  :hook (js2-mode . (lambda ()
                      (set (make-local-variable 'company-backends) '(company-tern))))
  :commands (company-tern))

;; Web
(use-package web-mode
  :mode ("\\.phtml\\'"
         "\\.tpl\\.php\\'"
         "\\.[agj]sp\\'"
         "\\.as[cp]x\\'"
         "\\.erb\\'"
         "\\.mustache\\'"
         "\\.djhtml\\'"
         "\\.html?\\'"))

;; Ruby
(use-package groovy-mode
  :ensure t)
(use-package rhtml-mode
  :ensure t
  :mode ("\\.html\\.erb\\'"))
(use-package rinari
  :hook (rhtml-mode . rinari-launch)
  :commands (rinari-launch))

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

;; LastPass
(use-package lastpass
  :ensure t
  :config
  (setq lastpass-user "me@alyssackwan.name"))

;; Ledger
(use-package ledger-mode
  :load-path "~/opt/homebrew/share/emacs/site-lisp/ledger"
  :mode ("\\.ledger\\'")
  :hook (ledger-mode . (lambda () (visual-line-mode nil))))
(use-package flycheck-ledger
  :ensure t
  :after (flycheck ledger-mode)
  :hook (ledger-mode . flycheck-mode))
(use-package company-ledger
  :straight (company-ledger :type git :host github :repo "debanjum/company-ledger")
  :hook (ledger-mode . (lambda ()
                         (set (make-local-variable 'company-backends) '(company-ledger-backend))))
  :after (company ledger-mode))

(let ((path "~/.emacs_local.el"))
  (if (file-exists-p path)
    (load-file path)))
(let ((path "~/.emacs_custom_set.el"))
  (setq custom-file path)
  (if (file-exists-p path)
    (load-file path)))