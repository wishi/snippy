;; This is a .emacs optimised for Aquamacs
;; to work with auctex and Latex. 
;; There's practically no alternative if you use AMS TeX.
;; Don't tell me that my LISP sucks. I know that!
;; -- wishi

;; F6 -> next error
;; I know that's sooo Borland. But I love it ;)
(global-set-key  [f6]  'next-error)

;; BUG: okay, this is OLD, but there're German Mac Users
;; - We suffer, too!
;;(global-set-key (kbd "\C-c \C-@") 'TeX-next-error)
;;(global-set-key (kbd "\C-c ¿") 'TeX-next-error)

;; IF aspell
;; (setq ispell-program-name "aspell")
;; (add-to-list 'exec-path "/opt/local/bin/aspell")

;; IF cocoaspell
;; ;; CocoaSpell
;; (setq ispell-dictionary-alist
;;       '((nil
;; 	 "[A-Za-z]" "[^A-Za-z]" "[']" nil
;; 	 ("-B" "-d" "german" "--dict-dir"
;; 	  "/Library/Application Support/cocoAspell/aspell6-de-20030222-1")
;; 	 nil iso-8859-1)))

;; Auto-Image File Mode - displays images 
(autoload 'imagetext-show "imagetext")
(add-hook 'image-mode-hook 'imagetext-show)

;; previous highlighted word
;; (global-set-key (kbd ÒC-c jÓ) Ôflyspell-check-previous-highlighted-word)
;;
;; this adds clear to the eshell
(defun eshell/clear ()
  (interactive)
  (let ((inhibit-read-only t))
    (erase-buffer)))

;; emacs wget configuration:
(setq wget-command "/opt/local/bin/wget")
(autoload 'wget "wget" "wget interface for Emacs." t)
        (autoload 'wget-web-page "wget" "wget interface to download whole web page." t)

;; emacs wget
(add-to-list 'load-path "/usr/local/share/emacs/site-lisp/emacs-wget")

;; open last session:
;;(desktop-save-mode 1)
;;    ;; Customization follows below
;;    (setq history-length 250)
;;    (add-to-list 'desktop-globals-to-save 'file-name-history)

;; a little neat transparency effect 
(modify-frame-parameters (selected-frame) '((alpha . 98)))

;; strict one frame, many buffers
(one-buffer-one-frame-mode 0)

;; w3m stuff 
(add-to-list 'exec-path "/opt/local/bin")
(add-to-list 'load-path "/opt/local/share/emacs/site-lisp/w3m")
(require 'w3m-load) 
;; (setq browse-url-browser-function 'w3m-browse-url)
 ;; (autoload 'w3m-browse-url "w3m" "Ask a WWW browser to show a URL." t)
 ;; optional keyboard short-cut
 ;; (global-set-key "\C-xm" 'browse-url-at-point)
(setq w3m-use-cookies t)

;; linum mode
(add-to-list 'load-path "/opt/local/share/emacs/site-lisp/")
(require 'linum)
(add-hook 'find-file-hook (lambda () (linum-mode 1)))

;; Titles
(setq frame-title-format "emacs - %b")

;; window height
(setq compilation-window-height 4)

;; Display time
(display-time)

;; Minibuffer completion
(add-hook 'minibuffer-setup-hook    
          '(lambda ()  
         (define-key minibuffer-local-map "\t" 'comint-dynamic-complete)))


;; Toolbar futschen
(tool-bar-mode nil)

;; Generally neat for editing tables
(require 'table)

;; Functions for open functions
(defun open-finder-here ()
  (interactive)
  (shell-command "open ."))
(defun open-file-in-mac ()
  (interactive)
  (shell-command
   (concat "open " (buffer-file-name))))

;; Set a narrow and blinking cursor
(blink-cursor-mode t)
(setq-default cursor-type '(bar . 2))

;; VIPER Bug:
(when (featurep 'aquamacs)
   (raise-frame))
 (setq viper-mode t)
 (add-hook 'emacs-startup-hook 'viper-mode)

;; VIPER
 (setq viper-mode t)
  (require 'viper)

 (when (featurep 'aquamacs)
   (raise-frame))
 (setq viper-mode t)
  (add-hook 'emacs-startup-hook 'viper-mode)

;; Line numbers
; Show line-number in the mode line
(line-number-mode 1) 
;; this is not linum

;; mutt wants this if used as an editor
; no backups
(setq make-backup-files nil) 

;; UTF8 terminal fix
(set-terminal-coding-system 'utf-8)
   (set-keyboard-coding-system 'utf-8)
   (prefer-coding-system 'utf-8)

;; Terminal.app Applescript hack
 (defun mac-open-terminal ()
   (interactive)
   (let ((dir ""))
     (cond
      ((and (local-variable-p 'dired-directory) dired-directory)
       (setq dir dired-directory))
      ((stringp (buffer-file-name))
       (setq dir (file-name-directory (buffer-file-name))))
      )
     (do-applescript
      (format "
 tell application \"Terminal\"
   activate
   try
     do script with command \"cd %s\"
   on error
     beep
   end try
 end tell" dir))
     ))

;; Tab completion
 (global-set-key [(tab)] 'smart-tab)
 (defun smart-tab ()
   "This smart tab is minibuffer compliant: it acts as usual in
     the minibuffer. Else, if mark is active, indents region. Else if
     point is at the end of a symbol, expands it. Else indents the
     current line."
   (interactive)
   (if (minibufferp)
       (unless (minibuffer-complete)
         (dabbrev-expand nil))
     (if mark-active
         (indent-region (region-beginning)
                        (region-end))
       (if (looking-at "\\_>")
           (dabbrev-expand nil)
         (indent-for-tab-command)))))

;; spell check display hack
(defun faces_x ()
  (custom-set-faces
'(flyspell-duplicate ((t (:foreground "Gold3" :underline t :weight normal))))
'(flyspell-incorrect ((t (:foreground "OrangeRed" :underline t :weight normal))))
))

;; .tex files are managed in LaTeX + reftex + autofill modes
(setq auto-mode-alist (cons '("\\.tex$" . LaTeX-mode) auto-mode-alist)) 
(add-hook 'LaTeX-mode-hook 'turn-on-auto-fill)
(add-hook 'LaTeX-mode-hook 'reftex-mode)
(add-hook 'LaTeX-mode-hook 'flyspell-mode)

;; Flyspell
;;  (defcustom flyspell-before-incorrect-word-string nil
;;     "String used to indicate an incorrect word."
;;     ;; If this is set to a string, the string persists in the buffer if
;;     ;; flyspell-auto-correct-word is called. It persists until
;;     ;; flyspell-delete-overlays is called.
;;     :group 'flyspell
;;     :type 'string)
;;   (defcustom flyspell-after-incorrect-word-string "<-"
;;     "String used to indicate an incorrect word."
;;     :group 'flyspell
;;     :type 'string)
;;   (defun make-flyspell-overlay (beg end face mouse-face)
;;     "Allocate an overlay to highlight an incorrect word.
;;   BEG and END specify the range in the buffer of that word.
;;   FACE and MOUSE-FACE specify the `face' and `mouse-face' properties
;;   for the overlay."
;;     (let ((flyspell-overlay (make-overlay beg end nil t nil)))
;;       (overlay-put flyspell-overlay 'face face)
;;       (overlay-put flyspell-overlay 'mouse-face mouse-face)
;;       (overlay-put flyspell-overlay 'flyspell-overlay t)
;;       (if flyspell-use-local-map
;;           (overlay-put flyspell-overlay
;;                        flyspell-overlay-keymap-property-name
;;                        flyspell-mouse-map))
;;       (when (eq face 'flyspell-incorrect-face)
;;         (and (stringp flyspell-before-incorrect-word-string)
;;              (overlay-put flyspell-overlay 'before-string
;;                           flyspell-before-incorrect-word-string))
;;         (and (stringp flyspell-after-incorrect-word-string)
;;              (overlay-put flyspell-overlay 'after-string
;;                           flyspell-after-incorrect-word-string)))
;;       flyspell-overlay))


;; Mailstuff
(expand-file-name "~/.authinfo")

;; GMAIL
(setq send-mail-function 'smtpmail-send-it
      message-send-mail-function 'smtpmail-send-it
      smtpmail-starttls-credentials
      '(("smtp.gmail.com" 587 nil nil))
      smtpmail-auth-credentials
      '(("smtp.gmail.com" 587 "marius.ciepluch@gmail.com" nil))
      smtpmail-default-smtp-server "smtp.gmail.com"
      smtpmail-smtp-server "smtp.gmail.com"
      smtpmail-smtp-service 587
      smtpmail-debug-info t)
(require 'smtpmail)

;; company mode
;; company-mode requires Emacs 22.
(require 'company-mode)
(require 'company-bundled-completions)
(company-install-bundled-completions-rules)

(add-to-list 'load-path "/opt/local/share/emacs/site-lisp/g-client")
(load-library "g")

;; TRAMP mode
;; /usr/local/info
;; (add-to-list 'load-path " /usr/local/info")
(require 'tramp)
(setq tramp-default-method "ssh")

;; hown - for notes
(add-to-list 'load-path "/opt/local/share/emacs/site-lisp/howm")
;; (add-to-list 'load-path "~/.emacs.d/hown/howm-1.3.6")
(require 'howm)

;; Source Indent
(add-hook 'c++-mode-hook 'my-set-newline-and-indent)
(add-hook 'c-mode-hook 'my-set-newline-and-indent)

;; Tabkey2
;; (add-to-list 'load-path ".emacs.d/tabkey2")
;; (require 'tabkey2)
