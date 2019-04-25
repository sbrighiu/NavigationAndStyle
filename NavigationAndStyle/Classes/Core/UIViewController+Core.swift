//
//  Copyright © 2019 Stefan Brighiu. All rights reserved.
//

import Foundation
import UIKit

protocol NavigationVC {
    var navigationElements: NavigationElementsModel { get }
    var navigationController: UINavigationController? { get }
    
    func triggerColorStyleRefresh(with navBar: UINavigationBar?, navItem: UINavigationItem?)
    
    func set(title: String, left: [UIBarButtonItemType], right: [UIBarButtonItemType], overrideModalSuperview: UIView?) -> (UILabel, [UIButton?], [UIButton?])
    func set(titleButton title: String, left: [UIBarButtonItemType], right: [UIBarButtonItemType], overrideModalSuperview: UIView?) -> (UIButton, [UIButton?], [UIButton?])
    func set(titleCustomView view: UIView, left: [UIBarButtonItemType], right: [UIBarButtonItemType], overrideModalSuperview: UIView?) -> (UIView, [UIButton?], [UIButton?])
    
    func change(titleTo title: String) -> UILabel
    func change(titleToCustomView view: UIView) -> UIView
    func change(titleToButtonWith title: String) -> UIButton
    
    func change(leftNavBarItems items: [UIBarButtonItemType], animated: Bool) -> [UIButton?]
    func change(rightNavBarItems items: [UIBarButtonItemType], animated: Bool) -> [UIButton?]
    
    func shouldAutomaticallyDismissFor(_ navBarItemType: UIBarButtonItemType) -> Bool
}

@objc protocol CanHandleVCNavigationActions {
    func titleViewButtonPressed(with button: UIButton)
    func navBarItemPressed(with type: UIBarButtonItemType, button: UIButton?, isLeft: Bool)
}

private var didSetupDict = [Int: Bool]()

extension UIViewController: NavigationVC {
    
    // MARK - Setup
    public var didSetupCustomNavigationAndStyle: Bool {
        return didSetupDict[uniqueIdentifier] ?? false
    }
    
    private func setupNavigationAndStyle() {
        self.navigationController?.setupNavigationConvenienceSettings(from: self)
        
        getNavigationBar()?.changeToTransparent()
        
        triggerColorStyleRefresh()
        didSetupDict[uniqueIdentifier] = true
    }
    
    func checkSetupStatus() {
        if !didSetupCustomNavigationAndStyle {
            logFrameworkWarning("Always use .set(...) to initialize navigation elements with the ColorStyle chosen.")
        }
    }
    
    // MARK: - Handle initial setup of navigation elements and style
    @discardableResult public func set(title: String,
                                       left: [UIBarButtonItemType] = [],
                                       right: [UIBarButtonItemType] = [],
                                       overrideModalSuperview: UIView? = nil) -> (UILabel, [UIButton?], [UIButton?]) {
        let (leftButtonsGroup, rightButtonsGroup) = set(left: left, right: right, overrideModalSuperview: overrideModalSuperview)
        let titleLabel = change(titleTo: title)
        
        return (titleLabel, leftButtonsGroup, rightButtonsGroup)
    }
    
    @discardableResult public func set(titleButton title: String,
                                       left: [UIBarButtonItemType] = [],
                                       right: [UIBarButtonItemType] = [],
                                       overrideModalSuperview: UIView? = nil) -> (UIButton, [UIButton?], [UIButton?]) {
        let (leftButtonsGroup, rightButtonsGroup) = set(left: left, right: right, overrideModalSuperview: overrideModalSuperview)
        let titleButton = change(titleToButtonWith: title)
        
        return (titleButton, leftButtonsGroup, rightButtonsGroup)
    }
    
    @discardableResult public func set(titleCustomView view: UIView,
                                       left: [UIBarButtonItemType] = [],
                                       right: [UIBarButtonItemType] = [],
                                       overrideModalSuperview: UIView? = nil) -> (UIView, [UIButton?], [UIButton?]) {
        let (leftButtonsGroup, rightButtonsGroup) = set(left: left, right: right, overrideModalSuperview: overrideModalSuperview)
        let customView = change(titleToCustomView: view)
        
        return (customView, leftButtonsGroup, rightButtonsGroup)
    }
    
    private func set(left: [UIBarButtonItemType] = [],
                     right: [UIBarButtonItemType] = [],
                     overrideModalSuperview: UIView? = nil) -> ([UIButton?], [UIButton?]) {
        if let navC = self.navigationController {
            if overrideModalSuperview != nil {
                logFrameworkWarning("Please remove the overrideModalSuperview value when an UINavigationController is present for your UIViewController, because it will not be used.")
            }
            addNavigationBarComplementElements(of: navC)
        } else {
            addOverlayNavigationBarElements(to: overrideModalSuperview ?? self.view)
        }
        setupNavigationAndStyle()
        
        let leftButtonsGroup = change(leftNavBarItems: left)
        let rightButtonsGroup = change(rightNavBarItems: right)
        
        return (leftButtonsGroup, rightButtonsGroup)
    }
    
    // MARK: - Handle changes in titleView
    @discardableResult public func change(titleTo title: String) -> UILabel {
        checkSetupStatus()
        return addLabel(with: title)
    }
    
    @discardableResult public func change(titleToCustomView view: UIView) -> UIView {
        checkSetupStatus()
        return addCustomView(with: view)
    }
    
