;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; IDE emacs config
;;
;; 'config/ide
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'config-common)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Variables
;;

(custom-set-variables
 '(global-semantic-highlight-edits-mode t nil (semantic/util-modes))
 '(global-semantic-idle-tag-highlight-mode t nil (semantic/idle))
 '(semantic-format-use-images-flag t)
 '(semantic-lex-debug-analyzers t)
 '(semantic-mode t)
 )

;; colors in Shell mode
(setq ansi-color-names-vector ; better contrast colors
      ["black" "red4" "green4" "yellow4"
       "blue3" "magenta4" "cyan4" "white"])
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)

;; pour que la fenetre de compilation ne soit pas trop grande
(setq compilation-window-height 10)

;; affiche les espaces inutile
(setq-default show-trailing-whitespace t)

;; special compilation window
(defun jo/compile-in-current-buffer ()
  (interactive)
  (switch-to-buffer "*compilation*")
  (compile "make")
  )

;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Plugins
;;

(add-to-list 'load-path "~/.emacs.d/plugins")
(add-to-list 'load-path "~/.emacs.d/plugins/yasnippet-0.6.1c")
(add-to-list 'load-path "~/.emacs.d/plugins/autocomplete")

;;
;; CEDET + SEMANTIC
;;
(semantic-mode 1)
(global-ede-mode t)
(setq semantic-default-submodes
	  '(global-semanticdb-minor-mode
		global-semantic-idle-scheduler-mode
		;; global-semantic-idle-summary-mode
		global-semantic-decoration-mode
		global-semantic-highlight-func-mode
		;; global-semantic-stickyfunc-mode
		;; global-semantic-idle-completions-mode
		))
;;
;; YASNIPPETS
;;
(require 'yasnippet)
(yas/initialize)
(yas/load-directory "~/.emacs.d/plugins/yasnippet-0.6.1c/snippets")

;;
;; AUTOCOMPLETE
;;
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/plugins/autocomplete/ac-dict")
(ac-config-default)

(setq-default ac-sources (append '(ac-source-semantic
                                   ac-source-semantic-raw)
                                 ac-sources))


;;
;; EASSIST
;;
(require 'eassist)

;;
;; AUTO-COMPLETE with semantic + yasnippet :
;;
(global-auto-complete-mode t)
(setq-default ac-auto-start t)
(setq-default ac-dwim t)
(setq-default ac-override-local-map nil)
(setq-default ac-expand-on-auto-complete nil)
(setq-default ac-quick-help-delay 0.5)
(setq-default ac-modes
              '(emacs-lisp-mode lisp-interaction-mode lisp-mode scheme-mode
                c-mode cc-mode c++-mode java-mode
                perl-mode cperl-mode python-mode ruby-mode
                ecmascript-mode javascript-mode php-mode css-mode
                makefile-mode sh-mode fortran-mode f90-mode ada-mode
                xml-mode sgml-mode
                haskell-mode literate-haskell-mode
                emms-tag-editor-mode
                asm-mode
                org-mode))

;;
;; AUTO-COMPELETE-CLANG
;;
(defun jo/clang-complete()
  (interactive)
  (add-to-list 'load-path "~/.emacs.d/plugins/autocomplete-clang")
  (require 'auto-complete-clang)
  (global-set-key [(control return)] 'ac-complete-clang)
  ;; (global-set-key (kbd "M-/") 'ac-complete-clang)
)
(add-hook 'c-mode-common-hook 'jo/clang-complete)

;;
;; QT4 SEMANTIC COMPLETION :
;;
;; (setq qt4-include-base-dir "/usr/include/")
;; (loop for dir in (directory-files qt4-include-base-dir t "^Q")
;; 	  do (semantic-add-system-include dir 'c++-mode))
;; (semantic-add-system-include qt4-include-base-dir 'c++-mode)
;; (add-to-list 'auto-mode-alist (cons (expand-file-name qt4-include-base-dir) 'c++-mode))

;;
;; HIDE-SHOW (FOLDING)
;;
(add-hook 'c-mode-common-hook 'hs-minor-mode)

;;
;; FlyMake
;;
(setq flymake-master-file-dirs
      '("."
        "./src" "../src" "../../src" "../../src"
        "./inc" "../inc" "../../inc"
        "./include" "../include" "../../include"
        ))

(setq flymake-buildfile-dirs  '("./"  "../" "../../" "../../../" "../../../../") )
(setq flymake-allowed-file-name-masks
      '(("\\.c\\'" flymake-simple-make-init)
        ("\\.cpp\\'" flymake-simple-make-init)
        ("\\.hpp\\'" flymake-simple-make-init)
        ("\\.h\\'" flymake-simple-make-init)
        ;; ("\\.h\\'" flymake-master-make-header-init flymake-master-cleanup)
        ("\\.xml\\'" flymake-xml-init)
        ("\\.html?\\'" flymake-xml-init)
        ("\\.cs\\'" flymake-simple-make-init)
        ("\\.pl\\'" flymake-perl-init)
        ("\\.java\\'" flymake-simple-make-java-init flymake-simple-java-cleanup)
        ("[0-9]+\\.tex\\'" flymake-master-tex-init flymake-master-cleanup)
        ("\\.tex\\'" flymake-simple-tex-init)
        ("\\.idl\\'" flymake-simple-make-init)
        ;; ("\\.cpp\\'" 1)
        ;; ("\\.java\\'" 3)
        ;; ("\\.h\\'" 2 ("\\.cpp\\'" "\\.c\\'")
        ;; ("[ \t]*#[ \t]*include[ \t]*\"\\([\w0-9/\\_\.]*[/\\]*\\)\\(%s\\)\"" 1 2))
        ;; ("\\.idl\\'" 1)
        ;; ("\\.odl\\'" 1)
        ;; ("[0-9]+\\.tex\\'" 2 ("\\.tex\\'")
        ;; ("[ \t]*\\input[ \t]*{\\(.*\\)\\(%s\\)}" 1 2 ))
        ;; ("\\.tex\\'" 1)
        ))
(global-set-key "\C-cl" 'flymake-start-syntax-check)
(setq flymake-gui-warnings-enabled nil)

;;
;; MadelBrot
;;
(require 'u-mandelbrot)

;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; CEDET SHORTCUTS
;;

(defun jo/cedet-hook ()
  ;; (local-set-key [(control return)] 'semantic-ia-complete-symbol-menu)
  (local-set-key "\C-c?" 'semantic-ia-complete-symbol)

  (local-set-key "\C-c>" 'semantic-complete-analyze-inline)
  (local-set-key "\C-c=" 'semantic-decoration-include-visit)

  (local-set-key "\C-cj" 'semantic-ia-fast-jump) ;;BUG
  (local-set-key "\C-xj" 'semantic-ia-fast-jump) ;;BUG
  (local-set-key "\C-cq" 'semantic-ia-show-doc)
  (local-set-key "\C-cs" 'semantic-ia-show-summary)

  (local-set-key "\C-n" 'senator-next-tag) ;;BUG tag != token
  (local-set-key "\C-p" 'senator-previous-tag) ;;BUG tag != token

  (local-set-key "\C-f" 'hs-toggle-hiding)
  (local-set-key "\C-cf" 'hs-hide-all)
  (local-set-key "\C-c\C-f" 'hs-show-all)

  ;; (local-set-key "\C-f" 'senator-fold-tag-toggle)

  (local-set-key "\C-cw" 'senator-kill-tag)
  )
(add-hook 'c-mode-common-hook 'jo/cedet-hook)
(add-hook 'lisp-mode-hook 'jo/cedet-hook)
(add-hook 'scheme-mode-hook 'jo/cedet-hook)
(add-hook 'emacs-lisp-mode-hook 'jo/cedet-hook)
(add-hook 'erlang-mode-hook 'jo/cedet-hook)
(defun jo/c-mode-cedet-hook ()
  (local-set-key "\C-cd" 'eassist-switch-h-cpp)
  (local-set-key "\M-m" 'eassist-list-methods)
  (local-set-key "\C-c\C-r" 'semantic-symref)
  )
(add-hook 'c-mode-common-hook 'jo/c-mode-cedet-hook)

;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(provide 'config-ide)
