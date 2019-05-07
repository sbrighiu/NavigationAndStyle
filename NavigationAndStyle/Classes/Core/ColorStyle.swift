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
    public static var global = ColorStyle.default
    
    public static var `default`: ColorStyle = {
        return ColorStyle(statusBarStyle: .default,
                          backgroundColor: Defaults.navigationBarBackgroundColor,
                          hairlineSeparatorColor: Defaults.hairlineSeparatorColor)
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
                          backgroundColor: .clear,
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
    
    public let backgroundColor: UIColor
    public let backgroundImage: UIImage?
    public let backgroundMaskColor: UIColor
    public let backgroundMaskImage: UIImage?
    public let hairlineSeparatorColor: UIColor
    public let shadow: UIColor
    
    public let titleFont: UIFont
    public let titleColor: UIColor
    public let buttonFont: UIFont
    public let buttonTitleColor: UIColor
    public let imageTint: UIColor
    
    public let highlightAlpha: CGFloat
    public let disabledColor: UIColor
    
    public init(statusBarStyle: UIStatusBarStyle = .default,
                backgroundColor: UIColor = Defaults.navigationBarBackgroundColor,
                backgroundImage: UIImage? = nil,
                backgroundMaskColor: UIColor = .clear,
                backgroundMaskImage: UIImage? = nil,
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
        
        self.backgroundColor = backgroundColor
        self.backgroundImage = backgroundImage
        self.backgroundMaskColor = backgroundMaskColor
        self.backgroundMaskImage = backgroundMaskImage
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
    
    public func new(statusBarStyle: UIStatusBarStyle? = nil,
                backgroundColor: UIColor? = nil,
                backgroundImage: UIImage? = Defaults.nullImage,
                backgroundMaskColor: UIColor? = nil,
                backgroundMaskImage: UIImage? = Defaults.nullImage,
                hairlineSeparatorColor: UIColor? = nil,
                shadow: UIColor? = nil,
                titleFont: UIFont? = nil,
                titleColor: UIColor? = nil,
                buttonFont: UIFont? = nil,
                buttonTitleColor: UIColor? = nil,
                imageTint: UIColor = Defaults.nullColor,
                highlightAlpha: CGFloat? = nil,
                disabledColor: UIColor? = nil) -> ColorStyle {
        return ColorStyle(statusBarStyle: statusBarStyle ?? self.statusBarStyle,
                          backgroundColor: backgroundColor ?? self.backgroundColor,
                          backgroundImage: backgroundImage !== Defaults.nullImage ? backgroundImage : self.backgroundImage,
                          backgroundMaskColor: backgroundMaskColor ?? self.backgroundMaskColor,
                          backgroundMaskImage: backgroundMaskImage !== Defaults.nullImage ? backgroundMaskImage : self.backgroundMaskImage,
                          hairlineSeparatorColor: hairlineSeparatorColor ?? self.hairlineSeparatorColor,
                          shadow: shadow ?? self.shadow,
                          titleFont: titleFont ?? self.titleFont,
                          titleColor: titleColor ?? self.titleColor,
                          buttonFont: buttonFont ?? self.buttonFont,
                          buttonTitleColor: buttonTitleColor ?? self.buttonTitleColor,
                          imageTint: imageTint !== Defaults.nullColor ? imageTint : self.imageTint,
                          highlightAlpha: highlightAlpha ?? self.highlightAlpha,
                          disabledColor: disabledColor ?? self.disabledColor)
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
        
        public static let nullImage = UIImage()
        public static let nullColor = UIColor()
    }
}
