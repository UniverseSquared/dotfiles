;; Disable unnecessary GUI elements, before the UI is initialized (early-init.el)
(push '(menu-bar-lines . 0) default-frame-alist)
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars) default-frame-alist)

;; Prevent `package.el' from loading in favor of `straight.el'
(setq package-enable-at-startup nil)
