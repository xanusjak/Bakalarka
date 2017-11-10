//
//  Extension-Colors.swift
//  MAnusjakBakalarka
//
//  Created by Milan Anusjak on 21/09/2017.
//  Copyright © 2017 Milan Anusjak. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    convenience init(rgb: UInt, alpha: Float = 1.0) {
        self.init(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: CGFloat(alpha)
        )
    }
    
    class func customBlueColor(withAlpha: Float = 1.0) -> UIColor {
        return UIColor(rgb: 0x3878e0, alpha: withAlpha)
    }
    
    class func customGreenColor(withAlpha: Float = 1.0) -> UIColor {
        return UIColor(rgb: 0x22db11, alpha: withAlpha)
    }
    
    class func customRedColor(withAlpha: Float = 1.0) -> UIColor {
        return UIColor(rgb: 0xf92727, alpha: withAlpha)
    }
    
    class func getRandomColor(index: Int) -> UIColor{
        
        switch index {
        case 1:
            return .red
        case 2:
            return .blue
        case 3:
            return .orange
        case 4:
            return .green
        case 5:
            return .yellow
        case 6:
            return .brown
        case 7:
            return .purple
            
        default:
            return .black
        }
    }
}
