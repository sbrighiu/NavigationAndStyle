//
//  Copyright © 2019 Stefan Brighiu. All rights reserved.
//

import UIKit
import NavigationAndStyle

typealias SpyCallback = (UIBarButtonItemType, UIButton?, Bool)->()
typealias TitleViewButtonSpyCallback = (UIButton)->()

class SpyVC: UIViewController {
    var callback: SpyCallback?
    var titleViewButtonSpyCallback: TitleViewButtonSpyCallback?
    
    override func navBarItemPressed(with type: UIBarButtonItemType, button: UIButton?, isLeft: Bool) {
        callback?(type, button, isLeft)
    }
    
    override func titleViewButtonPressed(with button: UIButton) {
        titleViewButtonSpyCallback?(button)
    }
}
