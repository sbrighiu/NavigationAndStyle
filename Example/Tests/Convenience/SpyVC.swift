//
//  Copyright © 2019 Stefan Brighiu. All rights reserved.
//

import UIKit
@testable import NavigationAndStyle

typealias SpyCallback = (UIBarButtonItemType, Bool)->()
typealias TitleViewButtonSpyCallback = (UINavigationBarItemType)->()

class SpyVC: UIViewController {
    var callback: SpyCallback?
    var titleViewButtonSpyCallback: TitleViewButtonSpyCallback?
    
    override func navBarTitlePressed(with type: UINavigationBarItemType) {
        titleViewButtonSpyCallback?(type)
    }
    
    override func navBarItemPressed(with type: UIBarButtonItemType, isLeft: Bool) {
        callback?(type, isLeft)
    }
    
    var leftButtons: [UIButton?] {
        return self.navigationItem.leftBarButtonItems!.map { $0.button }
    }
    
    var rightButtons: [UIButton?] {
        return self.navigationItem.rightBarButtonItems!.map { $0.button }
    }
}
