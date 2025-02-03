//
//  UITextView+Additions.swift
//  TastyBox
//
//  Created by Adeel on 25/06/2020.
//  Copyright © 2020 Buzzware. All rights reserved.
//

import UIKit

class UITextView_Additions: UITextView {

    required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
      textContainerInset = UIEdgeInsets(top: 8, left: 15, bottom: 0, right: 10)
    }

}
extension UITextView{
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
