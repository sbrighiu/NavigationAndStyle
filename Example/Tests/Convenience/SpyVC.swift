//
//  Copyright © 2019 Stefan Brighiu. All rights reserved.
//

import UIKit
import NavigationAndStyle

typealias SpyCallback = (UIBarButtonItemType, UIButton?, Bool)->()
typealias TitleViewSpyCallback = (UIButton)->()

class SpyVC: UIViewController {
    var callback: SpyCallback?
    var titleViewSpyCallback: TitleViewSpyCallback?
    
    override func navBarItemPressed(with type: UIBarButtonItemType, button: UIButton?, isLeft: Bool) {
        callback?(type, button, isLeft)
    }
    
    override func titleViewButtonPressed(with button: UIButton) {
        titleViewSpyCallback?(button)
    }
}
