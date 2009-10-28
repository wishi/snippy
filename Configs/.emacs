""" 
This is a .emacs optimised for Aquamacs (emacs 23, MacOS, GUI)

 - to work with auctex, e. g. AMS LaTeX
 - to enable interactive OCaml and F# (mono-based) sessions (hooked tuareg mode)
 - mode-configs for dylan, haskell, f#, ocaml, iPython, Ruby and C/C++. 
 * dunno, still looking for kewl Java and C# hacks here (sucks without IDE)
 - emacs-wget and w3m-emacs fun-stuff 
 - for buffer-based tab-completion: popup based  through company mode 
   like omnicomplete 
 	
 - combines advantages of vim and emacs (viper mode) 
		* if you hate it: your problem. 

 -> There's practically no alternative if you use AMS TeX
 -> There's practically no alternative if you do functional programming
 -> There's practically no better editor, however you'll need years to master it
 

 Don't tell me that my LISP sucks. I know that! Therefore most of this is stolen.
 Thank you all!

 -- wishi
"""

;; F6 -> next error
;; I know that's sooo Borland
(global-set-key  [f6]  'next-error)

;; Aquamacs has native spell checking nowadays, and aspell always sucked
;; (setq ispell-program-name "aspell")		
;; (add-to-list 'exec-path "/opt/local/bin/aspell")

;; This was a nasty hack... really sucked!
;; IF cocoaspell
;; ;; CocoaSpell
;; (setq ispell-dictionary-alist
;;       '((nil
;; 	 "[A-Za-z]" "[^A-Za-z]" "[']" nil
;; 	 ("-B" "-d" "german" "--dict-dir"
;; 	  "/Library/Application Support/cocoAspell/aspell6-de-20030222-1")
;; 	 nil iso-8859-1)))

;; beginner-tip: "normal" tab behavior: in "$programming"-mode press C-q TAB 
(global-set-key (kbd "TAB") 'self-insert-command);

;; reasonable defaults - mostly copied from entropy's .emacs
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
 default-tab-width 2
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

;; various minor modes
(dolist (i '((auto-image-file-mode 1)              
             (global-auto-revert-mode 1)
             ;; (line-number-mode -1)
             (display-time-mode 1)
             (column-number-mode 1)
             (show-paren-mode 1)
             (winner-mode 1)
             (tooltip-mode -1)
             (size-indication-mode 1)
             (transient-mark-mode 0)
             (global-font-lock-mode 1)
             (auto-compression-mode 1)
             ))
  (when (fboundp (car i))
    (funcall (car i) (cdr i))))

;; auto-Image File Mode - displays images in buffer
;; kewl for LaTeX documents  
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
    (forward-line -1)))

;; F# specific configs 
;; hooked ocaml tuareg mode. If you do ML with mono e. g. 
(add-to-list 'load-path "~/.elisp/tuareg-mode")
    (autoload 'tuareg-mode "tuareg" "Major mode for editing Caml code" t)
    (autoload 'camldebug "camldebug" "Run the Caml debugger" t)
    (autoload 'tuareg-imenu-set-imenu "tuareg-imenu" 
      "Configuration of imenu for tuareg" t) 
    (add-hook 'tuareg-mode-hook 'tuareg-imenu-set-imenu)
    (setq auto-mode-alist 
        (append '(("\\.ml[ily]?$" . tuareg-mode)
	          ("\\.topml$" . tuareg-mode))
                  auto-mode-alist))

;; now we use *.fs files for this mode
(setq auto-mode-alist (cons '("\\.fs\\w?" . tuareg-mode) auto-mode-alist))

(add-hook 'tuareg-mode-hook
       '(lambda ()
       (set (make-local-variable 'compile-command)
        (concat "fsc \""
            (file-name-nondirectory buffer-file-name)
            "\""))))

(defun tuareg-find-alternate-file ()
  "Switch Implementation/Interface."
  (interactive)
  (let ((name (buffer-file-name)))
    (if (string-match "\\`\\(.*\\)\\.fs\\(i\\)?\\'" name)
    (find-file (concat (tuareg-match-string 1 name)
               (if (match-beginning 2) ".fs" ".fsi"))))))


(defun mt-major-mode-p (symbol)
  "Return non-nil if SYMBOL is a major mode.
Used in `interactive' forms to read major mode names from the user."
  (and (fboundp symbol)
       (let ((function-name (symbol-name symbol)))
         (and (string-match "-mode\\'" function-name)
              (not (string-match "\\`turn-\\(on\\|off\\)-"
                                 function-name))))
       (not (assq symbol minor-mode-alist))))

