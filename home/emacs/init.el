(defcustom my/notes-location (expand-file-name "~/Documents/notes")
  "My default notes location")

(use-package exec-path-from-shell
  :config
  (exec-path-from-shell-initialize)
  (if (and (fboundp 'native-comp-available-p)
	   (native-comp-available-p))
      (progn
	(message "Native comp is available")
	  ;;; Using Emacs.app/Contents/MacOS/bin since it was compiled with
	  ;;; ./configure --prefix="$PWD/nextstep/Emacs.app/Contents/MacOS"
	  ;;; Append to path to give priority to values from exec-path-from-shell-initialize.
	(add-to-list 'exec-path (concat invocation-directory (file-name-as-directory "bin")) t)
	(setenv "LIBRARY_PATH" (concat (getenv "LIBRARY_PATH")
				       (when (getenv "LIBRARY_PATH")
					 ":")
					 ;;; This is where Homebrew puts libgccjit libraries.
				       (car (file-expand-wildcards
					     (expand-file-name "/opt/homebrew/opt/libgccjit/lib/gcc/*")))))
	  ;;; Only set after LIBRARY_PATH can find gcc libraries.
	(setq comp-deferred-compilation t)
	(setq comp-speed 3))
    (message "Native comp is *not* available")))

(use-package no-littering)

(setq backup-directory-alist
      `(("\\`/tmp/" . nil)
	("\\`/dev/shm/" . nil)
	("." . ,(no-littering-expand-var-file-name "backup/"))))

(setq auto-save-file-name-transforms
      `((".*" ,(no-littering-expand-var-file-name "auto-save/") t)))

(setq auto-save-file-name-transforms
      `(("\\`/[^/]*:\\([^/]*/\\)*\\([^/]*\\)\\'"
	 ,(concat temporary-file-directory "\\2") t)
	("\\`\\(/tmp\\|/dev/shm\\)\\([^/]*/\\)*\\(.*\\)\\'" "\\3")
	(".*" ,(no-littering-expand-var-file-name "auto-save/") t)))

(recentf-mode 1)
(add-to-list 'recentf-exclude no-littering-var-directory)
(add-to-list 'recentf-exclude no-littering-etc-directory)

(setq custom-file (no-littering-expand-etc-file-name "custom.el"))

(setq auto-save-file-name-transforms
      `((".*" ,(no-littering-expand-var-file-name "auto-save/") t)))

;; (setenv "GPG_TTY" "$(tty)")
(require 'epa-file)
(epa-file-enable)
(setenv "GPG_AGENT_INFO" nil)
(setq pg-gpg-program "gpg2")
(setq epg-pinentry-mode 'loopback)
(setq auth-source-debug t)

(scroll-bar-mode -1)
;; (menu-bar-mode -1)
(tool-bar-mode -1)
(blink-cursor-mode -1)
(fset 'yes-or-no-p 'y-or-n-p)
(global-display-line-numbers-mode 1)
(setq display-line-numbers-type 'relative)
(setq inhibit-startup-screen t)
(setq backup-by-copying t)

;; (use-package face-remap
;;   :ensure nil
;;   :custom-face
;;   (fixed-pitch ((t (:family "JetBrainsMono Nerd Font" :height 1.0))))
;;   (org-block ((t (:inheerit fixed-pitch))))
;;   :hook
;;   (org-mode-hook . variable-pitch-mode))

;; icons
(use-package all-the-icons
  :if (display-graphic-p))

;; fonts
(let* ((candidates '("JetBrainsMono Nerd Font-16" "Hack Nerd Font-16" "Fira Code-16"))
       (chosen (seq-find (lambda (n) (member n (font-family-list))) candidates "JetBrainsMono Nerd Font-16")))
  (cl-pushnew
   (cons 'font chosen)
   default-frame-alist
   :key #'car :test #'eq))

(use-package mixed-pitch
  :hook
  ;; If you want it in all text modes:
  ((org-mode markdown-mode) . mixed-pitch-mode))

(use-package doom-modeline
  :init (doom-modeline-mode 1)
  ;;; :custom ((doom-modeline-height 15))
  )

(use-package hl-line ; built in
  :ensure nil
  :hook ((prog-mode text-mode conf-mode) . hl-line-mode)
  :config
  ;;; I don't need hl-line showing in other windows. This also offers a small
  ;;; speed boost when buffer is displayed in multiple windows.
  (setq hl-line-sticky-flag nil
	global-hl-line-sticky-flag nil))

(use-package ef-themes
  :custom
  (my/dark-theme 'ef-bio)
  (my/light-theme 'ef-frost)
  (ef-themes-headings
    '((1 light variable-pitch 1.5)
       (2 regular 1.3)
       (3 1.1)
       (agenda-date 1.3)
       (agenda-structure variable-pitch light 1.8)
       (t variable-pitch)))
  :config
  (load-theme 'ef-bio :no-confirm))


;;; only works with emacs-plus
(defun my/toggle-theme (appearance)
  "Load theme, taking current system APPEARANCE into consideration."
  (mapc #'disable-theme custom-enabled-themes)
  (pcase appearance
    ('light
     (progn (enable-theme my/light-theme)
	    (disable-theme my/dark-theme)))
    ('dark
     (progn (enable-theme my/dark-theme)
	    (disable-theme my/light-theme)))
    )
  )

(setq mac-command-modifier 'meta)
(setq mac-option-modifier 'super)

(use-package evil
  :custom
  (evil-want-keybinding nil)
  ;; (evil-want-minibuffer t)
  :config
  (evil-mode 1)
  (evil-set-undo-system 'undo-redo))

;; (with-eval-after-load 'evil-maps
;;   (define-key evil-motion-state-map (kbd "RET") nil))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

(use-package evil-surround
  :config
  (global-evil-surround-mode 1))

(use-package evil-commentary
  :config (evil-commentary-mode 1))

(use-package general
  :config
  (general-evil-setup)
  ;; (general-create-definer tyrant!
  ;;   :keymaps 'override)
  ;; (general-create-definer leader!
  ;;   ;; :prefix leader
  ;;   :states '(normal visual insert emacs)
  ;;   :prefix "SPC"
  ;;   :non-normal-prefix "s-SPC")
  ;; (general-create-definer local-leader!
  ;;   :states '(normal)
  ;;   ;; :prefix my-local-leader
  ;;   :prefix ",")
  ;; (leader! "hf" 'describe-function)
  )

(general-create-definer tyrant!
  :keymaps 'override)
(general-create-definer leader!
  ;; :prefix leader
  :states '(normal visual insert emacs)
  :prefix "SPC"
  :non-normal-prefix "s-SPC")
(general-create-definer local-leader!
  :states '(normal)
  ;; :prefix my-local-leader
  :prefix ",")
(leader! "hf" 'describe-function)

(use-package which-key
  :config
  (which-key-mode 1))

(use-package hydra)

(tyrant!
  "M-o" 'find-file
  "M-d" 'dired-jump
  "M-w" 'evil-quit
  "M-q" 'save-buffers-kill-terminal
  "M-p" 'projectile-find-file-dwim
  "M-P" 'projectile-switch-project
  "M-r" 'consult-recent-file
  "M-b" 'consult-buffer
  "M-B" 'consult-project-buffer
  "M-g" 'magit-status
  "M-s" 'save-buffer
  "M-S" 'save-some-buffers
  "M-v" 'yank
  "M-a" 'mark-whole-buffer
  "M-f" 'consult-line
  "M-F" 'consult-ripgrep
  "M-t" 'vterm
  "M-=" 'text-scale-increase
  "M--" 'text-scale-decrease
  "M-0" (lambda () (interactive) (text-scale-set 0)))

(leader!
  "u" '(universal-argument :which-key "universal argument")
  "`" '("switch" . evil-switch-to-windows-last-buffer)
  "o" '(nil :which-key "open")
  ;; "o o" '+macos/reveal-in-finder
  "x" '(nil :which-key "eval")
  "x x" '("eval" . elisp-eval-region-or-buffer))

(leader!
  "h" '(nil :which-key "help")
  "h f" '("function" . describe-function)
  "h v" '("variable" . describe-variable)
  "h k" '("key" . describe-key)
  )

(leader!
  "a" '(nil :which-key "app")
  "f" '(nil :which-key "file")
  "fr" '(consult-recent-file :which-key "recent files")
  "fR" '(consult-recent-file :which-key "recent files")
  "ff" '(find-file :which-key "find file"))

(leader!
  "b" '(nil :which-key "buffer")
  "bb" '(consult-buffer :which-key "switch buffer")
  "bB" '(consult-project-buffer :which-key "project buffer")
  "bm" '(bookmark-set :which-key "set bookmark")
  "bM" '(bookmark-delete :which-key "delete bookmark")
  "bk" '(kill-this-buffer :which-key "kill buffer"))

(leader!
  "p" '(nil :which-key "project")
  "pf" '(projectile-find-file-dwim :which-key "find file")
  "pp" '(projectile-switch-project :which-key "find project")
  "pb" '(consult-project-buffer :which-key "project buffer"))

(leader!
  "s" '(nil :which-key "search")
  "sm" '(bookmark-jump :which-key "jump to bookmark")
  "sb" '(consult-line :which-key "search buffer")
  "sB" '(consult-line-multi 'all-buffer :which-key "search all open buffer")
  "sp" '(consult-ripgrep :which-key "search project")
  "sB" '(consult-line-multi 'all-buffer :which-key "search all open buffer"))

;; search
(use-package anzu
  :config
  (global-anzu-mode +1))

(use-package evil-anzu
  :after evil
  :config
  (require 'evil-anzu))

;; remember notes
(setq initial-buffer-choice 'remember-notes
      remember-data-file (expand-file-name "remember.org" my/notes-location)
      remember-notes-initial-major-mode 'org-mode
      remember-notes-auto-save-visited-file t)

;; find file TODO: assign keys
(use-package affe
  :config
  (consult-customize affe-grep :preview-key (kbd "M-."))
  (tyrant! "M-O" #'affe-find)
  (leader! "fF" #'affe-find)
  ;; -*- lexical-binding: t -*-
  ;; (defun affe-orderless-regexp-compiler (input _type _ignorecase)
  ;;   (setq input (orderless-pattern-compiler input))
  ;;   (cons input (lambda (str) (orderless--highlight input str))))
  ;; (setq affe-regexp-compiler #'affe-orderless-regexp-compiler)
  )

(use-package bufler
  :general
  (leader! "bb" #'bufler)
  (:keymaps 'bufler-list-mode-map
            :states 'normal
            "," 'hydra:bufler/body
            "RET" 'bufler-list-buffer-switch
            "SPC" 'bufler-list-buffer-peek
            "d" 'bufler-list-buffer-kill))

(use-package crux
  :commands crux-open-with
  :general
  (leader! "f r" #'crux-recentf-find-file))

(use-package vertico
  :init
  (vertico-mode))

(use-package vertico-posframe
  :after vertico
  :requires posframe
  :config
  (setq vertico-posframe-poshandler #'posframe-poshandler-frame-top-center)
  (setq vertico-posframe-parameters
	'((internal-border-width . 10)
	  (left-fringe . 8)
	  (right-fringe . 8)
	  ))
  (vertico-posframe-mode 1)
  )

(use-package vertico-directory
  :after vertico
  :ensure nil
  ;; More convenient directory navigation commands
  :general
  (vertico-map
   "DEL"  'vertico-directory-delete-char
   "M-DEL"  'vertico-directory-delete-word)
  ;;; Tidy shadowed file names
  :hook (rfn-eshadow-update-overlay . vertico-directory-tidy))

(use-package savehist
  :ensure nil
  :init
  (savehist-mode))

(use-package orderless
  :init
  (setq completion-styles '(orderless partial-completion basic)))

(use-package marginalia
  :init
  (marginalia-mode))

;; TODO: add meaningful bindings
;; (use-package embark
;;   :bind
;;   ("M-." . embark-act)
;;   ("M-;" . embark-dwim)
;;   ("M-e" . embark-export)
;;   ("C-h B" . embark-bindings))

(use-package embark-consult
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

(use-package wgrep
  :ensure t
  :config
  (setq wgrep-auto-save-buffer t)
  (setq wgrep-enable-key "r"))

(use-package consult
  :config
  (setq consult-project-root-function #'projectile-project-root)
  ;; (setq consult-ripgrep-args "rg --null --hidden --line-buffered --color=never --max-columns=1000 --path-separator /   --smart-case --no-heading --line-number .")
  )

(use-package corfu
  :custom
  (corfu-cycle t)
  (corfu-auto t)
  :general
  (corfu-map
   "TAB"  'corfu-next
   "[tab]" 'corfu-next
   "S-TAB" 'corfu-previous
   "[backtab]" 'corfu-previous)
  :init
  (global-corfu-mode))

(use-package corfu-popupinfo
  :after corfu
  :ensure nil
  :init
  (corfu-popupinfo-mode 1))

;; (use-package corfu-echo
;;   :after corfu
;;   :straight nil
;;   :init
;;   (corfu-echo-mode 1))

;; Find config example [[https://github.com/minad/cape][here]].

(use-package cape
  :init
  ;; Add `completion-at-point-functions', used by `completion-at-point'.
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)
  (add-to-list 'completion-at-point-functions #'cape-file)
  (add-to-list 'completion-at-point-functions #'cape-history)
  (add-to-list 'completion-at-point-functions #'cape-symbol)
  )

(use-package emacs
  :init
  (setq completion-cycle-threshold 3)
  (setq tab-always-indent 'complete))

(use-package dabbrev
  :ensure nil
  ;; Swap M-/ and C-M-/
  :general
  (:states 'normal
	   "M-/" 'dabbrev-completion
	   "C-M-/" 'dabbrev-expand)
  :custom
  (dabbrev-ignored-buffer-regexps '("\\.\\(?:pdf\\|jpe?g\\|png\\)\\'")))

(use-package projectile
  :init
  (projectile-mode +1)
  :config
  (setq projectile-completion-system 'default))

  (use-package magit
    :commands (magit-status magit-blame)
    :init
    ;; Have magit-status go full screen and quit to previous
    ;; configuration.  Taken from
    ;; http://whattheemacsd.com/setup-magit.el-01.html#comment-748135498
    ;; and http://irreal.org/blog/?p=2253
    (defadvice magit-status (around magit-fullscreen activate)
      (window-configuration-to-register :magit-fullscreen)
      ad-do-it
      (delete-other-windows))
    (defadvice magit-quit-window (after magit-restore-screen activate)
      (jump-to-register :magit-fullscreen))
    :custom
    (magit-diff-refine-hunk 'all)
    :config
    ;; (remove-hook 'magit-status-sections-hook 'magit-insert-tags-header)
    ;; (remove-hook 'magit-status-sections-hook 'magit-insert-status-headers)
    (remove-hook 'magit-status-sections-hook 'magit-insert-unpushed-to-pushremote)
    (remove-hook 'magit-status-sections-hook 'magit-insert-unpulled-from-pushremote)
    (remove-hook 'magit-status-sections-hook 'magit-insert-unpulled-from-upstream)
    (remove-hook 'magit-status-sections-hook 'magit-insert-unpushed-to-upstream-or-recent)
    )

  (use-package git-gutter
    :after magit
    :init
    (global-git-gutter-mode +1))

  (use-package git-gutter-fringe
    :after git-gutter
    :config
    (define-fringe-bitmap 'git-gutter-fr:added [224] nil nil '(center repeated))
    (define-fringe-bitmap 'git-gutter-fr:modified [224] nil nil '(center repeated))
    (define-fringe-bitmap 'git-gutter-fr:deleted [128 192 224 240] nil nil 'bottom))

  ;; it's slow: https://github.com/dandavison/magit-delta/issues/9
  ;; (use-package magit-delta
  ;;   :after magit
  ;;   :hook (magit-mode . magit-delta-mode))

  (use-package browse-at-remote
    :after magit)

  (use-package forge
    :after magit)

  (use-package consult-gh
    :after consult
    :config
    (setq consult-gh-default-orgs-list '("xiaoxinghu" "orgapp" "nib-group"))
    (setq consult-gh-default-clone-directory "~/Projects"))

  ;; (setq magit-refresh-status-buffer nil)

(defhydra hydra-git (:hint nil)
  "git"
  ("g" magit-status "status" :color blue)
  ("r" browse-at-remote "remote" :color blue)
  ("s" magit-stage-buffer-file "stage" :color blue)
  ("S" consult-gh-search-repos "stage" :color blue)
  ("c" magit-commit "commit" :color blue)
  ("p" magit-push "push" :color blue)
  ("l" magit-log "log" :color blue)
  ("f" magit-log-buffer-file "log" :color blue)
  ("b" magit-blame "blame" :color blue)
  ("q" nil "quit"))

(leader! "g" '("git" . hydra-git/body))

(use-package dired
  :ensure nil
  :init
  (setq
   dired-dwim-target t
   ;; don't prompt to revert, just do it
   dired-auto-revert-buffer #'dired-buffer-stale-p
   ;; Always copy/delete recursively
   dired-recursive-copies  'always
   dired-recursive-deletes 'top
   auto-revert-remote-files nil
   ;; Ask whether destination dirs should get created when copying/removing files.
   dired-create-destination-dirs 'ask
   dired-listing-switches "-alh"))

;; (use-package dired-preview
;;   :after dired
;;   :hook (dired-mode . dired-preview-mode)
;;   :custom (dired-preview-delay 0))

(use-package diredfl
  :hook (dired-mode . diredfl-mode))

(general-define-key
   :keymaps '(wdired-mode-map local) "M-s" 'wdired-finish-edit)

(use-package treemacs
  :config
  (treemacs-follow-mode t)
  ;; (setq treemacs-no-png-images t)
  )

(use-package treemacs-evil
  :after (treemacs evil))

(use-package treemacs-projectile
  :after (treemacs projectile))

(use-package treemacs-all-the-icons
  :after (treemacs all-the-icons)
  :config
  (treemacs-load-theme "all-the-icons"))

;; (use-package treemacs-icons-dired
;;   :hook (dired-mode . treemacs-icons-dired-enable-once))

;; (use-package treemacs-magit
;;   :after (treemacs magit))

(use-package dwim-shell-command
  :bind (([remap shell-command] . dwim-shell-command)
          :map dired-mode-map
          ([remap dired-do-async-shell-command] . dwim-shell-command)
          ([remap dired-do-shell-command] . dwim-shell-command)
          ([remap dired-smart-shell-command] . dwim-shell-command))
  :config
  (defun my/dwim-shell-command-convert-to-gif ()
    "Convert all marked videos to optimized gif(s)."
    (interactive)
    (dwim-shell-command-on-marked-files
      "Convert to gif"
      "ffmpeg -loglevel quiet -stats -y -i <<f>> -pix_fmt rgb24 -r 15 <<fne>>.gif"
      :utils "ffmpeg")))

(use-package pdf-tools
  :mode ("\\.pdf\\'" . pdf-view-mode)
  :config
  (pdf-tools-install))

(use-package bookmark+
  ;; :straight (:host github :repo "emacsmirror/bookmark-plus")
  :general
  ("M-s-b" 'consult-bookmark))

(add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))
(add-to-list 'default-frame-alist '(ns-appearance . dark))

(defun +macos-open-with (&optional app-name path)
  "Send PATH to APP-NAME on OSX."
  (interactive)
  (let* ((path (expand-file-name
                 (replace-regexp-in-string
                   "'" "\\'"
                   (or path (if (derived-mode-p 'dired-mode)
                              (dired-get-file-for-visit)
                              (buffer-file-name)))
                   nil t)))
          (command (format "open %s"
                     (if app-name
                       (format "-a %s '%s'" (shell-quote-argument app-name) path)
                       (format "'%s'" path)))))
    (message "Running: %s" command)
    (shell-command command)))

(defmacro +macos--open-with (id &optional app dir)
  `(defun ,(intern (format "+macos/%s" id)) ()
     (interactive)
     (+macos-open-with ,app ,dir)))

;;;###autoload (autoload '+macos/reveal-in-finder "os/macos/autoload" nil t)
(+macos--open-with reveal-in-finder "Finder" default-directory)

;;;###autoload (autoload '+macos/reveal-project-in-finder "os/macos/autoload" nil t)
(+macos--open-with reveal-project-in-finder "Finder"
                   (or (projectile-project-root) default-directory))

(leader!
  "o o" '+macos/reveal-in-finder)

(use-package org
  :config
  (setq
   org-directory my/notes-location
   org-src-preserve-indentation t
   org-goto-interface 'outline-path-completion
   org-outline-path-complete-in-steps nil
   org-format-latex-options (plist-put org-format-latex-options :scale 1.5)
   org-preview-latex-default-process 'dvisvgm
   org-agenda-window-setup 'only-window
   org-hide-emphasis-markers t
   org-return-follows-link t
   org-default-notes-file (concat org-directory "/inbox.org")
   org-todo-keywords
   '((sequence
      "TODO(t)"   ; a task
      "WAIT(w)"   ; waiting for something
      "|"
      "DONE(d)"   ; task is done
      "KILL(k)")) ; task is cancelled

   org-todo-keyword-faces
   '(("TODO" . org-todo)
     ("TO-READ" . org-todo)
     ("READING" . (:foreground "chartreuse3" :weight bold))
     ("WAITING" . (:foreground "orange" :weight bold))
     ("IDEA" . (:foreground "cyan3" :weight bold))
     ("DONE" . org-done)
     ("NO" . (:foreground "yellow" :weight bold))
     ("CANCELLED" . (:foreground "yellow" :weight bold))
     )
   ;; Edit settings
   org-auto-align-tags nil
   org-tags-column 0
   org-catch-invisible-edits 'show-and-error
   org-special-ctrl-a/e t
   org-insert-heading-respect-content t
   org-agenda-start-on-weekday nil

   ;; Org styling, hide markup etc.
   org-hide-emphasis-markers t
   org-pretty-entities t
   org-ellipsis "…"

   ;; Agenda styling
   org-agenda-tags-column 0
   ;; org-agenda-block-separator ?─
   ;; org-agenda-time-grid
   ;; '((daily today require-timed)
   ;;    (800 1000 1200 1400 1600 1800 2000)
   ;;    " ┄┄┄┄┄ " "┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄")
   org-agenda-current-time-string
   "⭠ now ─────────────────────────────────────────────────")

  ;; templates
  (setq org-capture-templates
	'(("t" "Todo" entry (file+headline org-default-notes-file "Tasks")
	   "* TODO %?\n %i\n")
	  ("n" "Note" entry (file+headline org-default-notes-file "Notes")
	   "* %?\n %i\n")
	  ))

  ;; insert mode when capture
  (add-hook 'org-capture-mode-hook 'evil-insert-state)

  ;; babel
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((python . t)))

  (setq org-babel-python-command "python3"
	org-confirm-babel-evaluate nil))

(define-key org-mode-map (kbd "M-j")
  'org-goto)

(leader! 'org-mode-map "SPC" '("find heading" . org-goto))
;; (evil-define-key 'normal 'org-mode-map (kbd "<leader> SPC") '("find heading" . org-goto))

(general-define-key
 :keymaps 'org-agenda-mode-map
 :states 'motion
 "j" 'org-agenda-next-item
 "k" 'org-agenda-previous-item
 )

(general-define-key
 :keymaps 'org-mode-map
 :states 'motion
 "RET" 'org-open-at-point
 )

(local-leader! :keymaps 'org-mode-map
  "a" '("archive" . org-archive-subtree-default)
  "l" '("link" . org-cliplink)
  "r" '("refile" . +org/refile-to-file))


(leader!
  "a a" 'my/agenda
  "c" 'org-capture)

(use-package org-ql
  :after org
  :config
  (setq org-ql-views
	'(("TODO" :buffers-files org-agenda-files
	   :query (todo)
	   :super-groups '((:auto-category t)))))
  (setq org-agenda-custom-commands
	'(("a" "Agenda"
	   (
	    (agenda)

	    (org-ql-block '(and (todo)
				(deadline auto))
			  ((org-ql-block-header "DUE")))

	    (org-ql-block '(and (todo)
				(scheduled :on today))
			  ((org-ql-block-header "TODAY")))

	    (org-ql-block '(and (todo)
				(priority "A"))
			  ((org-ql-block-header "IMPORTANT")))

	    (org-ql-block '(and (todo "TODO") (not (habit)) (not (category "inbox")) (not (scheduled)))
			  ((org-ql-block-header "TASKS")))

	    (org-ql-block '(and (todo "TODO") (tags "book"))
			  ((org-ql-block-header "INPUT")))

	    (org-ql-block '(and (todo "IDEA"))
			  ((org-ql-block-header "IDEAS")))

	    ))))
  )

(use-package org-roam
  :after org
  :custom
  (org-roam-directory my/notes-location)
  (org-roam-dailies-directory "daily/")
  (org-roam-completion-everywhere t)
  (org-roam-node-display-template "${title:*} ${tags:10}")
  (org-roam-node-dailies-capture-template
   '(("d" "default" entry
      "* %?"
      :target (file+head "%<%Y-%m-%d>.org"
			 "#+title: %<%Y-%m-%d>\n"))))
  (org-roam-capture-templates
   '(("d" "default" plain "%?" :target
      (file+head "${slug}.org" "#+title: ${title}\n\n")
      :unnarrowed t)
     ("p" "project" plain "%?" :target
      (file+head "${slug}.org" "#+title: ${title}\n#+filetags: :project:\n\n")
      :unnarrowed t)
     ("l" "link" plain "* TO-READ %?\n" :target
      (file+head "resource.org" "Inbox")
      :unnarrowed t)
     ))
  :config
  (org-roam-setup))

(defun my/org-find-project ()
  (interactive)
  (org-roam-node-find
   nil
   nil
   (lambda (node)
    (member "project" (org-roam-node-tags node)))))



(use-package evil-org
  :after org
  :hook (org-mode . (lambda () evil-org-mode))
  :config
  (require 'evil-org-agenda)
  (evil-org-agenda-set-keys))

(add-hook 'org-mode-hook
	  #'(lambda ()
	      (visual-line-mode)
	      (org-indent-mode)))

;; look and feel
(use-package olivetti)

(defun my/org-mode ()
  (olivetti-mode)
  (olivetti-set-width 80)
  ;; turn off line numbers
  (display-line-numbers-mode -1))

(add-hook 'org-mode-hook 'my/org-mode)

(setq org-image-actual-width nil)
(use-package org-download)
(use-package org-cliplink)

(use-package lsp-mode
  :commands lsp
  :custom
  (lsp-completion-provider :none) ;; we use Corfu instead
  (lsp-headerline-breadcrumb-enable nil)
  (lsp-headerline-breadcrumb-enable nil)
  :init
  ;; (setq lsp-keymap-prefix "C-c l")
  (defun my/lsp-mode-setup-completion ()
    (setf (alist-get 'styles (alist-get 'lsp-capf completion-category-defaults))
	  '(orderless))) ;; Configure orderless
  :hook
  ((typescript-mode . lsp)
   (web-mode . lsp)
   (typescript-ts-mode . lsp)
   (js2-mode . lsp)
   (js-mode . lsp)
   (js-ts-mode . lsp)
   (jsx-mode . lsp)
   (yaml-mode . lsp)
   (yaml-ts-mode . lsp)
   (lsp-mode . lsp-enable-which-key-integration)
   (lsp-completion-mode . my/lsp-mode-setup-completion))
  :config
  (evil-define-key 'normal 'global "gD" 'lsp-find-type-definition)
  (evil-define-key 'normal 'global "gr" 'lsp-find-references)
  (evil-define-key 'normal 'global "K" 'lsp-ui-doc-glance)
  ;; (evil-define-key 'normal 'global "gr" 'lsp-find-references)
  (evil-define-key 'normal 'global "gR" 'lsp-rename)
  (evil-define-key 'normal 'global (kbd "M-.") 'lsp-execute-code-action))

;; (with-eval-after-load 'lsp-mode
;;   (add-hook 'lsp-mode-hook #'lsp-enable-which-key-integration))

(use-package lsp-ui
  :hook
  (lsp-mode . lsp-ui-mode)
  :config
  (setq lsp-ui-doc-show-with-cursor nil))

(use-package consult-lsp
  :after (lsp-mode))

;; Key bindings.

(defhydra hydra-lsp (:hint nil)
  "lsp"
  ("s" consult-lsp-file-symbols "symbols" :color blue)
  ("r" lsp-find-references "reference" :color blue)
  ("R" lsp-rename "rename" :color blue)
  ("o" lsp-organize-imports "org imports" :color blue)
  ("q" nil "quit"))


;; (evil-define-minor-mode-key 'normal lsp-mode (kbd "SPC l") lsp-command-map)
(general-def 'normal lsp-mode :definer 'minor-mode
  "M-l" 'hydra-lsp/body)

(use-package treesit-auto
  :config
  (global-treesit-auto-mode))

(use-package apheleia
  :ensure t
  :config
  (apheleia-global-mode +1))

;; Automatically make file executable when =shebang= is found.
(add-hook 'after-save-hook
	  'executable-make-buffer-file-executable-if-script-p)

(use-package editorconfig
  :config
  (editorconfig-mode 1))

(use-package smartparens
  :config
  (require 'smartparens-config)
  (add-hook 'prog-mode-hook #'smartparens-mode))

(use-package origami
  :config
  (global-origami-mode))

(use-package eldoc
  :ensure nil
  :config
  (setq eldoc-idle-delay 0
	eldoc-echo-area-use-multiline-p nil))

(defhydra hydra-check (:hint nil)
  "flymake"
  ("j" flymake-goto-next-error "next error")
  ("k" flymake-goto-prev-error "prev error")
  ("l" flymake-show-buffer-diagnostics "list errors" :color blue)
  ("a" eglot-code-actions "action" :color blue)
  ("o" eglot-code-action-organize-imports "orgnize import" :color blue)
  ("q" nil "quit"))

(tyrant!
  :states '(normal)
  ";" 'hydra-check/body)

(defgroup shebang nil
  "Shebang."
  :group 'extensions)

(defcustom shebang-env-path "/usr/bin/env"
  "Path to the env executable."
  :type 'string
  :group 'shebang)

(defcustom shebang-interpretor-map
  '(("sh" . "bash")
    ("py" . "python3")
    ("js" . "deno run")
    ("mjs" . "deno run")
    ("ts" . "deno run")
    ("rb" . "ruby"))
  "Alist of interpretors and their paths."
  :type '(alist :key-type (string :tag "Extension")
           :value-type (string :tag "Interpreter"))
  :group 'shebang)

(defun guess-shebang-command ()
  "Guess the command to use for the shebang."
  (let ((ext (file-name-extension (buffer-file-name))))
    (or (cdr (assoc ext shebang-interpretor-map))
        ext)))

(defun insert-shebang ()
  "Insert shebang line at the top of the buffer."
  (interactive)
  (goto-char (point-min))
  (insert (format "#!%s %s" shebang-env-path (guess-shebang-command)))
  (newline))

(leader! "ib" '(insert-shebang :which-key "insert shebang"))

(defgroup run nil
  "Run."
  :group 'extensions)

(defcustom run-ext-command-map
  '(("sh" . "bash")
    ("py" . "python3")
    ("js" . "deno run")
    ("ts" . "deno run")
    ("mjs" . "deno run")
    ("rb" . "ruby"))
  "Alist of interpretors and their paths."
  :type '(alist :key-type (string :tag "Extension")
           :value-type (string :tag "Command"))
  :group 'run)

(defun get-command (file)
  "Get command for executing FILE.

Return the FILE when the file is executable.
Return the command from the run-ext-command-map otherwise"
  (if (file-executable-p file)
      file
    (let ((ext (file-name-extension file)))
      (format "%s %s" (cdr (assoc ext run-ext-command-map)) file))))

(defun run-buffer ()
  "Run the current buffer."
  (interactive)
  (when (not (buffer-file-name)) (save-buffer))
  (when (buffer-modified-p) (save-buffer))
  (let* (
          ($outputb "*run output*")
          (resize-mini-windows nil)
          ($fname (buffer-file-name))
          ($cmd (get-command $fname))
          )
    (progn
      (message "Running %s" $cmd)
      (shell-command $cmd $outputb)
      )))

(use-package copilot
  :ensure nil
  :hook (prog-mode . copilot-mode)
  :bind (("C-TAB" . 'copilot-accept-completion-by-word)
          ("C-<tab>" . 'copilot-accept-completion-by-word)
          :map copilot-completion-map
          ("<tab>" . 'copilot-accept-completion)
          ("TAB" . 'copilot-accept-completion)))

(use-package nix-mode
  :mode "\\.nix\\'")

(setq js-indent-level 2)

(use-package web-mode
  :mode (("\\.html?\\'" . web-mode)
         ("\\.css\\'"   . web-mode)
         ("\\.svelte\\'"   . web-mode)
         ("\\.[t|j]sx\\'"  . jsx-mode))
  :custom
  (web-mode-markup-indent-offset 2)
  (web-mode-css-indent-offset 2)
  (web-mode-code-indent-offset 2)
  :config
  ;; https://github.com/emacs-typescript/typescript.el/issues/4#issuecomment-947866123
  (define-derived-mode jsx-mode web-mode "jsx")
  (setq web-mode-content-types-alist '(("jsx" . "\\.js[x]?\\'")))
  (with-eval-after-load 'lsp-mode
    (add-to-list 'lsp--formatting-indent-alist '(jsx-mode . js-indent-level))))

(use-package javascript-mode
  :ensure nil
  :mode (("\\.[m|c]?js\\'" . javascript-mode))
  :config
  (setq js-indent-level 2))

(use-package typescript-mode
  :mode (("\\.ts\\'" . typescript-mode))
  :init
  ;; (autoload 'typescript-tsx-mode "typescript-mode" nil t)
  ;; (add-to-list 'auto-mode-alist
  ;; 	       (cons "\\.tsx\\'"
  ;; 		     #'typescript-tsx-mode))
  :config
  ;; (define-derived-mode typescript-tsx-mode web-mode "tsx")
  (setq typescript-indent-level 2))

(define-derived-mode astro-mode web-mode "astro")
(setq auto-mode-alist
      (append '((".*\\.astro\\'" . astro-mode))
              auto-mode-alist))

;; (with-eval-after-load 'lsp-mode
;;   (add-to-list 'lsp-language-id-configuration
;;                '(astro-mode . "astro")))

(use-package lua-mode
  :init
  ;; lua-indent-level defaults to 3 otherwise. Madness.
  (setq lua-indent-level 2)
)

(use-package rustic
  :mode ("\\.rs\\'" . rustic-mode)
  :config
  (setq rustic-lsp-server 'rust-analyzer))

(use-package json-mode
  :mode "\\.js\\(?:on\\|[hl]int\\(?:rc\\)?\\)\\'"
  :init
  :config
  ;; (map! :after json-mode
  ;;       :map json-mode-map
  ;;       :localleader
  ;;       :desc "Copy path" "p" #'json-mode-show-path
  ;;       "t" #'json-toggle-boolean
  ;;       "d" #'json-mode-kill-path
  ;;       "x" #'json-nullify-sexp
  ;;       "+" #'json-increment-number-at-point
  ;;       "-" #'json-decrement-number-at-point
  ;;       "f" #'json-mode-beautify)
  )

(use-package yaml-mode)

(use-package csv-mode)

(use-package markdown-mode
  :mode "\\.md\\'"
  :config
  (setq markdown-command "multimarkdown")
  (unbind-key "M-p" markdown-mode-map))
