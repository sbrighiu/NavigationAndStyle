//
//  Copyright © 2019 Stefan Brighiu. All rights reserved.
//

import Foundation
import UIKit

private var barButtonItemsDict = [Int: NavBarItemType]()

extension UIButton: Identifiable {
    internal static func build(with type: NavBarItemType,
                               initialFrame: CGRect,
                               and colorStyle: ViewControllerColorStyle) -> UIButton {
        let newButton = UIButton(type: .custom)
        newButton.frame = initialFrame
        newButton.setNavBarItemType(to: type)
        return newButton.configure(with: colorStyle)
    }
    
    @discardableResult internal func configure(with colorStyle: ViewControllerColorStyle) -> UIButton {
        guard let type = getNavBarItemType() else { return self }
        
        if let image = type.image {
            self.setImage(image, for: .normal)
            self.imageView?.tintColor = colorStyle.imageTint
            self.imageView?.contentMode = .scaleAspectFit
            self.imageView?.clipsToBounds = true
        }
        self.contentEdgeInsets = type.contentEdgeInsets
        self.setTitle(type.title ?? "", for: .normal)
        self.setTitleColor(colorStyle.buttonTint, for: .normal)
        self.setTitleColor(colorStyle.disabledTint, for: .disabled)
        self.setTitleColor(colorStyle.buttonTint.withAlphaComponent(ViewControllerColorStyle.Constants.defaultAlphaWhenTapped), for: .highlighted)
        self.titleLabel?.font = colorStyle.buttonFont
        self.sizeToFit()
        
        return self
    }
    
    internal func setNavBarItemType(to type: NavBarItemType) {
        barButtonItemsDict[uniqueIdentifier] = type
    }
    
    internal func getNavBarItemType() -> NavBarItemType? {
        return barButtonItemsDict[uniqueIdentifier]
    }
}
