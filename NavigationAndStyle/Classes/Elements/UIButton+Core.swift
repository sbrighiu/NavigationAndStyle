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
                               and style: NavigationBarStyle) -> UIButton {
        let newButton = createButton(target: target,
                                     selector: selector,
                                     forEvent: (type as? UIBarButtonItemType) != nil ? .touchDown : .touchUpInside)
        
        newButton.saveItemType(type)
        return newButton.configure(with: style, isLeft: isLeft)
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
    
    @discardableResult internal func configure(with style: NavigationBarStyle, isLeft: Bool?) -> UIButton {
        guard let genericType = genericItemType else { return self }
        
        let targetTitle = genericType.title ?? ""
        
        var shouldAddExtraSpace: Bool = false
        var font: UIFont
        var color: UIColor
        if let isLeft = isLeft, let type = barItemType {
            if let _ = type.image {
                shouldAddExtraSpace = true
            }
            self.contentEdgeInsets = type.contentInsets(forLeftElement: isLeft)
            
            font = style.buttonFont
            color = style.buttonTitleColor
            
        } else if let _ = navItemType {
            font = style.titleFont
            color = style.titleColor
            
        } else {
            logFrameworkError("Button was not configured properly.")
            return self
        }
        
        if let image = genericType.image {
            self.setImage(image, for: .normal)
            self.imageView?.configure(with: style)
        }
        
        var firstLine: String
        var secondLine: String
        if let endlineIndex = targetTitle.firstIndex(of: "\n") {
            let afterIndex = targetTitle.index(after: endlineIndex)
            firstLine = String(targetTitle.prefix(upTo: afterIndex))
            secondLine = String(targetTitle.suffix(from: afterIndex))
        } else {
            firstLine = targetTitle
            secondLine = ""
        }
        
        if !secondLine.isEmpty {
            self.titleLabel?.numberOfLines = 2
        }
        
        if let isLeft = isLeft {
            self.titleLabel?.textAlignment = isLeft ? .left : .right
        } else {
            self.titleLabel?.textAlignment = .center
        }
        
        if shouldAddExtraSpace {
            firstLine.insert(" ", at: targetTitle.startIndex)
            secondLine.insert(" ", at: targetTitle.startIndex)
        }
        
        self.tintColor = color
        
        for (state, color) in [
            (UIControl.State.normal, color),
            (.disabled, style.disabledColor),
            (.highlighted, style.highlightColor(for: color))
            ] {
                let firstLineAttr = [NSAttributedString.Key.font: font,
                                     NSAttributedString.Key.foregroundColor: color]
                
                var secondLineAttr: [NSAttributedString.Key : Any]
                if var attr = genericType.secondLineAttributes {
                    if attr[NSAttributedString.Key.font] == nil {
                        attr[NSAttributedString.Key.font] = font
                    }
                    if attr[NSAttributedString.Key.foregroundColor] == nil {
                        attr[NSAttributedString.Key.foregroundColor] = color
                    }
                    secondLineAttr = attr
                } else {
                    secondLineAttr = firstLineAttr
                }
                
                let attrText = NSMutableAttributedString(string: firstLine, attributes: firstLineAttr)
                attrText.append(NSAttributedString(string: secondLine, attributes: secondLineAttr))
                
                self.setAttributedTitle(attrText, for: state)
        }
        
        return self
    }
}
