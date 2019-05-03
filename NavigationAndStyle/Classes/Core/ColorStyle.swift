//
//  Copyright © 2019 Stefan Brighiu. All rights reserved.
//

import Foundation
import UIKit

@objc protocol CanHaveColorStyle {
    func getColorStyle() -> ColorStyle
}

extension UIViewController: CanHaveColorStyle {
    open func getColorStyle() -> ColorStyle {
        return navigationController?.getColorStyle() ??
            ColorStyle.global
    }
}

open class ColorStyle: NSObject {
    // MARK: - Convenience styles
    public static var global = ColorStyle()
    
    public static var `default`: ColorStyle = {
        return ColorStyle(statusBarStyle: .default,
                          background: Defaults.navigationBarBackgroundColor,
                          backgroundImage: nil,
                          hairlineSeparatorColor: Defaults.hairlineSeparatorColor,
                          shadow: .clear,
                          titleFont: Defaults.titleFont,
                          titleColor: Defaults.darkTextColor,
                          buttonFont: Defaults.buttonFont,
                          buttonTitleColor: Defaults.blueColor,
                          imageTint: Defaults.blueColor,
                          highlightAlpha: Defaults.highlightAlpha,
                          disabledColor: Defaults.disabledColor)
    }()
    
    public static func transparent(statusBarStyle: UIStatusBarStyle = .default,
                                   shadow: UIColor = .clear,
                                   titleFont: UIFont = Defaults.titleFont,
                                   titleColor: UIColor = Defaults.darkTextColor,
                                   buttonFont: UIFont = Defaults.buttonFont,
                                   buttonTitleColor: UIColor = Defaults.blueColor,
                                   imageTint: UIColor = Defaults.blueColor,
                                   highlightAlpha: CGFloat = Defaults.highlightAlpha,
                                   disabledColor: UIColor = Defaults.disabledColor) -> ColorStyle {
        return ColorStyle(statusBarStyle: statusBarStyle,
                          background: .clear,
                          backgroundImage: nil,
                          hairlineSeparatorColor: .clear,
                          shadow: shadow,
                          titleFont: titleFont,
                          titleColor: titleColor,
                          buttonFont: buttonFont,
                          buttonTitleColor: buttonTitleColor,
                          imageTint: imageTint,
                          highlightAlpha: highlightAlpha,
                          disabledColor: disabledColor)
    }
    
    // MARK: - Implementation
    public let statusBarStyle: UIStatusBarStyle
    
    public let background: UIColor
    public let backgroundImage: UIImage?
    public let hairlineSeparatorColor: UIColor
    public let shadow: UIColor
    
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
                hairlineSeparatorColor: UIColor = .clear,
                shadow: UIColor = .clear,
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
    
        self.highlightAlpha = highlightAlpha
        self.disabledColor = disabledColor
        
        self.titleFont = titleFont
        self.titleColor = titleColor
        self.buttonFont = buttonFont
        self.buttonTitleColor = buttonTitleColor
        self.imageTint = imageTint
        
        super.init()
    }
    
    // MARK: Convenience methods
    public var barStyle: UIBarStyle {
        return statusBarStyle == .default ? .default : .black
    }
    
    public func highlightColor(for color: UIColor) -> UIColor {
        return Defaults.highlightColor(for: color, highlightAlpha: highlightAlpha)
    }
    
    // MARK: - Default values for global style
    public class Defaults {
        public static var highlightAlpha: CGFloat = 0.66
        internal static func highlightColor(for color: UIColor, highlightAlpha: CGFloat = Defaults.highlightAlpha) -> UIColor {
            return color.withAlphaComponent(highlightAlpha)
        }
        
        public static var titleFont: UIFont = .boldSystemFont(ofSize: 17)
        
        public static var buttonFont: UIFont = .systemFont(ofSize: 17)
        
        public static var disabledColor: UIColor = .lightGray
        
        public static var blueColor: UIColor = UIButton(frame: .zero).tintColor
        
        public static var darkTextColor: UIColor = .darkText
        
        public static var navigationBarBackgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1)
        
        public static var hairlineSeparatorColor = UIColor(red: 0.11, green: 0.11, blue: 0.11, alpha: 0.13)
        
        public static var heightOfHairlineSeparator: CGFloat = 1
        
        public static var backgroundShadow = UIImage.NavigationAndStyle.backgroundShadow
    }
}
