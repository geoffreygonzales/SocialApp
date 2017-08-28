//
//  LoginTextField.swift
//  SocialApp
//
//  Created by Geoffrey on 8/28/17.
//  Copyright © 2017 Geoffrey. All rights reserved.
//

import UIKit

class LoginTextField: UITextField {

        override func awakeFromNib() {
                super.awakeFromNib()
                
//                layer.borderColor = UIColor(red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.6).cgColor
//                
//                func textRect(forBounds: CGRect) -> CGRect {
//                        return bounds.insetBy(dx: 10, dy: 5)
//                }
//                
//                func editingRect(forBounds: CGRect) -> CGRect {
//                        return bounds.insetBy(dx: 10, dy: 5)
//                }
                
                layer.cornerRadius = 3.0
                
                
        }

}
