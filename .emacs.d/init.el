(require 'package)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("bd7b7c5df1174796deefce5debc2d976b264585d51852c962362be83932873d9" default)))
 '(haskell-tags-on-save t)
 '(line-number-mode t)
 '(ns-right-alternate-modifier (quote none))
 '(ns-use-native-fullscreen t)
 '(package-archives
   (quote
    (("gnu" . "http://elpa.gnu.org/packages/")
     ("melpa" . "https://melpa.org/packages/"))))
 '(package-selected-packages
   (quote
    (nginx-mode vue-mode json-mode company-tern xref-js2 js2-refactor js2-mode monokai-theme yasnippet company-sourcekit swift-mode ivy-prescient counsel swiper magit exec-path-from-shell hindent intero ace-jump-mode haskell-mode nlinum magit ivy-prescient intero hindent exec-path-from-shell doom-modeline doom counsel ace-jump-mode))))
(package-initialize)

(load-theme 'monokai)
(global-set-key (kbd "s-F") 'toggle-frame-fullscreen)

(when (memq window-system '(mac ns x))
  (exec-path-from-shell-initialize))

(setq ring-bell-function 'ignore)
(menu-bar-mode -1)
(scroll-bar-mode -1)

(ivy-mode t)
(setq ivy-use-virtual-buffers t)
(setq enable-recursive-minibuffers t)
;;(setq search-default-mode #'char-fold-to-regexp)
(global-set-key "\C-s" 'swiper)
(global-set-key (kbd "C-c C-r") 'ivy-resume)
(global-set-key (kbd "<f6>") 'ivy-resume)
(ivy-prescient-mode t)
(counsel-mode t)
(setq ivy-re-builders-alist
      '((read-file-name-internal . ivy--regex-fuzzy)
	(t . ivy--regex-plus)))
(global-set-key (kbd "C-c g") 'counsel-git)
(global-set-key (kbd "C-c j") 'counsel-git-grep)
(global-set-key (kbd "C-c k") 'counsel-ag)
(global-set-key (kbd "C-x l") 'counsel-locate)
(global-set-key (kbd "C-S-o") 'counsel-rhythmbox)
(define-key minibuffer-local-map (kbd "C-r") 'counsel-minibuffer-history)

;; project
(global-set-key (kbd "C-c p f") 'project-find-file)
(global-set-key (kbd "C-c p s") 'project-find-regexp)

;; ace jump
(define-key global-map (kbd "C-c SPC") 'ace-jump-mode)

;; magit
(global-set-key (kbd "C-x g") 'magit-status)
(global-set-key (kbd "C-x M-g") 'magit-dispatch)

;; haskell
(intero-global-mode 1)
(add-hook 'haskell-mode-hook #'hindent-mode)

;; javascript
(require 'js2-mode)
(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
(setq js2-strict-missing-semi-warning nil)

;; Better imenu
(add-hook 'js2-mode-hook #'js2-imenu-extras-mode)

(require 'js2-refactor)
(require 'xref-js2)

(add-hook 'js2-mode-hook #'js2-refactor-mode)
(js2r-add-keybindings-with-prefix "C-c C-r")
(define-key js2-mode-map (kbd "C-k") #'js2r-kill)

;; js-mode (which js2 is based on) binds "M-." which conflicts with xref, so
;; unbind it.
(define-key js-mode-map (kbd "M-.") nil)

(add-hook 'js2-mode-hook (lambda ()
  (add-hook 'xref-backend-functions #'xref-js2-xref-backend nil t)))

(require 'company)
(require 'company-tern)

(add-to-list 'company-backends 'company-tern)
(add-hook 'js2-mode-hook (lambda ()
                           (tern-mode)
                           (company-mode)))
                           
;; Disable completion keybindings, as we use xref-js2 instead
(define-key tern-mode-keymap (kbd "M-.") nil)
(define-key tern-mode-keymap (kbd "M-,") nil)

;; Swift
(require 'company-sourcekit)
(add-to-list 'company-backends 'company-sourcekit)

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
