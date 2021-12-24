;;; consult-better-jumper.el --- browse better-jumper jump points with consult -*- lexical-binding: t; -*-

;; Copyright (C) 2021  Nicholas Hubbard

;; Author: Nicholas Hubbard
;; Maintainer: Nicholas Hubbard
;; Created: December 24, 2021
;; Version: 1.0.0
;; Homepage: https://github.com/NicholasBHubbard/consult-better-jumper
;; Package-Requires: ((emacs "26.1") (consult "0.13") (better-jumper "1.0.0")) 
;; Keywords: consult, better-jumper
;;
;; This file is not part of GNU Emacs.

;;; License: GNU General Public License v3.0

;;; Commentary:
;;
;; Consult-better-jumper integrates better-jumper into consult so that jump points
;; can be browsed using the consult framework.
;;
;; To use consult-better-jumper try: M-x consult-better-jumper

;;; Code:

(require 'better-jumper)
(require 'consult)

(defun consult-better-jumper--candidates ()
  (let ((markers (better-jumper--get-marker-table)))
    (mapcar
     (pcase-lambda (`(,_path ,_pt ,key))
       (when-let ((marker (gethash key markers)))
         (save-excursion
           (goto-char marker)
           (consult--location-candidate
            (consult--line-with-cursor marker)
            marker (line-number-at-pos)))))
     (ring-elements (better-jumper--get-jump-list)))))

(defun consult-better-jumper ()
  "Browse better-jumper jump points with consult"
  (interactive)
  (consult--read
   (consult-better-jumper--candidates)
   :prompt "Jump to: "
   :annotate (consult--line-prefix)
   :category 'consult-location
   :sort nil
   :require-match t
   :lookup #'consult--lookup-location
   :history '(:input consult--line-history)
   :add-history (thing-at-point 'symbol)
   :state (consult--jump-state)))

(provide 'consult-better-jumper)
;;; consult-better-jumper.el ends here
