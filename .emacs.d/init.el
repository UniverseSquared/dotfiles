;; Bootstrap straight.el
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

;; Install use-package
(straight-use-package 'use-package)

(setq straight-use-package-by-default t)

;; Install and configure packages
(use-package company
  :hook (after-init . global-company-mode)
  :bind (("C-<tab>" . company-complete)
         :map company-active-map
         ("<tab>" . company-complete-selection)))

(use-package counsel
  :hook (after-init . counsel-mode))

(use-package dracula-theme
  :config
  (load-theme 'dracula t))

(use-package ivy
  :hook (after-init . ivy-mode))

(use-package magit
  :bind ("C-c g" . magit-status))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package rust-mode)

(use-package smartparens
  :hook (after-init . smartparens-global-mode)
  :config
  (sp-with-modes sp-lisp-modes
    (sp-local-pair "'" nil :actions nil)
    (sp-local-pair "`" nil :actions nil)))

(use-package swiper
  :bind ("C-s" . swiper))

(use-package which-key
  :hook (after-init . which-key-mode))

(use-package yaml-mode)

;; Utility functions
(setq my/config-path (concat user-emacs-directory "init.el"))

(defun my/edit-config ()
  "Open the emacs init.el file for editing."
  (interactive)
  (find-file my/config-path))

(defun my/set-alpha-for-all-frames (alpha)
  "Set the alpha value for all visible frames, and the default value,
to ALPHA."
  (add-to-list 'default-frame-alist `(alpha . (,alpha . ,alpha)))
  (mapc #'(lambda (frame)
            (set-frame-parameter frame 'alpha `(,alpha . ,alpha)))
        (visible-frame-list)))

(defun my/around-load-theme-advice (old-fn &rest args)
  "Advice for `load-theme' to unload previously loaded themes before loading
the new theme, and set the `cursor-type' to box."
  (mapc #'disable-theme custom-enabled-themes)
  (apply old-fn args)
  (setq-default cursor-type 'box))

(advice-add #'load-theme :around #'my/around-load-theme-advice)

;; Disable unnecessary GUI elements
(menu-bar-mode 0)
(tool-bar-mode 0)
(scroll-bar-mode 0)

;; Disable cursor blink
(blink-cursor-mode 0)

;; Set the default font
(setq my/default-font "JetBrains Mono-11")

(set-frame-font my/default-font)
(add-to-list 'default-frame-alist `(font . ,my/default-font))

;; Make comments, comment delimiters and doc strings italic
(set-face-attribute 'font-lock-comment-face nil :slant 'italic)
(set-face-attribute 'font-lock-comment-delimiter-face nil :slant 'italic)
(set-face-attribute 'font-lock-doc-face nil :slant 'italic)

;; Make line numbers not italic
(set-face-attribute 'line-number nil :slant 'normal)

;; Set the alpha for all frames
(my/set-alpha-for-all-frames 75)

;; Display line and column numbers globally
(column-number-mode)
(global-display-line-numbers-mode)

;; Scroll one line at a time
(setq scroll-step 1
      scroll-conservatively 10000)

;; Move temporary files to a dedicated folder
(setq temporary-file-directory "~/.emacs.d/backups"
      backup-directory-alist `((".*" . ,temporary-file-directory))
      auto-save-file-name-transforms `((".*" ,temporary-file-directory t)))

;; Show the *scratch* buffer on startup instead of the default startup screen
(setq inhibit-startup-screen t)

;; Delete the selection when typing
(delete-selection-mode)

;; Use spaces for indentation, not tabs
(setq-default indent-tabs-mode nil)

;; Configure indentation in C-like languages
(setq c-default-style "java"
      c-basic-offset 4)

;; Delete trailing whitespace before saving
(add-hook 'before-save-hook #'delete-trailing-whitespace)

;; Use the string syntax in `re-builder'
(setq reb-re-syntax 'string)

;; Show human-readable file sizes in dired
(setq dired-listing-switches "-alh")

;; Enable some functions that are disabled by default
(put #'erase-buffer 'disabled nil)
(put #'upcase-region 'disabled nil)
(put #'downcase-region 'disabled nil)

;; Make the frame title format more informative
(setq-default frame-title-format
              '(:eval (format "%s@%s%s"
                              user-real-login-name system-name
                              (let ((current-buffer-name (buffer-name)))
                                (if (string-prefix-p " " current-buffer-name)
                                    ""
                                  (concat " (" current-buffer-name ")"))))))

;; Misc. key bindings
(bind-keys
 ("ESC ESC" . keyboard-escape-quit)
 ("C-x C-b" . ibuffer)
 ("C-z" . zap-up-to-char)
 ("M-o" . other-window)
 ("M-0" . delete-window)
 ("M-1" . delete-other-windows)
 ("M-2" . split-window-below)
 ("M-3" . split-window-right)
 ("C-c a" . align-regexp)
 ("C-c c" . compile)
 ("C-c e" . my/edit-config)
 ("C-c s" . sort-lines)
 ("C-c C-e" . eval-buffer))
