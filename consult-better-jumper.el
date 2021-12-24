;;; consult-better-jumper --- Consult integration for better-jumper

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
