//
//  Copyright © 2019 Stefan Brighiu. All rights reserved.
//

import Foundation
import UIKit

protocol NavigationVC {
    var navigationElements: NavigationElementsModel { get }
    var navigationController: UINavigationController? { get }
    
    func triggerColorStyleRefresh(with navBar: UINavigationBar?, navItem: UINavigationItem?)
    
    func set(title: UINavigationBarItemType, leftItems: [UIBarButtonItemType], rightItems: [UIBarButtonItemType], overrideModalSuperview: UIView?)
    
    func change(title type: UINavigationBarItemType)
    func change(leftItems items: [UIBarButtonItemType], animated: Bool)
    func change(rightItems items: [UIBarButtonItemType], animated: Bool)
    
    func shouldAutomaticallyDismissFor(_ navBarItemType: UINavigationBarGenericItem) -> Bool
}

@objc protocol CanHandleVCNavigationActions {
    func navBarTitlePressed(with type: UINavigationBarItemType)
    func navBarItemPressed(with type: UIBarButtonItemType, isLeft: Bool)
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
    public func set(title type: UINavigationBarItemType = .title(""),
                    leftItems: [UIBarButtonItemType] = [],
                    rightItems: [UIBarButtonItemType] = [],
                    overrideModalSuperview: UIView? = nil) {
        if let navC = self.navigationController {
            if overrideModalSuperview != nil {
                logFrameworkWarning("Please remove the overrideModalSuperview value when an UINavigationController is present for your UIViewController, because it will not be used.")
            }
            addNavigationBarComplementElements(of: navC)
        } else {
            addOverlayNavigationBarElements(to: overrideModalSuperview ?? self.view)
        }
        setupNavigationAndStyle()
        
        change(title: type)
        change(leftItems: leftItems)
        change(rightItems: rightItems)
    }
    
    // MARK: - Handle changes in titleView
    public func change(title type: UINavigationBarItemType) {
        checkSetupStatus()
        
        let colorStyle = getColorStyle()
        
        var button: UIButton?
        var imageView: UIImageView?
        if let _ = type.title {
            var target: Any?
            var selector: Selector?
            if type.isTappable {
                target = self
                selector = #selector(pressedNavTitle)
            }
            
            button = UIButton.build(with: type,
                                    target: target,
                                    action: selector,
                                    isLeft: nil,
                                    and: getColorStyle())
            imageView = button?.imageView
            
            if !type.isTappable {
                button?.isUserInteractionEnabled = false
                imageView?.isUserInteractionEnabled = false
            }
            
        } else if let image = type.image {
            imageView = UIImageView(image: image)
            imageView?.setup(with: colorStyle)
            imageView?.saveItemType(type)
            
            if type.isTappable {
                let gesture = UITapGestureRecognizer(target: self, action: #selector(pressedNavTitle))
                imageView?.addGestureRecognizer(gesture)
                imageView?.isUserInteractionEnabled = true
            }
        }
        
        navigationElements.titleImageView = imageView
        navigationElements.titleViewButton = button
        
        getNavigationItem().titleView = button ?? imageView
    }
    
    // MARK: - Handle changes in navigation bar items
    public func change(leftItems items: [UIBarButtonItemType], animated: Bool = true) {
        checkSetupStatus()
        if items.count == 0 {
            getNavigationItem().hidesBackButton = true
        }
        getNavigationItem().setLeftBarButtonItems(get(navBarItems: items, isLeft: true), animated: animated)
    }
    
    public func change(rightItems items: [UIBarButtonItemType], animated: Bool = true) {
        checkSetupStatus()
        getNavigationItem().setRightBarButtonItems(get(navBarItems: items.reversed(), isLeft: false), animated: animated)
    }
    
    // MARK: - Handle actions and button creation
    private func get(navBarItems items: [UIBarButtonItemType], isLeft: Bool) -> [UIBarButtonItem] {
        let colorStyle = getColorStyle()
        return items.map {
            return UIBarButtonItem.buildSystemItem(with: $0,
                                                   target: self,
                                                   action: (isLeft
                                                    ? #selector(pressedNavLeft(item:))
                                                    : #selector(pressedNavRight(item:))),
                                                   isLeft: isLeft,
                                                   and: colorStyle).0
        }
    }
    
    @objc internal func pressedNavLeft(item: Any) {
        if let item = item as? IsNavigationBarItem, let type = item.barItemType {
            navBarItemPressed(with: type, isLeft: true)
            return
        }
        logFrameworkError("Failed to get type for left button action")
    }
    
    @objc internal func pressedNavRight(item: Any) {
        if let item = item as? IsNavigationBarItem, let type = item.barItemType {
            navBarItemPressed(with: type, isLeft: false)
            return
        }
        logFrameworkError("Failed to get type for right button action")
    }
    
    @objc internal func pressedNavTitle() {
        let titleView = navigationElements.titleViewButton ?? navigationElements.titleImageView
        if let type = titleView?.navItemType {
            navBarTitlePressed(with: type)
            return
        }
        logFrameworkError("Failed to get type for title action")
    }
}

// MARK: - Handle taps
extension UIViewController: CanHandleVCNavigationActions {
    open func navBarTitlePressed(with type: UINavigationBarItemType) {
        if shouldAutomaticallyDismissFor(type) { return }
        assert(false, "Please implement navBarTitlePressed(with:) in your UIViewController")
    }
    
    open func navBarItemPressed(with type: UIBarButtonItemType, isLeft: Bool) {
        if shouldAutomaticallyDismissFor(type) { return }
        assert(false, "Please implement navBarItemPressed(with:button:isLeft:) in your UIViewController for \(type)")
    }
    
    public func shouldAutomaticallyDismissFor(_ navBarItemType: UINavigationBarGenericItem) -> Bool {
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
            guard let _ = item.barItemType else { return }
            
            item.button?.configure(with: colorStyle, isLeft: isLeft)
        }
        
        navItem.leftBarButtonItems?.forEach({ updateBarButtonItemsBlock($0, true) })
        navItem.rightBarButtonItems?.forEach({ updateBarButtonItemsBlock($0, false) })
        
        // Update titleView
        navigationElements.titleViewButton?.configure(with: colorStyle, isLeft: nil)
        navigationElements.titleImageView?.tintColor = colorStyle.imageTint
    }
}
