//
//  Copyright © 2019 Stefan Brighiu. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    internal static func build(with type: UINavigationBarGenericItem,
                               target: Any?,
                               action selector: Selector?,
                               isLeft: Bool?,
                               and colorStyle: ColorStyle) -> UIButton {
        let newButton = createButton(target: target,
                                     selector: selector,
                                     forEvent: (type as? UIBarButtonItemType) != nil ? .touchDown : .touchUpInside)
        
        newButton.saveItemType(type)
        return newButton.configure(with: colorStyle, isLeft: isLeft)
    }
    
    private static func createButton(target: Any?,
                                     selector: Selector?,
                                     forEvent event: UIControl.Event?) -> UIButton {
        let newButton = UIButton(type: .custom)
        newButton.frame = CGRect(x: 0, y: 0, width: Constants.recommendedItemHeight, height: Constants.recommendedItemHeight)
        
        if let target = target,
            let action = selector,
            let event = event {
            newButton.addTarget(target,
                                action: action,
                                for: event)
        }
        return newButton
    }
    
    @discardableResult internal func configure(with colorStyle: ColorStyle, isLeft: Bool?) -> UIButton {
        guard let genericType = genericItemType else { return self }
        
        var targetTitle = genericType.title ?? ""
        
        var font: UIFont
        var color: UIColor
        if let isLeft = isLeft, let type = barItemType {
            if let image = type.image {
                self.setImage(image, for: .normal)
                self.imageView?.configure(with: colorStyle)
                
                targetTitle.insert(" ", at: targetTitle.startIndex)
            }
            self.contentEdgeInsets = type.contentInsets(forLeftElement: isLeft)
            
            font = colorStyle.buttonFont
            color = colorStyle.buttonTitleColor
            
        } else if let _ = navItemType {
            font = colorStyle.titleFont
            color = colorStyle.titleColor
            
        } else {
            logFrameworkError("Button was not configured properly.")
            return self
        }
        
        self.tintColor = color
        self.setTitle(targetTitle, for: .normal)
        self.titleLabel?.font = font
        self.setTitleColor(color, for: .normal)
        self.setTitleColor(colorStyle.disabledColor, for: .disabled)
        self.setTitleColor(colorStyle.highlightColor(for: color), for: .highlighted)
        
        return self
    }
}
