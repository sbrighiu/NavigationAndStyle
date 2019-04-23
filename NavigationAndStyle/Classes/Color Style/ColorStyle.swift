//
//  Copyright © 2019 Stefan Brighiu. All rights reserved.
//

import Foundation
import UIKit

open class ColorStyle: NSObject {
    
    public static var global = ColorStyle()
    
    public class Defaults {
        public static var highlightAlpha: CGFloat = 0.66
        public static func highlightColor(for color: UIColor, highlightAlpha: CGFloat = Defaults.highlightAlpha) -> UIColor {
            return color.withAlphaComponent(highlightAlpha)
        }
        
        public static var titleFont: UIFont = .boldSystemFont(ofSize: 17)
        
        public static var buttonFont: UIFont = .boldSystemFont(ofSize: 17)
        
        public static var disabledColor: UIColor = .lightGray
        
        public static var blueColor: UIColor {
            return UIButton(frame: .zero).tintColor
        }
        
        public static var darkTextColor: UIColor {
            return .darkText
        }
        
        public static var navigationBarBackgroundColor: UIColor {
            return UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1)
        }
        
        public static var hairlineSeparatorColor: UIColor {
            return UIColor(red: 0.11, green: 0.11, blue: 0.11, alpha: 0.13)
        }
        
        public static var heightOfHairlineSeparator: CGFloat {
            return 1
        }
    }
    
    public let statusBarStyle: UIStatusBarStyle
    public var barStyle: UIBarStyle {
        return statusBarStyle == .default ? .default : .black
    }
    
    public let background: UIColor
    public let backgroundImage: UIImage?
    public let shadow: UIColor
    public let hairlineSeparatorColor: UIColor
    
    public let primary: UIColor
    public let secondary: UIColor
    public let third: UIColor
    
    public let titleFont: UIFont
    public let titleColor: UIColor
    public let buttonFont: UIFont
    public let buttonTitleColor: UIColor
    public let imageTint: UIColor?
    
    public let highlightAlpha: CGFloat
    public let disabledColor: UIColor
    
    public init(statusBarStyle: UIStatusBarStyle = .default,
                background: UIColor = Defaults.navigationBarBackgroundColor,
                backgroundImage: UIImage? = nil,
                shadow: UIColor = .clear,
                hairlineSeparatorColor: UIColor = Defaults.hairlineSeparatorColor,
                titleFont: UIFont = Defaults.titleFont,
                titleColor: UIColor = Defaults.darkTextColor,
                buttonFont: UIFont = Defaults.buttonFont,
                buttonTitleColor: UIColor = Defaults.blueColor,
                imageTint: UIColor = Defaults.blueColor,
                highlightAlpha: CGFloat = Defaults.highlightAlpha,
                disabledColor: UIColor = Defaults.disabledColor) {
        self.statusBarStyle = statusBarStyle
        
        self.background = background
        self.backgroundImage = backgroundImage
        self.shadow = shadow
        self.hairlineSeparatorColor = hairlineSeparatorColor
        
        self.primary = titleColor
        self.secondary = buttonTitleColor
        self.third = imageTint
        self.highlightAlpha = highlightAlpha
        self.disabledColor = disabledColor
        
        self.titleFont = titleFont
        self.titleColor = titleColor
        self.buttonFont = buttonFont
        self.buttonTitleColor = buttonTitleColor
        self.imageTint = imageTint
        
        super.init()
    }
    
    open var titleAttr: [NSAttributedString.Key: Any] {
        return [.foregroundColor: titleColor, .font: titleFont]
    }
    
    open func highlightColor(for color: UIColor) -> UIColor {
        return Defaults.highlightColor(for: color, highlightAlpha: highlightAlpha)
    }
    
}
