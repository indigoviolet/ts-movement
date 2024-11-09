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

(defvar-local tms--current-node nil
  "Current tree-sitter node being navigated.")

(defun tms--get-or-init-node ()
  "Get current node or initialize it to node at point."
  (or tms--current-node
    (setq tms--current-node (treesit-node-at (point)))))

(defun tms/node-prev ()
  "Go to previous sibling of current node and go to start of node."
  (interactive)
  (when-let* ((node (tms--get-or-init-node))
               (prev (treesit-node-prev-sibling node)))
    (setq tms--current-node prev)
    (goto-char (treesit-node-start prev))))

(defun tms/node-next ()
  "Go to next sibling of current node and go to start of node."
  (interactive)
  (when-let* ((node (tms--get-or-init-node))
               (next (treesit-node-next-sibling node)))
    (setq tms--current-node next)
    (goto-char (treesit-node-start next))))

(defun tms/node-parent ()
  "Go to parent of current node."
  (interactive)
  (when-let* ((node (tms--get-or-init-node))
               (parent (treesit-node-parent node)))
    (setq tms--current-node parent)
    (goto-char (treesit-node-start parent))))

(defun tms/node-child ()
  "Go to first child containing point."
  (interactive)
  (when-let* ((node (tms--get-or-init-node))
               (child (treesit-node-first-child-for-pos node (point))))
    (setq tms--current-node child)
    (goto-char (treesit-node-start child))))

(defun tms/node-start ()
  "Go to start of current node."
  (interactive)
  (when-let ((node (tms--get-or-init-node)))
    (goto-char (treesit-node-start node))))

(defun tms/node-end ()
  "Go to end of current node."
  (interactive)
  (when-let ((node (tms--get-or-init-node)))
    (goto-char (1- (treesit-node-end node)))))

(defun tms/reset-node ()
  "Reset the current node to the one at point."
  (interactive)
  (setq tms--current-node (treesit-node-at (point))))

;;;###autoload
(defvar ts-movement-simple-map
  (let ((map (make-sparse-keymap "Tree Sitter Simple Movement")))
    ;; Add your preferred keybindings here
    map)
  "Keymap for `ts-movement-simple-mode'.")

;;;###autoload
(define-minor-mode ts-movement-simple-mode
  "Movement commands using treesit syntax tree."
  :keymap ts-movement-simple-map
  (setq-local tms--current-node nil))

(provide 'ts-movement-simple)
;;; ts-movement-simple.el ends here