(defun mt-read-major-mode ()
  "Read a major mode from the user, and return it.
Based on Kevin Rogers' `edit-region' interactive spec."
  (intern (completing-read
           (format "Major mode (default `%s'): " major-mode)
           obarray 'mt-major-mode-p t nil nil
           (symbol-name major-mode))))

(defun mt-edit-region (&optional edit-mode)
  "Edit the current region in a separate buffer.
With a prefix arg, change `major-mode' to EDIT-MODE."
  (interactive (list (when current-prefix-arg (mt-read-major-mode))))
  (clone-indirect-buffer nil t)
  (narrow-to-region (region-beginning) (region-end))
  (shrink-window-if-larger-than-buffer)
  (when edit-mode (funcall edit-mode)))

(defun mt-kill-mode-buffers (&optional mode)
  "Kill all buffers of this major mode.
With optional argument MODE, all buffers in major mode MODE are killed
instead."
  (interactive (list (when current-prefix-arg (ted-read-major-mode))))
  (setq mode (or mode major-mode))
  (when (or current-prefix-arg
            (y-or-n-p (format "Really kill all %s buffers? " mode)))
    (mapc (lambda (buffer)
            (when (with-current-buffer buffer
                    (eq major-mode mode))
              (kill-buffer buffer)))
          (buffer-list))))

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

;; w3m and emacs 23 aren't friends jet (non CVS version)
;; (add-to-list ‘w3m-command-environment ‘(“GC_NPROCS” . “1”))
;;(require 'w3m-e21)
;; (provide 'w3m-e23)

(defun mt-w3m-setup ()
  "Setup a w3m buffer."
  (set (make-local-variable 'auto-hscroll-mode) nil)
  ;; (setq browse-url-browser-function 'w3m-browse-url
  ;;       browse-url-new-window-flag f)
  (setq w3m-use-cookies t
        w3m-cookie-accept-bad-cookies t
        w3m-use-tab nil
        w3m-use-tab-menubar nil
        w3m-auto-show nil)
  (mapc
   (lambda (mapping)
     (apply #'define-key w3m-mode-map mapping))
   `((,(kbd "C-c C-@") lui-track-next-buffer)
     (,(kbd "<down>") next-line)
     (,(kbd "<up>") previous-line)
     (,(kbd "<right>") forward-char)
     (,(kbd "<left>") backward-char)
     (,(kbd "C-x b") ido-switch-buffer))))


