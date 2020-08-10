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

(use-package haskell-mode
  :hook (haskell-mode . interactive-haskell-mode))

(use-package hl-todo
  :custom-face (hl-todo ((t (:inherit font-lock-comment-face))))
  :hook (after-init . global-hl-todo-mode))

(use-package ivy
  :hook (after-init . ivy-mode))

(use-package lua-mode
  :custom (lua-indent-level 4))

(use-package magit
  :bind ("C-c g" . magit-status))

(use-package markdown-mode)

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package rust-mode)

(use-package s)

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

;; Have custom be less intrusive
(setq custom-file (concat user-emacs-directory "custom.el"))
(load custom-file)

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

;; Add cargo's bin folder to `exec-path'
(add-to-list 'exec-path (concat (getenv "HOME") "/.cargo/bin"))

;; Make the frame title format more informative
(setq-default frame-title-format
              '(:eval (format "%s@%s%s"
                              user-real-login-name system-name
                              (let ((current-buffer-name (buffer-name)))
                                (if (string-prefix-p " " current-buffer-name)
                                    ""
                                  (concat " (" current-buffer-name ")"))))))

;; Modeline customization
(defun my/shorten-path (path)
  "Shorten PATH to the last two components."
  (let* ((components (split-string path "/"))
         (last-components (nthcdr (- (length components) 2) components)))
    (s-join "/" last-components)))

(defun my/pretty-buffer-file-encoding ()
  "Return the prettified name of the encoding system used by the current
buffer."
  (let* ((coding-system (coding-system-plist buffer-file-coding-system))
         (coding-system-category (plist-get coding-system :category)))
    (if (memq coding-system-category
              '(coding-category-utf-8 coding-category-undecided))
        "UTF-8"
      (upcase (symbol-name (plist-get coding-system :name))))))

(defun my/find-rust-version ()
  "Return the string that represents the currently installed version of Rust."
  (if (boundp 'my/current-rust-version)
      my/current-rust-version
    (setq-local my/current-rust-version
                (nth 1 (split-string
                        (shell-command-to-string "rustc --version") " ")))))

(defun my/major-mode-description ()
  "Return the name of the major mode to be used in the modeline, possibly with
extra information about the environment, such as the language version."
  (propertize
   (pcase major-mode
     ('rust-mode (format "%s %s" mode-name (my/find-rust-version)))
     (_ (format-mode-line mode-name)))
   'face 'bold))

(defface mode-line-modified-buffer-id
  '((t (:inherit mode-line-buffer-id :slant italic)))
  "Face used for buffer identification parts of the mode line, when the buffer
is modified.")

(setq my/left-mode-line-format
      `(" "

        (:eval (file-size-human-readable (buffer-size)))

        " "

        (:eval (propertize
                (if buffer-file-name
                    (my/shorten-path buffer-file-name)
                  (buffer-name))
                'face (if (buffer-modified-p)
                          'mode-line-modified-buffer-id
                        'mode-line-buffer-id)))

        " %l:%c"))

(setq my/right-mode-line-format
      `((:eval
         (let ((buffer-eol-type
                (coding-system-eol-type buffer-file-coding-system))
               (buffer-coding-system
                (plist-get (coding-system-plist buffer-file-coding-system) :name)))
           (concat
            (pcase buffer-eol-type
              (0 "LF")
              (1 "CRLF")
              (2 "CR"))
            "  "
            (my/pretty-buffer-file-encoding))))

        "  " (:eval (my/major-mode-description))))

(setq-default mode-line-format
              `(,@my/left-mode-line-format

                (:eval (s-repeat
                        (- (window-width)
                           (length (format-mode-line my/left-mode-line-format))
                           (length (format-mode-line my/right-mode-line-format)))
                        " "))

                ,@my/right-mode-line-format))

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
 ("C-c m" . man)
 ("C-c s" . sort-lines)
 ("C-c C-e" . eval-buffer))
