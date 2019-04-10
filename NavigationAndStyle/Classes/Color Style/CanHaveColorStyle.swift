//
//  Copyright © 2019 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation
import UIKit

@objc protocol CanHaveColorStyle {
    func getColorStyle() -> ColorStyle?
}

extension UIViewController: CanHaveColorStyle {
    open func getColorStyle() -> ColorStyle? {
        return ColorStyle.Defaults.globalStyle ??
                splitViewController?.getColorStyle() ??
                tabBarController?.getColorStyle() ??
                navigationController?.getColorStyle()
    }
}
