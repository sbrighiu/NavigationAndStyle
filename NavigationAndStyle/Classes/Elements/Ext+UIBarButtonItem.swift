//
//  Copyright © 2019 Stefan Brighiu. All rights reserved.
//

import Foundation
import UIKit

private var systemBarButtonItemsDict = [Int: UIBarButtonItemType]()

extension UIBarButtonItem: Identifiable {
    internal var button: UIButton? {
        return self.customView as? UIButton
    }
    
    internal static func buildSystemItem(with type: UIBarButtonItemType,
                                         target: Any,
                                         action: Selector,
                                         isLeft: Bool,
                                         and colorStyle: ColorStyle) -> (UIBarButtonItem, UIButton?, Bool) {
        let newItem: UIBarButtonItem
        var newButton: UIButton?
        if let systemItem = type.systemItem {
            newItem = UIBarButtonItem(barButtonSystemItem: systemItem, target: target, action: action)
            newItem.tintColor = colorStyle.buttonTitleColor
            
        } else if let button = type.button {
            newButton = button
            newItem = UIBarButtonItem(customView: button)
            
        } else if let view = type.view {
            newItem = UIBarButtonItem(customView: view)
            
        } else if let barButtonItem = type.barButtonItem {
            newItem = barButtonItem
            
        } else {
            let button = UIButton.build(with: type,
                                        target: target,
                                        action: action,
                                        and: colorStyle)
            newItem = UIBarButtonItem(customView: button)
            newButton = button
            newItem.tintColor = colorStyle.buttonTitleColor
        }
        
        systemBarButtonItemsDict[newItem.uniqueIdentifier] = type
        return (newItem, newButton, type.autoDismiss)
    }
    
    internal func getNavBarItemType() -> UIBarButtonItemType? {
        return systemBarButtonItemsDict[uniqueIdentifier]
    }
}
