//
//  Copyright © 2019 Stefan Brighiu. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    internal static func build(with string: String,
                               initialFrame: CGRect,
                               and colorStyle: ViewControllerColorStyle) -> UILabel {
        let newLabel = UILabel(frame: initialFrame)
        newLabel.text = string
        newLabel.textColor = colorStyle.titleTint
        newLabel.font = colorStyle.titleFont
        newLabel.sizeToFit()
        
        return newLabel
    }
}
