//
//  CustomTextField.swift
//  Example Project (iOS)
//
//  Created by Max on 04/05/2021.
//

import UIKit

class TextField: UITextField {

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIConstants.textFieldPadding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIConstants.textFieldPadding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIConstants.textFieldPadding)
    }
}
