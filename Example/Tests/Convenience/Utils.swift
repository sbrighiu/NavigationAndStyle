//
//  Copyright © 2019 Stefan Brighiu. All rights reserved.
//

import UIKit
@testable import NavigationAndStyle

extension UIWindow {
    static func makeContextWithVC(buttonCallback: SpyCallback?, titleViewButtonSpyCallback: TitleViewButtonSpyCallback?) -> SpyVC {
        let window = UIWindow()
        let vc = SpyVC()
        vc.callback = buttonCallback
        vc.titleViewButtonSpyCallback = titleViewButtonSpyCallback
        window.rootViewController = vc
        window.makeKeyAndVisible()
        return vc
    }
    
    static func makeContextWithNavC(buttonCallback: SpyCallback?, titleViewButtonSpyCallback: TitleViewButtonSpyCallback?) -> SpyVC {
        let window = UIWindow()
        let vc = SpyVC()
        vc.callback = buttonCallback
        vc.titleViewButtonSpyCallback = titleViewButtonSpyCallback
        let navC = UINavigationController(rootViewController: vc)
        window.rootViewController = navC
        window.makeKeyAndVisible()
        return vc
    }
}

let anyText: String = "anyText"
let otherText: String = "otherText"
let anyImage: UIImage = UIImage()
let anyBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: nil, action: nil)
let anyView = UIView()
let anyButton = UIButton()

let anyTitleItem = UINavigationBarItemType.label(anyText)
let anyTitleItemButton = UINavigationBarItemType.button(anyText)
let anyOtherTitleItem = UINavigationBarItemType.label(otherText)
let anyOtherTitleItemButton = UINavigationBarItemType.button(otherText)
