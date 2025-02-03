//
//  UITexfield+Additions.swift
//  TradeAir
//
//  Created by Adeel on 07/10/2019.
//  Copyright © 2019 Buzzware. All rights reserved.
//

import UIKit
import iOSDropDown
//
//
class UITexfield_Additions_DropDown: DropDown {

    
    let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
}
class UITexfield_Additions: UITextField {

    
    let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

extension UITextField{

    func isValid() -> Bool {
        if self.text?.isEmpty == true {
            return false
        }
        return true
    }
    
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
    @IBInspectable var fontName: String {
            get {
                return self.font?.fontName ?? Constant.Montserrat_Regular
            }
            set {
                if let currentFontSize = self.font?.pointSize, let newFont = UIFont(name: newValue, size: currentFontSize) {
                    self.font = newFont
                } else {
                    print("Font with name \(newValue) not found.")
                }
            }
        }

    

}
extension UITextView {
    func isValid() -> Bool {
        if self.text?.isEmpty == true {
            return false
        }
        return true
    }
    
}

extension UITextField {
  func findFirstResponderTextField() -> UITextField? {
    if let windowScene = UIApplication.shared.connectedScenes
      .filter({ $0.activationState == .foregroundActive })
      .first as? UIWindowScene {
      for window in windowScene.windows {
        if let textField = findTextFieldInView(window) {
          return textField
        }
      }
    }
    return nil
  }
  private func findTextFieldInView(_ view: UIView) -> UITextField? {
    for subview in view.subviews {
      if let textField = subview as? UITextField, textField.isFirstResponder {
        return textField
      } else if let textField = findTextFieldInView(subview) {
        return textField
      }
    }
    return nil
  }
}
