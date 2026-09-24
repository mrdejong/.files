(setq user-full-name "Alexander de Jong"
      user-mail-address "mrdejong89@gmail.com")

(use-package! catppuccin-theme :init (setq catppuccin-flavor 'mocha))
(setq doom-theme 'catppuccin)

(setq display-line-numbers-type 'relative)

(setq doom-font (font-spec :family "GeistMono Nerd Font" :size 16)
      doom-variable-pitch-font (font-spec :family "Roboto" :size 16)
      doom-big-font (font-spec :family "GeistMono Nerd Font" :size 22))

(setq org-directory "~/.org")
(setq corfu-auto-delay 0.05
      corfu-auto-prefix 0.05)

(require 'key-chord)
(key-chord-mode 1)
(setq key-chord-two-keys-delay 0.5)
(setq key-chord-one-key-delay 0.3)
(defun key-seq-define (keymap keys command)
  (when (/= 2 (length keys))
    (error "Key-chord keys must have two elements"))
  (let ((key1 (aref keys 0))
        (key2 (aref keys 1)))
    (unless (and (integerp key1) (< key1 256)
                 (integerp key2) (< key2 256))
      (error "Key-chord keys must both be bytes (characters with codes < 256)"))
    (if (eq key1 key2)
        (define-key keymap (vector 'key-chord key1 key2) command)
      (define-key keymap (vector 'key-chord key1 key2) command))
    (if command
        (key-chord-register-keys key1 key2)
      (key-chord-unregister-keys key1 key2))))

(defun exec-keys (chars)
  (evil-normal-state)
  (execute-kbd-macro (read-kbd-macro chars)))

(defun save-exit ()
  (interactive)
  (evil-normal-state)
  (save-buffer))

(defun move-char ()
  (interactive)
  (exec-keys "la"))

(key-seq-define evil-insert-state-map "jk" 'evil-normal-state)
(key-seq-define evil-insert-state-map "jw" 'save-exit)
(key-seq-define evil-insert-state-map "jl" 'move-char)

(after! org-journal (setq org-journal-file-format "%W-%A-%B-%d-%m-%Y.org"))

(use-package! org-roam
  :custom
  (org-roam-directory "~/.org/roam")
  (org-roam-database-connector 'sqlite-builtin)
  (org-roam-db-location (expand-file-name "org-roam.db" org-roam-directory))

  :config
  (unless (file-exists-p org-roam-directory)
    (make-directory org-roam-directory t))

  (advice-add 'org-roam-db-query :around
              (lambda (fn &rest args)
                (condition-case err
                    (apply fn args)
                  (error
                   (message "Database error in org-roam: %S" err)
                   nil))))
  (org-roam-db-autosync-mode +1))

(use-package! websocket
  :after org-roam)

(use-package! org-roam-ui
  :after org-roam
  :config
  (setq org-roam-ui-sync-theme t
        org-roam-ui-follow t
        org-roam-ui-update-on-save t
        org-roam-ui-open-on-start t))

(with-eval-after-load 'org
  (define-key org-mode-map (kbd "C-c e") #'org-set-effort)
  (define-key org-mode-map (kbd "C-c i") #'org-clock-in)
  (define-key org-mode-map (kbd "C-c o") #'org-clock-out))

(add-to-list 'auto-mode-alist '("\\.templ\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.svelte\\'" . web-mode))

(set-file-template! "\\.templ$" :trigger "__templ" :mode 'web-mode)
(set-file-template! "\\.svelte$" :trigger "__svelte" :mode 'web-mode)

(use-package! svelte-mode
  :mode "\\.svelte\\'"
  :config
  (setq svelte-basic-offset 2)
  (setq svelte-format-on-save nil)
  (add-hook 'svelte-mode-hook 'prettier-js-mode))

(use-package! prettier-js
  :config
  (setq prettier-js-args
        '("--parser" "svelte"
          "--tab-width" "4"
          "--use-tabs" "true")))

(use-package! lsp-tailwindcss)
