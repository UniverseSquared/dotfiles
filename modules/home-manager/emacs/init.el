;; TODO: maybe (setq dired-omit-files "^\\.\\.?[^\\.]+$") with dired-omit-mode?
;; hides hidden files (.foo) but not . and ..

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

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

(use-package consult
  :bind (("C-x b" . consult-buffer)
         ("C-s" . consult-line))
  :custom (consult-line-start-from-top t))

(use-package edit-indirect)

(use-package haskell-mode
  :hook (haskell-mode . interactive-haskell-mode))

(use-package hl-todo
  :custom-face (hl-todo ((t (:weight bold :inherit font-lock-comment-face))))
  :hook (after-init . global-hl-todo-mode)
  :config
  (add-to-list 'hl-todo-keyword-faces '("SAFETY" . "#7cb8bb")))

(use-package ligature
  :hook (after-init . global-ligature-mode)
  :config
  (ligature-set-ligatures
   t
   '("<---" "<--" "<<-" "<-" "->" "->>" "-->" "--->" "<===" "<==" "<<="
     "=>" "=>>" ">==" ">===" "<->" "<-->" "<--->" "<---->" "<=>" "<==>"
     "<===>" "<====>" "::" ":::" "==" "!=" "~=" "<>" "===" "!==" "<|" "<|>" "|>"
     ":=" "++" "+++" "<!--" "<!---" "<=" ">=" ">>=" "<<=" "<<" ">>" "<*" "<*>" "*>"
     "<<<" ">>>")))

(use-package lua-mode
  :custom (lua-indent-level 4))

(use-package magit
  :bind ("C-c g" . magit-status))

(use-package marginalia
  :hook (after-init . marginalia-mode)
  :config
  ;; Always use three separate dots instead of a single ellipsis character
  (defun marginalia--ellipsis ()
    "..."))

(use-package markdown-mode)

(use-package merlin
  :hook (tuareg-mode . merlin-mode))

(use-package ocamlformat
  :bind (:map tuareg-mode-map
              ("C-c C-f" . ocamlformat))
  :custom (ocamlformat-enable 'enable-outside-detected-project))

(use-package orderless
  :custom ((completion-styles '(orderless basic))
           (completion-category-overrides '((file (styles basic partial-completion))))))

(defun my/prettify-org-checkboxes ()
  (push '("[ ]" . "☐") prettify-symbols-alist)
  (push '("[X]" . "☑") prettify-symbols-alist)
  (push '("[-]" . "☐") prettify-symbols-alist)
  (turn-on-prettify-symbols-mode))

(use-package org
  :bind (:map org-mode-map
         ("C-c M-o" . org-store-link))
  :custom ((org-support-shift-select t)
           (org-hide-emphasis-markers t)
           (org-hide-leading-stars t)
           (org-list-allow-alphabetical t)
           (org-preview-latex-image-directory "~/.cache/org-lateximg/")
           (org-attach-use-inheritance t)
           (org-attach-auto-tag nil)
           (org-startup-truncated nil))
  :custom-face
  (org-block ((t (:foreground unspecified :inherit fixed-pitch))))
  (org-table ((t (:inherit fixed-pitch))))
  (org-code ((t (:inherit fixed-pitch))))
  (org-quote ((t (:inherit fixed-pitch))))
  (org-target ((t (:inherit font-lock-comment-face))))
  (org-level-1 ((t (:height 1.3))))
  (org-level-2 ((t (:height 1.2))))
  (org-level-3 ((t (:height 1.1))))
  :hook
  (org-mode . variable-pitch-mode)
  (org-mode . visual-line-mode)
  (org-mode . my/prettify-org-checkboxes)
  :config
  (setq org-format-latex-options (plist-put org-format-latex-options :scale 1.0))
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((sqlite . t) (C . t) (haskell . t) (python . t) (ocaml . t) (gnuplot . t))))

(use-package org-appear
  :hook (org-mode . org-appear-mode))

(use-package org-superstar
  :hook (org-mode . org-superstar-mode))

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

(use-package vertico
  :hook (after-init . vertico-mode)
  :bind (:map vertico-map
         ("<prior>" . my/vertico-page-up)
         ("<next>" . my/vertico-page-down))
  :init
  (defun my/vertico-page-up ()
    (interactive)
    (vertico-previous vertico-count))

  (defun my/vertico-page-down ()
    (interactive)
    (vertico-next vertico-count)))

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
  (setf (alist-get 'alpha-background default-frame-alist) alpha)
  (mapc #'(lambda (frame)
            (set-frame-parameter frame 'alpha-background alpha))
        (frame-list)))

;; Disable cursor blink
(blink-cursor-mode 0)
(setq visible-cursor nil)

;; Set the default font
(let ((monospace-font-family "Iosevka")
      (monospace-font-size 12)
      (variable-font-family "Source Sans 3")
      (variable-font-size 12))
  (custom-set-faces
   `(default ((t (:family ,monospace-font-family :height ,(* 10 monospace-font-size)))))
   `(fixed-pitch ((t (:family ,monospace-font-family :height ,(* 10 monospace-font-size)))))
   `(variable-pitch ((t (:family ,variable-font-family :height ,(* 10 variable-font-size)))))
   ;; Ensure that `variable-pitch-mode' doesn't affect line numbers
   `(line-number ((t :inherit fixed-pitch)))))

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

;; Disable unnecessary GUI elements
(menu-bar-mode 0)
(tool-bar-mode 0)
(scroll-bar-mode 0)

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
(setq dired-listing-switches "-alh"
      dired-dwim-target t)

;; End sentences with a single space, and fill paragraphs to a reasonable margin
(setq-default sentence-end-double-space nil
              fill-column 110)

;; Pass DISPLAY env var to processes (e.g. GPG password prompt)
(add-to-list 'process-environment "DISPLAY=:0")

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

(let ((left-mode-line-format
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
      (right-mode-line-format
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

         "  " (:eval (my/major-mode-description)))))
  (setq-default mode-line-format
                `(,@left-mode-line-format
                  ,mode-line-format-right-align
                  ,@right-mode-line-format)))

;; Allow toggling between a light and dark theme
(setq my/is-light-theme nil)

(defun my/cycle-theme ()
  (interactive)
  (setq my/is-light-theme (not my/is-light-theme))
  (pcase-let ((`(,flavor ,alpha) (if my/is-light-theme
                                     '(latte 100)
                                   '(macchiato 75))))
    (setq catppuccin-flavor flavor)
    (load-theme 'catppuccin t)
    (my/set-alpha-for-all-frames alpha)))

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
 ("C-c n" . my/open-current-notes)
 ("C-c t" . my/cycle-theme))
