//
//  Copyright © 2019 Stefan Brighiu. All rights reserved.
//

import Foundation
import UIKit

protocol NavigationVC {
    var navigationElements: NavigationVCModel { get }
    var navigationController: UINavigationController? { get }
    
    func triggerColorStyleRefresh(with navBar: UINavigationBar?, navItem: UINavigationItem?)
    
    func set(title: UINavigationBarItemType, leftItems: [UIBarButtonItemType], rightItems: [UIBarButtonItemType])
    
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
        self.navigationController?.setupNavigationConvenienceSettings()
        
        getNavigationBar()?.setupAndChangeToTransparent()
        
        triggerColorStyleRefresh()
        didSetupDict[uniqueIdentifier] = true
    }
    
    internal func checkSetupStatus() {
        if !didSetupCustomNavigationAndStyle {
            logFrameworkWarning("Always use .set(...) to initialize navigation elements with the ColorStyle chosen.")
        }
    }
    
    // MARK: - Handle initial setup of navigation elements and style
    public func set(title type: UINavigationBarItemType = .label(""),
                    leftItems: [UIBarButtonItemType] = [],
                    rightItems: [UIBarButtonItemType] = []) {
        if let navC = self.navigationController {
            addNavigationBarComplementElements(of: navC)
        } else {
            addOverlayNavigationBarElements(to: self.view)
        }
        setupNavigationAndStyle()
        
        change(title: type)
        change(leftItems: leftItems)
        change(rightItems: rightItems)
    }
    
    // MARK: - Handle changes in titleView
    public func change(title type: UINavigationBarItemType) {
        checkSetupStatus()
        
        if let _ = type.title {
            addButtonTitleView(with: type)
        } else {
            logFrameworkError("this type was not treated")
        }
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
            if shouldAutomaticallyDismissFor(type) { return }
            navBarItemPressed(with: type, isLeft: true)
            return
        }
        logFrameworkError("Failed to get type for left button action")
    }
    
    @objc internal func pressedNavRight(item: Any) {
        if let item = item as? IsNavigationBarItem, let type = item.barItemType {
            if shouldAutomaticallyDismissFor(type) { return }
            navBarItemPressed(with: type, isLeft: false)
            return
        }
        logFrameworkError("Failed to get type for right button action")
    }
    
    @objc internal func pressedNavTitle() {
        if let type = getNavigationItem().titleView?.navItemType {
            if shouldAutomaticallyDismissFor(type) { return }
            navBarTitlePressed(with: type)
            return
        }
        logFrameworkError("Failed to get type for title action")
    }
}

// MARK: - Handle taps
extension UIViewController: CanHandleVCNavigationActions {
    open func navBarTitlePressed(with type: UINavigationBarItemType) {
        assert(false, "Please implement navBarTitlePressed(with:) in your UIViewController")
    }
    
    open func navBarItemPressed(with type: UIBarButtonItemType, isLeft: Bool) {
        assert(false, "Please implement navBarItemPressed(with:isLeft:) in your UIViewController for \(type)")
    }
    
    @objc open func willAutomaticallyDismiss() {
        // Empty default implementation
    }
    
    public func shouldAutomaticallyDismissFor(_ navBarItemType: UINavigationBarGenericItem) -> Bool {
        if navBarItemType.autoDismiss {
            guard let navC = self.navigationController else {
                dismiss(animated: true)
                willAutomaticallyDismiss()
                return true
            }
            if navC.viewControllers.count == 1 {
                navC.dismiss(animated: true)
                willAutomaticallyDismiss()
                return true
            }
            navC.popViewController(animated: true)
            willAutomaticallyDismiss()
            return true
        }
        return false
    }
}

// MARK: - Handle ColorStyle refresh
extension UIViewController {
    @objc open func triggerColorStyleRefresh(with navBar: UINavigationBar? = nil, navItem: UINavigationItem? = nil) {
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
        if let backgroundImageView = navigationElements.backgroundImageView {
            if backgroundImageView.backgroundColor != colorStyle.backgroundColor {
                backgroundImageView.backgroundColor = colorStyle.backgroundColor
            }
            if backgroundImageView.image != colorStyle.backgroundImage {
                backgroundImageView.image = colorStyle.backgroundImage
            }
        }
        
        if let maskImageView = navigationElements.backgroundMaskImageView {
            if maskImageView.backgroundColor != colorStyle.backgroundMaskColor {
                maskImageView.backgroundColor = colorStyle.backgroundMaskColor
            }
            if maskImageView.image != colorStyle.backgroundMaskImage {
                maskImageView.image = colorStyle.backgroundMaskImage
            }
        }
        
        if let hairlineView = navigationElements.hairlineSeparatorView, hairlineView.backgroundColor != colorStyle.hairlineSeparatorColor {
            hairlineView.backgroundColor = colorStyle.hairlineSeparatorColor
        }
        
        if let shadowView = navigationElements.shadowBackgroundView, shadowView.tintColor != colorStyle.shadow  {
            shadowView.tintColor = colorStyle.shadow
        }
        
        // Update navigation bar buttons
        let updateBarButtonItemsBlock: ((UIBarButtonItem, Bool)->()) = { item, isLeft in
            guard let _ = item.barItemType else { return }
            
            item.button?.configure(with: colorStyle, isLeft: isLeft)
        }
        
        navItem.leftBarButtonItems?.forEach({ updateBarButtonItemsBlock($0, true) })
        navItem.rightBarButtonItems?.forEach({ updateBarButtonItemsBlock($0, false) })
        
        // Update custom titleView
        (getNavigationItem().titleView as? UIButton)?.configure(with: colorStyle, isLeft: nil)
    }
}
