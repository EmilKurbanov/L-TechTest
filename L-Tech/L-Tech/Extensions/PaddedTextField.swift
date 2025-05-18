//
//  PaddedTextField.swift
//  L-Tech
//
//  Created by emil kurbanov on 16.05.2025.
//

import UIKit

class PaddedTextField: UITextField {
    var horizontalPadding: CGFloat = 10

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: horizontalPadding, dy: 0)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: horizontalPadding, dy: 0)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: horizontalPadding, dy: 0)
    }
}
