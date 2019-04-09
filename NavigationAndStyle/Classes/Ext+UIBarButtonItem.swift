//
//  Copyright © 2019 Stefan Brighiu. All rights reserved.
//

import Foundation
import UIKit

private var systemBarButtonItemsDict = [Int: NavBarItemType]()

extension UIBarButtonItem: Identifiable {
    internal var button: UIButton? {
        return self.customView as? UIButton
    }
    
    internal static func build(with type: NavBarItemType,
                               initialFrame: CGRect,
                               and colorStyle: ViewControllerColorStyle) -> (UIBarButtonItem, UIButton?, Bool)? {
        let button = UIButton.build(with: type,
                                    initialFrame: initialFrame,
                                    and: colorStyle)
        let newItem = UIBarButtonItem(customView: button)
        newItem.setNavBarItemType(to: type)
        return (newItem, button, type.autoDismiss)
    }
    
    internal static func buildSystemItem(with type: NavBarItemType,
                                         target: Any,
                                         selector: Selector,
                                         and colorStyle: ViewControllerColorStyle) -> (UIBarButtonItem, UIButton?, Bool)? {
        if let systemItem = type.systemItem {
            let buttonItem = UIBarButtonItem(barButtonSystemItem: systemItem, target: target, action: selector)
            buttonItem.tintColor = colorStyle.buttonTint
            buttonItem.setNavBarItemType(to: type)
            return (buttonItem, nil, type.autoDismiss)
        }
        return nil
    }
    
    internal func setNavBarItemType(to type: NavBarItemType) {
        systemBarButtonItemsDict[uniqueIdentifier] = type
    }
    
    internal func getNavBarItemType() -> NavBarItemType? {
        return systemBarButtonItemsDict[uniqueIdentifier]
    }
}
