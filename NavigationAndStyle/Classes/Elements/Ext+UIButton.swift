//
//  Copyright © 2019 Stefan Brighiu. All rights reserved.
//

import Foundation
import UIKit

private var barButtonItemsDict = [Int: UIBarButtonItemType]()

extension UIButton: Identifiable {
    internal static func build(with type: UIBarButtonItemType,
                               target: Any,
                               action: Selector,
                               and colorStyle: ColorStyle) -> UIButton {
        let newButton = UIButton(type: .custom)
        newButton.frame = Constants.defaultFrame
        
        newButton.addTarget(target,
                            action: action,
                            for: .touchDown)
        
        barButtonItemsDict[newButton.uniqueIdentifier] = type
        return newButton.configure(with: colorStyle)
    }
    
    @discardableResult internal func configure(with colorStyle: ColorStyle) -> UIButton {
        guard let type = getNavBarItemType() else { return self }
        
        if let image = type.image {
            self.setImage(image, for: .normal)
            self.imageView?.contentMode = .scaleAspectFit
            self.imageView?.clipsToBounds = true
            self.imageView?.tintColor = colorStyle.imageTint
        }
        self.contentEdgeInsets = type.contentEdgeInsets
            
        self.setTitle(type.title ?? "", for: .normal)
        self.titleLabel?.font = colorStyle.buttonFont
        self.setTitleColor(colorStyle.buttonTitleColor, for: .normal)
        self.setTitleColor(colorStyle.disabledColor, for: .disabled)
        self.setTitleColor(colorStyle.highlightColor(for: colorStyle.buttonTitleColor), for: .highlighted)
        
        return self
    }
    
    internal func getNavBarItemType() -> UIBarButtonItemType? {
        return barButtonItemsDict[uniqueIdentifier]
    }
}
