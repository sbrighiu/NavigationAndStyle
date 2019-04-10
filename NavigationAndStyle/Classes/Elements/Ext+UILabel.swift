//
//  Copyright © 2019 Stefan Brighiu. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    internal static func build(with string: String,
                               and colorStyle: ColorStyle?) -> UILabel {
        let newLabel = UILabel(frame: Constants.defaultFrame)
        newLabel.text = string
        
        if let colorStyle = colorStyle {
            newLabel.textColor = colorStyle.titleColor
            newLabel.font = colorStyle.titleFont
        } else {
            newLabel.textColor = ColorStyle.Defaults.systemBarButtonItemTint
        }
        return newLabel
    }
}
