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
                                         and colorStyle: ColorStyle) -> (UIBarButtonItem, UIButton?) {
        let newItem: UIBarButtonItem!
        var newButton: UIButton?
        if let systemItem = type.systemItem {
            newItem = UIBarButtonItem(barButtonSystemItem: systemItem, target: target, action: action)
            newItem.tintColor = colorStyle.buttonTitleColor
            if let style = type.systemStyle {
                newItem.style = style
            }
        } else {
            let button = UIButton.build(with: type,
                                        target: target,
                                        action: action,
                                        isLeft: isLeft,
                                        and: colorStyle)
            newItem = UIBarButtonItem(customView: button)
            newButton = button
            newItem.tintColor = colorStyle.buttonTitleColor
        }
        
        newItem.saveItemType(type)
        return (newItem, newButton)
    }
}
