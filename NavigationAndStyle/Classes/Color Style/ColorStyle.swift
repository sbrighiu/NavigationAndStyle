//
//  Copyright © 2019 Stefan Brighiu. All rights reserved.
//

import Foundation
import UIKit

open class ColorStyle: NSObject {
    
    public class Defaults {
        private init() { }
        
        public static var globalStyle: ColorStyle?
        
        public static var titleFont: UIFont = .boldSystemFont(ofSize: 17)
        public static var buttonFont: UIFont = .boldSystemFont(ofSize: 17)
        
        public static var alphaWhenTapped: CGFloat = 0.66
        
        // This value masks the fact that UISearchBar does not support removing the background shadow before rendering
        // (UISearchController), and by applying a white background and rounding the corners, we fix this issue and leave
        // the search bar looking as clean/simple as possible. This value should be bigger than 8-12.
        public static var cornerRadiusForSearchBarHotfix: CGFloat = 34/2
        
        public static var searchBarFont: UIFont = .systemFont(ofSize: 17)
        public static var searchBarTextTint: UIColor = .black
        public static var searchBarTextBackground: UIColor = .white
        
        public static let shadowAlpha: CGFloat = 0.25
        
        public static let disabledColor: UIColor = .lightGray
        
        public static var systemBarButtonItemTint: UIColor {
            return systemBlue
        }
        private static let systemBlue: UIColor = {
            return UIButton(frame: .zero).tintColor ?? UIColor(red: 0, green: 0.477, blue: 1, alpha: 1)
        }()
        
        public static var systemNavigationBarTitleTextColor: UIColor {
            return systemDarkTextColor
        }
        private static var systemDarkTextColor: UIColor {
            return .darkText
        }
        
        public static var systemNavigationBarBackgroundImage: UIImage? = {
            let navBar = UINavigationBar(frame: .zero)
            return navBar.backgroundImage(for: .default)
        }()
    }
    
    public let statusBarStyle: UIStatusBarStyle
    public var barStyle: UIBarStyle {
        return statusBarStyle == .default ? .default : .black
    }
    
    public let background: UIColor
    public let backgroundImage: UIImage?
    public let shadow: UIColor
    public let shadowAlpha: CGFloat
    
    public let primary: UIColor
    public let secondary: UIColor
    public let third: UIColor
    public let disabledColor: UIColor
    
    public let titleFont: UIFont
    public let titleColor: UIColor
    public let buttonFont: UIFont
    public let buttonTitleColor: UIColor
    public let imageTint: UIColor?
    
    required public init(statusBarStyle: UIStatusBarStyle,
                         background: UIColor,
                         backgroundImage: UIImage? = nil,
                         shadow: UIColor = .clear,
                         primary: UIColor,
                         secondary: UIColor,
                         third: UIColor,
                         disabled: UIColor = Defaults.disabledColor) {
        self.statusBarStyle = statusBarStyle
        
        self.background = background
        self.backgroundImage = backgroundImage
        self.shadow = shadow
        self.shadowAlpha = Defaults.shadowAlpha
        
        self.primary = primary
        self.secondary = secondary
        self.third = third
        self.disabledColor = disabled
        
        self.titleFont = Defaults.titleFont
        self.titleColor = primary
        self.buttonFont = Defaults.buttonFont
        self.buttonTitleColor = secondary
        self.imageTint = third
        
        super.init()
    }
    
    public init(statusBarStyle: UIStatusBarStyle,
                background: UIColor,
                backgroundImage: UIImage? = nil,
                shadow: UIColor = .clear,
                shadowAlpha: CGFloat = Defaults.shadowAlpha,
                titleFont: UIFont = Defaults.titleFont,
                titleColor: UIColor,
                buttonFont: UIFont = Defaults.buttonFont,
                buttonTitleColor: UIColor,
                imageTint: UIColor,
                disabled: UIColor = Defaults.disabledColor) {
        self.statusBarStyle = statusBarStyle
        
        self.background = background
        self.backgroundImage = backgroundImage
        self.shadow = shadow
        self.shadowAlpha = shadowAlpha
        
        self.primary = titleColor
        self.secondary = buttonTitleColor
        self.third = imageTint
        self.disabledColor = disabled
        
        self.titleFont = titleFont
        self.titleColor = titleColor
        self.buttonFont = buttonFont
        self.buttonTitleColor = buttonTitleColor
        self.imageTint = imageTint
        
        super.init()
    }
    
    public var titleAttr: [NSAttributedString.Key: Any] {
        return [.foregroundColor: titleColor, .font: titleFont]
    }
    
}
