//
//  Copyright © 2019 Stefan Brighiu. All rights reserved.
//

import Foundation
import UIKit

private let privateClearImage = UIImage()

public extension UINavigationBar {
    enum CustomType {
        case transparent
        case custom(isTranslucent: Bool, bgColor: UIColor, shadowImage: UIImage?)

        public func set(on navBar: UINavigationBar) {
            navBar.set(with: isTranslucent, bgColor: .clear, and: privateClearImage)
        }

        internal static var clearImage: UIImage {
            return privateClearImage
        }

        public var isTranslucent: Bool {
            switch self {
            case .transparent:
                return true

            case let .custom(isTranslucent: isTranslucent, bgColor: _, shadowImage: _):
                return isTranslucent
            }
        }

        public var bgColor: UIColor {
            switch self {
            case .transparent:
                return .clear

            case let .custom(isTranslucent: _, bgColor: bgColor, shadowImage: _):
                return bgColor
            }
        }

        public var shadowImage: UIImage {
            switch self {
            case .transparent:
                return privateClearImage

            case let .custom(isTranslucent: _, bgColor: _, shadowImage: shadowImage):
                return shadowImage ?? privateClearImage
            }
        }
    }

    internal func updateCustomStyleIfNeeded(with style: NavigationBarStyle) {
        let customType = style.customBarType

        self.isTranslucent = customType.isTranslucent
        //        if !(self.barTintColor?.isEqual(customType.bgColor) == true) {
//        UIView.animate(withDuration: 0.15) {
            self.backgroundColor = customType.bgColor
//            self.barTintColor = customType.bgColor
        self.setBackgroundImage(customType.bgColor.image(), for: .default)
//        }
        //        }
        if self.shadowImage != customType.shadowImage {
            self.shadowImage = customType.shadowImage
        }
    }

    fileprivate func set(with translucent: Bool, bgColor: UIColor, and shadowImage: UIImage) {
        self.isTranslucent = translucent

        self.backgroundColor = bgColor
//        self.barTintColor = bgColor

        self.setBackgroundImage(privateClearImage, for: .default)
        self.shadowImage = shadowImage
    }

    internal func set(_ type: CustomType) {
        type.set(on: self)
    }
}
