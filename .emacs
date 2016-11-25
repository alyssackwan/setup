(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(backup-directory-alist (quote ((".*" . "~/.emacs.d/backup"))))
 '(column-number-mode t)
 '(helm-command-prefix-key "C-x h")
 '(indent-tabs-mode nil)
 '(js-indent-level 2)
 '(package-archives
   (quote
    (("gnu" . "http://elpa.gnu.org/packages/")
     ("melpa" . "http://melpa.milkbox.net/packages/"))))
 '(projectile-completion-system (quote helm))
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

;; Ensure installed

(defvar packages
  '(exec-path-from-shell
    projectile
    company
    helm
    helm-projectile
    helm-company
    flycheck
    magit
    clojure-mode
    midje-mode
    cider
    paredit
    go-mode
    company-go
    groovy-mode
    rhtml-mode
    rinari
    yaml-mode))

(defun packages-installed-p ()
  (if (remove-if 'package-installed-p packages)
      nil
    t))

(defun packages-install ()
  (dolist (package packages)
    (when (not (package-installed-p package))
      (package-install package))))

;; Cider
(add-hook 'cider-mode-hook 'cider-turn-on-eldoc-mode)

;; Midje
(add-hook 'clojure-mode-hook 'midje-mode)

;; Paredit
(add-hook 'eval-expression-minibuffer-setup-hook 'paredit-mode)
(add-hook 'ielm-mode-hook                        'paredit-mode)
(add-hook 'lisp-mode-hook                        'paredit-mode)
(add-hook 'lisp-interaction-mode-hook            'paredit-mode)
(add-hook 'scheme-mode-hook                      'paredit-mode)
(add-hook 'clojure-mode-hook                     'paredit-mode)
(add-hook 'cider-repl-mode-hook                  'paredit-mode)

;; Go
(add-hook 'go-mode-hook (lambda ()
                          (if (not (string-match "go" compile-command))
                              (set (make-local-variable 'compile-command)
                                   "go build -v && go test -v && go vet"))
                          (add-hook 'before-save-hook #'gofmt-before-save)
                          (set (make-local-variable 'company-backends) '(company-go))
                          (local-set-key (kbd "M-.") 'godef-jump)
                          (local-set-key (kbd "M-*") 'pop-tag-mark)))

;; Ruby
(add-to-list 'auto-mode-alist '("\\.html\\.erb\\'" . rhtml-mode))
(add-hook 'rhtml-mode-hook
     	  (lambda () (rinari-launch)))

;;; After init
(defun after-init ()
  ;; Ensure installed
  (package-initialize)
  (require 'cl)
  (when (not (packages-installed-p))
    (package-refresh-contents)
    (packages-install))
  ;; exec-path-from-shell
  (when (memq window-system '(mac ns))
    (exec-path-from-shell-initialize)
    (exec-path-from-shell-copy-env "GOPATH"))
  ;; Projectile
  (projectile-mode)
  ;; Company
  (global-company-mode)
  (global-set-key (kbd "M-TAB") 'company-complete)
  ;; Flycheck
  (global-flycheck-mode)
  ;; Helm
  (global-set-key (kbd "M-x") 'helm-M-x)
  (global-set-key (kbd "M-y") 'helm-show-kill-ring)
  (global-set-key (kbd "C-x b") 'helm-mini)
  (global-set-key (kbd "C-x C-f") 'helm-find-files)
  (global-set-key (kbd "C-c h o") 'helm-occur)
  (global-set-key (kbd "C-h SPC") 'helm-all-mark-rings)
  (helm-mode 1)
  (helm-projectile-on)
  ;; Magit
  (global-set-key (kbd "C-x g") 'magit-status)
  (global-set-key (kbd "C-x M-g") 'magit-dispatch-popup)
  ;; Paredit
  (autoload 'paredit-mode "paredit" nil t)
  (add-hook 'emacs-lisp-mode-hook 'paredit-mode))
(add-hook 'after-init-hook 'after-init)