;; Dylan mode config
(defun mt-dylan-setup ()
  "Setup a dylan buffer."
  (line-number-mode 1)
  (abbrev-mode 1)
  (filladapt-mode 1)
  (set (make-local-variable 'auto-hscroll-mode) nil)
  (mapc
   (lambda (mapping)
     (apply #'define-key dylan-mode-map mapping))
   `(
     (,(kbd "C-c C-c") compile)
     )))


;; Haskell mode config
(defun mt-haskell-setup ()
  "Setup a haskell buffer."
  (line-number-mode 1)
  (abbrev-mode 1)
  (filladapt-mode 1)
  (set (make-local-variable 'auto-hscroll-mode) nil)
  (turn-on-font-lock)
  (turn-on-haskell-decl-scan)
  (turn-on-haskell-doc-mode)
  (turn-on-haskell-indent)
  (set-variable 'haskell-program-name "ghci")
  (setq compile-command  "make")
  (setq comment-padding " ")
  (setq comment-start "--"))

(add-to-list 'auto-mode-alist '("\\.[hg]s$"   . haskell-mode))
(add-to-list 'auto-mode-alist '("\\.hi$"      . haskell-mode))
(add-to-list 'auto-mode-alist '("\\.l[hg]s$"  . literate-haskell-mode))
(autoload 'haskell-mode "haskell-mode"
  "Major mode for editing Haskell scripts" t)
(autoload 'literate-haskell-mode "haskell-mode"
  "Major mode for editing literate Haskell scripts" t)
(autoload 'run-ghci "haskell-ghci"
  "Go to the *ghci* buffer" t nil)
;;(set-variable 'haskell-program-name "ghci")
(defalias 'run-haskell (quote switch-to-haskell))
(autoload (quote switch-to-haskell) "inf-haskell"
  "Show the inferior-haskell buffer.  Start the process if needed." t nil)

(add-hook 'haskell-mode-hook 'mt-haskell-setup)


(autoload 'highlight-parentheses-mode "highlight-parentheses"
  "highlight parentheses mode" t)

(add-to-list 'filladapt-token-table '("-- " haskell-comment))
(add-to-list 'filladapt-token-match-table '(haskell-comment haskell-comment))
(add-to-list 'filladapt-token-conversion-table '(haskell-comment . exact))

(defun mt-sass-setup ()
  (mapc
   (lambda (mapping)
     (apply #'define-key sass-mode-map mapping))
   `((,(kbd "RET") newline-and-indent)
     )))

(defun mt-haml-setup ()
  (mapc
   (lambda (mapping)
     (apply #'define-key haml-mode-map mapping))
   `((,(kbd "RET") newline-and-indent)
     )))

;; Python mode config - needs some work to work ;)
;; setq load-path
;;      (append (list nil	"~/.emacs.d/ipython"
;;		                 	)
;;              load-path)
; (require 'ipython)
;; (setq py-python-command-args '( "-colors" "Linux"))

;; (require 'python-mode)
;; (require 'pymacs)
;; (pymacs-load "ropemacs" "rope-")

;; ipython instead of standard interpreter shell
;; (setq ipython-completion-command-string "print(';'.join(__IP.Completer.all_completions('%s')))\n")
;; afaik the python mode completions are deprecated

;; hown - for project notes
(add-to-list 'load-path "/opt/local/share/emacs/site-lisp/howm")
;; (add-to-list 'load-path "~/.emacs.d/hown/howm-1.3.6")
(require 'howm)

;; - helps to keep notes about projects
(defun mt-howmc-setup ()
  ;; (mapc
  ;;  (lambda (mapping)
  ;;    (apply #'define-key howm-mode-map mapping))
  ;;  `((,(kbd "RET") haml-indent-line)
  ;;    ))
)

;; html stuff... very basic
(defun mt-html-setup ()
  "Initialize the HTML mode for my purposes."
  (set (make-local-variable 'time-stamp-start)
       "<!-- time stamp start -->\n")
  (set (make-local-variable 'time-stamp-end)
       "\n<!-- time stamp end -->")
  (set (make-local-variable 'time-stamp-format)
       "<p class=\"timestamp\">Last modified: %3a %3b %2d %02H:%02M:%02S %Z %:y</p>")
  (set (make-local-variable 'time-stamp-line-limit) 0)
  (when (= (point-min)
           (point-max))
    (let ((ins nil))
      (if (string-match "\\.ht$" (buffer-file-name))
          (progn
            (insert "<h1>")
            (setq ins (point))
            (insert "</h1>\n")
            (insert "\n"
                    "<!-- time stamp start -->\n"
                    "\n"
                    "<!-- time stamp end -->\n"))
        (insert "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Strict//EN\"\n"
                "                      \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd\">\n"
                "<html xmlns=\"http://www.w3.org/1999/xhtml\">\n"
                "<head>\n"
                "<link rel=\"stylesheet\" type=\"text/css\" href=\"screen.css\"/>\n"
                "<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\" />\n"
                "<title>")
        (setq ins (point))
        (insert "</title>\n"
                "</head>\n"
                "\n"
                "<body>\n"
                "<h1></h1>\n"
                "\n"
                "\n"
                "\n"
                "<hr />\n"
                "<address>"
                "ackro.ath.cx"
                "</address>\n"
                "<!-- Created: "
                (format-time-string "%a %b %e %T %Z %Y")
                " -->\n"
                "<!-- time stamp start -->\n"
                "\n"
                "<!-- time stamp end -->\n"
                "</body> </html>\n"))
      (goto-char ins))))

(defun mt-turn-on-show-trailing-whitespace ()
  "Set `show-trailing-whitespace' to t."
  (setq show-trailing-whitespace t))

(defun mt-try-complete-abbrev (old)
  (if (expand-abbrev) t nil))

(defadvice comment-dwim (around xmp-hack activate)
  ""
  (if (and (eq last-command 'comment-dwim))
      (insert "=>")  ad-do-it))

(defun mt-isearch-occur ()
  "Invoke `occur' from within isearch."
  (interactive)
  (let ((case-fold-search isearch-case-fold-search))
    (occur (if isearch-regexp isearch-string (regexp-quote isearch-string)))))

(defun mt-match-paren (arg)
  "Go to the matching paren if on a paren; otherwise insert %."
  (interactive "p")
  (cond ((looking-at "\\s\(") (forward-list 1) (backward-char 1))
        ((looking-at "\\s\)") (forward-char 1) (backward-list 1))
        (t (self-insert-command (or arg 1)))))

(defun isearch-yank-regexp (regexp)
  "Pull REGEXP into search regexp." 
  (let ((isearch-regexp nil)) ;; Dynamic binding of global.
    (isearch-yank-string regexp))
  (isearch-search-and-update))
  
(defun isearch-yank-symbol (&optional partialp)
  "Put symbol at current point into search string.
  
  If PARTIALP is non-nil, find all partial matches."
  (interactive "P")
  (let* ((sym (find-tag-default))
         ;; Use call of `re-search-forward' by `find-tag-default' to
         ;; retrieve the end point of the symbol.
         (sym-end (match-end 0))
         (sym-start (- sym-end (length sym))))
    (if (null sym)
        (message "No symbol at point")
      (goto-char sym-start)
      ;; For consistent behavior, restart Isearch from starting point
      ;; (or end point if using `isearch-backward') of symbol.
      (isearch-search)
      (if partialp
          (isearch-yank-string sym)
        (isearch-yank-regexp
         (concat "\\_<" (regexp-quote sym) "\\_>"))))))
  
(defun isearch-current-symbol (&optional partialp)
  "Incremental search forward with symbol under point.
  
  Prefixed with \\[universal-argument] will find all partial
  matches."
  (interactive "P")
  (let ((start (point)))
    (isearch-forward-regexp nil 1)
    (isearch-yank-symbol partialp)))
  
;; by xsteve
(defun mt-show-message-buffer (arg)
  "Show the *message* buffer.
When called with a prefix argument, show the *trace-output* buffer."
  (interactive "P")
  (let ((buffer (current-buffer)))
    (pop-to-buffer (if arg "*trace-output*" "*Messages*"))
    (goto-char (point-max))
    (recenter -12)
    (pop-to-buffer buffer)))

(defun mt-show-scratch-buffer ()
  "Show the *scratch* buffer."
  (interactive)
  (let ((buffer (current-buffer)))
    (pop-to-buffer "*scratch*")
    (goto-char (point-max))
    (recenter -12)
    (pop-to-buffer buffer)))

(defun isearch-backward-current-symbol (&optional partialp)
  "Incremental search backward with symbol under point.
  
  Prefixed with \\[universal-argument] will find all partial
  matches."
  (interactive "P")
  (let ((start (point)))
    (isearch-backward-regexp nil 1)
    (isearch-yank-symbol partialp)))


;; just a signature inersert - help function
(defun mt-insert-signature ()
  (interactive)
  (insert (shell-command-to-string "mksig")))

(defvar url-nonrelative-link "\\`\\([-a-zA-Z0-9+.]+:\\)"
  "A regular expression that will match an absolute URL.")

(defun mt-textile-region-to-file (start end)
  (interactive "r")
  "Save current region in a temporarily file and return the filename as string"
  (shell-command-on-region start end (concat "2textile.rb" " ")))

(defun mt-qp-decode (start end)
  (interactive "r")
  (let ((coding-system-for-read 'latin-1))
    (shell-command-on-region start end (concat "qp -d" " ") t))
  (fill-region start end))

(defun mt-nopaste-region-to-file (start end)
  "Save current region in a temporarily file and return the filename as string"
  (let ((filename (make-temp-file "/tmp/nopaste")))
    (kill-ring-save start end)
    (find-file filename)
    (yank)
    (save-buffer)
    (kill-buffer (substring filename 5))
    filename))

(defun mt-nopaste-send (file)
  (message (concat "pasting with " nopaste-facility))
  (kill-new
   (shell-command-to-string (concat nopaste-facility " " file))))

(defun mt-nopaste-region (start end)
  "Send the current region to nopaste"
  (interactive "r")
  (mt-nopaste-send (mt-nopaste-region-to-file start end)))


(defun mt-insert-last-paste ()
  "Insert last paste url from ~/.lastpste"
  (interactive)
  (save-excursion
    (insert-file-literally "/Users/mit/.lastpste"))
  (goto-char (point-at-eol)))

(defun mt-kill-file-and-buffer ()
  "Removes file associated to current buffer."
  (interactive )
  (when (y-or-n-p (concat "Delete " buffer-file-name "? "))
    (delete-file (buffer-file-name))
    (kill-buffer nil)))

(defun mt-insert-ackro-post-skel (comp)
  "Insert what we're playing right now."
  (interactive "sComponent? ")
  (save-excursion
    (let ((coding-system-for-read 'latin-1))
      (call-process "/Users/mit/bin/backbite" nil t nil (concat "polis gen post " comp)))
    (backward-delete-char 1))
  (goto-char (point-at-eol)))


;;25.07.2000; xsteve
(defun mt-copy-buffer-file-name-as-kill(choice)
  "Copy the buffer-file-name to the kill-ring"
  (interactive "cCopy BufferName (f)ull, (d)irectory, (n)ame, (w)ikiname or (q)uit?")
  ;(message "your choice %c" choice)
  (let ((new-kill-string)
        (name (if (eq major-mode 'dired-mode)
                  (dired-get-filename)
                (or (buffer-file-name) ""))))
    (cond ((eq choice ?f)
           (setq new-kill-string name))
          ((eq choice ?d)
           (setq new-kill-string (file-name-directory name)))
          ((eq choice ?n)
           (setq new-kill-string (file-name-nondirectory name)))
          ((eq choice ?w)
           (setq new-kill-string (run-hook-with-args-until-success 'planner-annotation-functions))))
    (when new-kill-string
      (message "%s copied" new-kill-string)
      (kill-new new-kill-string))))


;;08.04.2003: Kai Großjohann
;;2008-03-17: Michael 'mictro' Trommer <mictro@gmail.com>, use prefix
(defun mt-increment-number-at-point (amount)
  "Increment number at point by given AMOUNT."
  (interactive "P")
  (let ((bounds (bounds-of-thing-at-point 'symbol))
        (old-num (number-at-point)))
    (unless old-num
      (error "No number at point"))
    (delete-region (car bounds) (cdr bounds))
    (insert (format "%d" (+ old-num (if amount amount 1))))))


(defun mt-insert-mpd-np (prefix)
  "Insert what we're playing right now."
  (interactive "P")
  (save-excursion
    (let ((coding-system-for-read 'utf-8))
      (call-process "/Users/mit/bin/np" nil t nil (if prefix "ssh" "")))
    (backward-delete-char 1))
  (goto-char (point-at-eol)))

(defun mt-insert-userid ()
  "Insert the my full name and address"
  (interactive)
  (insert "Michael 'mictro' Trommer <mictro@gmail.com>"))

(defun mt-indent-buffer ()
  (interactive)
  (save-excursion
    (indent-region (point-min) (point-max) nil)))

(require 'calendar)
(defun mt-insert-any-date (&optional days)
  (interactive "p*")
  (insert
   (calendar-date-string
    (calendar-gregorian-from-absolute
     (+ (calendar-absolute-from-gregorian (calendar-current-date))
        days)))))

(defun mt-insert-date (prefix)
  "Insert the current date. With prefix-argument, use ISO format. With
two prefix arguments, write out the day and month name."
  (interactive "P")
  (let ((format (cond
                 ((not prefix) "%Y-%m-%d")
                 ((equal prefix '(4)) "%d.%m.%Y")
                 (t "%A, %d. %B %Y")))
        (system-time-locale "de_DE"))
    (insert (format-time-string format))))


(defun mt-kill-to-beginning-of-line ()
  "Kill from the beginning of the line to point."
  (interactive)
  (kill-region (point-at-bol)
               (point)))

(defun mt-remove-cr ()
  "Remove all occurrences of ^M in the current buffer."
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (while (re-search-forward "\r" nil t)
      (replace-match ""))))

(defun mt-quoted-insert-file (name delim)
  "Insert contents of a file with a delimiter, as in mail."
  (interactive "*fInsert file: \nsDelimiter (default \"> \"):")
  (if (string= ""delim) (setq delim "> "))
  (insert-file name)
  (replace-regexp "^"delim))

(defun mt-unfill-paragraph ()
  (interactive)
  (let ((fill-column (point-max)))
    (fill-paragraph nil)))

(defun mt-indent-or-complete ()
  "Complete if point is at end of a word, otherwise indent line."
  (interactive)
  (if snippet
      (snippet-next-field)
    (if (looking-at "\\>")
        (dabbrev-expand nil)
      (indent-for-tab-command))))

(defun mt-insert-gpl-v2 ()
  "Insert standard GPL header."
  (interactive "*")
  (insert "# programm - the description\n"
          "# Copyright (C) Marius Ciepluch, wishinet@gmail.com"
          "#\n"
          "# This program is free software; you can redistribute it and/or\n"
          "# modify it under the terms of the GNU General Public License\n"
          "# as published by the Free Software Foundation; either version 2\n"
          "# of the License, or (at your option) any later version.\n"
          "#\n"
          "# This program is distributed in the hope that it will be useful,\n"
          "# but WITHOUT ANY WARRANTY; without even the implied warranty of\n"
          "# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n"
          "# GNU General Public License for more details.\n"
          "#\n"
          "# You should have received a copy of the GNU General Public License\n"
          "# along with this program; if not, write to the Free Software\n"
          "# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.\n"
          "#\n\n"))

(defun mt-lorem ()
  "Insert a lorem ipsum."
  (interactive)
  (insert "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do "
          "eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad "
          "minim veniam, quis nostrud exercitation ullamco laboris nisi ut "
          "aliquip ex ea commodo consequat. Duis aute irure dolor in "
          "reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla "
          "pariatur. Excepteur sint occaecat cupidatat non proident, sunt in "
          "culpa qui officia deserunt mollit anim id est laborum."))


(defun mt-eshell-maybe-bol ()
  (interactive)
  (let ((p (point)))
    (eshell-bol)
    (if (= p (point))
        (beginning-of-line))))

(defun mt-dict-cc (word)
  (interactive "sWord: ")
  (w3m-browse-url 
   (format "http://dict.cc/?s=%s" 
           (w3m-url-encode-string word))))

(defun mt-google (what)
  "Use google to search for WHAT."
  (interactive "sSearch: ")
  (w3m-browse-url (concat "http://www.google.de/search?q="
                          (w3m-url-encode-string what))))

(defalias 'g (symbol-function 'mt-google))

;; http://www.ee.ryerson.ca/~elf/pb/mac-dot-emacs
(defun next-word () (interactive) (forward-word 2) (backward-word 1))

(defun mt-choose-browser (url &rest args)
  (interactive "sURL: ")
  (if (y-or-n-p "External browser? ")
      ;;(mt-browse-url-firefox-new-tab url)
      (setq browse-url-browser-function 'browse-url-default-macosx-browser)
    (w3m-browse-url url)))

;; (defun mt-browse-url-firefox-new-tab (url &optional new-window)
;;   "Open URL in a new tab in Firefox."
;;   (interactive (browse-url-interactive-arg "URL: "))
;;   (shell-command-to-string (concat "btab '" url "'" )))


;; getting rfc text
(defun rfc (num)
  "Show RFC NUM in a buffer."
  (interactive "nRFC (0 for index): ")
  (let ((url (if (zerop num)
                 "http://www.ietf.org/iesg/1rfc_index.txt"
               (format "http://www.ietf.org/rfc/rfc%i.txt" num)))
        (buf (get-buffer-create "*RFC*")))
    (with-current-buffer buf
      (let ((inhibit-read-only t))
        (delete-region (point-min) (point-max))
        (let ((proc (start-process "wget" buf "wget" "-q" "-O" "-" url)))
          (set-process-sentinel proc 'rfc-sentinel))
        (message "Getting RFC %i..." num)))))

(defun rfc-sentinel (proc event)
  "Sentinel for `rfc'."
  (with-current-buffer (process-buffer proc)
    (goto-char (point-min))
    (view-mode 1)
    (when (fboundp'rfcview-mode)
      (rfcview-mode)))
  (display-buffer (process-buffer proc)))

(provide 'mt-functions)

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

;; java mode completion hook
;; (add-to-list 'load-path "~/.emacs.d/java")
;; (add-hook 'java-mode-hook (lambda () (local-set-key (kbd "C-<tab>") 'java-complete)))

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



;; Set a narrow and blinking cursor
(blink-cursor-mode t)
(setq-default cursor-type '(bar . 2))


;; VIPER Bug circumvention
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

;; UTF8 terminal fix
(set-terminal-coding-system 'utf-8)
   (set-keyboard-coding-system 'utf-8)
   (prefer-coding-system 'utf-8)

;; Functions for open functions
(defun open-finder-here ()
  (interactive)
  (shell-command "open ."))
(defun open-file-in-mac ()
  (interactive)
  (shell-command
   (concat "open " (buffer-file-name))))

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

;; company mode
(add-to-list 'load-path "~/.emacs.d/company")
(autoload 'company-mode "company" nil t)
(setq company-begin-commands '(self-insert-command))

;; company mode actually seems to be preferable
;; completion ui
;; (add-to-list 'load-path "~/.emacs.d/completion-ui")
;; (require 'completion-ui)
;; (global-set-key (kbd "C-<tab>") 'dabbrev-expand)
;;    (define-key minibuffer-local-map (kbd "C-<tab>") 'dabbrev-expand)


;; Tab completion
  ;; (global-set-key [(tab)] 'smart-tab)
  ;; (defun smart-tab ()
  ;;   "This smart tab is minibuffer compliant: it acts as usual in
  ;;     the minibuffer. Else, if mark is active, indents region. Else if
  ;;     point is at the end of a symbol, expands it. Else indents the
  ;;     current line."
  ;;   (interactive)
  ;;    (if (minibufferp)
  ;;        (unless (minibuffer-complete)
  ;;          (dabbrev-expand nil))
  ;;      (if mark-active
  ;;          (indent-region (region-beginning)
  ;;                         (region-end))
  ;;        (if (looking-at "\\_>")
  ;;            (dabbrev-expand nil)
  ;;          (indent-for-tab-command)))))


;; @BUGGY
;; cedet mode
;; (load-file "~/.emacs.d/cedet/cedet-1.0pre6/common/cedet.el")
;; (require 'semantic-ia)
;; (require 'semantic-gcc)
;; (global-ede-mode t)                      ; Enable the Project management system
;; (semantic-load-enable-minimum-features)  ; Enable prototype help and smart completion 
;; (global-srecode-minor-mode 1)            ; Enable template insertion menu


;; spell check display hack -- by wishi ;)
(defun faces_x ()
  (custom-set-faces
'(flyspell-duplicate ((t (:foreground "Gold3" :underline t :weight normal))))
'(flyspell-incorrect ((t (:foreground "OrangeRed" :underline t :weight normal))))
))

;; LaTeX mode config
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


;; company-mode requires Emacs 23 afaik
(require 'company-mode)
(require 'company-bundled-completions)
(company-install-bundled-completions-rules)

(add-to-list 'load-path "/opt/local/share/emacs/site-lisp/g-client")
(load-library "g")

;; TRAMP mode for edting through I/O ssh
(require 'tramp)
(setq tramp-default-method "ssh")

;; Source Indent for C/C++
(add-hook 'c++-mode-hook 'my-set-newline-and-indent)
(add-hook 'c-mode-hook 'my-set-newline-and-indent)


;; funstuff
;; 10.12.2001; xsteve
;; 17.03.2008; Michael 'mictro' Trommer <mictro@gmail.com>, Nato (international code)
(setq nato-alphabet
'(("A" . "Alfa") ("B" . "Bravo") ("C" . "Charlie") ("D" . "Delta") ("E" . "Echo")
  ("F" . "Foxtrot") ("G" . "Golf") ("H" . "Hotel") ("I" . "India") ("J" . "Juliet")
  ("K" . "Kilo") ("L" . "Lima") ("M" . "Mike") ("N" . "November") ("O" . "Oscar")
  ("P" . "Papa") ("Q" . "Quebec") ("R" . "Romeo") ("S" . "Sierra") ("T" . "Tango")
  ("U" . "Uniform") ("V" . "Victor") ("W" . "Whiskey") ("X" . "Xray")
  ("Y" . "Yankee") ("Z" . "Zulu") ("1" . "One") ("2" . "Two") ("3" . "Three") 
  ("4" . "Four") ("5" . "Five") ("6" . "Six") ("7" . "Seven") ("8" . "Eight")
  ("9" . "Nine") ("0" . "Zero") (" " . "_")))

;; 10.12.2001; xsteve
;; 17.03.2008; Michael 'mictro' Trommer <mictro@gmail.com>, use region
(defun nato-on-region (beg end)
  (interactive "r")
  (insert 
   (format "%s" 
           (mapcar (lambda (ch)
                     (cdr (assoc (char-to-string ch) nato-alphabet))) (upcase (buffer-substring beg end)))))
  (kill-region beg end))
