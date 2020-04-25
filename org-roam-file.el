;;; org-roam-db.el --- Roam Research replica with Org-mode -*- coding: utf-8; lexical-binding: t -*-

;; Copyright © 2020 zbelial <zjyzhaojiyang@gmail.com>

;; Author: zbelial <zjyzhaojiyang@gmail.com>
;; URL: https://github.com/jethrokuan/org-roam
;; Keywords: org-mode, roam, convenience
;; Version: 1.1.0
;; Package-Requires: ((emacs "26.1") (dash "2.13") (f "0.17.2") (s "1.12.0") (org "9.3") (emacsql "3.0.0") (emacsql-sqlite "1.0.0"))

;; This file is NOT part of GNU Emacs.

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Commentary:
;;
;; This library provides the underlying file api to org-roam. Using this to enable sharing org roam files between computers with different file system layout.
;;
;;; Code:
;;;; Library Requires
(eval-when-compile (require 'subr-x))
(require 'f)
(require 's)

(defvar org-roam-directory)

;;;; Options
(defcustom org-roam-file-directory-label "ORG-ROAM"
  "Label corresponding to `org-roam-directory'."
  :type 'string
  :group 'org-roam)

(defun org-roam-file--to-db (file)
  "Replace prefix of full file name with `org-roam-file-directory-label'"
  (if (f-ancestor-of? org-roam-directory file)
      (concat org-roam-file-directory-label ":" (s-chop-prefix (f-slash org-roam-directory) file))
    (error (format "FILE %S is not in %S" file org-roam-directory))
    )
  )

(defun org-roam-file--from-db (file)
  "Return full file name"
  (if (s-prefix? (concat org-roam-file-directory-label ":") file)
      (expand-file-name (s-chop-prefix (concat org-roam-file-directory-label ":") file) org-roam-directory)
    (error (format "FILE %S does not in %S" file org-roam-directory)))
  )

(defun org-roam-file--link-from-db (link)
  (vector (org-roam-file--from-db (aref link 0))
          (org-roam-file--from-db (aref link 1))
          (aref link 2)
          (aref link 3))
  )

(defun org-roam-file--link-to-db (link)
  (vector (org-roam-file--to-db (aref link 0))
          (org-roam-file--to-db (aref link 1))
          (aref link 2)
          (aref link 3))
  )


(provide 'org-roam-file)

;;; org-roam-db.el ends here
