//
//  Copyright © 2019 Stefan Brighiu. All rights reserved.
//

import Foundation
import UIKit

protocol NavigationVCBase {
    var navigationController: UINavigationController? { get }
    
    func refreshNavigationElements(with navBar: UINavigationBar?, navItem: UINavigationItem?, animated: Bool)
    func updateBarStyle(of navBar: UINavigationBar, navItem: UINavigationItem, with colorStyle: ColorStyle?)
    func updateUI(of navBar: UINavigationBar, navItem: UINavigationItem, with colorStyle: ColorStyle?)
}

protocol NavigationVC: NavigationVCBase {
    func set(title: String, left: [NavBarItemType], right: [NavBarItemType], overrideModalSuperview: UIView?) -> (UILabel, [UIButton?], [UIButton?], UINavigationBar, UIImageView, UIImageView?)
    
    func change(titleToSearchBarWithPlaceholder placeholder: String) -> UISearchBar
    func change(titleToImageViewWithImage image: UIImage?) -> UIImageView
    func change(titleToButtonWithTitle title: String, andImage image: UIImage?) -> UIButton
    func change(titleTo title: String) -> UILabel
    
    func change(leftNavBarItems items: [NavBarItemType], animated: Bool) -> [UIButton?]
    func change(rightNavBarItems items: [NavBarItemType], animated: Bool) -> [UIButton?]
    
    func shouldAutomaticallyDismissFor(_ navBarItemType: NavBarItemType) -> Bool
}

@objc protocol NavigationVCActions {
    func titleViewButtonPressed(with button: UIButton)
    func navBarItemPressed(with type: NavBarItemType, button: UIButton?, isLeft: Bool)
}

private var didSetupDict = [Int: Bool]()

extension UIViewController: NavigationVC {
    
    // MARK - Setup
    public var didSetupCustomNavigationAndStyle: Bool {
        return didSetupDict[uniqueIdentifier] ?? false
    }
    
    private func setupNavigationAndStyle() {
        let colorStyle = getColorStyle()
        if colorStyle != nil, let navBar = self.getNavigationBar() {
            makeNavigationBarTransparent(navBar)
        }
        
        if let navC = self.navigationController {
            navC.setupNavigationConvenienceSettings()
            
        } else if colorStyle == nil, let navBar = self.getNavigationBar() {
            makeNavigationBarTransparent(navBar)
        }
        
        refreshNavigationElements(animated: false)
        didSetupDict[uniqueIdentifier] = true
    }
        
        private func makeNavigationBarTransparent(_ navBar: UINavigationBar?) {
            navBar?.isTranslucent = true
            navBar?.shadowImage = UIImage()
            
            navBar?.backgroundColor = .clear
            navBar?.barTintColor = .clear
            navBar?.setBackgroundImage(UIImage(), for: .default)
        }
    
    // MARK: - Handle changes in navigation bar items
    @discardableResult public func change(titleToSearchBarWithPlaceholder placeholder: String) -> UISearchBar {
        let searchBar = addSearchBarInTitleView(with: placeholder)
        return searchBar
    }
    
    @discardableResult public func change(titleToImageViewWithImage image: UIImage?) -> UIImageView {
        let imageView = addImageView(with: image)
        return imageView
    }
    
    @discardableResult public func change(titleToButtonWithTitle title: String, andImage image: UIImage? = nil) -> UIButton {
        let button = addButton(with: title, and: image)
        return button
    }
    
    @discardableResult public func change(titleTo title: String) -> UILabel {
        let label = addLabel(with: title)
        getNavigationItem().titleView = label
        return label
    }
    
    @discardableResult public func change(leftNavBarItems items: [NavBarItemType], animated: Bool = true) -> [UIButton?] {
        let (barItems, buttons) = get(navBarItems: items, isLeft: true)
        getNavigationItem().setLeftBarButtonItems(barItems, animated: animated)
        return buttons
    }
    
    @discardableResult public func change(rightNavBarItems items: [NavBarItemType], animated: Bool = true) -> [UIButton?] {
        let items: [NavBarItemType] = items.reversed()
        let (barItems, buttons) = get(navBarItems: items, isLeft: false)
        getNavigationItem().setRightBarButtonItems(barItems, animated: animated)
        return buttons
    }
    
    // MARK: - Handle refresh
    public func refreshNavigationElements(with navBar: UINavigationBar? = nil, navItem: UINavigationItem? = nil, animated: Bool = true) {
        let duration = self.navigationController?.getAnimatedElementsUpdateDuration() ?? Constants.defaultAnimationTime
        refeshNavigationElementsAction(with: navBar, navItem: navItem, duration: animated ? duration : 0)
    }
    
    // MARK: - Handle actions and button creation
    private func get(navBarItems items: [NavBarItemType], isLeft: Bool) -> ([UIBarButtonItem], [UIButton?]) {
        let colorStyle = getColorStyle()
        let newItems: [(UIBarButtonItem, UIButton?, Bool)] = items.compactMap({
            return UIBarButtonItem.buildSystemItem(with: $0,
                                                   target: self,
                                                   action: (isLeft
                                                    ? #selector(pressedLeft(item:))
                                                    : #selector(pressedRight(item:))),
                                                   isLeft: isLeft,
                                                   and: colorStyle)
        })
        var buttons = [UIButton?]()
        let barItems: [UIBarButtonItem] = newItems.map {
            buttons.append($0.1)
            return $0.0
        }
        
        return (barItems, buttons)
    }
    
    @objc internal func pressedLeft(item: Any) {
        if let button = item as? UIButton, let type = button.getNavBarItemType() {
            navBarItemPressed(with: type, button: button, isLeft: true)
            return
        } else if let item = item as? UIBarButtonItem, let type = item.getNavBarItemType() {
            navBarItemPressed(with: type, button: nil, isLeft: true)
            return
        }
        logFrameworkWarning("Failed to get type for left button")
    }
    
    @objc internal func pressedRight(item: Any) {
        if let button = item as? UIButton, let type = button.getNavBarItemType() {
            navBarItemPressed(with: type, button: button, isLeft: false)
            return
        } else if let item = item as? UIBarButtonItem, let type = item.getNavBarItemType() {
            navBarItemPressed(with: type, button: nil, isLeft: false)
            return
        }
        logFrameworkWarning("Failed to get type for right button")
    }
}

// MARK: - Setup
extension UIViewController {
    
