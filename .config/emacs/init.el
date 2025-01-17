(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

(require 'use-package-ensure)
(setq use-package-always-ensure t)

;; `load-theme' advice, defined before themes are loaded
(defun my/around-load-theme-advice (old-fn &rest args)
  "Advice for `load-theme' to unload previously loaded themes before loading
the new theme, and set the `cursor-type' to box."
  (mapc #'disable-theme custom-enabled-themes)
  (apply old-fn args)
  (setq-default cursor-type 'box)

  ;; Make comments, comment delimiters and doc strings italic
  (set-face-attribute 'font-lock-comment-face nil :slant 'italic)
  (set-face-attribute 'font-lock-comment-delimiter-face nil :slant 'italic)
  (set-face-attribute 'font-lock-doc-face nil :slant 'italic))

(advice-add #'load-theme :around #'my/around-load-theme-advice)

;; Install and configure packages
(use-package catppuccin-theme
  :custom
  (catppuccin-flavor 'macchiato)
  (catppuccin-italic-blockquotes nil)
  :config
  (load-theme 'catppuccin t))

(use-package company
  :hook (after-init . global-company-mode)
  :bind (("C-<tab>" . company-complete)
         :map company-active-map
         ("<tab>" . company-complete-selection)))

(use-package counsel
  :hook (after-init . counsel-mode)
  :bind (("C-x 8 RET" . counsel-unicode-char)))

(use-package edit-indirect)

(use-package haskell-mode
  :hook (haskell-mode . interactive-haskell-mode))

(use-package hl-todo
  :custom-face (hl-todo ((t (:weight bold :inherit font-lock-comment-face))))
  :hook (after-init . global-hl-todo-mode)
  :config
  (add-to-list 'hl-todo-keyword-faces '("SAFETY" . "#7cb8bb")))

(use-package ivy
  :hook (after-init . ivy-mode))

(use-package ligature
  :hook (after-init . global-ligature-mode)
  :config
  (ligature-set-ligatures
   t
   '("<---" "<--" "<<-" "<-" "->" "->>" "-->" "--->" "<===" "<==" "<<="
     "=>" "=>>" ">==" ">===" "<->" "<-->" "<--->" "<---->" "<=>" "<==>"
     "<===>" "<====>" "::" ":::" "==" "!=" "~=" "<>" "===" "!==" "<|" "<|>" "|>"
     ":=" "++" "+++" "<!--" "<!---" "<=" ">=" ">>=" "<<=" "<<" ">>")))

(use-package lua-mode
  :custom (lua-indent-level 4))

(use-package magit
  :bind ("C-c g" . magit-status))

(use-package markdown-mode)

(use-package merlin
  :hook (tuareg-mode . merlin-mode))

(use-package ocamlformat
  :bind (:map tuareg-mode-map
              ("C-c C-f" . ocamlformat))
  :custom (ocamlformat-enable 'enable-outside-detected-project))

(use-package org
  :bind (:map org-mode-map
         ("C-c M-o" . org-store-link))
  :custom ((org-support-shift-select t)
           (org-hide-emphasis-markers t)
           (org-list-allow-alphabetical t)
           (org-preview-latex-image-directory "~/.cache/org-lateximg/")
           (org-attach-use-inheritance t)
           (org-attach-auto-tag nil))
  :custom-face
  (org-block ((t (:foreground unspecified :inherit default))))
  (org-target ((t (:inherit font-lock-comment-face))))
  :config
  (setq org-format-latex-options (plist-put org-format-latex-options :scale 1.4))
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((sqlite . t) (C . t) (haskell . t) (python . t) (ocaml . t))))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package rust-mode)

(use-package s)

(use-package smartparens
  :hook (after-init . smartparens-global-mode)
  :custom (sp-highlight-pair-overlay nil)
  :config
  ;; FIXME: do more smartparens config
  ;; (require 'smartparens-config)

  (sp-with-modes sp-lisp-modes
    (sp-local-pair "'" nil :actions nil)
    (sp-local-pair "`" nil :actions nil))

  (require 'smartparens-rust)
  (require 'smartparens-ml)
  )

(use-package swiper
  :bind ("C-s" . swiper))

(use-package tuareg
  :custom (tuareg-match-clause-indent 2)
  :custom-face
  (tuareg-font-lock-governing-face
   ((t (:inherit font-lock-keyword-face :weight unspecified :foreground unspecified))))
  ;; By default, this inherits `default', which causes OCaml code in code blocks to break the background
  ;; color sometimes
  (tuareg-font-lock-constructor-face ((t (:inherit unspecified))))
  :config
  (add-to-list 'exec-path (s-trim (shell-command-to-string "opam var bin"))))

(use-package web-mode
  :custom ((web-mode-markup-indent-offset 2)
           (web-mode-enable-auto-opening nil)
           (web-mode-enable-auto-closing nil)
           (web-mode-enable-auto-pairing nil)
           (web-mode-enable-auto-quoting nil)
           (web-mode-ac-sources-alist '(("css" (ac-source-css-property)))))
  :mode ("\\.html?\\'" "\\.css\\'"))

(use-package which-key
  :hook (after-init . which-key-mode))

(use-package yaml-mode)

(use-package zig-mode
  :hook (zig-mode . (lambda () (zig-format-on-save-mode 0))))

;; Utility functions
(setq my/config-path (concat user-emacs-directory "init.el"))

(defun my/edit-config ()
  "Open the emacs init.el file for editing."
  (interactive)
  (find-file my/config-path))

(defun my/open-current-notes ()
  "Open today's university notes file."
  (interactive)
  (let* ((date-string (format-time-string "%Y-%m-%d"))
         (notes-file-path (concat (getenv "HOME") "/uni/notes/" date-string ".org"))
         (bin-path "/home/universe/.cache/cargo/debug/caltest")
         (command (concat bin-path " now --title-only"))
         (title (s-trim (shell-command-to-string command))))
    (find-file notes-file-path)

    (unless (string= title "no current event")
      (beginning-of-buffer)

      (unless (re-search-forward (concat "^\\* " title) nil t)
        (end-of-buffer)
        (unless (= (point) 1) (newline))
        (insert (concat "* " title "\n")))

      (beginning-of-line))))

(defun my/set-alpha-for-all-frames (alpha)
  "Set the alpha value for all visible frames, and the default value,
to ALPHA."
  (add-to-list 'default-frame-alist `(alpha-background . ,alpha))
  (mapc #'(lambda (frame)
            (set-frame-parameter frame 'alpha-background alpha))
        (visible-frame-list)))

;; Disable cursor blink
(blink-cursor-mode 0)
(setq visible-cursor nil)

;; Set the default font
(setq my/default-font "Iosevka-12")

(set-frame-font my/default-font)
(add-to-list 'default-frame-alist `(font . ,my/default-font))

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
(setq temporary-file-directory (concat user-emacs-directory "backups")
      backup-directory-alist `((".*" . ,temporary-file-directory))
      auto-save-file-name-transforms `((".*" ,temporary-file-directory t)))

;; Have custom be less intrusive
(setq custom-file (concat user-emacs-directory "custom.el"))
(when (file-exists-p custom-file) (load custom-file))

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

;; End sentences with a single space, and fill paragraphs to a reasonable margin
(setq-default sentence-end-double-space nil
              fill-column 110)

;; Prevent Emacs from drawing its own background color in terminal frames
(defun my/remove-background-for-terminal-frame (frame)
  (unless (display-graphic-p frame)
    (set-face-background 'default "unspecified-bg" frame)
    (set-face-background 'line-number "unspecified-bg" frame)))

(add-to-list 'after-make-frame-functions #'my/remove-background-for-terminal-frame)

;; Enable some functions that are disabled by default
(put #'erase-buffer 'disabled nil)
(put #'upcase-region 'disabled nil)
(put #'downcase-region 'disabled nil)

;; Add cargo's bin folder to `exec-path'
(add-to-list 'exec-path (concat (getenv "HOME") "/.cargo/bin"))
(add-to-list 'exec-path "/usr/lib/rustup/bin")

;; Add Lean to `exec-path'
(add-to-list 'exec-path (concat (getenv "HOME") "/.elan/bin"))

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
(bind-keys*
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
 ("C-c n" . my/open-current-notes))
