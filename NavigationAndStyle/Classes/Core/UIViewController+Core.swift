//
//  Copyright © 2019 Stefan Brighiu. All rights reserved.
//

import Foundation
import UIKit

protocol NavigationVC {
    var navigationElements: NavigationVCModel { get }
    var navigationController: UINavigationController? { get }
    
    func triggerNavigationBarStyleRefresh(with navBar: UINavigationBar?, navItem: UINavigationItem?)
    
    func set(title: UINavigationBarItemType, leftItems: [UIBarButtonItemType], rightItems: [UIBarButtonItemType])
    
    func dockViewToNavigationBar(_ view: UIView, constant: CGFloat)
    func setLargeTitle(andDock view: UIView?)
    
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
        
        triggerNavigationBarStyleRefresh()
        didSetupDict[uniqueIdentifier] = true
    }
    
    internal func checkSetupStatus() {
        if !didSetupCustomNavigationAndStyle {
            logFrameworkWarning("Always use .set(...) to initialize navigation elements with the NavigationBarStyle chosen.")
        }
    }
    
    // MARK: - Dock UI in modals to the navigation bar created
    public func dockViewToNavigationBar(_ view: UIView, constant: CGFloat) {
        dockViewToNavigationBarAction(view, constant: constant)
    }
    
    // MARK: - Activate large title
    /// This function will set .prefersLargeTitles on the current navigationController. By default all navigationItems's largeTitleDisplayMode is set to .never
    public func setLargeTitle(andDock view: UIView?) {
        setLargeTitleAction(andDock: view)
    }
    
    // MARK: - Handle initial setup of navigation elements and style
    public func set(title type: UINavigationBarItemType = .title(""),
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
        
        self.navigationItem.largeTitleDisplayMode = .never
    }
    
    // MARK: - Handle changes in titleView
    public func change(title type: UINavigationBarItemType) {
        checkSetupStatus()
        
        getNavigationBar()?.titleTextAttributes = getNavigationBarStyle().titleAttributes
        
        if let _ = type.title {
            addButtonTitleView(with: type)
        } else if let _ = type.image {
            addTitleImageView(with: type)
        } else {
            getNavigationItem().titleView = nil
            if type.nativeTitle == nil {
                logFrameworkError("This UINavigationBarItemType was not treated")
            }
        }
        
        self.title = type.nativeTitle ?? ""
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
        let style = getNavigationBarStyle()
        return items.map {
            return UIBarButtonItem.buildSystemItem(with: $0,
                                                   target: self,
                                                   action: (isLeft
                                                    ? #selector(pressedNavLeft(item:))
                                                    : #selector(pressedNavRight(item:))),
                                                   isLeft: isLeft,
                                                   and: style).0
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

// MARK: - Handle NavigationBarStyle refresh
extension UIViewController {
    @objc open func triggerNavigationBarStyleRefresh(with navBar: UINavigationBar? = nil, navItem: UINavigationItem? = nil) {
        triggerNavigationBarStyleRefreshAction(with: navBar, navItem: navItem)
    }
    
    public func triggerNavigationBarStyleRefreshAction(with navBar: UINavigationBar?, navItem: UINavigationItem?) {
        let style = getNavigationBarStyle()
        
        let navItem = getNavigationItem(overrideIfExists: navItem)
        guard let navBar = self.getNavigationBar(overrideIfExists: navBar) else {
            logFrameworkError("No navigation bar present to configure bar style for!")
            return
        }
        
        navBar.barStyle = style.barStyle
        updateUI(of: navBar, navItem: navItem, with: style)
    }
    
    internal func updateUI(of navBar: UINavigationBar, navItem: UINavigationItem, with style: NavigationBarStyle) {
        // Setup background using the mask
        if let backgroundImageView = navigationElements.backgroundImageView {
            if backgroundImageView.backgroundColor != style.backgroundColor {
                backgroundImageView.backgroundColor = style.backgroundColor
            }
            if backgroundImageView.image != style.backgroundImage {
                backgroundImageView.image = style.backgroundImage
            }
        }
        
        if let maskImageView = navigationElements.backgroundMaskImageView {
            if maskImageView.backgroundColor != style.backgroundMaskColor {
                maskImageView.backgroundColor = style.backgroundMaskColor
            }
            if maskImageView.image != style.backgroundMaskImage {
                maskImageView.image = style.backgroundMaskImage
            }
            if maskImageView.alpha != style.backgroundMaskAlpha {
                maskImageView.alpha = style.backgroundMaskAlpha
            }
        }
        
        if let hairlineView = navigationElements.hairlineSeparatorView, hairlineView.backgroundColor != style.hairlineSeparatorColor {
            hairlineView.backgroundColor = style.hairlineSeparatorColor
        }
        
        if let shadowView = navigationElements.shadowBackgroundView, shadowView.tintColor != style.shadow  {
            shadowView.tintColor = style.shadow
        }
        
        // Update navigation bar buttons
        let updateBarButtonItemsBlock: ((UIBarButtonItem, Bool)->()) = { item, isLeft in
            guard let _ = item.barItemType else { return }
            
            item.button?.configure(with: style, isLeft: isLeft)
        }
        
        navItem.leftBarButtonItems?.forEach({ updateBarButtonItemsBlock($0, true) })
        navItem.rightBarButtonItems?.forEach({ updateBarButtonItemsBlock($0, false) })
        
        // Update custom titleView
        (getNavigationItem().titleView as? UIButton)?.configure(with: style, isLeft: nil)
    }
}
