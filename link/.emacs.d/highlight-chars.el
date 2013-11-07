;;; highlight-chars.el --- Highlight specified sets of characters, including whitespace.
;;
;; Filename: highlight-chars.el
;; Description: Highlight specified sets of characters, including whitespace.
;; Author: Drew Adams
;; Maintainer: Drew Adams
;; Copyright (C) 2000-2013, Drew Adams, all rights reserved.
;; Created: Fri Nov 16 08:37:04 2012 (-0800)
;; Version: 0
;; Package-Requires: ()
;; Last-Updated: Sun Sep  8 12:20:31 2013 (-0700)
;;           By: dradams
;;     Update #: 210
;; URL: http://www.emacswiki.org/highlight-chars.el
;; Doc URL: http://www.emacswiki.org/ShowWhiteSpace#HighlightChars
;; Keywords: highlight, whitespace, characters, Unicode
;; Compatibility: GNU Emacs: 20.x, 21.x, 22.x, 23.x, 24.x
;;
;; Features that might be required by this library:
;;
;;   None
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;; Commentary:
;;
;;    Highlight specified sets of characters, including whitespace.
;;
;; This library provides commands and non-interactive functions for
;; highlighting the following:
;;
;; * Tab chars (command `hc-toggle-highlight-tabs').
;;
;; * Hard space (aka no-break space, aka non-breaking space) chars
;;   (command `hc-toggle-highlight-hard-spaces').
;;
;; * Hard hyphen (aka non-breaking hyphen) chars (command
;;   `hc-toggle-highlight-hard-hyphens').
;;
;; * Trailing whitespace: tabs, spaces, and hard spaces at the end of
;;   a line of text (command
;;   `hc-toggle-highlight-trailing-whitespace')
;;
;; * Any set of chars you choose (commands `hc-highlight-chars' and
;;   `hc-toggle-highlight-other-chars').  You can specify characters
;;   in four ways: (1) individually, (2) using ranges, (3) using
;;   character classes (e.g. [:digit:]), and (4) using character sets
;;   (e.g. `iso-8859-1' or `lao').
;;
;;   For `hc-toggle-highlight-other-chars', you can also specify
;;   characters (the same four ways) that are to be *excluded* from
;;   highlighting.
;;
;;   You can thus, for example, highlight all characters in character
;;   set `greek-iso8859-7' except `GREEK SMALL LETTER LAMBDA'.  Or all
;;   characters in class `[:space:]' (whitespace) except `tab'.  Or
;;   all Unicode characters in the range ?\u2190 through ?\u21ff
;;   (mathematical arrows) except ?\u21b6, ?\u21b7, ?\u21ba, and
;;   ?\u21bb (curved arrows).  You get the idea.
;;
;;   - Command `hc-highlight-chars' prompts you for the characters to
;;     highlight and the face to use.  With a prefix arg it
;;     unhighlights.
;;
;;   - Command `hc-toggle-highlight-other-chars' toggles highlighting,
;;     using face `hc-other-char', of the characters specified by user
;;     option `hc-other-chars', but excluding the characters specified
;;     by option `hc-other-chars-NOT'.  With a prefix arg it prompts
;;     you for the face to use.
;;
;;   For these particular commands and functions, option
;;   `hc-other-chars-font-lock-override' controls whether the current
;;   highlighting face overrides (`t'), is overridden by (`keep'), or
;;   merges with (`append' or `prepend') any existing highlighting.
;;
;; To use this library, add this to your init file (~/.emacs):
;;
;;      (require 'highlight-chars) ; Load this library.
;;
;; You can then use the commands and functions defined here to turn
;; the various kinds of highlighting on and off when in Font-Lock
;; mode.  For example, you can bind a key to toggle highlighting of
;; trailing whitespace:
;;
;;      (global-set-key (kbd "<f11>")
;;                      'hc-toggle-highlight-trailing-whitespace)
;;
;; Because variable `font-lock-keywords' is buffer-local, that key
;; binding lets you use `f11' to toggle highlighting separately in
;; each buffer.
;;
;; But if you want to use a particular kind of highlighting by default
;; globally, then just add the corresponding `hc-highlight-*' function
;; to the hook `font-lock-mode-hook'.  Then, whenever Font-Lock mode
;; is turned on (in any buffer), the appropriate highlighting will
;; also be turned on.
;;
;; For example, you can turn on tab highlighting everywhere by default
;; by adding function `hc-highlight-tabs' to `font-lock-mode-hook' in
;; your init file (`~/.emacs'), as follows:
;;
;;     (add-hook 'font-lock-mode-hook 'hc-highlight-tabs)
;;
;; In addition to buffer-specific highlighting and global
;; highlighting, you can turn on a given kind of highlighting
;; automatically for all buffers that are in a certain major mode.
;;
;; For that, do the following, where `THE-MODE' is the appropriate
;; mode symbol (value of variable `major-mode'), such as `text-mode'.
;; This example turns on trailing whitespace highlighting - use
;; different `hc-highlight-*' and `hc-dont-highlight-*' functions for
;; other kinds of highlighting.
;;
;;      (add-hook 'change-major-mode-hook
;;                (lambda ()
;;                  (add-hook 'font-lock-mode-hook
;;                            'hc-highlight-trailing-whitespace)))
;
;;      (add-hook 'after-change-major-mode-hook
;;                (lambda ()
;;                  (when (eq major-mode 'THE-MODE)
;;                    (remove-hook 'font-lock-mode-hook
;;                                 'hc-highlight-trailing-whitespace)
;;                    (hc-dont-highlight-trailing-whitespace)))
;;                'APPEND)
;;
;; Highlighting Different Sets of Characters in Different Buffers
;; --------------------------------------------------------------
;;
;; Especially for highlighting non-whitespace characters (commands
;; `hc-toggle-highlight-other-chars' and `hc-highlight-chars'), it can
;; sometimes be useful to highlight different characters in different
;; buffers.  For example, you might want to highlight all Chinese
;; characters in a Gnus buffer and all hexadecimal digits in a CSS or
;; HTML buffer.
;;
;; You can do this by setting the local value of option
;; `hc-other-chars' (and perhaps option `hc-other-chars-NOT') in each
;; of the buffers.  For example:
;;
;;      (with-current-buffer (current-buffer)
;;        (set (make-local-variable 'hc-other-chars)
;;             '(chinese-big5-1)))
;;
;; You can use Customize to find the Lisp value that corresponds to
;; the highlighting you want: `M-x customize-option hc-other-chars',
;; then use button `Value Menu' to choose a value, then button `State
;; to `Set for Current Session'.
;;
;; Then use `C-h v hc-other-chars' to see what the Lisp value is (for
;; example, `(chinese-big5-1)'), and plug that value into the
;; `make-local-variable' expression.
;;
;; Vanilla Emacs Highlighting of Hard Spaces and Hyphens
;; -----------------------------------------------------
;;
;; Vanilla Emacs can itself highlight hard spaces and hard hyphens,
;; and it does so whenever `nobreak-char-display' is non-nil, which it
;; is by default.  By "hard" space and hyphen I mean "no-break" or
;; non-breaking.  These are the non-ASCII Unicode characters with code
;; points 160 (#xa0) and 8209 (#x2011), respectively.
;;
;; This low-level vanilla Emacs highlighting does not use Font Lock
;; mode, and it cannot highlight only one of these characters and not
;; the other.
;;
;; Using `highlight-chars.el' to highlight hard space and hyphen chars
;; requires turning off their default highlighting provided by vanilla
;; Emacs, that is, setting `nobreak-char-display' to nil.  This is
;; done automatically by the functions defined here.  When you turn
;; off this font-lock highlighting, the vanilla Emacs highlighting is
;; automatically restored.
;;
;; That is, the value of variable `nobreak-char-display' is reset to
;; its original value when `highlight-chars.el' was loaded (`t' is the
;; default value, so if you didn't change it prior to loading
;; `highlight-chars.el' then t is restored).
;;
;; NOTE: If you byte-compile this file in an older version of Emacs
;; (prior to Emacs 23) then the code for highlighting hard hyphens and
;; hard spaces will not work, even in Emacs 23+.  If you use Emacs 23+
;; then you should either byte-compile it using Emacs 23+ or evaluate
;; the source code that defines functions that highlight such
;; characters.  (This is because older Emacs versions interpret
;; [\u2011] as just [u2011], etc.)
;;
;;
;; See Also:
;;
;; * Library `highlight.el' for ways to highlight text more generally,
;;   not just specific characters.  It is available here:
;;   http://www.emacswiki.org/cgi-bin/wiki/highlight.el     (code)
;;   http://www.emacswiki.org/cgi-bin/wiki/HighlightLibrary (doc)
;;
;; * Standard library `whitespace.el' for other ways to highlight
;;   whitespace characters.
;;
;;   This does some things similar to what `highlight-chars.el' does,
;;   plus other, unrelated things.  As its name suggests, its effects
;;   are limited to whitespace characters.  It is also somewhat
;;   complicated to use (10 faces, 24 options!), and it seems to have
;;   more than a few bugs.
;;
;;   Besides being simpler, I think that `highlight-chars.el' has an
;;   advantage of letting you easily highlight ONLY particular
;;   whitespace characters.  `whitespace.el' apparently makes you pick
;;   whether to highlight spaces and hard spaces together, or not, for
;;   instance.
;;
;;   (As a workaround, With `whitespace.el' you can get the effect of
;;   highlighting only one of these kinds of space by customizing the
;;   face used to highlight the other one so that it is the same as
;;   the `default' face.  But that will interfere with other font-lock
;;   highlighting of that other character.  Maybe I'm missing
;;   something, this seems to me the only workaround.)
;;
;;
;; Faces defined here:
;;
;;    `hc-hard-hyphen' (Emacs 23+), `hc-hard-space', `hc-other-char',
;;    `hc-tab', `hc-trailing-whitespace'.
;;
;; User options defined here:
;;
;;    `hc-other-chars', `hc-other-chars-font-lock-override',
;;    `hc-other-chars-NOT'.
;;
;; Commands defined here:
;;
;;    `toggle-highlight-hard-hyphens' (alias, Emacs 23+),
;;    `toggle-highlight-hard-spaces' (alias),
;;    `toggle-highlight-other-chars', `toggle-highlight-tabs' (alias),
;;    `toggle-highlight-trailing-whitespace' (alias),
;;    `hc-highlight-chars', `hc-toggle-highlight-hard-hyphens' (Emacs
;;    23+), `hc-toggle-highlight-hard-spaces',
;;    `hc-toggle-highlight-other-chars', `hc-toggle-highlight-tabs',
;;    `hc-toggle-highlight-trailing-whitespace'.
;;
;; Non-interactive functions defined here:
;;
;;    `hc-dont-highlight-hard-hyphens' (Emacs 23+),
;;    `hc-dont-highlight-hard-spaces',
;;    `hc-dont-highlight-other-chars', `hc-dont-highlight-tabs',
;;    `hc-dont-highlight-trailing-whitespace',
;;    `hc-highlight-hard-hyphens' (Emacs 23+),
;;    `hc-highlight-other-chars', `hc-highlight-hard-spaces',
;;    `hc-highlight-tabs', `hc-highlight-trailing-whitespace',
;;    `hc-other-chars-defcustom-spec', `hc-other-chars-description',
;;    `hc-other-chars-font-lock-spec', `hc-other-chars-matcher'.
;;
;; Internal variables defined here:
;;
;;    `hc-highlight-hard-hyphens-p', `hc-highlight-hard-spaces-p',
;;    `hc-highlight-tabs-p', `hc-highlight-trailing-whitespace-p',
;;    `hc--other-chars-last-match-data',
;;    `hc--saved-nobreak-char-display'.
;;
;;
;; History:
;;
;; Peter Steiner, <unistein@isbe.ch>, wrote `hilite-trail.el', which
;; included some whitespace character-highlighting commands.  Since
;; 2000 I have extended those and added other character-highlighting
;; functions, in `show-wspace.el'.  I eventually (2012) renamed
;; `show-wspace.el' to `highlight-chars.el'.  Highlighting whitespace
;; and other easily confused characters remains an important use case,
;; however.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;; Change Log:
;;
;; 2012/11/18 dadams
;;     hc-other-chars(-NOT): Added :set to reset the match-data cache.
;;     hc-other-chars-matcher: Allow nil values for options hc-other-chars(-NOT):
;;       Use fake match-data if hc-chars-other is empty.  Set match-data from
;;       hc-other-chars search if hc-other-chars-NOT is empty.  Reset match-data cache,
;;       hc--other-chars-last-match-data, if hc-chars-other search fails.
;;     Added autoload cookies for hc-other-chars(-NOT).  Removed cookie from a defvar.
;; 2012/11/17 dadams
;;     hc-other-chars-matcher: Corrected for empty chars-NOT, i.e. regexp-out = \\(\\).
;; 2012/11/16 dadams
;;     Renamed this library from show-wspace.el to highlight-chars.el.
;;     Added: hc-other-chars-NOT, hc-other-chars-description, hc-other-chars-matcher,
;;            hc--other-chars-last-match-data.
;;     Renamed: Prefix change: ws- to hc-.
;;              Show-Whitespace to Highlight-Characters (defgroup).
;;     hc-toggle-highlight-other-chars:
;;       Use hc-other-chars-description.  Account for hc-other-chars-NOT.  Added arg FACE.
;;     , hc-highlight-chars: Use hc-other-chars-description.
;;     hc-other-chars-font-lock-spec:
;;       Added optional arg CHARS-NOT.  Handle it.  Use hc-other-chars-matcher.
;;     All calls to hc-other-chars-font-lock-spec: Pass a value for arg  CHARS-NOT.
;; 2012/11/15 dadams
;;    ws-other-chars-font-lock-spec:
;;      Use one font-lcck spec for all, instead of one for each.
;;      Removed +'s.
;; 2012/11/13 dadams
;;     ws-highlight-hard-hyphens-p, ws--saved-nobreak-char-display:
;;       Define for all versions, so can use in tests.
;;     ws(-dont)-highlight-(hard-spaces|trailing-whitespace):
;;       Handle \u00a0 and \240 separately for diff versions.
;;     ws-highlight-(hard-(hyphens|spaces)|trailing-whitespace):
;;       Set nobreak-char-display to nil always.
;;     ws-dont-highlight-(hard-(hyphens|spaces)|trailing-whitespace):
;;       Reset nobreak-char-display only if not needed to be nil otherwise.
;;     ws(-dont)-highlight-other-chars: Do not set/reset nobreak-char-display.
;;     Everywhere: mention \u00a0, not just \240.
;; 2012/07/29 dadams
;;     ws-other-chars-defcustom-spec, ws-highlight-chars, ws-other-chars-font-lock-spec,
;;       ws-toggle-highlight-other-chars:
;;         Handle charsets too now.
;;     ws-other-chars-font-lock-spec: Use regexp-opt-charset for range, for Emacs 22+.
;; 2012/07/28 dadams
;;     Added: ws-highlight-chars, ws-other-chars-font-lock-override.
;;     ws(-dont)-highlight-other-chars, ws-other-chars-font-lock-spec:
;;       Added optional args CHARS and FACE.
;;     ws-other-chars-font-lock-spec: Use ws-other-chars-font-lock-override.
;; 2012/07/26 dadams
;;     Changed prefix from show-ws- to just ws-.  Removed suffix -show-ws from toggle-*.
;;     Added: *-hard-hyphen*, *-other(s)*, ws--saved*.  Renamed *-show* to *-highlight*.
;;     Use 'APPEND with font-lock-add-keywords, so not overridden by other font-locking.
;;     Added note to hard-space functions and vars about Emacs bug #12054.
;;     Factored out font-lock :group to the defgroup.
;;     Added optional MSGP arg for commands - no msg otherwise.
;; 2011/01/04 dadams
;;     Added autoload cookies for defgroup and defface.
;; 2009/06/25 dadams
;;     show-ws-dont-*: Should be no-op's for Emacs 20, 21.
;; 2009/06/17 dadams
;;     Added: show-ws-dont-highlight-*.
;;     show-ws-toggle-show-*: Remove the font-lock keywords. Needed for Emacs 22+.
;; 2007/09/25 dadams
;;     Renamed to use prefix show-ws-.  Thx to Cyril Brulebois.
;; 2006/11/11 dadams
;;     Corrected doc strings.  Clarified: hard space is non-breaking space, ?\240.
;;     Included hard space in highlight-trailing-whitespace.
;; 2006/04/06 dadams
;;     highlight-*: Use font-lock-add-keywords.  Thanks to Karl Chen.
;; 2006/02/20 dadams
;;     Mentioned in Commentary how to use non-interactively.
;; 2006/01/07 dadams
;;     Added :link for sending bug report.
;; 2006/01/06 dadams
;;     Added defgroup and use it.
;; 2005/12/30 dadams
;;     Removed require of def-face-const.el.
;;     Renamed faces, without "-face".
;; 2005/01/25 dadams
;;     Removed ###autoload for defvars.
;; 2004/06/10 dadams
;;     Fixed minor bug in highlight-* functions.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License as
;; published by the Free Software Foundation; either version 3, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 51 Franklin Street, Fifth
;; Floor, Boston, MA 02110-1301, USA.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;; Code:

;;;;;;;;;;;;;;;;;;;;;;;;;


;; Quiet the byte compiler.

(defvar nobreak-char-display)

;;;;;;;;;;;;;;;;;;;;;;;;;

;;;###autoload
(defgroup Highlight-Characters nil
  "Highlight specified sets of characters, possibly including whitespace."
  :prefix "hc-"
  :group 'convenience :group 'matching :group 'font-lock
  :link `(url-link :tag "Send Bug Report"
          ,(concat "mailto:" "drew.adams" "@" "oracle" ".com?subject=\
highlight-chars.el bug: \
&body=Describe bug here, starting with `emacs -q'.  \
Don't forget to mention your Emacs and library versions."))
  :link '(url-link :tag "Other Libraries by Drew"
          "http://www.emacswiki.org/DrewsElispLibraries")
  :link '(url-link :tag "Download"
          "http://www.emacswiki.org/highlight-chars.el")
  :link '(url-link :tag "Description"
          "http://www.emacswiki.org/ShowWhiteSpace#HighlightChars")
  :link '(emacs-commentary-link :tag "Commentary" "highlight-chars")
  )

;;;###autoload
(defface hc-tab '((t (:background "LemonChiffon")))
  "*Face for highlighting tab characters (`C-i') in Font-Lock mode."
  :group 'Highlight-Characters :group 'faces)

;;;###autoload
(defface hc-trailing-whitespace '((t (:background "Gold")))
  "*Face for highlighting whitespace at line ends in Font-Lock mode.
This includes tab, space, and hard (non-breaking) space characters."
  :group 'Highlight-Characters :group 'faces)

;;;###autoload
(defface hc-hard-space '((t (:background "Aquamarine")))
  "*Face for highlighting non-breaking spaces (`?\u00a0')in Font-Lock mode.
\(This is also ?\240.)"
  :group 'Highlight-Characters :group 'faces)

(when (> emacs-major-version 22)
  (defface hc-hard-hyphen '((t (:background "PaleGreen")))
    "*Face for highlighting non-breaking hyphens (`?\u2011')in Font-Lock mode."
    :group 'Highlight-Characters :group 'faces))

;;;###autoload
(defface hc-other-char '((t (:background "HotPink")))
  "*Face for highlighting chars in `hc-other-chars' in Font-Lock mode."
  :group 'Highlight-Characters :group 'faces)

(defun hc-other-chars-defcustom-spec ()
  "Custom :type spec for `hc-other-chars' and `hc-other-chars-NOT'."
  (if (> emacs-major-version 21)
      `(repeat
        (choice
         (string :tag "Characters (string)")
         (choice :tag "Character set" ,@(mapcar (lambda (cset) `(const ,cset))
                                                (if (fboundp 'charset-priority-list)
                                                    (charset-priority-list)
                                                  charset-list)))
         (cons   :tag "Character range" (character :tag "From") (character :tag "To"))
         (choice :tag "Character class"
          (const   :tag "ASCII char\t[:ascii:]"                        [:ascii:])
          (const   :tag "Non-ASCII char\t[:nonascii:]"                 [:nonascii:])
          (const   :tag "Word char\t[:word:]"                          [:word:])
          (const   :tag "Letter or digit\t[:alnum:]"                   [:alnum:])
          (const   :tag "Letter\t[:alpha:]"                            [:alpha:])
          (const   :tag "Lowercase letter\t[:lower:]"                  [:lower:])
          (const   :tag "Uppercase letter\t[:upper:]"                  [:upper:])
          (const   :tag "Digit\t[:digit:]"                             [:digit:])
          (const   :tag "Hex digit\t[:xdigit:]"                        [:xdigit:])
          (const   :tag "Punctuation char (non-word char)\t[:punct:]"  [:punct:])
          (const   :tag "Space or tab char\t[:blank:]"                 [:blank:])
          (const   :tag "Whitespace char\t[:space:]"                   [:space:])
          (const   :tag "Control char\t[:cntrl:]"                      [:cntrl:])
          (const   :tag "Not control or delete char\t[:print:]"        [:print:])
          (const   :tag "Not control, space or delete char\t[:graph:]" [:graph:])
          (const   :tag "Multibyte char\t[:multibyte:]"                [:multibyte:])
          (const   :tag "Unibyte char\t[:unibyte:]"                    [:unibyte:]))))
    '(repeat
      (choice
       (string :tag "Characters (string)")
       (cons :tag "Character range" (character :tag "From") (character :tag "To"))))))

;;;###autoload
(defcustom hc-other-chars ()
  "*Characters to highlight using face `hc-other-char'.
The characters are highlighted unless they are excluded by option
`hc-other-chars-NOT'.

A nil value means highlight *all* characters (except those excluded by
`hc-other-chars-NOT').

If non-nil, the value is a list of entries, each of which can be any
of these:
 * a string of individual characters
 * a character range, represented as a cons (FROM . TO),
   where FROM and TO are both included
 * a character class, such as [:nonascii:]
 * a character set, such as `iso-8859-1' or `lao'

The last two alternatives are available only for Emacs 22 and later.

For the first alternative, remember that you can insert any character
into the string using `C-q', and (for Emacs 23 and later) you can
insert any Unicode character using `C-x 8 RET'.

For Emacs 20, the first alternative is not well supported: Do not use
chars that are special within a regexp character alternative (i.e.,
\[...]).  In Emacs 20, the string you specify is simply wrapped with
\[...], which is not correct for all chars."
  :set (lambda (sym defs)
         (custom-set-default sym defs)
         (setq hc--saved-nobreak-char-display  nil)) ; Reset cached match-data.
  :type (hc-other-chars-defcustom-spec) :group 'Highlight-Characters)

;;;###autoload
(defcustom hc-other-chars-NOT ()
  "*Chars to exclude from highlighting with face `hc-other-char'.
The possible option values are the same as for `hc-other-char'."
  :set (lambda (sym defs)
         (custom-set-default sym defs)
         (setq hc--saved-nobreak-char-display  nil)) ; Reset cached match-data.
  :type (hc-other-chars-defcustom-spec) :group 'Highlight-Characters)

;;;###autoload
(defcustom hc-other-chars-font-lock-override 'append
  "*How highlighting for other chars interacts with existing highlighting.
The values correspond to the values for an OVERRIDE spec in
`font-lock-keywords'.  See (elisp) `Search-based Fontification'.

This affects commands `hc-toggle-highlight-other-chars' and
 `hc-highlight-chars', and functions `hc-highlight-other-chars' and
 `hc-dont-highlight-other-chars'."
  :type '(choice
          (const :tag "Do not override existing highlighting (`keep')" keep)
          (const :tag "Merge after existing highlighting (`append')"   append)
          (const :tag "Merge before existing highlighting (`prepend')" prepend)
          (const :tag "Replace (override) existing highlighting"       t))
  :group 'Highlight-Characters)

(defvar hc-highlight-tabs-p nil
  "Non-nil means font-lock mode highlights TAB characters (`C-i').")

(defvar hc-highlight-trailing-whitespace-p nil
  "Non-nil means font-lock mode highlights whitespace at line ends.
This includes tab, space, and hard (non-breaking) space characters.")

(defvar hc-highlight-hard-spaces-p nil
  "Non-nil means font-lock mode highlights non-breaking spaces (`?\u00a0').
\(This is also ?\240.)")

(defvar hc-highlight-hard-hyphens-p nil
  "Non-nil means font-lock mode highlights non-breaking hyphens (`?\u2011').")

(defvar hc-highlight-other-chars-p nil
  "Non-nil means font-lock mode highlights the chars in `hc-other-chars'.")

(defvar hc--other-chars-last-match-data nil
  "Last successful match data for `hc-other-chars'.
Used to restore match data after matching a character to exclude.")

(defvar hc--saved-nobreak-char-display (and (boundp 'nobreak-char-display)
                                            nobreak-char-display)
  "Saved value of `nobreak-char-display', so that it can be restored.")

;;;###autoload
(defalias 'toggle-highlight-tabs 'hc-toggle-highlight-tabs)
;;;###autoload
(defun hc-toggle-highlight-tabs (&optional msgp)
  "Toggle highlighting of TABs, using face `hc-tab'."
  (interactive "p")
  (setq hc-highlight-tabs-p  (not hc-highlight-tabs-p))
  (if hc-highlight-tabs-p
      (add-hook 'font-lock-mode-hook 'hc-highlight-tabs)
    (remove-hook 'font-lock-mode-hook 'hc-highlight-tabs)
    (hc-dont-highlight-tabs))
  (font-lock-mode) (font-lock-mode)
  (when msgp
    (message "TAB highlighting is now %s" (if hc-highlight-tabs-p "ON" "OFF"))))

;;;###autoload
(defalias 'toggle-highlight-hard-spaces 'hc-toggle-highlight-hard-spaces)
;;;###autoload
(defun hc-toggle-highlight-hard-spaces (&optional msgp)
  "Toggle highlighting of non-breaking space characters (`?\u00a0').
\(This is also ?\240.)
Uses face `hc-hard-space'."
  (interactive "p")
  (setq hc-highlight-hard-spaces-p  (not hc-highlight-hard-spaces-p))
  (cond (hc-highlight-hard-spaces-p
         (add-hook 'font-lock-mode-hook 'hc-highlight-hard-spaces))
        (t
         (remove-hook 'font-lock-mode-hook 'hc-highlight-hard-spaces)
         (hc-dont-highlight-hard-spaces)))
  (font-lock-mode) (font-lock-mode)
  (when msgp (message "Hard (non-breaking) space highlighting is now %s"
                      (if hc-highlight-hard-spaces-p "ON" "OFF"))))

(when (> emacs-major-version 22)
  (defalias 'toggle-highlight-hard-hyphens 'hc-toggle-highlight-hard-hyphens)
  (defun hc-toggle-highlight-hard-hyphens (&optional msgp)
    "Toggle highlighting of non-breaking hyphen characters (`?\u2011').
Uses face `hc-hyphen-space'."
    (interactive "p")
    (setq hc-highlight-hard-hyphens-p  (not hc-highlight-hard-hyphens-p))
    (cond (hc-highlight-hard-hyphens-p
           (add-hook 'font-lock-mode-hook 'hc-highlight-hard-hyphens))
          (t
           (remove-hook 'font-lock-mode-hook 'hc-highlight-hard-hyphens)
           (hc-dont-highlight-hard-hyphens)))
    (font-lock-mode) (font-lock-mode)
    (when msgp (message "Hard (non-breaking) hyphen highlighting is now %s"
                        (if hc-highlight-hard-hyphens-p "ON" "OFF")))))

;;;###autoload
(defun hc-highlight-chars (chars face &optional offp msgp)
  "Read a string of CHARS, read a FACE name, then highlight the CHARS.
With a prefix arg, unhighlight the CHARS.

As an alternative to being a string of characters, CHARS can be any of
the following (the last two are only for Emacs 22+):

* A cons (C1 . C2), where C1 and C2 are characters, that is, integers,
  which you can represent using character notation.  This represents
  the range of characters from C1 through C2.

  For example, you would enter `(?a . ?g)' to mean the characters from
  `a' through `g', inclusive.  Note that you enter the parentheses and
  the dot, and you can use character read syntax (e.g., `?a' for `a').

* A character class, such as `[:digit:]'.  This matches all characters
  in the class.  You must type the brackets and colons (`:').  (This
  possibility is available only for Emacs 22 and later.)

* A character set, such as `iso-8859-1' or `lao'.  This matches all
  characters in the set.

If you mistype CHARS in one of the above representations, then what
you type is interpreted as just a string of the characters to
highlight.  For example, if you mean to type `[:digit:]' but you
instead type `[:digit]' (no second colon), then the characters
highlighted are [, :, d, g, i, t, and ]."
  (interactive
   (let* ((prompt  (format "Chars to %shighlight: " (if current-prefix-arg "UN" "")))
          (chrs    (read-string prompt))
          (chrs    (progn (while (string= "" chrs)
                            (setq chrs  (read-string (concat (substring prompt 0 -2)
                                                             " (not empty): "))))
                          chrs))
          (fac     (read-face-name "Face")))
     (when (string= "" fac)  (setq fac  'hc-other-chars))
     (list (let ((cs  (condition-case nil  (read chrs)  (error nil))))
             (cond ((and (fboundp 'charsetp)  (charsetp cs)) ; Charset
                    (list cs))
                   ((and (consp cs)     ; Char range: (ch1 . ch2)
                         (if (fboundp 'characterp) (characterp (car cs)) (integerp (car cs)))
                         (if (fboundp 'characterp) (characterp (cdr cs)) (integerp (cdr cs))))
                    (list cs))
                   ((and (> emacs-major-version 21) ; Char class
                         (vectorp cs)  (= 1 (length cs))  (keywordp (aref cs 0))
                         (let ((name  (symbol-name (aref cs 0))))
                           (eq ?: (aref name (1- (length name))))))
                    (list cs))
                   (t (list chrs))))    ; Separate chars
           fac
           current-prefix-arg
           t)))
  (if (not offp)
      (add-hook 'font-lock-mode-hook
                `(lambda () (hc-highlight-other-chars ',chars nil ',face))
                'APPEND)
    (remove-hook 'font-lock-mode-hook
                 `(lambda () (hc-highlight-other-chars ',chars nil ',face)))
    (hc-dont-highlight-other-chars chars nil face))
  (font-lock-mode) (font-lock-mode)
  (when msgp
    (message "Highlighting of %s with face `%s' is now %s"
             (mapconcat #'hc-other-chars-description chars ", ")
             (if (fboundp 'propertize)
                 (propertize (symbol-name face) 'face face)
               face)
             (if offp "OFF" "ON"))))

;;;###autoload
(defalias 'toggle-highlight-other-chars 'hc-toggle-highlight-other-chars)
;;;###autoload
(defun hc-toggle-highlight-other-chars (&optional face msgp)
  "Toggle highlighting chars in `hc-other-chars'
By default, face `hc-other-char' is used.
With a prefix arg you are prompted for the face to use."
  (interactive
   (progn (unless hc-other-chars (error "No chars in `hc-other-chars' to highlight"))
          (let ((fac  (and current-prefix-arg  (read-face-name "Face"))))
            (when (and fac  (string= "" fac))  (setq fac  'hc-other-chars))
            (list fac t))))
  (when (and (not hc-other-chars)  msgp)
    (error "No chars in `hc-other-chars' to highlight"))
  (setq hc-highlight-other-chars-p  (not hc-highlight-other-chars-p))
  (cond (hc-highlight-other-chars-p
         (add-hook
          'font-lock-mode-hook
          (if face
              `(lambda () (hc-highlight-other-chars hc-other-chars hc-other-chars-NOT ',face))
            'hc-highlight-other-chars)))
        (t
         (remove-hook
          'font-lock-mode-hook
          (if face
              `(lambda () (hc-highlight-other-chars hc-other-chars hc-other-chars-NOT ',face))
            'hc-highlight-other-chars))
         (if face
             (hc-dont-highlight-other-chars hc-other-chars hc-other-chars-NOT face)
           (hc-dont-highlight-other-chars))))
  (font-lock-mode) (font-lock-mode)
  (when msgp
    (message "Highlighting of %s%s%s is now %s"
             (mapconcat #'hc-other-chars-description hc-other-chars ", ")
             (if hc-other-chars-NOT
                 (format " (EXCEPT %s)" (mapconcat #'hc-other-chars-description
                                                   hc-other-chars-NOT
                                                   ", "))
               "")
             (if face
                 (format " in face `%s'" (if (fboundp 'propertize)
                                             (propertize (symbol-name face) 'face face)
                                           face))
               "")
             (if hc-highlight-other-chars-p "ON" "OFF"))))

(defun hc-other-chars-description (chars &optional face)
  "Return a desription of CHARS."
  (cond ((and (fboundp 'charsetp)  (charsetp chars)) ; Charset
         (format "charset `%s'" chars))
        ((and (consp chars)             ; Char range: (ch1 . ch2)
              (if (fboundp 'characterp) (characterp (car chars)) (integerp (car chars)))
              (if (fboundp 'characterp) (characterp (cdr chars)) (integerp (cdr chars))))
         (if (and face  (fboundp 'propertize))
             (format "%s to %s"
                     (propertize (string (car chars)) 'face face)
                     (propertize (string (cdr chars)) 'face face))
           (format "%c to %c" (car chars) (cdr chars))))
        ((vectorp chars)                ; Char class
         (format "%s" chars))
        ((stringp chars)                ; Separate chars
         (mapconcat (if (and face  (fboundp 'propertize))
                        (lambda (chr) (propertize (string chr) 'face face))
                      #'string)
                    chars
                    ", "))))

;;;###autoload
(defalias 'toggle-highlight-trailing-whitespace
    'hc-toggle-highlight-trailing-whitespace)
;;;###autoload
(defun hc-toggle-highlight-trailing-whitespace (&optional msgp)
  "Toggle highlighting of trailing whitespace.
This includes tab, space, and hard (non-breaking) space characters.
Uses face `hc-trailing-whitespace'."
  (interactive "p")
  (setq hc-highlight-trailing-whitespace-p  (not hc-highlight-trailing-whitespace-p))
  (if hc-highlight-trailing-whitespace-p
      (add-hook 'font-lock-mode-hook 'hc-highlight-trailing-whitespace)
    (remove-hook 'font-lock-mode-hook 'hc-highlight-trailing-whitespace)
    (hc-dont-highlight-trailing-whitespace))
  (font-lock-mode) (font-lock-mode)
  (when msgp (message "Trailing whitespace highlighting is now %s"
                      (if hc-highlight-trailing-whitespace-p "ON" "OFF"))))

(defun hc-highlight-tabs ()
  "Highlight tab characters (`C-i')."
  (font-lock-add-keywords nil '(("[\t]+" (0 'hc-tab t))) 'APPEND))

;; These are no-ops for Emacs 20, 21:
;; `font-lock-remove-keywords' is not defined, and we don't need to use it.
(defun hc-dont-highlight-tabs ()
  "Do not highlight tab characters (`C-i')."
  (when (fboundp 'font-lock-remove-keywords)
    (font-lock-remove-keywords nil '(("[\t]+" (0 'hc-tab t))))))

(defun hc-highlight-hard-spaces ()
  "Highlight hard (non-breaking) space characters (`?\u00a0').
\(This is also ?\240.)
This also sets `nobreak-char-display' to nil, to turn off its
low-level, vanilla highlighting."
  (when (boundp 'nobreak-char-display) (setq nobreak-char-display  nil))
  (if (> emacs-major-version 22)
      (font-lock-add-keywords nil '(("[\u00a0]+" (0 'hc-hard-space t))) 'APPEND)
    (font-lock-add-keywords nil '(("[\240]+" (0 'hc-hard-space t))) 'APPEND)))

(defun hc-dont-highlight-hard-spaces ()
  "Do not highlight hard (non-breaking) space characters (`?\u00a0').
\(This is also ?\240.)
If no other `hc-*' highlighting of hard spaces or hard hyphens is in
effect, this also restores `nobreak-char-display' to its original
value."
  (unless (or hc-highlight-trailing-whitespace-p  hc-highlight-hard-hyphens-p)
    (setq nobreak-char-display  hc--saved-nobreak-char-display))
  (when (fboundp 'font-lock-remove-keywords)
    (if (> emacs-major-version 22)
        (font-lock-remove-keywords nil '(("[\u00a0]+" (0 'hc-hard-space t))))
      (font-lock-remove-keywords nil '(("[\240]+" (0 'hc-hard-space t)))))))

(when (> emacs-major-version 22)
  (defun hc-highlight-hard-hyphens ()
    "Highlight hard (non-breaking) hyphen characters (`?\u2011').
This also sets `nobreak-char-display' to nil, to turn off its
low-level, vanilla highlighting."
    (when (boundp 'nobreak-char-display) (setq nobreak-char-display  nil))
    (font-lock-add-keywords nil '(("[\u2011]+" (0 'hc-hard-hyphen t))) 'APPEND)))

(when (> emacs-major-version 22)
  (defun hc-dont-highlight-hard-hyphens ()
    "Stop highlighting hard (non-breaking) hyphen characters (`?\u2011').
If no other `hc-*' highlighting of hard spaces or hard hyphens is in
effect, this also restores `nobreak-char-display' to its original
value."
    (unless (or hc-highlight-trailing-whitespace-p  hc-highlight-hard-spaces-p)
      (setq nobreak-char-display  hc--saved-nobreak-char-display))
    (when (fboundp 'font-lock-remove-keywords)
      (font-lock-remove-keywords nil '(("[\u2011]+" (0 'hc-hard-hyphen t)))))))

(defun hc-highlight-trailing-whitespace ()
  "Highlight whitespace characters at line ends.
This includes tab, space, and hard (non-breaking) space characters.
This also sets `nobreak-char-display' to nil, to turn off the
low-level, vanilla highlighting of hard spaces."
  (when (boundp 'nobreak-char-display) (setq nobreak-char-display  nil))
  (if (> emacs-major-version 22)
      (font-lock-add-keywords
       nil '(("[\u00a0\040\t]+$" (0 'hc-trailing-whitespace t))) 'APPEND)
    (font-lock-add-keywords
     nil '(("[\240\040\t]+$" (0 'hc-trailing-whitespace t))) 'APPEND)))

(defun hc-dont-highlight-trailing-whitespace ()
  "Do not highlight whitespace characters at line ends.
See also `hc-highlight-trailing-whitespace'.
If no other `hc-*' highlighting of hard spaces or hard hyphens is in
effect, this also restores `nobreak-char-display' to its original
value."
  (unless (or hc-highlight-hard-spaces-p  hc-highlight-hard-hyphens-p)
    (setq nobreak-char-display  hc--saved-nobreak-char-display))
  (when (fboundp 'font-lock-remove-keywords)
    (if (> emacs-major-version 22)
        (font-lock-remove-keywords
         nil '(("[\u00a0\040\t]+$" (0 'hc-trailing-whitespace t))))
      (font-lock-remove-keywords
       nil '(("[\240\040\t]+$" (0 'hc-trailing-whitespace t)))))))

(defun hc-highlight-other-chars (&optional chars chars-NOT face)
  "Highlight CHARS using FACE.
CHARS and CHARS-NOT are lists of character specifications acceptable
as a value of `hc-other-chars' or `hc-other-chars-NOT'.
CHARS defaults to the value of `hc-other-chars'.
CHARS-NOT defaults to the value of `hc-other-chars-NOT'.
FACE defaults to face `hc-other-char'."
  (font-lock-add-keywords
   nil (hc-other-chars-font-lock-spec chars chars-NOT face) 'APPEND))

(defun hc-dont-highlight-other-chars (&optional chars chars-NOT face)
  "Do not highlight CHARS using FACE.  That is, unhighlight any such.
CHARS, CHARS-NOT, and FACE are as for `hc-highlight-other-chars'."
  (when (fboundp 'font-lock-remove-keywords)
    (font-lock-remove-keywords
     nil (hc-other-chars-font-lock-spec chars chars-NOT face))))

(defun hc-other-chars-font-lock-spec (&optional chars chars-NOT face)
  "Font-lock spec used by `hc-highlight-other-chars'.
CHARS, CHARS-NOT, and FACE are as for `hc-highlight-other-chars'."
  (setq face         (or face  'hc-other-char)
        chars        (or chars  hc-other-chars)
        chars-NOT    (or chars-NOT  hc-other-chars-NOT))
  (let ((regexp-in  (format
                     "\\(%s\\)"
                     (mapconcat
                      #'identity
                      (mapcar (lambda (chrs)
                                (cond ((and (consp chrs) ; Char range: (ch1 . ch2)
                                            (if (fboundp 'characterp)
                                                (characterp (car chrs))
                                              (integerp (car chrs)))
                                            (if (fboundp 'characterp)
                                                (characterp (cdr chrs))
                                              (integerp (cdr chrs))))
                                       (let ((chr   (car chrs))
                                             (last  (cdr chrs)))
                                         (if (> emacs-major-version 20)
                                             (let ((chs  ()))
                                               (while (<= chr last)
                                                 (push chr chs)
                                                 (setq chr  (1+ chr)))
                                               (regexp-opt-charset (nreverse chs)))
                                           (let ((class  "["))
                                             (while (<= chr last)
                                               (setq class  (concat class (string chr))
                                                     chr    (1+ chr)))
                                             (concat class "]")))))
                                      ((and (fboundp 'charsetp)  (charsetp chrs)) ; Charset
                                       (let ((chs  ()))
                                         (map-charset-chars
                                          (lambda (range ARG)
                                            (let ((chr   (car range))
                                                  (last  (cdr range)))
                                              (while (<= chr last)
                                                (push chr chs)
                                                (setq chr  (1+ chr)))))
                                          chrs)
                                         (regexp-opt-charset (nreverse chs))))
                                      ((vectorp chrs) ; Char class
                                       (concat "[" (format "%s" chrs) "]"))
                                      ((stringp chrs) ; Separate chars
                                       (if (> emacs-major-version 20)
                                           (regexp-opt-charset (append chrs ()))
                                         ;; Emacs 20 `regexp-opt-charset' does not work.
                                         ;; Fake it.
                                         (concat "[" chrs "]")))))
                              chars)
                      "\\|")))
        (regexp-out  (format
                      "\\(%s\\)"
                      (mapconcat
                       #'identity
                       (mapcar (lambda (chrs)
                                 (cond ((and (consp chrs) ; Char range: (ch1 . ch2)
                                             (if (fboundp 'characterp)
                                                 (characterp (car chrs))
                                               (integerp (car chrs)))
                                             (if (fboundp 'characterp)
                                                 (characterp (cdr chrs))
                                               (integerp (cdr chrs))))
                                        (let ((chr   (car chrs))
                                              (last  (cdr chrs)))
                                          (if (> emacs-major-version 20)
                                              (let ((chs  ()))
                                                (while (<= chr last)
                                                  (push chr chs)
                                                  (setq chr  (1+ chr)))
                                                (regexp-opt-charset (nreverse chs)))
                                            (let ((class  "["))
                                              (while (<= chr last)
                                                (setq class  (concat class (string chr))
                                                      chr    (1+ chr)))
                                              (concat class "]")))))
                                       ((and (fboundp 'charsetp)  (charsetp chrs)) ;Charset
                                        (let ((chs  ()))
                                          (map-charset-chars
                                           (lambda (range ARG)
                                             (let ((chr   (car range))
                                                   (last  (cdr range)))
                                               (while (<= chr last)
                                                 (push chr chs)
                                                 (setq chr  (1+ chr)))))
                                           chrs)
                                          (regexp-opt-charset (nreverse chs))))
                                       ((vectorp chrs) ; Char class
                                        (concat "[" (format "%s" chrs) "]"))
                                       ((stringp chrs) ; Separate chars
                                        (if (> emacs-major-version 20)
                                            (regexp-opt-charset (append chrs ()))
                                          ;; Emacs 20 `regexp-opt-charset' does not work.
                                          ;; Fake it.
                                          (concat "[" chrs "]")))))
                               chars-NOT)
                       "\\|"))))
    `((,(hc-other-chars-matcher regexp-in regexp-out)
        (0 ',face ,hc-other-chars-font-lock-override)))))

(defun hc-other-chars-matcher (regexp-in regexp-out)
  "Return a font-lock matcher function for `hc-other-chars-font-lock-spec'.
REGEXP-IN is a regexp for matching the CHARS arg, that is, for chars
 to be included.
REGEXP-OUT is a regexp for matching the CHARS-NOT arg, that is, for
 chars to be excluded."
  `(lambda (bound)
    (let ((in     nil)
          (mdata  (or hc--other-chars-last-match-data  (match-data))))
      (setq in  (if (string= "\\(\\)" ,regexp-in) ; No CHARS, but maybe CHARS-NOT
                    (progn (forward-char)
                           (set-match-data ; Fake it - put match data around the char.
                            (list (copy-marker (1- (point))) (copy-marker (point))
                                  (copy-marker (1- (point))) (copy-marker (point))))
                           (point))
                  (re-search-forward ,regexp-in bound t)))
      (unless in (setq hc--other-chars-last-match-data  nil)) ; Search failed, so reset.
      (and in  (progn
                 (if (string= "\\(\\)" ,regexp-out) ; No chars to exclude.
                     (setq hc--other-chars-last-match-data  (match-data))
                   (if (save-excursion
                         (save-match-data (backward-char 1) (looking-at ,regexp-out)))
                       (set-match-data mdata)
                     (setq hc--other-chars-last-match-data  (match-data))))
                 (goto-char in))))))

;;;;;;;;;;;;;;;;;;;;;;;

(provide 'highlight-chars)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; highlight-chars.el ends here
