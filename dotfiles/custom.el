(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(Linum-format "%7i ")
 '(ac-ispell-requires 4 t)
 '(ahs-case-fold-search nil)
 '(ahs-default-range 'ahs-range-whole-buffer)
 '(ahs-idle-interval 0.25)
 '(ahs-idle-timer 0 t)
 '(ahs-inhibit-face-list nil)
 '(ansi-color-faces-vector
   [default bold shadow italic underline bold bold-italic bold])
 '(ansi-color-names-vector
   ["#110F13" "#B13120" "#719F34" "#CEAE3E" "#7C9FC9" "#7868B5" "#009090" "#F4EAD5"])
 '(ansi-term-color-vector
   [unspecified "#1d1f21" "#cc6666" "#b5bd68" "#f0c674" "#81a2be" "#b294bb" "#81a2be" "#c5c8c6"] t)
 '(before-save-hook
   '(spacemacs//python-sort-imports gofmt-before-save org-update-all-dblocks))
 '(browse-url-browser-function 'browse-url-generic)
 '(browse-url-generic-program "/home/jb55/bin/browser")
 '(c-default-style
   '((c-mode . "linux")
     (java-mode . "java")
     (awk-mode . "awk")
     (other . "gnu")))
 '(company-clang-arguments '("-Ideps"))
 '(company-quickhelp-delay nil)
 '(company-quickhelp-mode t)
 '(compilation-message-face 'default)
 '(compilation-window-height 15)
 '(csv-separators '("," "	"))
 '(cua-global-mark-cursor-color "#2aa198")
 '(cua-normal-cursor-color "#657b83")
 '(cua-overwrite-cursor-color "#b58900")
 '(cua-read-only-cursor-color "#859900")
 '(debug-on-error nil)
 '(debug-on-quit nil)
 '(disaster-objdump "objdump -d -M att -Sl --no-show-raw-insn")
 '(elm-indent-offset 4)
 '(epg-gpg-home-directory "~/.gnupg")
 '(epg-gpg-program "gpg")
 '(eshell-prompt-function 'jb55/eshell-prompt)
 '(evil-kill-on-visual-paste nil)
 '(evil-shift-width 2)
 '(evil-want-Y-yank-to-eol t)
 '(expand-region-contract-fast-key "V")
 '(expand-region-reset-fast-key "r")
 '(fci-rule-character-color "#202020" t)
 '(fci-rule-color "#202020" t)
 '(fill-column 70)
 '(flycheck-clang-include-path '("deps"))
 '(flycheck-clang-language-standard nil)
 '(flycheck-display-errors-function 'flycheck-pos-tip-error-messages)
 '(flycheck-gcc-language-standard "c++11")
 '(flycheck-ghc-args '("-isrc"))
 '(flycheck-hlint-ignore-rules '("Eta reduce"))
 '(flycheck-pos-tip-timeout 2)
 '(flycheck-standard-error-navigation t)
 '(fringe-mode '(1 . 1) nil (fringe))
 '(global-display-fill-column-indicator-mode t)
 '(global-hl-line-mode t)
 '(gnus-select-method '(nntp "nntp.lore.kernel.org"))
 '(grep-find-ignored-directories
   '("SCCS" "RCS" "CVS" "MCVS" ".svn" ".git" ".hg" ".bzr" "_MTN" "_darcs" "{arch}" "node_modules"))
 '(haskell-font-lock-symbols nil)
 '(haskell-hoogle-command nil t)
 '(haskell-hoogle-url "http://localhost:8080/?hoogle=%s" t)
 '(haskell-indentation-indent-leftmost t)
 '(haskell-interactive-mode-scroll-to-bottom t)
 '(haskell-interactive-popup-error nil t)
 '(haskell-mode-hook
   '(turn-on-haskell-indent haskell-hook turn-on-hi2 flycheck-mode) t)
 '(haskell-notify-p t t)
 '(haskell-process-args-cabal-repl '("--ghc-options=-ferror-spans -fshow-loaded-modules"))
 '(haskell-process-args-ghci
   '("-isrc" "-XOverloadedStrings" "-ferror-spans" "-fshow-loaded-modules"))
 '(haskell-process-auto-import-loaded-modules t t)
 '(haskell-process-log t)
 '(haskell-process-suggest-remove-import-lines t t)
 '(haskell-process-type 'ghci)
 '(haskell-stylish-on-save nil t)
 '(haskell-tags-on-save nil)
 '(helm-echo-input-in-header-line nil)
 '(helm-ff-skip-boring-files t)
 '(highlight-changes-colors '("#d33682" "#6c71c4"))
 '(highlight-symbol-colors
   (--map
    (solarized-color-blend it "#fdf6e3" 0.25)
    '("#b58900" "#2aa198" "#dc322f" "#6c71c4" "#859900" "#cb4b16" "#268bd2")))
 '(highlight-symbol-foreground-color "#586e75")
 '(highlight-tail-colors
   '(("#eee8d5" . 0)
     ("#B4C342" . 20)
     ("#69CABF" . 30)
     ("#69B7F0" . 50)
     ("#DEB542" . 60)
     ("#F2804F" . 70)
     ("#F771AC" . 85)
     ("#eee8d5" . 100)))
 '(hl-bg-colors
   '("#DEB542" "#F2804F" "#FF6E64" "#F771AC" "#9EA0E5" "#69B7F0" "#69CABF" "#B4C342"))
 '(hl-fg-colors
   '("#fdf6e3" "#fdf6e3" "#fdf6e3" "#fdf6e3" "#fdf6e3" "#fdf6e3" "#fdf6e3" "#fdf6e3"))
 '(hl-todo-keyword-faces
   '(("TODO" . "#dc752f")
     ("NEXT" . "#dc752f")
     ("THEM" . "#2d9574")
     ("PROG" . "#3a81c3")
     ("OKAY" . "#3a81c3")
     ("DONT" . "#f2241f")
     ("FAIL" . "#f2241f")
     ("DONE" . "#42ae2c")
     ("NOTE" . "#b1951d")
     ("KLUDGE" . "#b1951d")
     ("HACK" . "#b1951d")
     ("TEMP" . "#b1951d")
     ("FIXME" . "#dc752f")
     ("XXX" . "#dc752f")
     ("XXXX" . "#dc752f")))
 '(if (version< emacs-version "24.4"))
 '(ispell-program-name "aspell")
 '(js-indent-level 2)
 '(js2-basic-offset 2)
 '(js2-bounce-indent-p t)
 '(js2-strict-missing-semi-warning nil)
 '(ledger-reports
   '(("bal realized" "%(binary) -f %(ledger-file) bal -V ")
     ("bal" "%(binary) -f %(ledger-file) bal")
     ("reg" "%(binary) -f %(ledger-file) reg")
     ("payee" "%(binary) -f %(ledger-file) reg @%(payee)")
     ("account" "%(binary) -f %(ledger-file) reg %(account)")))
 '(link-hint-delete-trailing-paren t)
 '(linum-format " %7i ")
 '(lsp-prefer-flymake :none)
 '(magit-diff-use-overlays nil)
 '(magit-log-margin '(nil age magit-log-margin-width nil 18))
 '(magit-refresh-status-buffer nil)
 '(magit-revision-insert-related-refs nil)
 '(magit-revision-show-gravatars nil)
 '(magit-revision-use-hash-sections 'quickest)
 '(mail-envelope-from 'header)
 '(mail-self-blind t)
 '(mail-specify-envelope-from nil)
 '(mailcap-user-mime-data '(("zathura %s" "application/pdf" nil)))
 '(main-line-color1 "#1E1E1E")
 '(main-line-color2 "#111111")
 '(main-line-separator-style 'chamfer)
 '(markdown-hide-urls t)
 '(mastodon-instance-url "https://maly.io")
 '(message-auto-save-directory "~/mail/drafts")
 '(message-kill-buffer-on-exit t)
 '(message-mode-hook nil)
 '(message-send-mail-function 'message-send-mail-with-sendmail)
 '(message-sendmail-envelope-from 'header)
 '(message-sendmail-f-is-evil nil)
 '(mm-html-inhibit-images t)
 '(mm-sign-option nil)
 '(mm-text-html-renderer 'shr)
 '(mml-secure-key-preferences
   '((OpenPGP
      (sign
       ("jb55@jb55.com" "5B2B1E4F62216BC74362AC61D4FBA2FC4535A2A9"))
      (encrypt
       ("jb55@jb55.com" "5B2B1E4F62216BC74362AC61D4FBA2FC4535A2A9")))
     (CMS
      (sign)
      (encrypt))))
 '(mml-secure-openpgp-encrypt-to-self
   '("8860420C3C135662EABEADF96342E010C44A6337" "87D78CE40B38B817" "5B2B1E4F62216BC74362AC61D4FBA2FC4535A2A9"))
 '(nil nil t)
 '(notmuch-command "notmuch")
 '(notmuch-fcc-dirs ".Sent +sent -inbox -unread")
 '(notmuch-hello-tag-list-make-query "tag:inbox")
 '(notmuch-message-headers-visible t)
 '(notmuch-saved-searches
   '((:name "flagged" :query "tag:flagged and tag:inbox" :key "f")
     (:name "lightning" :query "tag:inbox and tag:lightning" :key "k" :sort-order newest-first)
     (:name "bitcoin" :query "tag:core and tag:inbox and subject:bitcoin/bitcoin" :key "b" :sort-order subject-ascending)
     (:name "best" :query "tag:best and tag:inbox" :key "B" :sort-order newest-first)
     (:name "inbox" :query "tag:inbox and not tag:filed and not tag:noise" :key "i" :sort-order newest-first)
     (:name "nixpkgs" :query "tag:nixpkgs and tag:inbox" :key "n" :sort-order subject-ascending)
     (:name "notmuch" :query "tag:notmuch and tag:inbox" :key "N" :sort-order newest-first)
     (:name "list" :query "tag:list and not tag:github and tag:inbox and not tag:busy" :key "l" :sort-order subject-ascending)
     (:name "github" :query "tag:github and not tag:busy and tag:inbox" :key "g" :sort-order subject-ascending)
     (:name "today" :query "date:today and tag:inbox" :key "1")
     (:name "rss" :query "tag:rss and tag:inbox and not tag:busy" :key "r" :sort-order from-ascending)
     (:name "rss-busy" :query "tag:rss and tag:inbox and tag:busy" :key "R" :sort-order from-ascending)
     (:name "2-day" :query "date:yesterday.. and tag:inbox" :key "2")
     (:name "work" :query "tag:inbox and tag:work" :key "w" :sort-order subject-ascending)))
 '(notmuch-search-line-faces
   '(("unread" . notmuch-search-unread-face)
     ("flagged" . notmuch-search-flagged-face)))
 '(notmuch-search-oldest-first nil)
 '(notmuch-search-sort-order 'newest-first)
 '(notmuch-show-all-tags-list t)
 '(notmuch-show-insert-text/plain-hook
   '(notmuch-wash-convert-inline-patch-to-part notmuch-wash-wrap-long-lines notmuch-wash-tidy-citations notmuch-wash-elide-blank-lines notmuch-wash-excerpt-citations))
 '(notmuch-tag-formats
   '(("unread" "?"
      (propertize tag 'face 'notmuch-tag-unread))
     ("flagged"
      #("*" 0 1
        (face
         ((:foreground "gold")
          (:foreground "gold")
          (:foreground "gold")
          (:foreground "gold")
          (:foreground "gold")
          (:foreground "gold")
          (:foreground "gold")
          (:foreground "gold")
          (:foreground "gold")
          (:foreground "gold")
          (:foreground "gold")
          (:foreground "gold")
          (:foreground "gold")
          (:foreground "gold")
          (:foreground "gold")
          (:foreground "gold")
          (:foreground "gold")
          (:foreground "gold")
          (:foreground "gold")
          (:foreground "gold"))))
      (notmuch-apply-face tag
                          '(:foreground "gold")))
     ("pr"
      (notmuch-apply-face tag
                          '(:foreground "green")))
     ("issue"
      (notmuch-apply-face tag
                          '(:foreground "orange")))
     ("filed"
      #("f" 0 1
        (face
         ((:foreground "dim gray")
          (:foreground "dim gray"))))
      (notmuch-apply-face tag
                          '(:foreground "dim gray")))
     ("list")
     ("github"
      #("gh" 0 2
        (face
         ((:foreground "dim gray")
          (:foreground "dim gray"))))
      (notmuch-apply-face tag
                          '(:foreground "dim gray")))
     ("inbox"
      #("i" 0 1
        (face
         ((:foreground "white")
          (:foreground "white"))))
      (notmuch-apply-face tag
                          '(:foreground "white")))
     ("closed"
      (notmuch-apply-face tag
                          '(:foreground "wheat")))
     ("merged"
      (notmuch-apply-face tag
                          '(:foreground "yellow")))
     ("bot"
      (notmuch-apply-face tag
                          '(:foreground "dim gray")))
     ("busy"
      #("b" 0 1
        (face
         ((:foreground "brown")
          (:foreground "brown"))))
      (notmuch-apply-face tag
                          '(:foreground "brown")))
     ("bitcoin"
      #("btc" 0 3
        (face
         ((:foreground "gold")
          (:foreground "gold"))))
      (notmuch-apply-face tag
                          '(:foreground "gold")))))
 '(notmuch-wash-wrap-lines-length 100)
 '(olivetti-body-width 100 t)
 '(org-adapt-indentation nil)
 '(org-agenda-current-time-string
   #("=========================== NOW ===========================" 0 59
     (org-heading t)))
 '(org-agenda-files
   '("~/src/c/polyadvent/todo.org" "/home/jb55/docs/org/projects.org" "/home/jb55/docs/org/tasks.org" "/home/jb55/projects/razorcx/doc/org/todo.org"))
 '(org-agenda-time-grid
   '((daily today require-timed)
     ""
     (800 1000 1200 1400 1600 1800 2000)))
 '(org-archive-location "archive/%s_archive::")
 '(org-directory "~/docs/org")
 '(org-duration-format '((special . h:mm)))
 '(org-export-headline-levels 2)
 '(org-export-with-section-numbers nil)
 '(org-export-with-toc nil)
 '(org-format-latex-options
   '(:foreground default :background default :scale 2.0 :html-foreground "Black" :html-background "Transparent" :html-scale 1.0 :matchers
                 ("begin" "$1" "$" "$$" "\\(" "\\[")))
 '(org-html-head-include-default-style nil)
 '(org-html-head-include-scripts nil)
 '(org-html-postamble nil)
 '(org-refile-targets '((org-agenda-files :maxlevel . 1)))
 '(org-trello-current-prefix-keybinding "C-c o" nil (org-trello))
 '(org-use-sub-superscripts '{})
 '(package-selected-packages
   '(envrc org-kanban lsp-pyright tracking treemacs-projectile spaceline rjsx-mode prettier-js gntp org-cliplink meson-mode lsp-haskell hierarchy json-snatcher json-reformat js2-mode window-purpose imenu-list epc ctable concurrent prop-menu htmlize parent-mode haml-mode project eldoc xref emacsql-sqlite flx evil-textobj-line evil-ledger evil-ediff elm-test-runner lcr csharp-mode counsel swiper ivy deferred web-completion-data rtags company-quickhelp pos-tip nixos-options lua-mode irony go-mode anaconda-mode pythonic company lsp-mode spinner ht dash-functional markdown-mode rust-mode blacken yasnippet packed auctex flycheck f s pkg-info epl avy auto-complete popup org-plus-contrib hydra lv evil bind-map bind-key notmuch neuron-mode projectile haskell-mode reformatter helm helm-core iedit paredit goto-chg undo-tree anzu smartparens magit git-commit async with-editor transient ghub treepy emacsql multiple-cursors skewer-mode simple-httpd treemacs magit-popup sml-mode alert log4e org-category-capture purescript-mode test-simple loc-changes load-relative powerline all-the-icons memoize pfuture visual-fill-column treemacs-persp treemacs-icons-dired ron-mode org-superstar magit-section dash lsp-ivy flycheck-elsa emr list-utils graphql-mode swift-mode company-tabnine unicode-escape names lsp-ui lsp-treemacs lsp-python-ms cquery company-lsp ccls github-search github-clone git-gutter-fringe+ git-gutter-fringe fringe-helper gist gh marshal logito confluence git-gutter+ git-gutter pcache diff-hl xml-rpc browse-at-remote direnv writeroom-mode treemacs-evil typescript-mode symbol-overlay realgud olivetti eglot flymake jsonrpc forge closql flycheck-package package-lint let-alist auctex-latexmk github-review treemacs-magit nodejs-repl flycheck-ycmd devdocs cpp-auto-include company-ycmd ycmd request-deferred company-reftex attrap hybrid-mode elpher protobuf-mode ini-mode vi-tilde-fringe org-bullets helm-xref helm-themes helm-swoop helm-purpose helm-projectile helm-mode-manager helm-flx helm-descbinds helm-ag ace-jump-helm-line yasnippet-snippets yapfify yaml-mode ws-butler winum which-key wgrep weechat web-mode web-beautify w3m volatile-highlights uuidgen use-package twittering-mode toml-mode toc-org tide tagedit symon string-inflection sql-indent spotify spaceline-all-the-icons smex smeargle slim-mode shen-mode shen-elisp scss-mode sass-mode restart-emacs request rainbow-delimiters racket-mode racer pyvenv pytest pyenv-mode py-isort pug-mode psci psc-ide powershell popwin pippel pipenv pip-requirements persp-mode pcre2el password-generator paradox overseer orgit org-projectile org-present org-pomodoro org-mime org-download org-clock-csv org-brain open-junk-file omnisharp ob-sml nix-mode neotree nameless mvn move-text mmm-mode meghanada maven-test-mode mastodon markdown-toc magit-svn magit-gitflow macrostep lorem-ipsum livid-mode live-py-mode link-hint ledger-mode json-navigator json-mode js2-refactor js-doc jade-mode ivy-yasnippet ivy-xref ivy-rtags ivy-purpose ivy-hydra intero insert-shebang indent-guide importmagic impatient-mode idris-mode hungry-delete hlint-refactor hl-todo hindent highlight-parentheses highlight-numbers highlight-indentation helm-pages helm-make haskell-snippets groovy-mode groovy-imports graphviz-dot-mode gradle-mode google-translate google-c-style golden-ratio godoctor go-tag go-rename go-impl go-guru go-gen-test go-fill-struct go-eldoc gnuplot gnu-apl-mode glsl-mode gitignore-templates gitignore-mode gitconfig-mode gitattributes-mode git-timemachine git-messenger git-link gh-md ggtags fuzzy fsharp-mode font-lock+ flycheck-rust flycheck-rtags flycheck-pos-tip flycheck-ledger flycheck-haskell flycheck-elm flycheck-bashate flx-ido fish-mode fill-column-indicator fancy-battery eyebrowse expand-region evil-visualstar evil-visual-mark-mode evil-unimpaired evil-tutor evil-surround evil-org evil-numbers evil-nerd-commenter evil-mc evil-matchit evil-magit evil-lisp-state evil-lion evil-indent-plus evil-iedit-state evil-goggles evil-exchange evil-escape evil-cleverparens evil-args evil-anzu eval-sexp-fu ereader ensime emojify emoji-cheat-sheet-plus emmet-mode elm-mode elisp-slime-nav editorconfig dumb-jump dotenv-mode disaster diminish define-word dante cython-mode csv-mode counsel-projectile counsel-notmuch counsel-gtags counsel-css company-web company-tern company-statistics company-shell company-rtags company-nixos-options company-lua company-irony company-go company-ghci company-ghc company-emoji company-emacs-eclim company-cabal company-c-headers company-auctex company-anaconda column-enforce-mode cmm-mode clean-aindent-mode clang-format centered-cursor-mode cargo bison-mode base16-theme auto-yasnippet auto-highlight-symbol auto-compile aggressive-indent ace-window ace-link ac-ispell))
 '(pdf-view-midnight-colors '("#655370" . "#fbf8ef"))
 '(powerline-color1 "#1E1E1E")
 '(powerline-color2 "#111111")
 '(projectile-globally-ignored-directories
   '(".idea" ".eunit" ".git" ".hg" ".fslckout" ".bzr" "_darcs" ".tox" ".svn" "build" "node_modules"))
 '(projectile-mode-line 'Projectile t)
 '(psc-ide-add-import-on-completion t t)
 '(psc-ide-rebuild-on-save nil t)
 '(python-indent-offset 4)
 '(racer-cmd "racer")
 '(racer-command-timeout 0.2)
 '(racer-eldoc-timeout 0.2)
 '(racer-rust-src-path nil)
 '(rainbow-identifiers-cie-l*a*b*-lightness 80)
 '(rainbow-identifiers-cie-l*a*b*-saturation 18)
 '(rcirc-buffer-maximum-lines 10000)
 '(ring-bell-function 'ignore)
 '(rng-nxml-auto-validate-flag nil)
 '(rust-indent-offset 4)
 '(safe-local-variable-values
   '((js-indent-level . 8)
     (python-backend . lsp)
     (indicate-empty-lines . t)
     (indent-tabs-mode . f)
     (flycheck-clang-include-path "./include" "../include")))
 '(send-mail-function 'smtpmail-send-it)
 '(sendmail-program "sendmail")
 '(smartrep-mode-line-active-bg (solarized-color-blend "#859900" "#eee8d5" 0.2))
 '(smerge-command-prefix "m")
 '(smtpmail-smtp-server "smtp.jb55.com")
 '(smtpmail-smtp-service 587)
 '(sql-port 5432)
 '(standard-indent 4)
 '(url-handler-mode nil)
 '(user-full-name "William Casarin")
 '(user-mail-address "jb55@jb55.com")
 '(vc-follow-symlinks t)
 '(w3m-default-display-inline-images nil)
 '(weechat-auto-monitor-buffers
   '("monstercat.#general" "monstercat.#payments" "monstercat.#code"))
 '(weechat-auto-monitor-new-buffers t)
 '(weechat-modules '(weechat-button weechat-image weechat-complete))
 '(yas-snippet-dirs '("/home/jb55/.emacs.d/private/snippets/")))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(diff-refine-added ((t (:background "dark green"))))
 '(notmuch-search-non-matching-authors ((t (:foreground "#353B45"))))
 '(notmuch-search-unread-face ((t nil))))
