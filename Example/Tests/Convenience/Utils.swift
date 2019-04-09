//
//  Copyright © 2019 Stefan Brighiu. All rights reserved.
//

import UIKit

extension UIWindow {
    static func makeContextWithVC(buttonCallback: SpyCallback?, titleViewSpyCallback: TitleViewSpyCallback?) -> SpyVC {
        let window = UIWindow()
        let vc = SpyVC()
        vc.callback = buttonCallback
        vc.titleViewSpyCallback = titleViewSpyCallback
        window.rootViewController = vc
        window.makeKeyAndVisible()
        return vc
    }
    
    static func makeContextWithNavC(buttonCallback: SpyCallback?, titleViewSpyCallback: TitleViewSpyCallback?) -> SpyVC {
        let window = UIWindow()
        let vc = SpyVC()
        vc.callback = buttonCallback
        vc.titleViewSpyCallback = titleViewSpyCallback
        let navC = UINavigationController(rootViewController: vc)
        window.rootViewController = navC
        window.makeKeyAndVisible()
        return vc
    }
}

var anyText: String = "anyText"
var otherText: String = "otherText"
var anyImage: UIImage = UIImage()

