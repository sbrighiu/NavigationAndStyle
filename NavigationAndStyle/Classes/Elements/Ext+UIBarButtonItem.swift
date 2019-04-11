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
    
    internal static func buildSystemItem(with type: NavBarItemType,
                                         target: Any,
                                         action: Selector,
                                         isLeft: Bool,
                                         and colorStyle: ColorStyle?) -> (UIBarButtonItem, UIButton?, Bool) {
        let newItem: UIBarButtonItem
        var newButton: UIButton?
        if let systemItem = type.systemItem {
            newItem = UIBarButtonItem(barButtonSystemItem: systemItem, target: target, action: action)
        } else {
            let button = UIButton.build(with: type,
                                        target: target,
                                        action: action,
                                        and: colorStyle)
            newItem = UIBarButtonItem(customView: button)
            newButton = button
        }
        
        if let colorStyle = colorStyle {
            newItem.tintColor = colorStyle.buttonTitleColor
        }
        
        systemBarButtonItemsDict[newItem.uniqueIdentifier] = type
        return (newItem, newButton, type.autoDismiss)
    }
    
    internal func getNavBarItemType() -> NavBarItemType? {
        return systemBarButtonItemsDict[uniqueIdentifier]
    }
}
