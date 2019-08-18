//
//  Copyright © 2019 Stefan Brighiu. All rights reserved.
//

import Foundation
import UIKit

@objc protocol CanHaveNavigationBarStyle {
    func getNavigationBarStyle() -> NavigationBarStyle
}

extension UIViewController: CanHaveNavigationBarStyle {
    open func getNavigationBarStyle() -> NavigationBarStyle {
        return navigationController?.getNavigationBarStyle() ??
            NavigationBarStyle.global
    }
}

// TODO: - declare inside UIViewController
open class NavigationBarStyle: NSObject {
    // MARK: - Convenience styles
    public static var global = NavigationBarStyle.default
    
    public static var `default`: NavigationBarStyle = {
        return NavigationBarStyle(statusBarStyle: .default,
                                  customBarType: .custom(isTranslucent: true,
                                                         bgColor: Defaults.navigationBarBackgroundColor,
                                                         shadowImage: Defaults.hairlineSeparatorColor.image()))
    }()
    
    public static func transparent(statusBarStyle: UIStatusBarStyle = .default,
                                   customShadow: UIColor = .clear,
                                   titleFont: UIFont = Defaults.titleFont,
                                   titleColor: UIColor = Defaults.darkTextColor,
                                   largeTitleFont: UIFont = Defaults.largeTitleFont,
                                   largeTitleColor: UIColor = Defaults.darkTextColor,
                                   buttonFont: UIFont = Defaults.buttonFont,
                                   buttonTitleColor: UIColor = Defaults.blueColor,
                                   imageTint: UIColor = Defaults.blueColor,
                                   highlightAlpha: CGFloat = Defaults.highlightAlpha,
                                   disabledColor: UIColor = Defaults.disabledColor) -> NavigationBarStyle {
        return NavigationBarStyle(statusBarStyle: statusBarStyle,
                                  customBarType: .transparent,
                                  customShadow: customShadow,
                                  titleFont: titleFont,
                                  titleColor: titleColor,
                                  largeTitleFont: largeTitleFont,
                                  largeTitleColor: largeTitleColor,
                                  buttonFont: buttonFont,
                                  buttonTitleColor: buttonTitleColor,
                                  imageTint: imageTint,
                                  highlightAlpha: highlightAlpha,
                                  disabledColor: disabledColor)
    }
    
    // MARK: - Implementation
    public let statusBarStyle: UIStatusBarStyle
    
    public let customBarType: UINavigationBar.CustomType
    public let customShadow: UIColor
    
    public let titleFont: UIFont
    public let titleColor: UIColor
    public let largeTitleFont: UIFont
    public let largeTitleColor: UIColor
    public let buttonFont: UIFont
    public let buttonTitleColor: UIColor
    public let imageTint: UIColor
    
    public let highlightAlpha: CGFloat
    public let disabledColor: UIColor
    
    public init(statusBarStyle: UIStatusBarStyle = .default,
                customBarType: UINavigationBar.CustomType,
                customShadow: UIColor = .clear,
                titleFont: UIFont = Defaults.titleFont,
                titleColor: UIColor = Defaults.darkTextColor,
                largeTitleFont: UIFont = Defaults.largeTitleFont,
                largeTitleColor: UIColor = Defaults.darkTextColor,
                buttonFont: UIFont = Defaults.buttonFont,
                buttonTitleColor: UIColor = Defaults.blueColor,
                imageTint: UIColor = Defaults.blueColor,
                highlightAlpha: CGFloat = Defaults.highlightAlpha,
                disabledColor: UIColor = Defaults.disabledColor) {
        self.statusBarStyle = statusBarStyle
        
        self.customBarType = customBarType
        self.customShadow = customShadow

        self.highlightAlpha = highlightAlpha
        self.disabledColor = disabledColor
        
        self.titleFont = titleFont
        self.titleColor = titleColor
        self.largeTitleFont = largeTitleFont
        self.largeTitleColor = largeTitleColor
        self.buttonFont = buttonFont
        self.buttonTitleColor = buttonTitleColor
        self.imageTint = imageTint
        
        super.init()
    }
    
    public func new(statusBarStyle: UIStatusBarStyle? = nil,
                    customBarType: UINavigationBar.CustomType? = nil,
                    customShadow: UIColor? = nil,
                    titleFont: UIFont? = nil,
                    titleColor: UIColor? = nil,
                    largeTitleFont: UIFont? = nil,
                    largeTitleColor: UIColor? = nil,
                    buttonFont: UIFont? = nil,
                    buttonTitleColor: UIColor? = nil,
                    imageTint: UIColor = Defaults.nullColor,
                    highlightAlpha: CGFloat? = nil,
                    disabledColor: UIColor? = nil) -> NavigationBarStyle {
        return NavigationBarStyle(statusBarStyle: statusBarStyle ?? self.statusBarStyle,
                                  customBarType: customBarType ?? self.customBarType,
                                  customShadow: customShadow ?? self.customShadow,
                                  titleFont: titleFont ?? self.titleFont,
                                  titleColor: titleColor ?? self.titleColor,
                                  largeTitleFont: largeTitleFont ?? self.largeTitleFont,
                                  largeTitleColor: largeTitleColor ?? self.largeTitleColor,
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

    public var titleAttributes: [NSAttributedString.Key : Any] {
        return [.foregroundColor: titleColor,
                .font: titleFont]
    }

    public var largeTitleAttributes: [NSAttributedString.Key : Any] {
        return [.foregroundColor: largeTitleColor,
                .font: largeTitleFont]
    }

    // MARK: - Default values for global style
    public class Defaults {
        public static var highlightAlpha: CGFloat = 0.66
        internal static func highlightColor(for color: UIColor, highlightAlpha: CGFloat = Defaults.highlightAlpha) -> UIColor {
            return color.withAlphaComponent(highlightAlpha)
        }

        public static var largeTitleFont: UIFont = .boldSystemFont(ofSize: 34)

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
