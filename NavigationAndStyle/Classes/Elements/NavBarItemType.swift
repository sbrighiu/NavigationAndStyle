//
//  Copyright © 2019 Stefan Brighiu. All rights reserved.
//

import Foundation
import UIKit

public class NavBarItemType: NSObject, Identifiable {
    public let systemItem: UIBarButtonItem.SystemItem?
    public let image: UIImage?
    public let title: String?
    public let autoDismiss: Bool
    public let contentEdgeInsets: UIEdgeInsets
    
    private init(systemItem: UIBarButtonItem.SystemItem, autoDismiss: Bool = false) {
        self.image = nil
        self.title = nil
        self.systemItem = systemItem
        self.autoDismiss = autoDismiss
        self.contentEdgeInsets = .zero
        super.init()
    }
    
    private init(image: UIImage, title: String, autoDismiss: Bool = false, contentEdgeInsets: UIEdgeInsets = .zero) {
        self.image = image
        self.title = title
        self.systemItem = nil
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
    
    public static func systemItem(_ type: UIBarButtonItem.SystemItem, autoDismiss: Bool = false) -> NavBarItemType {
        return NavBarItemType(systemItem: type, autoDismiss: autoDismiss)
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
