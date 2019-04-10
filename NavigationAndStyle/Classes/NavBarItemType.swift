//
//  Copyright © 2019 Stefan Brighiu. All rights reserved.
//

import Foundation
import UIKit

public class NavBarItemType: NSObject, Identifiable {
    let image: UIImage?
    let title: String?
    let systemItem: UIBarButtonItem.SystemItem?
    let autoDismiss: Bool
    let contentEdgeInsets: UIEdgeInsets
    
    private init(image: UIImage, title: String, autoDismiss: Bool = false, contentEdgeInsets: UIEdgeInsets = .zero) {
        self.image = image
        self.title = title
        self.systemItem = nil
        self.autoDismiss = autoDismiss
        self.contentEdgeInsets = contentEdgeInsets
        super.init()
    }
    
    private init(systemItem: UIBarButtonItem.SystemItem, autoDismiss: Bool = false, contentEdgeInsets: UIEdgeInsets = .zero) {
        self.image = nil
        self.title = nil
        self.systemItem = systemItem
        self.autoDismiss = autoDismiss
        self.contentEdgeInsets = contentEdgeInsets
        super.init()
    }
    
    private init(image: UIImage, autoDismiss: Bool = false, contentEdgeInsets: UIEdgeInsets = .zero) {
        self.image = image
        self.title = nil
        self.systemItem = nil
        self.autoDismiss = autoDismiss
        self.contentEdgeInsets = contentEdgeInsets
        super.init()
    }
    
    private init(title: String, autoDismiss: Bool = false, contentEdgeInsets: UIEdgeInsets = .zero) {
        self.image = nil
        self.title = title
        self.systemItem = nil
        self.autoDismiss = autoDismiss
        self.contentEdgeInsets = contentEdgeInsets
        super.init()
    }
    
    public static func systemItem(_ type: UIBarButtonItem.SystemItem, autoDismiss: Bool = false, contentEdgeInsets: UIEdgeInsets = .zero) -> NavBarItemType {
        return NavBarItemType(systemItem: type, autoDismiss: autoDismiss, contentEdgeInsets: contentEdgeInsets)
    }
    
    public static func imageAndTitle(_ image: UIImage, title: String, autoDismiss: Bool = false, contentEdgeInsets: UIEdgeInsets = .zero) -> NavBarItemType {
        return NavBarItemType(image: image, title: title, autoDismiss: autoDismiss, contentEdgeInsets: contentEdgeInsets)
    }
    
    public static func image(_ image: UIImage, autoDismiss: Bool = false, contentEdgeInsets: UIEdgeInsets = .zero) -> NavBarItemType {
        return NavBarItemType(image: image, autoDismiss: autoDismiss, contentEdgeInsets: contentEdgeInsets)
    }
    
    public static func title(_ title: String, autoDismiss: Bool = false, contentEdgeInsets: UIEdgeInsets = .zero) -> NavBarItemType {
        return NavBarItemType(title: title, autoDismiss: autoDismiss, contentEdgeInsets: contentEdgeInsets)
    }
}

public extension UIImage {
    struct Placeholders {
        private static var bundle: Bundle {
            return Bundle(url: Bundle(identifier: "org.cocoapods.NavigationAndStyle")!.url(forResource: "Resources", withExtension: "bundle")!)!
        }
        public static var backArrow: UIImage! {
            return UIImage(named: "backward_glyph", in: bundle, compatibleWith: nil)!.withRenderingMode(.alwaysTemplate)
        }
        public static var close: UIImage! {
            return UIImage(named: "close", in: bundle, compatibleWith: nil)!.withRenderingMode(.alwaysTemplate)
        }
        public static var forwardArrow: UIImage! {
            return UIImage(named: "forward_glyph", in: bundle, compatibleWith: nil)!.withRenderingMode(.alwaysTemplate)
        }
        public static var settings: UIImage! {
            return UIImage(named: "settings", in: bundle, compatibleWith: nil)!.withRenderingMode(.alwaysTemplate)
        }
        public static var backgroundShadow: UIImage! {
            return UIImage(named: "shadowBlackToClear", in: bundle, compatibleWith: nil)!.withRenderingMode(.alwaysTemplate)
        }
    }
}
