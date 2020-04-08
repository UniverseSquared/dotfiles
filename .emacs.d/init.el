(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

(unless package-archive-contents
  (package-refresh-contents))

(setq my/config-path (concat user-emacs-directory "init.el"))

(setq custom-file (concat user-emacs-directory "custom.el"))
(if (file-exists-p custom-file)
    (load custom-file))

;; Convenience functions and keybinds.
(defun my/ensure-packages-installed (packages)
  "Install all packages in PACKAGES, if they are not already installed."
  (dolist (package packages)
    (unless (package-installed-p package)
      (package-install package))))

(defun my/edit-config ()
  "Open the emacs init.el file for editing."
  (interactive)
  (find-file my/config-path))

(defun my/reload-config ()
  "Reload the emacs init.el file."
  (interactive)
  (load my/config-path))

(defun my/open-todo-list ()
  "Open the todo.org."
  (interactive)
  (find-file "~/todo.org"))

(defun my/set-global-keybinds (keybinds)
  "Set each key combination to the corresponding function in KEYBINDS."
  (dolist (bind keybinds)
    (let ((keys (kbd (car bind)))
          (func (cdr bind)))
      (global-set-key keys func))))

(defun my/load-random-theme (&optional themes)
  "Loads a random theme from either THEMES if provided or all available themes."
  (interactive)
  (let* ((themes (or themes (custom-available-themes)))
         (theme (nth (random (length themes)) themes)))
    (load-theme theme t)
    (message (symbol-name theme))))

(defun my/kill-other-buffers ()
  "Kill all buffers other than *scratch* and *Messages*."
  (interactive)
  (let ((preserved-buffer-names '("*scratch" "*Messages*")))
    (mapc (lambda (buffer)
            (unless (member (buffer-name buffer) preserved-buffer-names)
              (kill-buffer buffer)))
          (buffer-list))))

(defun my/set-alpha-for-all-frames (alpha)
  "Set the alpha value for all visible frames, and set the default value."
  (add-to-list 'default-frame-alist `(alpha . (,alpha . ,alpha)))
  (mapc #'(lambda (frame)
            (set-frame-parameter frame 'alpha `(,alpha . ,alpha)))
        (visible-frame-list)))

(defun my/around-load-theme-advice (old-fn &rest args)
  "Advice for `load-theme' to unload previously loaded themes before loading the
new theme, and set `cursor-type' to box."
  (mapc #'disable-theme custom-enabled-themes)
  (apply old-fn args)
  (setq-default cursor-type 'box))

(advice-add #'load-theme :around #'my/around-load-theme-advice)

;; Eshell functions
(require 'eshell)
(defun eshell/clear ()
  "Clear the eshell buffer."
  (let ((inhibit-read-only t))
    (erase-buffer)))

;; Set global keybinds.
(my/set-global-keybinds
 `(("C-c i" . my/install-packages)
   ("C-c e" . my/edit-config)
   ("C-c r" . my/reload-config)
   ("C-c t" . my/open-todo-list)
   ("C-c c" . compile)
   ("C-c a" . align-regexp)
   ("C-c m" . man)
   ("C-c s" . sort-lines)
   ("C-c g" . magit-status)
   ("C-c f" . find-function)
   ("ESC ESC" . keyboard-escape-quit)
   ("C-<tab>" . company-complete)
   ("M-o" . other-window)
   ("M-O" . (lambda () (interactive) (other-window -1)))
   ("M-0" . delete-window)
   ("M-1" . delete-other-windows)
   ("M-2" . split-window-below)
   ("M-3" . split-window-right)
   ("C-z" . zap-up-to-char)
   ("C-c C-e" . eval-buffer)
   ("C-x C-b" . ibuffer)
   ("C-s" . swiper)
   ("C-M-<right>" . sp-slurp-hybrid-sexp)
   ("C-M-<left>" . sp-forward-barf-sexp)
   ("C-h C-f" . (lambda () (interactive) (find-function (symbol-at-point))))
   ("C-c SPC" . ace-jump-mode)))

;; Package management.
(my/ensure-packages-installed
 '(ace-jump-mode
   company
   counsel
   csharp-mode
   dracula-theme
   exec-path-from-shell
   go-mode
   haskell-mode
   hindent
   ivy
   lua-mode
   magit
   markdown-mode
   monokai-theme
   php-mode
   rainbow-delimiters
   rust-mode
   slime
   smartparens
   swiper
   vterm
   web-mode
   which-key
   yaml-mode
   zig-mode))

;; Load a theme and set cursor type.
(load-theme 'dracula t)

;; Disable unneeded graphical things.
(menu-bar-mode 0)
(tool-bar-mode 0)
(scroll-bar-mode 0)

;; Disable cursor blink.
(blink-cursor-mode 0)

;; Enable smartparens globally.
(smartparens-global-mode)

(sp-with-modes sp-lisp-modes
  (sp-local-pair "'" nil :actions nil))

;; Enable rainbow-delimiters in all programming modes.
(require 'rainbow-delimiters)
(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)

;; Enable ivy and counsel.
(ivy-mode)
(counsel-mode)

;; Enable which-key.
(which-key-mode)

;; Enable org-support-shift-select.
(setq org-support-shift-select t)

;; Associate forth-mode and forth-mode with the appropriate file extensions.
(autoload 'forth-mode "gforth.el")
(add-to-list 'auto-mode-alist '("\\.fs\\'" . forth-mode))

(autoload 'forth-block-mode "gforth.el")
(add-to-list 'auto-mode-alist '("\\.fb\\'" . forth-block-mode))

;; Associate xml-mode with C# project files.
(add-to-list 'auto-mode-alist '("\\.csproj\\'" . xml-mode))

;; Set the indent level in lua-mode.
(setq lua-indent-level 4)

;; Enable interactive-haskell-mode and hindent-mode in haskell files.
(add-hook 'haskell-mode-hook 'interactive-haskell-mode)
(add-hook 'haskell-mode-hook 'hindent-mode)

;; Make haskell-move use ivy for completion.
(setq haskell-completing-read-function 'ivy-completing-read)

;; Configure SLIME.
(add-to-list 'slime-contribs 'slime-repl)

(setq slime-lisp-implementations
      `(("sbcl" (,(executable-find "sbcl")))))

;; Enable company-mode globally, and make tab accept the highlighted candidate.
(add-hook 'after-init-hook 'global-company-mode)

(require 'company)
(define-key company-active-map (kbd "<tab>") 'company-complete-selection)

;; Typing should delete the selection.
(delete-selection-mode 1)

;; Configure indentation in c-like languages.
(setq c-default-style "java"
      c-basic-offset 4)

;; In vterm, C-u should be sent to the shell.
(require 'vterm)
(define-key vterm-mode-map (kbd "C-u") #'vterm--self-insert)

;; Use the PATH from ~/.zshrc as emacs' `exec-path'.
(exec-path-from-shell-initialize)

;; Disable tabs.
(setq-default indent-tabs-mode nil)

;; Show line and column numbers.
(global-display-line-numbers-mode 1)
(column-number-mode 1)

;; Scroll one line at a time.
(setq scroll-step 1
      scroll-conservatively 10000)

;; Set the default compile command.
(setq compile-command "make -C .. ")

;; Set the default font.
(setq my/default-font-family "Fira Code"
      my/default-font-size   11
      my/default-font        (format "%s-%s"
                                     my/default-font-family
                                     my/default-font-size))

(set-frame-font my/default-font)
(add-to-list 'default-frame-alist `(font . ,my/default-font))

;; Set the frame alpha value.
(my/set-alpha-for-all-frames 75)

;; Move where emacs saves temporary files.
(setq temporary-file-directory "~/.emacs.d/backups"
      backup-directory-alist `((".*" . ,temporary-file-directory))
      auto-save-file-name-transforms `((".*" ,temporary-file-directory t)))

;; Disable the default emacs startup screen.
(setq inhibit-startup-screen t)

;; Make `split-window-sensibly' never split horizontally.
(setq split-width-threshold nil
      split-height-threshold 80)

;; Remove trailing whitespace automatically before saving.
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; Enable these functions that are disabled by default.
(put 'erase-buffer 'disabled nil)
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)

;; Store authentication information in ~/.authinfo.gpg
(setq auth-sources '("~/.authinfo.gpg"))

;; Make dired show human-readable file sizes.
(setq dired-listing-switches "-alh")

;; Use the string syntax in `re-builder'
(setq reb-re-syntax 'string)

;; Make the frame title include the username, hostname and buffer name.
;; If the buffer name starts with a space (e.g. " *Minibuf-1*"), don't include
;; it in the title.
(setq-default frame-title-format
              '(:eval (format "%s@%s%s"
                              user-real-login-name system-name
                              (let ((current-buffer-name (buffer-name)))
                                (if (string-prefix-p " " current-buffer-name)
                                    ""
                                  (concat " (" current-buffer-name ")"))))))

(provide 'init)
;;; init.el ends here
