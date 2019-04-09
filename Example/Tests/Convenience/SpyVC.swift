//
//  Copyright © 2019 Stefan Brighiu. All rights reserved.
//

import Foundation
import UIKit
import NavigationAndStyle

typealias SpyCallback = (NavBarItemType, UIButton?, Bool)->()
typealias TitleViewSpyCallback = (UIButton)->()

class SpyVC: UIViewController {
    var callback: SpyCallback?
    var titleViewSpyCallback: TitleViewSpyCallback?
    
    override func navBarItemPressed(with type: NavBarItemType, button: UIButton?, isLeft: Bool) {
        callback?(type, button, isLeft)
    }
    
    override func titleViewButtonPressed(with button: UIButton) {
        titleViewSpyCallback?(button)
    }
}
