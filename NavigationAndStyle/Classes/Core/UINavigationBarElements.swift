//
//  Copyright © 2019 Stefan Brighiu. All rights reserved.
//

import Foundation
import UIKit

public protocol UINavigationBarGenericItem {
    var title: String? { get }
    var image: UIImage? { get }
    var secondLineAttributes: [NSAttributedString.Key : Any]? { get }
    
    var isTappable: Bool { get }
    var autoDismiss: Bool { get }
}

public class UINavigationBarItemType: NSObject, UINavigationBarGenericItem {
    public let title: String?
    public let image: UIImage?
    public let nativeTitle: String?
    
    public let secondLineAttributes: [NSAttributedString.Key : Any]?
    
    public let isTappable: Bool
    public let autoDismiss: Bool
    
    fileprivate init(title: String? = nil,
                     image: UIImage? = nil,
                     nativeTitle: String? = nil,
                     secondLineAttributes: [NSAttributedString.Key : Any]? = nil,
                     isTappable: Bool,
                     autoDismiss: Bool) {
        self.title = title
        self.image = image
        self.nativeTitle = nativeTitle
        
        self.secondLineAttributes = secondLineAttributes
        
        self.isTappable = isTappable
        self.autoDismiss = autoDismiss
        super.init()
    }
    
    // MARK: - Factory methods
    public static func title(_ title: String) -> UINavigationBarItemType {
        return UINavigationBarItemType(nativeTitle: title, isTappable: false, autoDismiss: false)
    }

    public static func largeTitle(_ title: String, andLabelTitle labelTitle: String, secondLineAttributes: [NSAttributedString.Key : Any]? = nil) -> UINavigationBarItemType {
        return UINavigationBarItemType(title: labelTitle, nativeTitle: title, secondLineAttributes: secondLineAttributes, isTappable: false, autoDismiss: false)
    }

    public static func largeTitle(_ title: String, andButtonTitle buttonTitle: String, secondLineAttributes: [NSAttributedString.Key : Any]? = nil, autoDismiss: Bool = false) -> UINavigationBarItemType {
        return UINavigationBarItemType(title: buttonTitle, nativeTitle: title, secondLineAttributes: secondLineAttributes, isTappable: true, autoDismiss: autoDismiss)
    }

    public static func largeTitle(_ title: String, andImage image: UIImage, isTappable: Bool = false, autoDismiss: Bool = false) -> UINavigationBarItemType {
        return UINavigationBarItemType(image: image, nativeTitle: title, isTappable: isTappable, autoDismiss: autoDismiss)
    }

    public static func label(_ title: String, secondLineAttributes: [NSAttributedString.Key : Any]? = nil) -> UINavigationBarItemType {
        return UINavigationBarItemType(title: title, secondLineAttributes: secondLineAttributes, isTappable: false, autoDismiss: false)
    }
    
    public static func button(_ title: String, secondLineAttributes: [NSAttributedString.Key : Any]? = nil, autoDismiss: Bool = false) -> UINavigationBarItemType {
        return UINavigationBarItemType(title: title, secondLineAttributes: secondLineAttributes, isTappable: true, autoDismiss: autoDismiss)
    }
    
    public static func imageView(_ image: UIImage, isTappable: Bool = false, autoDismiss: Bool = false) -> UINavigationBarItemType {
        return UINavigationBarItemType(image: image, isTappable: isTappable, autoDismiss: autoDismiss)
    }
    
    public static var empty: UINavigationBarItemType = {
        return .label("")
    }()
}

public class UIBarButtonItemType: NSObject, UINavigationBarGenericItem {
    public let title: String?
    public let image: UIImage?
    
    public let secondLineAttributes: [NSAttributedString.Key: Any]?
    
    public let systemItem: UIBarButtonItem.SystemItem?
    public let systemStyle: UIBarButtonItem.Style?
    
    public let isTappable: Bool
    public let autoDismiss: Bool
    public let extendByValue: CGFloat
    
    private init(title: String? = nil,
                 image: UIImage? = nil,
                 secondLineAttributes: [NSAttributedString.Key : Any]? = nil,
                 autoDismiss: Bool = false,
                 systemItem: UIBarButtonItem.SystemItem? = nil,
                 systemStyle: UIBarButtonItem.Style? = nil,
                 extendTapAreaBy extendByValue: CGFloat = 0) {
        self.title = title
        self.image = image
        
        self.secondLineAttributes = secondLineAttributes
        
        self.systemItem = systemItem
        self.systemStyle = systemStyle
        
        self.isTappable = true
        self.autoDismiss = autoDismiss
        self.extendByValue = extendByValue
        super.init()
    }
    
    // MARK: - Factory methods
    public static func title(_ title: String, secondLineAttributes: [NSAttributedString.Key : Any]? = nil, extendTapAreaBy: CGFloat = 0, autoDismiss: Bool = false) -> UIBarButtonItemType {
        return UIBarButtonItemType(title: title, secondLineAttributes: secondLineAttributes, autoDismiss: autoDismiss, extendTapAreaBy: extendTapAreaBy)
    }
    
    public static func titleAndImage(_ title: String, image: UIImage, secondLineAttributes: [NSAttributedString.Key : Any]? = nil, extendTapAreaBy: CGFloat = 0, autoDismiss: Bool = false) -> UIBarButtonItemType {
        return UIBarButtonItemType(title: title, image: image, secondLineAttributes: secondLineAttributes, autoDismiss: autoDismiss, extendTapAreaBy: extendTapAreaBy)
    }
    
    public static func image(_ image: UIImage, autoDismiss: Bool = false) -> UIBarButtonItemType {
        return UIBarButtonItemType(image: image, autoDismiss: autoDismiss)
    }
    
    public static func systemItem(_ type: UIBarButtonItem.SystemItem, systemStyle: UIBarButtonItem.Style = .plain, autoDismiss: Bool = false) -> UIBarButtonItemType {
        return UIBarButtonItemType(autoDismiss: autoDismiss, systemItem: type, systemStyle: systemStyle)
    }
    
    // MARK: - Internal Convenience methods
    internal func contentInsets(forLeftElement isLeft: Bool) -> UIEdgeInsets {
        if extendByValue != 0 {
            if isLeft {
                return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: extendByValue)
            } else {
                return UIEdgeInsets(top: 0, left: extendByValue, bottom: 0, right: 0)
            }
        }
        return .zero
    }

    // MARK: - Convenience
    public struct generic {
        public static func back(autoDismiss: Bool = true) -> UIBarButtonItemType {
            return .image(UIImage.NavigationAndStyle.backArrow, autoDismiss: autoDismiss)
        }
        public static func close(autoDismiss: Bool = true) -> UIBarButtonItemType {
            return .image(UIImage.NavigationAndStyle.close, autoDismiss: autoDismiss)
        }
        public static var forward: UIBarButtonItemType {
            return .image(UIImage.NavigationAndStyle.forwardArrow, autoDismiss: false)
        }
        public static var settings: UIBarButtonItemType {
            return .image(UIImage.NavigationAndStyle.settings, autoDismiss: false)
        }
    }
}
