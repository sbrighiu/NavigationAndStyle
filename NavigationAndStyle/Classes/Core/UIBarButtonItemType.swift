//
//  Copyright © 2019 Stefan Brighiu. All rights reserved.
//

import Foundation
import UIKit

public class UIBarButtonItemType: NSObject, Identifiable {
    public let title: String?
    public let image: UIImage?
    public let systemItem: UIBarButtonItem.SystemItem?
    public let systemStyle: UIBarButtonItem.Style?
    public let button: UIButton?
    public let view: UIView?
    public let barButtonItem: UIBarButtonItem?
    public let autoDismiss: Bool
    internal let contentEdgeInsets: UIEdgeInsets
    
    private init(title: String, autoDismiss: Bool = false, contentEdgeInsets: UIEdgeInsets = .zero) {
        self.title = title
        self.image = nil
        self.systemItem = nil
        self.systemStyle = nil
        self.button = nil
        self.view = nil
        self.barButtonItem = nil
        self.autoDismiss = autoDismiss
        self.contentEdgeInsets = contentEdgeInsets
        super.init()
    }
    
    private init(title: String, image: UIImage, autoDismiss: Bool = false, contentEdgeInsets: UIEdgeInsets = .zero) {
        self.title = title
        self.image = image
        self.systemItem = nil
        self.systemStyle = nil
        self.button = nil
        self.view = nil
        self.barButtonItem = nil
        self.autoDismiss = autoDismiss
        self.contentEdgeInsets = contentEdgeInsets
        super.init()
    }
    
    private init(image: UIImage, autoDismiss: Bool = false, contentEdgeInsets: UIEdgeInsets = .zero) {
        self.title = nil
        self.image = image
        self.systemItem = nil
        self.systemStyle = nil
        self.button = nil
        self.view = nil
        self.barButtonItem = nil
        self.autoDismiss = autoDismiss
        self.contentEdgeInsets = contentEdgeInsets
        super.init()
    }
    
    private init(systemItem: UIBarButtonItem.SystemItem, systemStyle: UIBarButtonItem.Style, autoDismiss: Bool = false) {
        self.title = nil
        self.image = nil
        self.systemItem = systemItem
        self.systemStyle = systemStyle
        self.button = nil
        self.view = nil
        self.barButtonItem = nil
        self.autoDismiss = autoDismiss
        self.contentEdgeInsets = .zero
        super.init()
    }
    
    private init(button: UIButton, autoDismiss: Bool = false, contentEdgeInsets: UIEdgeInsets = .zero) {
        self.title = nil
        self.image = nil
        self.systemItem = nil
        self.systemStyle = nil
        self.button = button
        self.view = nil
        self.barButtonItem = nil
        self.autoDismiss = autoDismiss
        self.contentEdgeInsets = .zero
        super.init()
    }
    
    private init(view: UIView, autoDismiss: Bool = false) {
        self.title = nil
        self.image = nil
        self.systemItem = nil
        self.systemStyle = nil
        self.button = nil
        self.view = view
        self.barButtonItem = nil
        self.autoDismiss = autoDismiss
        self.contentEdgeInsets = .zero
        super.init()
    }
    
    private init(barButtonItem: UIBarButtonItem, autoDismiss: Bool = false) {
        self.title = nil
        self.image = nil
        self.systemItem = nil
        self.systemStyle = nil
        self.button = nil
        self.view = nil
        self.barButtonItem = barButtonItem
        self.autoDismiss = autoDismiss
        self.contentEdgeInsets = .zero
        super.init()
    }
    
    public static func title(_ title: String, autoDismiss: Bool = false, contentEdgeInsets: UIEdgeInsets = .zero) -> UIBarButtonItemType {
        return UIBarButtonItemType(title: title, autoDismiss: autoDismiss, contentEdgeInsets: contentEdgeInsets)
    }
    
    public static func titleAndImage(_ title: String, image: UIImage, autoDismiss: Bool = false, contentEdgeInsets: UIEdgeInsets = .zero) -> UIBarButtonItemType {
        return UIBarButtonItemType(title: title, image: image, autoDismiss: autoDismiss, contentEdgeInsets: contentEdgeInsets)
    }
    
    public static func image(_ image: UIImage, autoDismiss: Bool = false, contentEdgeInsets: UIEdgeInsets = .zero) -> UIBarButtonItemType {
        return UIBarButtonItemType(image: image, autoDismiss: autoDismiss, contentEdgeInsets: contentEdgeInsets)
    }
    
    public static func systemItem(_ type: UIBarButtonItem.SystemItem, systemStyle: UIBarButtonItem.Style = .done, autoDismiss: Bool = false) -> UIBarButtonItemType {
        return UIBarButtonItemType(systemItem: type, systemStyle: systemStyle, autoDismiss: autoDismiss)
    }
    
    public static func button(_ button: UIButton, autoDismiss: Bool = false) -> UIBarButtonItemType {
        return UIBarButtonItemType(button: button, autoDismiss: autoDismiss)
    }
    
    public static func view(_ view: UIView, autoDismiss: Bool = false, contentEdgeInsets: UIEdgeInsets = .zero) -> UIBarButtonItemType {
        return UIBarButtonItemType(view: view, autoDismiss: autoDismiss)
    }
    
    public static func raw(_ barButtonItem: UIBarButtonItem, autoDismiss: Bool = false) -> UIBarButtonItemType {
        return UIBarButtonItemType(barButtonItem: barButtonItem, autoDismiss: autoDismiss)
    }
}
