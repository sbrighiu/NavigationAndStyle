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
    public let extendByValue: CGFloat
    
    private init(title: String,
                 extendTapAreaBy extendByValue: CGFloat = 0,
                 autoDismiss: Bool = false) {
        self.title = title
        self.image = nil
        self.systemItem = nil
        self.systemStyle = nil
        self.button = nil
        self.view = nil
        self.barButtonItem = nil
        self.autoDismiss = autoDismiss
        self.extendByValue = extendByValue
        super.init()
    }
    
    private init(title: String,
                 image: UIImage,
                 extendTapAreaBy extendByValue: CGFloat = 0,
                 autoDismiss: Bool = false) {
        self.title = title
        self.image = image
        self.systemItem = nil
        self.systemStyle = nil
        self.button = nil
        self.view = nil
        self.barButtonItem = nil
        self.autoDismiss = autoDismiss
        self.extendByValue = extendByValue
        super.init()
    }
    
    private init(image: UIImage,
                 extendTapAreaBy extendByValue: CGFloat = 0,
                 autoDismiss: Bool = false) {
        self.title = nil
        self.image = image
        self.systemItem = nil
        self.systemStyle = nil
        self.button = nil
        self.view = nil
        self.barButtonItem = nil
        self.autoDismiss = autoDismiss
        self.extendByValue = extendByValue
        super.init()
    }
    
    private init(systemItem: UIBarButtonItem.SystemItem,
                 systemStyle: UIBarButtonItem.Style,
                 autoDismiss: Bool = false) {
        self.title = nil
        self.image = nil
        self.systemItem = systemItem
        self.systemStyle = systemStyle
        self.button = nil
        self.view = nil
        self.barButtonItem = nil
        self.autoDismiss = autoDismiss
        self.extendByValue = 0
        super.init()
    }
    
    private init(button: UIButton,
                 autoDismiss: Bool = false) {
        self.title = nil
        self.image = nil
        self.systemItem = nil
        self.systemStyle = nil
        self.button = button
        self.view = nil
        self.barButtonItem = nil
        self.autoDismiss = autoDismiss
        self.extendByValue = 0
        super.init()
    }
    
    private init(view: UIView,
                 autoDismiss: Bool = false) {
        self.title = nil
        self.image = nil
        self.systemItem = nil
        self.systemStyle = nil
        self.button = nil
        self.view = view
        self.barButtonItem = nil
        self.autoDismiss = autoDismiss
        self.extendByValue = 0
        super.init()
    }
    
    private init(barButtonItem: UIBarButtonItem,
                 autoDismiss: Bool = false) {
        self.title = nil
        self.image = nil
        self.systemItem = nil
        self.systemStyle = nil
        self.button = nil
        self.view = nil
        self.barButtonItem = barButtonItem
        self.autoDismiss = autoDismiss
        self.extendByValue = 0
        super.init()
    }
    
    // MARK: - Factory methods
    public static func title(_ title: String, extendTapAreaBy: CGFloat = 0, autoDismiss: Bool = false) -> UIBarButtonItemType {
        return UIBarButtonItemType(title: title, extendTapAreaBy: extendTapAreaBy, autoDismiss: autoDismiss)
    }
    
    public static func titleAndImage(_ title: String, image: UIImage, extendTapAreaBy: CGFloat = 0, autoDismiss: Bool = false) -> UIBarButtonItemType {
        return UIBarButtonItemType(title: title, image: image, extendTapAreaBy: extendTapAreaBy, autoDismiss: autoDismiss)
    }
    
    public static func image(_ image: UIImage, extendTapAreaBy: CGFloat = 0, autoDismiss: Bool = false) -> UIBarButtonItemType {
        return UIBarButtonItemType(image: image, extendTapAreaBy: extendTapAreaBy, autoDismiss: autoDismiss)
    }
    
    public static func systemItem(_ type: UIBarButtonItem.SystemItem, systemStyle: UIBarButtonItem.Style = .done, autoDismiss: Bool = false) -> UIBarButtonItemType {
        return UIBarButtonItemType(systemItem: type, systemStyle: systemStyle, autoDismiss: autoDismiss)
    }
    
    public static func button(_ button: UIButton, autoDismiss: Bool = false) -> UIBarButtonItemType {
        return UIBarButtonItemType(button: button, autoDismiss: autoDismiss)
    }
    
    public static func view(_ view: UIView, autoDismiss: Bool = false) -> UIBarButtonItemType {
        return UIBarButtonItemType(view: view, autoDismiss: autoDismiss)
    }
    
    public static func raw(_ barButtonItem: UIBarButtonItem, autoDismiss: Bool = false) -> UIBarButtonItemType {
        return UIBarButtonItemType(barButtonItem: barButtonItem, autoDismiss: autoDismiss)
    }
    
    // MARK: - Internal Convenience methods
    func contentInsets(forLeftElement isLeft: Bool) -> UIEdgeInsets {
        if extendByValue != 0 {
            if isLeft {
                return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: extendByValue)
            } else {
                return UIEdgeInsets(top: 0, left: extendByValue, bottom: 0, right: 0)
            }
        }
        return .zero
    }
}
