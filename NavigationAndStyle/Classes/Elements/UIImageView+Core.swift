//
//  Copyright © 2019 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    internal static func build(with type: UINavigationBarGenericItem,
                               target: Any?,
                               action selector: Selector?,
                               and style: NavigationBarStyle) -> UIImageView {
        let newImage = createImageView(target: target,
                                       selector: selector)
        
        newImage.saveItemType(type)
        return newImage.configure(with: style)
    }
    
    private static func createImageView(target: Any?, selector: Selector?) -> UIImageView {
        let newImage = UIImageView()
        newImage.frame = CGRect(x: 0, y: 0, width: Constants.recommendedItemHeight, height: Constants.recommendedItemHeight)
        
        if let target = target,
            let selector = selector {
            let gesture = UITapGestureRecognizer(target: target, action: selector)
            newImage.addGestureRecognizer(gesture)
            newImage.isUserInteractionEnabled = true
        }
        return newImage
    }
    
    @discardableResult internal func configure(with style: NavigationBarStyle) -> UIImageView {
        if let image = self.navItemType?.image {
            self.image = image
        }
        
        self.contentMode = .scaleAspectFit
        self.clipsToBounds = true
        self.tintColor = style.imageTint
        
        return self
    }
}
