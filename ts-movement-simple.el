;;; ts-movement-simple.el --- Movement commands using treesit syntax tree -*- lexical-binding:t -*-

;; Copyright (C) 2022 Free Software Foundation, Inc.

;; Author: Venky Iyer
;; Version: 0.1
;; Keywords: movement, treesit
;; URL:

;;; Commentary:
;; Simple movement commands using treesit syntax tree.

;;; Code:
(require 'treesit)

(defun tsms/node-prev (point)
  "Go to previous sibling of node at POINT and go to start of node."
  (interactive "d")
  (when-let* ((node (treesit-node-at point))
               (prev (treesit-node-prev-sibling node)))
    (goto-char (treesit-node-start prev))))

(defun tsms/node-next (point)
  "Go to next sibling of node at POINT and go to start of node."
  (interactive "d")
  (when-let* ((node (treesit-node-at point))
               (next (treesit-node-next-sibling node)))
    (goto-char (treesit-node-start next))))

(defun tsms/node-parent (point)
  "Go to parent of node at POINT."
  (interactive "d")
  (when-let* ((node (treesit-node-at point))
               (parent (treesit-node-parent node)))
    (goto-char (treesit-node-start parent))))

(defun tsms/node-child (point)
  "Go to first child containing POINT."
  (interactive "d")
  (when-let* ((node (treesit-node-at point))
               (child (treesit-node-first-child-for-pos node point)))
    (goto-char (treesit-node-start child))))

(defun tsms/node-start (point)
  "Go to start of node at POINT."
  (interactive "d")
  (when-let ((node (treesit-node-at point)))
    (goto-char (treesit-node-start node))))

(defun tsms/node-end (point)
  "Go to end of node at POINT."
  (interactive "d")
  (when-let ((node (treesit-node-at point)))
    (goto-char (1- (treesit-node-end node)))))

;;;###autoload
(defvar ts-movement-map
  (let ((map (make-sparse-keymap "Tree Sitter Movement")))
    ;; Add your preferred keybindings here
    map)
  "Keymap for `ts-movement-mode'.")

;;;###autoload
(define-minor-mode ts-movement-mode
  "Movement commands using treesit syntax tree."
  :keymap ts-movement-map)

(provide 'ts-movement-simple)
;;; ts-movement-simple.el ends here
