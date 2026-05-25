(dolist (mode '(tool-bar-mode
		menu-bar-mode
		scroll-bar-mode))
  (when (fboundp mode)
    (funcall mode -1)))

(add-to-list 'load-path (expand-file-name "~/.emacs.d/elisp"))

(when (executable-find "zprint")
  (global-set-key (kbd "C-x C-h C-z")
		  #'(lambda ()
		      (interactive)
		      (shell-command-on-region
		       (region-beginning) (region-end)
		       "/usr/bin/zprint" (current-buffer) t))))

(defun colorize-region ()
  (interactive)
  (ansi-color-apply-on-region (region-beginning) (region-end)))

(defun clip-alpha (x)
  (max 5 (min 100 x)))

(defun adjust-transp (delta)
  (let* ((alpha (or (frame-parameter nil 'alpha) '(100 100)))
         (active (clip-alpha (+ (car alpha) delta)))
         (inactive (clip-alpha (+ (cadr alpha) delta))))
    (set-frame-parameter nil 'alpha (list active inactive))))

(defun inc-transp () (interactive) (adjust-transp 5))
(defun dec-transp () (interactive) (adjust-transp -5))

(global-set-key (kbd "C-x <S-prior>") 'inc-transp)
(global-set-key (kbd "C-x <S-next>") 'dec-transp)

(require 'package)

(setq package-archives
  '(("gnu" . "https://elpa.gnu.org/packages/")
    ("melpa-stable" . "https://stable.melpa.org/packages/")
    ("melpa" . "https://melpa.org/packages/")))

(package-initialize)

;; Check for packages missing from standard setup
(setq *stdpackages*
  '((highlight-symbol . elpa)
    ;; (ac-cider . elpa)
    (company . elpa)
    (cyberpunk-2019-theme . elpa)
    (cyberpunk-theme . elpa)
    (deadgrep . elpa)
    (elisp-slime-nav . elpa)
    ;; (elixir-mode . elpa)
    ;; (geiser . elpa)
    (cider . elpa)
    (clojure-mode . elpa)
    (go-mode . elpa)
    (dart-mode . melpa)
    (flutter . melpa)
    (json-mode . elpa)
    (lsp-mode . melpa)
    (lsp-ui . melpa)
    (magit . elpa)
    (markdown-mode . elpa)
    (paredit . elpa)
    (powerline . elpa)
    (railscasts-reloaded-theme . elpa)
    (rainbow-delimiters . elpa)
    (slime . elpa)
    (swiper . elpa)
    (web-mode . elpa)
    ;; (with-editor . elpa)
    (flycheck-clj-kondo . melpa)
    (zerodark-theme . elpa)
    (zprint-mode . elpa)
    (undo-tree . elpa)))

(let ((not-installed (seq-filter #'(lambda (x)
				      (not (package-installed-p (car x))))
				  *stdpackages*)))
  (when not-installed
    (when (or noninteractive (yes-or-no-p "Missing packages. Install them now? "))
      (package-refresh-contents)
      (dolist (p not-installed)
        (package-install (car p) (cdr p))))))

;; Core Global Variables
(setq ispell-program-name "aspell"
      inferior-lisp-program "/usr/bin/sbcl"
      slime-contribs '(slime-fancy)
      scheme-program-name "guile"
      browse-url-browser-function #'browse-url-firefox
      exec-path (append exec-path (mapcar #'expand-file-name '("~/bin" "~/go/bin" "~/flutter/bin"))))

;; Disable lockfiles and centralize auto-saves, backups and undo history
(setq create-lockfiles nil
      auto-save-file-name-transforms '((".*" "~/.emacs.d/auto-saves/" t))
      backup-directory-alist '(("." . "~/.emacs.d/backups/"))
      undo-tree-history-directory-alist '(("." . "~/.emacs.d/undo-tree/")))

;; Ensure the target directories exist on startup
(make-directory "~/.emacs.d/auto-saves/" t)
(make-directory "~/.emacs.d/backups/" t)
(make-directory "~/.emacs.d/undo-tree/" t)

;; Java & Python
(defun setup-java-environment ()
  (setq-local c-basic-offset 4
              c-continued-statement-offset 4
              indent-tabs-mode nil)
  (c-set-offset 'arglist-cont-nonempty 4)
  (line-number-mode 1))

(defun setup-python-environment ()
  (setq-local python-indent-offset 4
              indent-tabs-mode nil))

(dolist (hook-pair '((java-mode-hook   . setup-java-environment)
                     (python-mode-hook . setup-python-environment)))
  (add-hook (car hook-pair) (cdr hook-pair)))

;; thanks https://ericscrivner.me/2015/06/better-emacs-rainbow-delimiters-color-scheme/
;; better colors for dark (cyberpunk) themes
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(rainbow-delimiters-depth-1-face ((t (:foreground "dark orange"))))
 '(rainbow-delimiters-depth-2-face ((t (:foreground "deep pink"))))
 '(rainbow-delimiters-depth-3-face ((t (:foreground "chartreuse"))))
 '(rainbow-delimiters-depth-4-face ((t (:foreground "deep sky blue"))))
 '(rainbow-delimiters-depth-5-face ((t (:foreground "yellow"))))
 '(rainbow-delimiters-depth-6-face ((t (:foreground "orchid"))))
 '(rainbow-delimiters-depth-7-face ((t (:foreground "spring green"))))
 '(rainbow-delimiters-depth-8-face ((t (:foreground "sienna1")))))


;; stuff for zero dark (HL paren is not showing well)
(defun red-hl-paren ()
  (interactive)
  (let ((class '((class color) (min-colors 89)))) ;; FIXME:
    (custom-theme-set-faces
     'zerodark
     `(show-paren-match ((,class (:foreground "#FF0000" :weight bold)))))))

(when (custom-theme-enabled-p 'zerodark)
  (red-hl-paren))

(require 'highlight-symbol)

(setq highlight-symbol-idle-delay 0
      highlight-symbol-on-navigation-p t
      highlight-symbol-occurrence-message '(explicit))

(dolist (hook '(lisp-mode-hook
		emacs-lisp-mode-hook
		scheme-mode-hook
		cider-repl-mode-hook
		clojure-mode-hook))
  (add-hook hook #'highlight-symbol-mode))

(global-set-key (kbd "C-<") 'highlight-symbol-prev)
(global-set-key (kbd "C->") 'highlight-symbol-next)

(defun highlight-symbol-count (&optional symbol)
  "(Do not) Print the number of occurrences of symbol at point."
  (interactive))

;; Clojure & CIDER
(defun setup-clojure-environment ()
  "Enable standard minor modes for Clojure buffers and the REPL."
  (show-paren-mode 1)
  (rainbow-delimiters-mode 1)
  (flycheck-mode 1)
  (undo-tree-mode 1)
  (company-mode 1)
  (paredit-mode 1))

(with-eval-after-load 'clojure-mode
  (require 'flycheck-clj-kondo)
  (add-hook 'clojure-mode-hook #'setup-clojure-environment)
  (add-hook 'clojure-mode-hook #'display-line-numbers-mode))

(with-eval-after-load 'cider
  (global-set-key (kbd "C-x C-h C-o") 'cider-repl-clear-buffer)
  (add-hook 'cider-repl-mode-hook #'setup-clojure-environment)

  (dolist (binding '(("RET"        . cider-repl-return)
                     ("<C-return>" . cider-repl-newline-and-indent)
                     ("<C-up>"     . nil)
                     ("<C-down>"   . nil)
                     ("<C-prior>"  . cider-repl-backward-input)
                     ("<C-next>"   . cider-repl-forward-input)))
    (define-key cider-repl-mode-map (kbd (car binding)) (cdr binding))))

;; swiper
(require 'swiper)
(global-set-key (kbd "C-x C-h C-s") 'swiper)


(with-eval-after-load 'lsp-mode
  (add-to-list 'lsp-disabled-clients 'clojure-lsp)
  (setq lsp-client-packages (delq 'clojure-mode lsp-client-packages))
  (setq lsp-client-packages (delq 'clojurescript-mode lsp-client-packages))
  (setq lsp-client-packages (delq 'clojurec-mode lsp-client-packages)))

;; Go
(defun setup-go-environment ()
  "Enable standard minor modes for Go buffers."
  (lsp-deferred)
  (setq-local tab-width 4
              indent-tabs-mode t)
  (company-mode 1)
  (display-line-numbers-mode 1)
  (add-hook 'before-save-hook #'lsp-format-buffer t t)
  (add-hook 'before-save-hook #'lsp-organize-imports t t))

(with-eval-after-load 'go-mode
  (add-hook 'go-mode-hook #'setup-go-environment))

;; Dart & Flutter
(defun setup-dart-environment ()
  "Enable standard minor modes for Dart/Flutter buffers."
  (lsp-deferred)
  (setq-local tab-width 2
              indent-tabs-mode nil)
  (company-mode 1)
  (display-line-numbers-mode 1)
  (add-hook 'before-save-hook #'lsp-format-buffer t t))

(with-eval-after-load 'dart-mode
  (add-hook 'dart-mode-hook #'setup-dart-environment))

(with-eval-after-load 'flutter
  (setq flutter-sdk-path (expand-file-name "~/flutter/"))
  (define-key flutter-mode-map (kbd "C-c C-r") #'flutter-run-or-hot-reload))


;; ;; Frame
;; ;; In case it's missing, navajowhite is 0xFFDEAD
;; (add-to-list 'default-frame-alist '(foreground-color . "navajowhite"))
;; (add-to-list 'default-frame-alist '(background-color . "black"))


;; JSON
(require 'json-mode)

(defun setup-json-environment ()
  (hs-minor-mode 1)
  (local-set-key (kbd "C-c h") #'hs-hide-block)
  (local-set-key (kbd "C-c s") #'hs-show-block))

(add-hook 'json-mode-hook #'setup-json-environment)

(winner-mode)

(add-hook 'html-mode-hook
	  (lambda ()
	    (web-mode)))

(defvar pandoc-command "pandoc")

(defun do-pandoc-preview ()
  (interactive)
  (let ((buf (get-buffer-create " *pandoc-preview")))
    (call-process pandoc-command nil buf nil buffer-file-name)
    (browse-url-of-buffer buf)))

;; Latex mode highlighting
(defun setup-latex-environment ()
  (local-set-key (kbd "C-c p") #'do-pandoc-preview)
  (dolist (rule '(("FIXME" . hi-yellow)
                  ("SUPERFL" . hi-pink)
                  ("PHRASING" . hi-red-b)
                  ("<CHECK>.*</CHECK>" . hi-yellow)))
    (highlight-regexp (car rule) (cdr rule)))
  (dolist (rule '(("TARG" . hi-green)
                  ("MENTION" . hi-blue)))
    (highlight-lines-matching-regexp (car rule) (cdr rule))))

(add-hook 'latex-mode-hook #'setup-latex-environment)

;; ORG mode local
(add-hook 'org-mode-hook
	  (lambda ()
	    (highlight-regexp "NOTE" 'hi-pink)))

(with-eval-after-load 'org
  (org-babel-do-load-languages 'org-babel-load-languages
                               '((java . t))))

;; Clear *SQL* buffer (copied from somewhere)
(defun clear-sql-comint-out ()
  (interactive)
  (when-let ((buf (get-buffer "*SQL: Postgres*")))
    (with-current-buffer buf
      (delete-region (point-min) (point-max))
      (comint-send-input))))

(global-set-key (kbd "C-c C-l C-l") #'clear-sql-comint-out)

(with-eval-after-load 'sql
  (setq sql-connection-alist '((podman (sql-product 'postgres)
				       (sql-server "localhost")
				       (sql-port 15432)
				       (sql-user "test")
				       (sql-database "podman")))
	sql-postgres-login-params (append sql-postgres-login-params
					  '((port 15432 :default 5432)))))

;; Elisp
(require 'elisp-slime-nav)

(defun setup-elisp-environment ()
  (rainbow-delimiters-mode 1)
  (paredit-mode 1)
  (undo-tree-mode 1)
  (display-line-numbers-mode 1)
  (elisp-slime-nav-mode 1))

(dolist (hook '(emacs-lisp-mode-hook ielm-mode-hook))
  (add-hook hook #'setup-elisp-environment))

;; Fullscreen mode
(global-set-key [f11] #'toggle-frame-fullscreen)

;; Set fonts when in window mode
(when (not (eql (framep (selected-frame)) 't))
  (let ((ft (find-font (font-spec :name "Ubuntu Mono"))))
    (when (fontp ft)
      (set-frame-font ft)))
  (set-face-attribute 'default nil :height 105 :weight 'normal :slant 'normal))

;; Use Noto Color Emoji for emojis (Version-aware for dotfiles portability)
(when (member "Noto Color Emoji" (font-family-list))
  (if (version<= "28.1" emacs-version)
      ;; For Emacs 28 and newer
      (set-fontset-font t 'emoji "Noto Color Emoji")
    ;; For older Emacs versions
    (set-fontset-font t 'symbol "Noto Color Emoji")))

;; Frame / Window navigation
(global-set-key (kbd "C-x <prior>") #'(lambda () (interactive) (other-frame -1)))
(global-set-key (kbd "C-x <next>") #'(lambda () (interactive) (other-frame +1)))

(defun cycle-windmove-up ()
  (interactive)
  (if (windowp (window-in-direction 'up))
      (windmove-up)
    (while (windowp (window-in-direction 'down))
      (windmove-down))))

(defun cycle-windmove-down ()
  (interactive)
  (if (windowp (window-in-direction 'down))
      (windmove-down)
    (while (windowp (window-in-direction 'up))
      (windmove-up))))

(defun cycle-windmove-left ()
  (interactive)
  (if (windowp (window-in-direction 'left))
      (windmove-left)
    (while (windowp (window-in-direction 'right))
      (windmove-right))))

(defun cycle-windmove-right ()
  (interactive)
  (if (windowp (window-in-direction 'right))
      (windmove-right)
    (while (windowp (window-in-direction 'left))
      (windmove-left))))

(require 'paredit)

(define-key paredit-mode-map (kbd "<M-up>") nil)
(define-key paredit-mode-map (kbd "<M-down>") nil)
(define-key paredit-mode-map (kbd "<C-left>") nil)
(define-key paredit-mode-map (kbd "<C-right>") nil)

(define-key paredit-mode-map (kbd "<C-M-left>") 'paredit-backward)
(define-key paredit-mode-map (kbd "<C-M-right>") 'paredit-forward)
(define-key paredit-mode-map (kbd "<C-M-up>") 'paredit-backward-up)
(define-key paredit-mode-map (kbd "<C-M-down>") 'paredit-forward-up)

(global-set-key (kbd "<C-up>") 'cycle-windmove-up)
(global-set-key (kbd "<C-down>") 'cycle-windmove-down)
(global-set-key (kbd "<C-left>") 'cycle-windmove-left)
(global-set-key (kbd "<C-right>") 'cycle-windmove-right)

(global-set-key (kbd "<M-up>") 'backward-paragraph)
(global-set-key (kbd "<M-down>") 'forward-paragraph)

;; Window state swap
(global-set-key (kbd "C-x <S-up>") 'windmove-swap-states-up)
(global-set-key (kbd "C-x <S-down>") 'windmove-swap-states-down)
(global-set-key (kbd "C-x <S-left>") 'windmove-swap-states-left)
(global-set-key (kbd "C-x <S-right>") 'windmove-swap-states-right)

;; Window resize by 1 line
(global-set-key (kbd "C-x <up>") (kbd "C-x ^"))
(global-set-key (kbd "C-x <down>") (kbd "C-u - 1 C-x ^"))
(global-set-key (kbd "C-x <left>") (kbd "C-x {"))
(global-set-key (kbd "C-x <right>") (kbd "C-x }"))

;; Window resize by 5 lines
(global-set-key (kbd "C-x M-<up>") (kbd "C-u 5 C-x <up>"))
(global-set-key (kbd "C-x M-<down>") (kbd "C-u 5 C-x <down>"))
(global-set-key (kbd "C-x M-<left>") (kbd "C-u 5 C-x <left>"))
(global-set-key (kbd "C-x M-<right>") (kbd "C-u 5 C-x <right>"))

(global-set-key (kbd "C-x M-0") 'balance-windows)

;; Magit
(require 'magit)
(global-set-key (kbd "C-c g") 'magit-blame)
(setq magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1)

;; Marker stack
(defun pop-marker-stack ()
  (interactive)
  (let ((prev-buffer (current-buffer)))
    (xref-pop-marker-stack)
    (unless (eq (current-buffer) prev-buffer)
      (kill-buffer prev-buffer))))

(global-set-key (kbd "M-,") 'pop-marker-stack)

(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)

;; display-buffer-alist stuff
(defun display-if-multiple (buffer alist)
  (unless (one-window-p)
    (window--display-buffer buffer
                            (pcase (alist-get 'target alist)
                              ('next (next-window))
                              ('same (selected-window)))
                            'reuse alist)))

(dolist (config '((next "^\\*cider-test-report\\*$"
			"^\\*cider-error\\*$")
                  (same "^\\*cider-repl .*\\*$"
			"^\\*deadgrep .*\\*$"
			"^\\*Buffer List\\*$")))
  (dolist (pattern (cdr config))
    (add-to-list 'display-buffer-alist
                 `(,pattern (display-if-multiple) (target . ,(car config))))))

;; For when using JDEE
;; (setq jdee-server-dir (expand-file-name "~/usr/jdee-bundle-1.1-full.jar"))

;; Ensime and scala stuff
;; (setq ensime-sbt-command (expand-file-name "~/usr/local/opt/sbt@0.13/bin"))

(global-set-key (kbd "C-M-w") 'yank)
(global-set-key (kbd "M-W") 'yank-pop)

;; Smerge Mode Bindings
(with-eval-after-load 'smerge-mode
  ;; Cut ^ from prefix
  (define-key smerge-mode-map (kbd "C-c n") 'smerge-next)
  (define-key smerge-mode-map (kbd "C-c p") 'smerge-prev)
  (define-key smerge-mode-map (kbd "C-c u") 'smerge-keep-upper)
  (define-key smerge-mode-map (kbd "C-c l") 'smerge-keep-lower)
  (define-key smerge-mode-map (kbd "C-c e") 'smerge-ediff))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes '(zerodark))
 '(custom-safe-themes
   '("0c85f7c35159e4de3f0a8f02023880a72202a7082ea88d59887c1ea47b343963" "fa10e8ac20bda83daa98777ad934854f4aa87a31587f855e559171e779034556" "9fb69436c074b82a62b78b8d733e6274d0bd16d156f7b094e2afe4345c040c49" "b0d414fd7200354d1236d5b207758a704f451f74dce51253596aee3ff59ab5a1" default))
 '(default-input-method "greek")
 '(desktop-save-mode t)
 '(fci-rule-color "#383838")
 '(ispell-dictionary nil)
 '(package-selected-packages
   '(csv-mode multiple-cursors iedit auto-complete undo-tree projectile magit cider gnu-elpa-keyring-update zprint-mode web-mode swiper rainbow-delimiters railscasts-reloaded-theme powerline paredit markdown-mode json-mode highlight-symbol flycheck-clj-kondo elisp-slime-nav cyberpunk-theme cyberpunk-2019-theme company clojure-mode))
 '(safe-local-variable-values
   '((cider-figwheel-main-default-options . ":dev")
     (cider-default-cljs-repl . figwheel-main)
     (cider-clojure-cli-aliases . "-A:dev"))))

;; ========================================================
;; Machine-Specific Local Overrides
;; (Must be at the very bottom so it gets the final say!)
;; ========================================================
(let ((local-config (expand-file-name "~/.emacs.local")))
  (when (file-exists-p local-config)
    (load local-config)))
