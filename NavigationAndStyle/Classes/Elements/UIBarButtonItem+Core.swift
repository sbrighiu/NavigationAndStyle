//
//  Copyright © 2019 Stefan Brighiu. All rights reserved.
//

import Foundation
import UIKit

extension UIBarButtonItem: IsNavigationBarItem {
    internal var button: UIButton? {
        return self.customView as? UIButton
    }
    
    internal static func buildSystemItem(with type: UIBarButtonItemType,
                                         target: Any,
                                         action: Selector,
                                         isLeft: Bool,
                                         and style: NavigationBarStyle) -> UIBarButtonItem {
        let newItem: UIBarButtonItem!
        if let systemItem = type.systemItem {
            newItem = UIBarButtonItem(barButtonSystemItem: systemItem, target: target, action: action)
            newItem.tintColor = style.buttonTitleColor
            if let style = type.systemStyle {
                newItem.style = style
            }
        } else if let _ = type.title {
            let button = UIButton.build(with: type,
                                        target: target,
                                        action: action,
                                        isLeft: isLeft,
                                        and: style)
            newItem = UIBarButtonItem(customView: button)
            newItem.tintColor = style.buttonTitleColor
        } else {
            newItem = UIBarButtonItem(image: type.image, style: .plain, target: target, action: action)
            newItem.tintColor = style.imageTint
        }
        
        newItem.saveItemType(type)
        return newItem
    }

    public var barItemType: UIBarButtonItemType? {
        return navBarItemTypes[uniqueIdentifier] as? UIBarButtonItemType
    }
}
