//
//  Copyright © 2019 Stefan Brighiu. All rights reserved.
//

import Foundation
import UIKit

private var barButtonItemsDict = [Int: NavBarItemType]()

extension UIButton: Identifiable {
    internal static func build(with type: NavBarItemType,
                               target: Any,
                               action: Selector,
                               and colorStyle: ColorStyle?) -> UIButton {
        let newButton = UIButton(type: .custom)
        newButton.frame = Constants.defaultFrame
        
        newButton.addTarget(target,
                            action: action,
                            for: .touchDown)
        
        barButtonItemsDict[newButton.uniqueIdentifier] = type
        return newButton.configure(with: colorStyle)
    }
    
    @discardableResult internal func configure(with colorStyle: ColorStyle?) -> UIButton {
        guard let type = getNavBarItemType() else { return self }
        
        if let image = type.image {
            self.setImage(image, for: .normal)
            self.imageView?.contentMode = .scaleAspectFit
            self.imageView?.clipsToBounds = true
            
            if let colorStyle = colorStyle {
                self.imageView?.tintColor = colorStyle.imageTint
            } else {
                self.imageView?.tintColor = ColorStyle.Defaults.systemBarButtonItemTint
            }
        }
        self.contentEdgeInsets = type.contentEdgeInsets
        self.setTitle(type.title ?? "", for: .normal)
        
        if let colorStyle = colorStyle {
            self.setTitleColor(colorStyle.buttonTitleColor, for: .normal)
            self.setTitleColor(colorStyle.disabledColor, for: .disabled)
            self.setTitleColor(colorStyle.buttonTitleColor.withAlphaComponent(ColorStyle.Defaults.alphaWhenTapped), for: .highlighted)
            self.titleLabel?.font = colorStyle.buttonFont
        } else {
            self.setTitleColor(ColorStyle.Defaults.systemBarButtonItemTint, for: .normal)
            self.setTitleColor(ColorStyle.Defaults.systemBarButtonItemTint, for: .disabled)
            self.setTitleColor(ColorStyle.Defaults.systemBarButtonItemTint.withAlphaComponent(ColorStyle.Defaults.alphaWhenTapped), for: .highlighted)
        }
        return self
    }
    
    internal func getNavBarItemType() -> NavBarItemType? {
        return barButtonItemsDict[uniqueIdentifier]
    }
}
