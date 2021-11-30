//
//  UIView+Shadow.swift
//  SeSAC_Motto
//
//  Created by kokojong on 2021/11/30.
//

import Foundation
import UIKit

extension UIView {
    func toShadowView(){
//        self.layer.cornerRadius = 10
        self.layer.shadowOpacity = 0.25
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.layer.shadowRadius = 3
//        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.masksToBounds = false
    }
}