    @discardableResult public func change(titleToButtonWith title: String) -> UIButton {
        checkSetupStatus()
        return addButton(with: title)
    }
    
    // MARK: - Handle changes in navigation bar items
    @discardableResult public func change(leftNavBarItems items: [UIBarButtonItemType], animated: Bool = true) -> [UIButton?] {
        checkSetupStatus()
        let (barItems, buttons) = get(navBarItems: items, isLeft: true)
        getNavigationItem().setLeftBarButtonItems(barItems, animated: animated)
        return buttons
    }
    
    @discardableResult public func change(rightNavBarItems items: [UIBarButtonItemType], animated: Bool = true) -> [UIButton?] {
        checkSetupStatus()
        let items: [UIBarButtonItemType] = items.reversed()
        let (barItems, buttons) = get(navBarItems: items, isLeft: false)
        getNavigationItem().setRightBarButtonItems(barItems, animated: animated)
        return buttons
    }
    
    // MARK: - Handle actions and button creation
    private func get(navBarItems items: [UIBarButtonItemType], isLeft: Bool) -> ([UIBarButtonItem], [UIButton?]) {
        let colorStyle = getColorStyle()
        var buttons = [UIButton?]()
        var barItems = [UIBarButtonItem]()
        let _: [(UIBarButtonItem, UIButton?, Bool)] = items.map {
            let result = UIBarButtonItem.buildSystemItem(with: $0,
                                                         target: self,
                                                         action: (isLeft
                                                            ? #selector(pressedLeft(item:))
                                                            : #selector(pressedRight(item:))),
                                                         isLeft: isLeft,
                                                         and: colorStyle)
            barItems.append(result.0)
            buttons.append(result.1)
            return result
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
        logFrameworkError("Failed to get type for left button")
    }
    
    @objc internal func pressedRight(item: Any) {
        if let button = item as? UIButton, let type = button.getNavBarItemType() {
            navBarItemPressed(with: type, button: button, isLeft: false)
            return
        } else if let item = item as? UIBarButtonItem, let type = item.getNavBarItemType() {
            navBarItemPressed(with: type, button: nil, isLeft: false)
            return
        }
        logFrameworkError("Failed to get type for right button")
    }
}

// MARK: - Handle taps
extension UIViewController: CanHandleVCNavigationActions {
    open func titleViewButtonPressed(with button: UIButton) {
        assert(false, "Please implement titleViewButtonPressed(with:) in your UIViewController")
    }
    
    open func navBarItemPressed(with type: UIBarButtonItemType, button: UIButton?, isLeft: Bool) {
        if shouldAutomaticallyDismissFor(type) { return }
        assert(false, "Please implement navBarItemPressed(with:button:isLeft:) in your UIViewController for \(type)")
    }
    
    public func shouldAutomaticallyDismissFor(_ navBarItemType: UIBarButtonItemType) -> Bool {
        if navBarItemType.autoDismiss {
            guard let navC = self.navigationController else {
                dismiss(animated: true)
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

// MARK: - Handle ColorStyle refresh
extension UIViewController {
    
    open func triggerColorStyleRefresh(with navBar: UINavigationBar? = nil, navItem: UINavigationItem? = nil) {
        triggerColorStyleRefreshAction(with: navBar, navItem: navItem)
    }
    
    public func triggerColorStyleRefreshAction(with navBar: UINavigationBar?, navItem: UINavigationItem?) {
        let colorStyle = getColorStyle()
        
        let navItem = getNavigationItem(overrideIfExists: navItem)
        guard let navBar = self.getNavigationBar(overrideIfExists: navBar) else {
            logFrameworkError("No navigation bar present to configure bar style for!")
            return
        }
        
        navBar.barStyle = colorStyle.barStyle
        updateUI(of: navBar, navItem: navItem, with: colorStyle)
    }
    
    internal func updateUI(of navBar: UINavigationBar, navItem: UINavigationItem, with colorStyle: ColorStyle) {
        // Setup background using the mask
        if let maskView = navigationElements.backgroundImageView {
            if maskView.backgroundColor != colorStyle.background {
                maskView.backgroundColor = colorStyle.background
            }
            if maskView.image != colorStyle.backgroundImage {
                maskView.image = colorStyle.backgroundImage
            }
        }
        
        if let hairlineView = navigationElements.hairlineSeparatorView, hairlineView.backgroundColor != colorStyle.hairlineSeparatorColor {
            hairlineView.backgroundColor = colorStyle.hairlineSeparatorColor
        }
        
        if let shadowView = navigationElements.shadowBackgroundView, shadowView.tintColor != colorStyle.shadow  {
            shadowView.tintColor = colorStyle.shadow
        }
        
        // Update buttons
        let updateBarButtonItemsBlock: ((UIBarButtonItem, Bool)->()) = { item, isLeft in
            if let type = item.getNavBarItemType() {
                if type.barButtonItem != nil { return }
                if type.button != nil { return }
            }
            item.tintColor = colorStyle.buttonTitleColor
            item.button?.configure(with: colorStyle, isLeft: isLeft)
        }
        
        navItem.leftBarButtonItems?.forEach({ updateBarButtonItemsBlock($0, true) })
        navItem.rightBarButtonItems?.forEach({ updateBarButtonItemsBlock($0, false) })
    }
}
