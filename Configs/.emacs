;; .emacs - one file to rule them all
;;  -- wishi
;; * vi_m_ & emacs23 hybrid
;;   - linum, viper
;; * optimized for no-x variants
;;   - no background
;; * tabs
;;   - tabbar-mode
;; * expansion, completion 
;;   - hippie & dabbdrev, IDE code-assists
;;   - eclim, JDE, CEDET EDE semantic, PyMacs with ipython
;; * LaTeX, C, C++, Java, Python, F#, Ruby
;; * cua support
;; * multilanguage spell checking (flyspell switch)
;; * backups + auto-save. Do the rest with VCS.

;; no menubar on emacs-nox variants - looks stupid
(menu-bar-mode 0)

;; tabbar - looks stupid, but everybody does tabs
(tabbar-mode 1)


;; for private config vars like gnus PW or OpenPGP
;; key stuff to sign documents
(when (file-exists-p "~/.private.el")
  (load-file "~/.private.el"))


;; company-mode - 0,5 - local path condition
(when (file-exists-p "~/.emacs.d/site-lisp/company/company.el")
  (add-to-list 'load-path "~/.emacs.d/site-lisp/company"))

;; CEDET stuff
;; - project management, senator mode, UML, taglists
(when (file-exists-p "~/.emacs.d/site-lisp/emacs-rc-cedet.el")
  (load-file "~/.emacs.d/site-lisp/emacs-rc-cedet.el"))

;; backup edited files
;; automated revision tracking within emacs:
(if (file-directory-p "~/.backup")
    (setq backup-directory-alist '(("." . "~/.backup")))
  (message "Directory does not exist: ~/.backup"))
 
(setq backup-by-copying t
      delete-old-versions t
      version-control t
      kept-new-versions 30
      kept-old-versions 20)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; expansion != tab-completion != code-assist
;; * expansion: no popup, no semantic backend, stupid-completion
;; * tab-complete: popup, no semantic backend, stupid-popup
;; * sem-assist: popup, semantic mode (semantic-mode)
;; * code-assist: popup, semantic backend (IDE backend)
;; * you get 2 of 4, expansion + one popup varinat based on the mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; hippie: alt-space for _expansion_
;; does mainly: file-names, folders
(global-set-key "\M- " 'hippie-expand)

;; expansion with hippie expand and dabbrev
(setq hippie-expand-try-functions-list '(try-expand-dabbrev-visible
                                         try-complete-file-name
                                         try-expand-dabbrev-from-kill
                                         try-expand-dabbrev
                                         try-expand-dabbrev-all-buffers
                                         try-complete-file-name))

;; so now we can take care of that annoyance:
;; yes OR NO <- y/n
(setq dabbrev-case-fold-search nil
	confirm-kill-emacs 'yes-or-no-p)



;; defaults - like any other editor has: tab-size e.g. 
(setq-default 
 ;; indent-tabs-mode nil 
 tab-width 3
 display-time-load-average   nil
 display-time-interval       30
 display-time-use-mail-icon  t
 require-final-newline 1
 indent-tabs-mode nil
 default-major-mode 'text-mode
 even-window-heights nil
 resize-mini-windows nil
 sentence-end-double-space nil
 display-time-24hr-format t
 browse-url-browser-function 'mt-choose-browser
 default-tab-width 3
 scroll-preserve-screen-position 'keep
 user-mail-address "wishinet@gmail.com"
 user-full-name "Marius"
 inhibit-startup-message t
 diff-switches "-c"
 comment-style 'extra-line
 case-fold-search t
 read-file-name-completion-ignore-case t
 completion-ignore-case t
 cursor-in-non-selected-windows nil
 x-stretch-cursor t
 mouse-yank-at-point t
 mouse-highlight 1
 tab-stop-list
   '(3 6 9 12 15 18 21 24 27 30 33 36 39 42 45 48 51
       54 57 60 63 66 69 72 75 78 81 84 87 90 93 96 99
            )
)
(add-hook 'before-save-hook 'time-stamp)

;; special variables for interoperability: CUA, German 
(custom-set-variables
 '(cua-mode t nil (cua-base))
 '(current-language-environment "German")
 '(display-battery-mode t)
 '(indicate-buffer-boundaries (quote right))
 '(save-place t nil (saveplace))
 '(show-paren-mode t)
 '(uniquify-buffer-name-style (quote forward) nil (uniquify)))

;; set font, no background for terminal 
;; I use Droid Sans Mono everywhere and it looks great
(custom-set-faces
  '(default ((t (:inherit nil :stipple nil  :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 98 :width normal :foundry "unknown" :family "Droid Sans Mono"))))
  )


;; spell-checking - switch German and English dicts
(defun fd-switch-dictionary()
  (interactive)
  (let* ((dic ispell-current-dictionary)
  change (if (string= dic "deutsch8") "english" "deutsch8")))
 	(ispell-change-dictionary change)
   (message "Dictionary switched from %s to %s" dic)
)

(global-set-key (kbd "<f8>")   'fd-switch-dictionary)

;; a custom-function to make flyspell highlight typos
(defun faces_x ()
    (custom-set-faces
     '(flyspell-duplicate ((t (:foreground "Gold3" :underline t :weight normal))))
     '(flyspell-incorrect ((t (:foreground "OrangeRed" :underline t :weight normal))))
))

;; okay, emacs need to know some more detail about the modes
;; here're some basic hooks: C, C++, Java
(add-hook 'c-mode-hook 'turn-on-font-lock)
(add-hook 'c++-mode-hook 'turn-on-font-lock)
(add-hook 'java-mode-hook 'turn-on-font-lock)
(add-hook 'java-mode-hook 'toggle-transient-mark-mode)
(add-hook 'c-mode-hook 'toggle-transient-mark-mode)
(add-hook 'c++-mode-hook 'toggle-transient-mark-mode)

;; JDE + eclim + semantic == win win win
(require 'jde)
(require 'company) 

;; eclim uses a comapny-mode backend
(defun th-turn-on-company-mode ()
  (interactive)
  (company-mode 1)
) 

;; eclim is alpha status, so we track it externally in the VCS dir
(add-to-list 'load-path (expand-file-name "~/Source/emacs-eclim/"))
(add-to-list 'load-path (expand-file-name "~/Source/emacs-eclim/vendor"))
 (require 'eclim)
 (setq eclim-auto-save t)
 (global-eclim-mode)

;; TODO: place the hooks for the appropiate mode 
(dolist (hook (list
               ;; 'emacs-lisp-mode-hook
               ;;                'lisp-mode-hook
               ;;               'lisp-interaction-mode-hook
               ;;                'clojure-mode-hook
                               'java-mode-hook
               ;;                'haskell-mode-hook
               ;;               'slime-repl-mode-hook
               ;;               'sh-mode-hook
                               ))
(add-hook hook 'th-turn-on-company-mode))

;; and hooking into Java
(add-hook 'java-mode-hook 'th-java-mode-init) 



;; note: if you just want semantic for one of these modes, load another backend
;; by manual invocation. I use semantic for C/C++
(setq company-idle-delay nil company-eclim-auto-save t)
(setq company-eclim-executable "~/eclipse_wrk/eclipse_32/plugins/org.eclim_1.6.1/bin/eclim")

(defun th-java-mode-init ()
  (setq company-backend 'company-eclim))
(add-hook 'java-mode-hook 'th-java-mode-init) 


;; TODO extra file
;; night-working theme by entropy, sweet colors
(defun color-theme-nox ()
  "Nice 256 color layout for transparent backgrounds"
  (interactive)
  (color-theme-install
   '(color-theme-nox
     (
     (background-color . "black")
      (border-color . "black")
      (background-mode . "black")
      (cursor-color . "Plum1")
      (foreground-color . "#8bcd8b")
      (mouse-color . "yellow1")
      (top-toolbar-shadow-color . "#e5e5e0e0e1e1")
      )
     (default ((t (nil))))
     (blue ((t (:foreground "#00cdff"))))
     (bold ((t (:bold t))))
     (bold-italic ((t (nil))))
     (border-glyph ((t (nil))))
     (fringe ((t (:background "#5c5c5c" .color "yellow"))))
     (font-lock-builtin-face ((t (:foreground "#8b8b8b"))))
     (highline-face ((t (:foreground "#8bcd8b" :background "#4d4d4d"))))
     (font-lock-comment-face ((t (:bold t :foreground "#737373" :height 0.8))))
     (font-lock-comment-delimiter-face ((t (:bold t :foreground "#737373" :heigh 0.8))))
     (font-lock-constant-face ((t (:bold t :foreground "#8bffcd" ))))
     (font-lock-doc-string-face ((t (:foreground "#00C000"))))
     (font-lock-doc-face ((t (:foreground "SkyBlue1" :background "RoyalBlue4"))))
     (font-lock-function-name-face ((t (:bold nil :foreground "#cdff8b" :height 1.2))))
     (font-lock-keyword-face ((t (:bold t :foreground "#ffcd00" :height 1.1))))
     (font-lock-other-emphasized-face ((t (:bold t :foreground "gold1"))))
     (font-lock-other-type-face ((t (:bold nil :foreground "gold1"))))
     (font-lock-preprocessor-face ((t (:foreground "plum"))))
     (font-lock-reference-face ((t (:bold t :foreground "orangered"))))
     (font-lock-string-face ((t (:foreground "plum" ))))
     (font-lock-type-face ((t (:bold t :foreground "ivory2" :height 1.1))))
     (font-lock-variable-name-face ((t (:foreground "#00ff00"))))
     (font-lock-warning-face ((t (:foreground "tomato"))))
     (flyspell-incorrect ((t (:foreground "#ff8b00"))))
     (flyspell-duplicate ((t (:foreground "#cdcd00"))))
     (green ((t (:foreground "green"))))
     (gui-button-face ((t (:background "grey75" :foreground "black"))))
     (gui-element ((t (:size "nil" :background "#e7e3d6" :foreground" #000000"))))
     (highlight ((t (:background "firebrick4" :foreground "yellow1"))))
     (isearch ((t (:bold t :background "pale turquoise" :foreground "blue"))))
     (italic ((t (nil))))
     (lazy-highlight-face ((t (:bold t :foreground "dark magenta"))))
     (left-margin ((t (nil))))
     (list-mode-item-selected ((t (:bold t :background "gray68" :foreground "yellow"))))
     ;;:overline "CadetBlue" :underline "turquoise4"
     (modeline ((t (:background "#2e2e2e" :foreground "#cdcd8b" :height 0.8))))
     (rcirc-timestamp ((t (:foreground "#5c5c5c"))))
     (rcirc-my-nick ((t (:foreground "#cdff8b"))))
     (rcirc-server ((t (:foreground "#737373"))))
     (rcirc-other-nick ((t (:foreground "#00ff8b"))))
     (rcirc-bright-nick ((t (:foreground "#8bff00-"))))
     (rcirc-prompt ((t (:foreground "cyan"))))
     (minibuffer-prompt ((t (:foreground "#fff" :background "brightred" :bold t))))
     (mode-line-inactive ((t (:italic t :background "#2e2e2e" :foreground "#5c5c5c" :box (:line-width -1 :color "SeaGreen") :slant oblique :weight light :height 0.8))))
     (modeline-buffer-id ((t (:background "#4d4d4d" :foreground "#8bff00k"))))
     (modeline-mousable ((t (:background "red" :foreground "darkblue"))))
     (modeline-mousable-minor-mode ((t (:background "sienna" :foreground "darkblue"))))
     (paren-blink-off ((t (:foreground "DodgerBlue4"))))
     (paren-match ((t (:background "red" :foreground "yellow"))))
     (paren-mismatch ((t (:background "DeepPink"))))
     (pointer ((t (:background "white"))))
     (primary-selection ((t (:bold t :background "medium sea green"))))
     (red ((t (:foreground "red"))))
     (diff-file-header ((t (:foreground "#8b8b8b" :bold t))))
     (diff-header ((t (:foreground "#8b8b8b"))))
     (diff-removed ((t (:foreground "#008b8b"))))
     (diff-added ((t (:foreground "#8bff8b"))))
     (diff-indicator-added ((t (:foreground "#8bff8b"))))
     (region ((t (:background "MediumSeaGreen" :foreground "yellow"))))
     (right-margin ((t (nil))))
     (secondary-selection ((t (:background "gray91" :foreground "sienna3"))))
     ;; (show-paren-match-face ((t (:background "cyan3" :foreground "blue"))))
     (howm-reminder-done-face ((t (:background "#00cd00" :foreground "black"))))
     
     (show-paren-mismatch-face ((t (:background "red" :foreground "blue"))))
     (show-trailing-whitespace ((t (:background "red" :foreground "blue"))))
     (text-cursor ((t (:background "tan" :foreground "DodgerBlue4"))))
     (toolbar ((t (:background "#e7e3d6" :foreground "#000000"))))
     (underline ((t (:underline t))))
     (vertical-divider ((t (:background "red" :foreground "yellow"))))
     (widget-button-face ((t (:bold t))))
     (widget-button-pressed-face ((t (:foreground "red"))))
     (widget-documentation-face ((t (:foreground "dark green"))))
     (widget-field-face ((t (:background "gray85"))))
     (widget-inactive-face ((t (:foreground "dim gray"))))
     (widget-single-line-field-face ((t (:background "gray85"))))
     (yellow ((t (:foreground "yellow"))))
     (circe-originator-face ((t (:foreground "OliveDrab2"))))
     (circe-my-message-face ((t (:foreground "SpringGreen3"))))
     (circe-highlight-nick-face ((t (:foreground "orchid2"))))
     (circe-server-face ((t (:foreground "thistle4"))))
     (circe-prompt-face ((t (:foreground "yellow1" :height 1.0))))
     (lui-button-face ((t (:foreground "yellow1"))))
     (lui-time-stamp-face ((t (:foreground "CadetBlue"))))
     (dired-warning ((t (:foreground "Orange"))))
     (dired-directory ((t (:foreground "LightBlue"))))
     (dired-filename ((t (:foreground "PaleGreen"))))
     
     (comint-highlight-prompt ((t (:foreground "grey10"))))
     (compilation-error ((t (:foreground "grey10"))))
     (compilation-line-number  ((t (:foreground "grey10"))))
     (eshell-ls-archive-face ((t (:bold t :foreground "IndianRed"))))
     (eshell-ls-backup-face ((t (:foreground "Grey"))))
     (eshell-ls-clutter-face ((t (:foreground "DimGray"))))
     (eshell-ls-directory-face ((t (:bold t :foreground "MediumSlateBlue"))))
     (eshell-ls-executable-face ((t (:foreground "Coral"))))
     (eshell-ls-missing-face ((t (:foreground "black"))))
     (eshell-ls-picture-face ((t (:foreground "Violet")))) ; non-standard face
     (eshell-ls-product-face ((t (:foreground "LightSalmon"))))
     (eshell-ls-readonly-face ((t (:foreground "Aquamarine"))))
     (eshell-ls-special-face ((t (:foreground "Gold"))))
     (eshell-ls-symlink-face ((t (:foreground "White"))))
     (eshell-ls-text-face ((t (:foreground "medium aquamarine")))) ; non-standard face
     (eshell-ls-todo-face ((t (:bold t :foreground "aquamarine")))) ; non-standard face
     (eshell-ls-unreadable-face ((t (:foreground "DimGray"))))
     (eshell-prompt-face ((t (:foreground "powder blue"))))
     (emms-playlist-selected-face ((t (:foreground "#8bcd8b" :underline t))))
     (emms-playlist-track-face ((t (:foreground "#8b8b8b"))))
     (emms-browser-album-face ((t (:foreground "#ff8b8b"))))
     (zmacs-region ((t (:background "white" :foreground "midnightblue"))))))
)

(autoload 'highlight-parentheses-mode "highlight-parentheses"
    "highlight parentheses mode" t)

;; tramp - sftp
;; TRAMP mode for edting through I/O ssh
(require 'tramp)
(setq tramp-default-method "ssh")

;; auto-Image File Mode - displays images in buffer
;; kewl for LaTeX documents - guess that doesn't work with nox 
(autoload 'imagetext-show "imagetext")
(add-hook 'image-mode-hook 'imagetext-show)


(defun mt-line-comment-and-duplicate()
  "Comment a line and duplicate it."
  (interactive)
  (let (
        (beg (line-beginning-position))
        (end (+ 1 (line-end-position))))
    (copy-region-as-kill beg end)
    (comment-region beg end)
    (beginning-of-line)
    (forward-line 1)
    (yank)
    (forward-line -1))
)

;; linenumbers
;; linum mode, gloabal, with 2 spaces
(global-linum-mode 1)
(setq linum-format "%d  ")

;; specifics for viper mode
;; the defaults in no way relfect any useable behavior
 (setq viper-mode t)
  (require 'viper)

;; highlight new modeline
  (eval-after-load 'viper
    '(progn
       (setq viper-vi-state-id (concat (propertize "<V>" 'face 'hi-blue-b) " "))
       (setq viper-emacs-state-id (concat (propertize "<E>" 'face 'hi-red-b) " "))
       (setq viper-insert-state-id (concat (propertize "<I>" 'face 'hi-blue-b) " "))
       (setq viper-replace-state-id (concat (propertize "<R>" 'face 'hi-blue-b) " "))
       ;; The property `risky-local-variable' is a security measure
       ;; for mode line variables that have properties
       (put 'viper-mode-string 'risky-local-variable t)))

(setq-default viper-auto-indent t)

(setq viper-change-notification-threshold 0
     viper-expert-level 5
     viper-inhibit-startup-message t
     viper-vi-style-in-minibuffer nil
     viper-want-ctl-h-help t)

(setq-default viper-ex-style-editing nil)
(setq-default viper-ex-style-motion nil)
(setq-default viper-delete-backwards-in-replace t)


; See `viper-adjust-keys-for' - no comment
(defun viper-adjust-keys() 
 (define-key viper-insert-basic-map "\C-m" nil) ; viper-autoindent
 (define-key viper-insert-basic-map "\C-j" nil)
 (define-key viper-insert-basic-map (kbd "<backspace>") nil) 
 ; viper-del-backward-char-in-insert
 (define-key viper-insert-basic-map "" nil)
)


;; company mode - popup completion
(autoload 'company-mode "company" nil t)
(setq company-begin-commands '(self-insert-command))
(global-set-key "\t" 'company-complete-common)
;; (require 'company-bundled-completions)
;; (company-install-bundled-completions-rules)

;; chose:
(defun complete-or-indent ()
  (interactive)
  (if (company-manual-begin)
      (company-complete-common)
    (indent-according-to-mode))
)
  
(defun indent-or-complete ()
    (interactive)
    (if (looking-at "\\_>")
        (company-complete-common)
        (indent-according-to-mode))
)

;; copy & paste behavior 
;; beginner-tip: "normal" tab behavior: in "$programming"-mode press C-q TAB 
(cua-mode t)
(setq cua-auto-tabify-rectangles nil) ;; Don't tabify after rectangle commands
(transient-mark-mode 1) ;; No region when it is not highlighted
(setq cua-keep-region-after-copy t) ;; Standard Windows behaviour


;; special search fkt
;; helper function
;; lists all lines where a regex occures ;)
(defun mt-occur (&optional arg)
    "Switch to *Occur* buffer, or run `occur'.
Without a prefix argument, switch to the buffer.
With a universal prefix argument, run occur again.
With a numeric prefix argument, run occur with NLINES
set to that number."
      (interactive "P")
        (if (and (not arg) (get-buffer "*Occur*"))
                  (switch-to-buffer "*Occur*")
              (occur (read-from-minibuffer "Regexp: ")
                                (if (listp arg) 0 arg))))

(add-hook 'occur-mode-hook
                    (lambda ()
                                  (local-set-key (kbd "<f1>") 'occur-next-error)))

(defun mt-text-setup ()
    "Setup a text buffer,"
      (line-number-mode 1)
        (mt-turn-on-show-trailing-whitespace)
          (auto-fill-mode 1))


