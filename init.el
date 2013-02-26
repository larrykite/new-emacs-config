(require 'package)
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/"))
(package-initialize)

(when (not package-archive-contents)
  (package-refresh-contents))

(defvar my-packages '(starter-kit
                      starter-kit-bindings
                      starter-kit-js
                      autopair
                      yasnippet
                      auto-complete
                      fuzzy)
  "A list of packages to ensure are installed at launch.")

(dolist (p my-packages)
  (when (not (package-installed-p p))
    (package-install p)))

(add-to-list 'load-path "~/.emacs.d/el-get/el-get")
(unless (require 'el-get nil 'noerror)
  (with-current-buffer
      (url-retrieve-synchronously
       "https://raw.github.com/dimitri/el-get/master/el-get-install.el")
    (let (el-get-master-branch)
      (goto-char (point-max))
      (eval-print-last-sexp))))

(setq jedi:setup-keys t)

(el-get 'sync)

(add-hook 'python-mode-hook 'jedi:setup)

(setq lmk-emacs-init-file load-file-name)
(setq lmk-emacs-config-dir
      (file-name-directory lmk-emacs-init-file))
(setq user-emacs-directory lmk-emacs-config-dir)
(add-to-list 'load-path lmk-emacs-config-dir)
(setq lmk-secrets-file "~/.emacs.d/lmksecrets.el")
(setq lmk-functions-file "~/.emacs.d/functions.el")
(setq lmk-keybindings-file "~/.emacs.d/keybindings.el")

(load lmk-functions-file)
(load lmk-keybindings-file)


(setq backup-directory-alist
      (list (cons "." (expand-file-name "backup" user-emacs-directory))))

(push "~/envs/default/bin" exec-path)
(setenv "PATH"
        (concat
         "~/envs/default/bin" ":"
         (getenv "PATH")
         ))

(add-to-list 'default-frame-alist '(font . "Inconsolata-11"))
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")


;; M-x shell is a nice shell interface to use, let's make it colorful.  If
;; you need a terminal emulator rather than just a shell, consider M-x term
;; instead.
(autoload 'ansi-color-for-comint-mode-on "ansi-color" nil t)
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)

(global-auto-revert-mode 1)
                                        ;(toggle-diredp-find-file-reuse-dir 1)
(setq compile-command "make")
(setq redisplay-dont-pause t)

(delete-selection-mode t)
(setq custom-file (expand-file-name "emacs-customizations.el" lmk-emacs-config-dir))
(load custom-file)
(load-theme 'zenburn)
(set-language-environment "utf-8")
(add-hook 'before-save-hook 'time-stamp)
(setq time-stamp-pattern nil)
(require 'ace-jump-mode)
(define-key global-map (kbd "C-c SPC") 'ace-jump-mode)
(require 'dired-x)
(require 'dired+)
(require 'switch-window)
(require 'saveplace)
(setq-default save-place t)
(require 'undo-tree)
(global-undo-tree-mode)
(require 'buffer-move)
(require 'fill-column-indicator)
;;(define-globalized-minor-mode global-fci-mode fci-mode (lambda () (fci-mode 1)))
;;(global-fci-mode 1)
(add-hook 'python-mode-hook 'fci-mode)

;; autopair and yas in all modes
;;(autopair-global-mode)
;;(yas-global-mode 1)

;; autocomplete
(require 'auto-complete-config)
(setq ac-dictionary-files (list (concat user-emacs-directory ".dict")))
(ac-config-default)
;; hack to fix ac-sources after pycomplete.el breaks it
(add-hook 'python-mode-hook
          '(lambda ()
             (setq ac-sources '(ac-source-pycomplete
                                ac-source-abbrev
                                ac-source-dictionary
                                ac-source-words-in-same-mode-buffers))))

;; Set up python-mode
(setq py-install-directory (concat esk-user-dir "/python-mode.el-6.0.12/"))
(add-to-list 'load-path py-install-directory)
;; this will show method signatures while typing
(setq py-set-complete-keymap-p t)
(require 'python-mode)
;; activate the virtualenv where Pymacs is located
(virtualenv-workon "default/")

(defun load-pycomplete ()
  "Load and initialize pycomplete."
  (interactive)
  (let* ((pyshell (py-choose-shell))
         (path (getenv "PYTHONPATH")))
    (setenv "PYTHONPATH" (concat
                          (expand-file-name py-install-directory) "completion"
                          (if path (concat path-separator path))))
    (if (py-install-directory-check)
        (progn
          (setenv "PYMACS_PYTHON" (if (string-match "IP" pyshell)
                                      "python"
                                    pyshell))
          (autoload 'pymacs-apply "pymacs")
          (autoload 'pymacs-call "pymacs")
          (autoload 'pymacs-eval "pymacs")
          (autoload 'pymacs-exec "pymacs")
          (autoload 'pymacs-load "pymacs")
          (load (concat py-install-directory "completion/pycomplete.el") nil t)
          (add-hook 'python-mode-hook 'py-complete-initialize))
      (error "`py-install-directory' not set, see INSTALL"))))
(eval-after-load 'pymacs '(load-pycomplete))

;; pyflakes flymake integration
;; http://stackoverflow.com/a/1257306/347942
;; (when (load "flymake" t)
;;   (defun flymake-pyflakes-init ()
;;     (let* ((temp-file (flymake-init-create-temp-buffer-copy
;;                        'flymake-create-temp-inplace))
;;            (local-file (file-relative-name
;;                         temp-file
;;                         (file-name-directory buffer-file-name))))
;;       (list "pycheckers" (list local-file))))
;;   (add-to-list 'flymake-allowed-file-name-masks
;;                '("\\.py\\'" flymake-pyflakes-init)))
;; (add-hook 'python-mode-hook 'flymake-mode)
(setq tramp-shell-prompt-pattern "^[^$>\n]*[#$%>] *\\(\[[0-9;]*[a-zA-Z] *\\)*")
(require 'tramp)
(setq tramp-default-method "ssh")

(setq-default default-tab-width 4)


