//
//  Copyright © 2019 Stefan Brighiu. All rights reserved.
//

import Foundation
import UIKit

open class ViewControllerColorStyle: NSObject {
    
    public class Constants {
        private init() { }
        
        fileprivate static let invisibleBackgroundImage = UIImage()
        fileprivate static func visibleBackgroundImage(with color: UIColor) -> UIImage {
            if color == .clear { return invisibleBackgroundImage }
            return color.getImage(withAlpha: 1.0) ?? invisibleBackgroundImage
        }
        
        fileprivate static let invisibleShadowImage = UIImage()
        fileprivate static func visibleShadowImage(with color: UIColor, and alpha: CGFloat = 1.0) -> UIImage {
            if color == .clear { return invisibleShadowImage }
            return color.getImage(withAlpha: alpha) ?? invisibleShadowImage
        }
        
        public static var defaultTitleFont: UIFont = .boldSystemFont(ofSize: 17)
        public static var defaultButtonFont: UIFont = .boldSystemFont(ofSize: 17)
        public static var defaultSearchBarFont: UIFont = .systemFont(ofSize: 17)
        
        public static let defaultShadowAlpha: CGFloat = 0.25
        
        public static let defaultDisabledTint: UIColor = .lightGray
        
        public static var defaultSearchBarTextTint: UIColor = .black
        public static var defaultSearchBarTextBackground: UIColor = .white
        
        public static var defaultAlphaWhenTapped: CGFloat = 0.66
        
        public static var defaultColorStyle = ViewControllerColorStyle(statusBarStyle: .default,
                                                                       background: .white,
                                                                       shadow: .clear,
                                                                       primary: .black,
                                                                       secondary: .black,
                                                                       disabledTint: defaultDisabledTint)
    }
    
    public var isTranslucent: Bool {
        return background == .clear
    }
    
    public var barStyle: UIBarStyle {
        return statusBarStyle == .default ? .default : .black
    }
    
    public let background: UIColor
    public let primary: UIColor
    public let secondary: UIColor
    public let disabledTint: UIColor
    public let shadow: UIColor
    public let shadowAlpha: CGFloat
    
    public let statusBarStyle: UIStatusBarStyle
    
    private(set) var underlineShadowImage: UIImage = UIImage()
    private(set) var backgroundImage: UIImage = UIImage()
    
    public let titleFont: UIFont
    public let titleTint: UIColor
    public let buttonTint: UIColor
    public let buttonFont: UIFont
    public let imageTint: UIColor?
    
    required public init(statusBarStyle: UIStatusBarStyle,
                         background: UIColor,
                         shadow: UIColor = .clear,
                         primary: UIColor,
                         secondary: UIColor,
                         disabledTint: UIColor = Constants.defaultDisabledTint,
                         underlineShadow: UIColor = .clear) {
        self.primary = primary
        self.secondary = secondary
        self.background = background
        self.disabledTint = disabledTint
        self.statusBarStyle = statusBarStyle
        self.shadow = shadow
        self.shadowAlpha = Constants.defaultShadowAlpha
        
        self.titleFont = Constants.defaultTitleFont
        self.titleTint = primary
        self.buttonFont = Constants.defaultButtonFont
        self.buttonTint = secondary
        self.imageTint = secondary
        
        super.init()
        
        self.underlineShadowImage = (underlineShadow == .clear) ? Constants.invisibleShadowImage : Constants.visibleShadowImage(with: underlineShadow)
        self.backgroundImage = self.isTranslucent ? Constants.invisibleBackgroundImage : Constants.visibleBackgroundImage(with: background)
    }
    
    public init(statusBarStyle: UIStatusBarStyle,
                background: UIColor,
                shadow: UIColor = .clear,
                shadowAlpha: CGFloat = Constants.defaultShadowAlpha,
                titleFont: UIFont = Constants.defaultTitleFont,
                titleTint: UIColor,
                buttonFont: UIFont = Constants.defaultButtonFont,
                buttonTint: UIColor,
                imageTint: UIColor,
                disabledTint: UIColor = Constants.defaultDisabledTint,
                underlineShadow: UIColor = .clear,
                underlineShadowAlpha: CGFloat = 1.0) {
        
        self.primary = titleTint
        self.secondary = buttonTint
        self.background = background
        self.disabledTint = disabledTint
        self.statusBarStyle = statusBarStyle
        self.shadow = shadow
        self.shadowAlpha = shadowAlpha
        
        self.titleFont = titleFont
        self.titleTint = titleTint
        self.buttonFont = buttonFont
        self.buttonTint = buttonTint
        self.imageTint = imageTint
        
        super.init()
        
        self.underlineShadowImage = (underlineShadow == .clear) ? Constants.invisibleShadowImage : Constants.visibleShadowImage(with: underlineShadow, and: underlineShadowAlpha)
        self.backgroundImage = self.isTranslucent ? Constants.invisibleBackgroundImage : Constants.visibleBackgroundImage(with: background)
    }
    
    public var titleAttr: [NSAttributedString.Key: Any] {
        return [.foregroundColor: titleTint, .font: titleFont]
    }
    
    public var clearShadowImage: UIImage {
        return Constants.invisibleShadowImage
    }
    
}

@objc protocol CanHaveColorStyle {
    func getColorStyle() -> ViewControllerColorStyle
}

extension UIViewController: CanHaveColorStyle {
    open func getColorStyle() -> ViewControllerColorStyle {
        return ViewControllerColorStyle.Constants.defaultColorStyle
    }
}
