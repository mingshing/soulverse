//
//  UIFont+Extensions.swift
//  KonoSummit
//
//  Created by mingshing on 2021/11/8.
//

import Foundation

import UIKit

extension UIFont {
    
    class func projectFont(ofSize fontSize: CGFloat, weight: UIFont.Weight = .regular) -> UIFont {
        
        if weight == .bold {
            return UIFont(name: "IBMPlexSans-Bold", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize, weight: .bold)
        } else if weight == .semibold {
            return UIFont(name: "IBMPlexSans-SemiBold", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize, weight: .semibold)
        } else if weight == .thin {
            return UIFont(name: "IBMPlexSans-Thin", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize, weight: .semibold)
        } else if weight == .medium {
            return UIFont(name: "IBMPlexSans-Medium", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize, weight: .medium)
        }
        
        return UIFont(name: "IBMPlexSans", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
    }
    
    class func italicProjectFont(ofSize fontSize: CGFloat) -> UIFont {
        return UIFont(name: "IBMPlexSans-Italic", size: fontSize) ?? UIFont.italicSystemFont(ofSize: fontSize)
    }
}
