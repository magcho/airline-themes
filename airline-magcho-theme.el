
;;; Code:

(deftheme airline-magcho
  "source: https://github.com/vim-airline/vim-airline-themes")

(let ((normal-outer-foreground   "#e2e2e2") (normal-outer-background   "#4f3598")
      (normal-inner-foreground   "#ff5fd7") (normal-inner-background   "#242322")
      (normal-center-foreground  "#e2e2e2") (normal-center-background  "#4a4a4a")

      (insert-outer-foreground   "#242322") (insert-outer-background   "#7eaefd")
      (insert-inner-foreground   "#75d7d8") (insert-inner-background   "#242322")
      (insert-center-foreground  "#e2e2e2") (insert-center-background  "#4a4a4a")

      (visual-outer-foreground   "#242322") (visual-outer-background   "#e6987a")
      (visual-inner-foreground   "#dbc570") (visual-inner-background   "#242322")
      (visual-center-foreground  "#e2e2e2") (visual-center-background  "#4a4a4a")

      (replace-outer-foreground  "#75d7d8") (replace-outer-background  "#005154")
      (replace-inner-foreground  "#75d7d8") (replace-inner-background  "#242322")
      (replace-center-foreground "#e2e2e2") (replace-center-background "#4a4a4a")

      (emacs-outer-foreground    "#e2e2e2") (emacs-outer-background    "#4f3598")
      (emacs-inner-foreground    "#ff5fd7") (emacs-inner-background    "#242322")
      (emacs-center-foreground   "#e2e2e2") (emacs-center-background   "#4a4a4a")

      (inactive1-foreground      "#b2b2b2") (inactive1-background      "#4a4a4a")
      (inactive2-foreground      "#b2b2b2") (inactive2-background      "#4a4a4a")
      (inactive3-foreground      "#b2b2b2") (inactive3-background      "#4a4a4a"))

  (airline-themes-set-deftheme 'airline-magcho)

  (when airline-cursor-colors
    (setq evil-emacs-state-cursor   emacs-outer-background
          evil-normal-state-cursor  normal-outer-background
          evil-insert-state-cursor  `(bar ,insert-outer-background)
          evil-replace-state-cursor replace-outer-background
          evil-visual-state-cursor  visual-outer-background))
  )

;;
(defun airline-themes-mode-line-format ()
  '(let* ((current-window-width (window-width))
          (active (powerline-selected-window-active))
          (separator-left (intern (format "powerline-%s-%s"
                                          (powerline-current-separator)
                                          (car powerline-default-separator-dir))))
          (separator-right (intern (format "powerline-%s-%s"
                                           (powerline-current-separator)
                                           (cdr powerline-default-separator-dir))))
          (mode-line-face (if active 'mode-line 'mode-line-inactive))
          (evil-mode-active (featurep 'evil))
          (visual-block (if evil-mode-active
                            (and (evil-visual-state-p)
                                 (eq evil-visual-selection 'block))
                          nil))
          (visual-line (if evil-mode-active
                           (and (evil-visual-state-p)
                                (eq evil-visual-selection 'line))
                         nil))
          (current-evil-state-string (if evil-mode-active
                                         (upcase (concat (symbol-name evil-state)
                                                         (cond (visual-block "-BLOCK")
                                                               (visual-line "-LINE"))))
                                       nil))
          ;; Shorten evil state to a single charater instead of the full word
          (current-evil-state-string (if (and current-evil-state-string
                                              (< current-window-width 80))
                                         (substring current-evil-state-string 0 1)
                                       current-evil-state-string))
          (outer-face
           (if active
               (if evil-mode-active
                   (cond ((eq evil-state (intern "normal"))  'airline-normal-outer)
                         ((eq evil-state (intern "insert"))  'airline-insert-outer)
                         ((eq evil-state (intern "visual"))  'airline-visual-outer)
                         ((eq evil-state (intern "replace")) 'airline-replace-outer)
                         ((eq evil-state (intern "emacs"))   'airline-emacs-outer)
                         (t                                  'airline-normal-outer))
                 'airline-normal-outer)
             'powerline-inactive1))

          (inner-face
           (if active
               (if evil-mode-active
                   (cond ((eq evil-state (intern "normal")) 'airline-normal-inner)
                         ((eq evil-state (intern "insert")) 'airline-insert-inner)
                         ((eq evil-state (intern "visual")) 'airline-visual-inner)
                         ((eq evil-state (intern "replace")) 'airline-replace-inner)
                         ((eq evil-state (intern "emacs"))   'airline-emacs-inner)
                         (t                                 'airline-normal-inner))
                 'airline-normal-inner)
             'powerline-inactive2))

          (center-face
           (if active
               (if evil-mode-active
                   (cond ((eq evil-state (intern "normal")) 'airline-normal-center)
                         ((eq evil-state (intern "insert")) 'airline-insert-center)
                         ((eq evil-state (intern "visual")) 'airline-visual-center)
                         ((eq evil-state (intern "replace")) 'airline-replace-center)
                         ((eq evil-state (intern "emacs"))   'airline-emacs-center)
                         (t                                 'airline-normal-center))
                 'airline-normal-center)
             'airline-inactive3))

          ;; Left Hand Side
          (lhs-mode (when (or (not airline-hide-state-on-inactive-buffers)
                              (and airline-hide-state-on-inactive-buffers active))
                      (if evil-mode-active
                          (list
                           ;; Evil Mode Name
                           (powerline-raw (concat " " current-evil-state-string " ") outer-face)
                           (funcall separator-left outer-face inner-face)
                           ;; Modified string
                           (powerline-raw "%*" inner-face 'l))
                        (list
                         ;; Modified string
                         ;; Current Line / Number of lines
                         (powerline-raw
                          (format "%%l/%d" (count-lines (point-min) (point-max))) outer-face 'l)

                         (powerline-raw "%3c" outer-face 'l)

                         ;; Separator >
                         (powerline-raw " " outer-face)
                         (funcall separator-left outer-face inner-face)))))

          (lhs-rest (list
                     ;; ;; Separator >
                     ;; (powerline-raw (char-to-string #x2b81) inner-face 'l)

                     ;; Eyebrowse current tab/window config
                     (if (and (or (not airline-hide-eyebrowse-on-inactive-buffers)
                                  (and airline-hide-eyebrowse-on-inactive-buffers active))
                              (featurep 'eyebrowse))
                         (powerline-raw (concat " " (eyebrowse-mode-line-indicator)) inner-face 'r))

                     ;; Git Branch
                     (if (and (or (not airline-hide-vc-branch-on-inactive-buffers)
                                  (and airline-hide-vc-branch-on-inactive-buffers active))
                              buffer-file-name vc-mode)
                         (powerline-raw (airline-get-vc) inner-face))

                     ;; Separator >
                     (powerline-raw " " inner-face)
                     (funcall separator-left inner-face center-face)

                     ;; Directory
                     (cond
                      ((and buffer-file-name ;; if buffer has a filename
                            (eq airline-display-directory
                                'airline-directory-shortened))
                       (powerline-raw (airline-shorten-directory default-directory airline-shortened-directory-length) center-face 'l))
                      ((and buffer-file-name ;; if buffer has a filename
                            (eq airline-display-directory
                                'airline-directory-full))
                       (powerline-raw default-directory center-face 'l))
                      (t
                       (powerline-raw " " center-face)))

                     ;; Buffer ID
                     ;; (powerline-buffer-id center-face)
                     (powerline-raw "%b" center-face)

                     ;; Current Function (which-function-mode)
                     (when (and (boundp 'which-func-mode) which-func-mode)
                       ;; (powerline-raw which-func-format 'l nil))
                       (powerline-raw which-func-format center-face 'l))

                     ;; ;; Separator >
                     ;; (powerline-raw " " center-face)
                     ;; (funcall separator-left mode-line face1)

                     (when (boundp 'erc-modified-channels-object)
                       (powerline-raw erc-modified-channels-object center-face 'l))

                     ;; ;; Separator <
                     ;; (powerline-raw " " face1)
                     ;; (funcall separator-right face1 face2)
                     ))

          (lhs (append lhs-mode lhs-rest))

          ;; Right Hand Side
          (rhs (list (powerline-raw global-mode-string center-face 'r)

                     ;; ;; Separator <
                     ;; (powerline-raw (char-to-string #x2b83) center-face 'l)

                     ;; Minor Modes
                     (powerline-minor-modes center-face 'l)
                     ;; (powerline-narrow center-face 'l)

                     ;; Subseparator <
                     (powerline-raw (char-to-string airline-utf-glyph-subseparator-right) center-face 'l)

                     ;; Major Mode
                     (powerline-major-mode center-face 'l)
                     (powerline-process center-face)

                     ;; Separator <
                     (powerline-raw " " center-face)
                     (funcall separator-right center-face inner-face)

                     ;; ;; Buffer Size
                     ;; (when powerline-display-buffer-size
                     ;;   (powerline-buffer-size inner-face 'l))
                     ;; ;; Mule Info
                     ;; (when powerline-display-mule-info
                     ;;   (powerline-raw mode-line-mule-info inner-face 'l))
                     ;; (powerline-raw " " inner-face)
                     (powerline-raw (format " %s " buffer-file-coding-system) inner-face)

                     ;; Separator <
                     (funcall separator-right inner-face outer-face)

                     ;; % location in file
                     (powerline-raw "%3p" outer-face 'l)
                     ;; LN charachter
                     (powerline-raw (char-to-string airline-utf-glyph-linenumber) outer-face 'l)

                     ;; Current Line / File Size
                     ;; (powerline-raw "%l/%I" outer-face 'l)
                     ;; Current Line / Number of lines
                     ;; (powerline-raw
                      ;; (format "%%l/%d" (count-lines (point-min) (point-max))) outer-face 'l)

                     (powerline-raw "ln :" outer-face 'l)
                     ;; Current Column
                     (powerline-raw "%3c " outer-face 'l)

                     ;; ;; position in file image
                     ;; (when powerline-display-hud
                     ;;   (powerline-hud inner-face outer-face))
                     )
               ))
     ;; Combine Left and Right Hand Sides
     (concat (powerline-render lhs)
             (powerline-fill center-face (powerline-width rhs))
             (powerline-render rhs))))

;;

(airline-themes-set-modeline)

(provide-theme 'airline-magcho)
;;; airline-magcho-theme.el ends here