    @discardableResult public func set(title: String,
                                       left: [NavBarItemType] = [],
                                       right: [NavBarItemType] = [],
                                       overrideModalSuperview: UIView? = nil) -> (UILabel, [UIButton?], [UIButton?], UINavigationBar, UIImageView, UIImageView?) {
        var shadowView: UIImageView?
        let maskView: UIImageView
        let navigationBar: UINavigationBar
        if let navC = self.navigationController {
            if overrideModalSuperview != nil {
                logFrameworkWarning("Please remove the overrideModalSuperview value when an UINavigationController is present for your UIViewController, because it will not be used.")
            }
            (navigationBar, maskView, shadowView) = addNavigationBarComplementElements(of: navC)
        } else {
            (navigationBar, maskView, shadowView) = addOverlayNavigationBarElements(to: overrideModalSuperview ?? self.view)
        }
        
        let titleLabel = change(titleTo: title)
        let leftButtonsGroup = change(leftNavBarItems: left)
        let rightButtonsGroup = change(rightNavBarItems: right)
        
        setupNavigationAndStyle()
        
        return (titleLabel, leftButtonsGroup, rightButtonsGroup, navigationBar, maskView, shadowView)
    }
    
}

extension UIViewController: NavigationVCActions {
    open func titleViewButtonPressed(with button: UIButton) {
        assert(false, "Please implement titleViewButtonPressed(with:) in your UIViewController")
    }
    
    open func navBarItemPressed(with type: NavBarItemType, button: UIButton?, isLeft: Bool) {
        if shouldAutomaticallyDismissFor(type) { return }
        assert(false, "Please implement navBarItemPressed(with:button:isLeft:) in your UIViewController for \(type)")
    }
    
    public func shouldAutomaticallyDismissFor(_ navBarItemType: NavBarItemType) -> Bool {
        if navBarItemType.autoDismiss {
            guard let navC = self.navigationController else {
                self.dismiss(animated: true)
                return true
            }
            if navC.viewControllers.count == 1 {
                navC.dismiss(animated: true)
                return true
            }
            navC.popViewController(animated: true)
            return true
        }
        return false
    }
}

extension UIViewController {
    internal func refeshNavigationElementsAction(with navBar: UINavigationBar?, navItem: UINavigationItem?, duration: TimeInterval) {
        let navItem = getNavigationItem(overrideIfExists: navItem)
        guard let navBar = self.getNavigationBar(overrideIfExists: navBar) else {
            logFrameworkError("No navigation bar present to configure bar style for!")
            return
        }
        
        let colorStyle = getColorStyle()
        updateBarStyle(of: navBar, navItem: navItem, with: colorStyle)
        
        UIView.transition(with: navBar,
                          duration: duration,
                          options: [
                            .beginFromCurrentState,
                            .allowAnimatedContent,
                            .transitionCrossDissolve
            ], animations: {
                self.updateUI(of: navBar, navItem: navItem, with: colorStyle)
        }, completion: nil)
    }
    
    internal func updateBarStyle(of navBar: UINavigationBar, navItem: UINavigationItem, with colorStyle: ColorStyle?) {
        guard let navBar = self.getNavigationBar(overrideIfExists: navBar) else {
            logFrameworkError("No navigation bar present to configure bar style for!")
            return
        }
        if let colorStyle = colorStyle {
            navBar.barStyle = colorStyle.barStyle
        }
        
        // Allow for more customizability
        extraNonAnimationBlock(navBar: navBar, navItem: navItem)
    }
    
    internal func updateUI(of navBar: UINavigationBar, navItem: UINavigationItem, with colorStyle: ColorStyle?) {
        guard let navigationBar = self.getNavigationBar(overrideIfExists: navBar) else {
            logFrameworkError("No navigation bar present to configure bar style for!")
            return
        }
        
        // Setup search bar
        setAppearance(for: getTitleSearchBar())
        setAppearance(for: getNavigationItem().searchController?.searchBar) // TODO: - handle .configure() somehow
        
        if let colorStyle = colorStyle {
            // Setup background using the mask
            getMaskView()?.backgroundColor = colorStyle.background
            getMaskView()?.image = colorStyle.backgroundImage
            
            // Setup title attributes
            navigationBar.titleTextAttributes = colorStyle.titleAttr
            
            // Update buttons
            let updateBarButtonItemsBlock: ((UIBarButtonItem)->()) = { item in
                item.tintColor = colorStyle.buttonTitleColor
                item.button?.configure(with: colorStyle)
            }
            
            navItem.leftBarButtonItems?.forEach(updateBarButtonItemsBlock)
            navItem.rightBarButtonItems?.forEach(updateBarButtonItemsBlock)
        }
        
        // Allow for more customizability
        extraAnimationBlock(navBar: navBar, navItem: navItem)
    }
    
    open func extraAnimationBlock(navBar: UINavigationBar, navItem: UINavigationItem) {
        // Meant to be overriden
    }
    
    open func extraNonAnimationBlock(navBar: UINavigationBar, navItem: UINavigationItem) {
        // Meant to be overriden
    }
}
