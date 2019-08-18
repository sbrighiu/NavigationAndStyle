//
//  Copyright © 2019 Stefan Brighiu. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    internal func getNavigationBar(overrideIfExists navBar: UINavigationBar? = nil) -> UINavigationBar? {
        return navBar ?? self.navigationController?.navigationBar
    }
    
    internal func getNavigationItem(overrideIfExists navItem: UINavigationItem? = nil) -> UINavigationItem {
        return navItem ?? self.navigationItem
    }
}

//    internal func addShadowView(to superView: UIView) -> UIImageView? {
//        let shadowView = UIImageView()
//        shadowView.backgroundColor = .clear
//        shadowView.contentMode = .scaleToFill
//        shadowView.clipsToBounds = true
//        shadowView.image = NavigationBarStyle.Defaults.backgroundShadow
//        shadowView.tintColor = getNavigationBarStyle().shadow
//        shadowView.isUserInteractionEnabled = false
//
//        navigationElements.shadowBackgroundView = shadowView
//
//        superView.insertSubview(shadowView, at: 0)
//        shadowView.translatesAutoresizingMaskIntoConstraints = false
//
//        NSLayoutConstraint.activate([
//            shadowView.topAnchor.constraint(equalTo: superView.topAnchor),
//            shadowView.leadingAnchor.constraint(equalTo: superView.leadingAnchor),
//            shadowView.trailingAnchor.constraint(equalTo: superView.trailingAnchor),
//            ])
//
//        return shadowView
//    }

// MARK: - Handle titleView
extension UIViewController {
    internal func addButtonTitleView(with type: UINavigationBarItemType) {
        var target: Any?
        var selector: Selector?
        if type.isTappable {
            target = self
            selector = #selector(pressedNavTitle)
        }
        
        let button = UIButton.build(with: type,
                                    target: target,
                                    action: selector,
                                    isLeft: nil,
                                    and: getNavigationBarStyle())
        
        if !type.isTappable {
            button.isUserInteractionEnabled = false
        }
        
        getNavigationItem().titleView = button
    }
    
    internal func addTitleImageView(with type: UINavigationBarItemType) {
        var target: Any?
        var selector: Selector?
        if type.isTappable {
            target = self
            selector = #selector(pressedNavTitle)
        }
        
        let imageView = UIImageView.build(with: type,
                                          target: target,
                                          action: selector,
                                          and: getNavigationBarStyle())
        
        getNavigationItem().titleView = imageView
    }

}
