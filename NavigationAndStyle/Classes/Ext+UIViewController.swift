//
//  Copyright © 2019 Stefan Brighiu. All rights reserved.
//

import Foundation
import UIKit

protocol NavigationVCBase {
    var navigationController: UINavigationController? { get }
    
    func refreshNavigationElements(with navBar: UINavigationBar?, navItem: UINavigationItem?, animated: Bool)
    func updateBarStyle(of navBar: UINavigationBar, navItem: UINavigationItem, with colorStyle: ViewControllerColorStyle)
    func updateUI(of navBar: UINavigationBar, navItem: UINavigationItem, with colorStyle: ViewControllerColorStyle)
}

protocol NavigationVC: NavigationVCBase {
    func set(title: String, left: [NavBarItemType], right: [NavBarItemType], overrideModalSuperview: UIView?) -> (UILabel, [UIButton?], [UIButton?], UINavigationBar?, UIView?)
    
    func change(titleToSearchBarWithPlaceholder placeholder: String) -> UISearchBar
    func change(titleTo: String) -> UILabel
    func change(leftNavBarItems items: [NavBarItemType], animated: Bool) -> [UIButton?]
    func change(rightNavBarItems items: [NavBarItemType], animated: Bool) -> [UIButton?]
    
    func shouldAutomaticallyDismissFor(_ navBarItemType: NavBarItemType) -> Bool
}

@objc protocol NavigationVCActions {
    func titleViewButtonPressed(with button: UIButton)
    func navBarItemPressed(with type: NavBarItemType, button: UIButton?, isLeft: Bool)
}

fileprivate class WEAK<T: AnyObject> {
    weak var item: T?
    init(with item: T) {
        self.item = item
    }
}

private var didSetupDict = [Int: Bool]()

private var modalNavigationBarDict = [Int: WEAK<UINavigationBar>]()
private var maskStatusBarViewDict = [Int: WEAK<UIView>]()
private var shadowOverlayViewDict = [Int: WEAK<UIImageView>]()

private var defaultDelayForPopCompletion: TimeInterval = defaultAnimationTime + 0.05

extension UIViewController: NavigationVC, Identifiable {
    
    // MARK - Setup
    private func getNavigationBar(overrideIfExists navBar: UINavigationBar? = nil) -> UINavigationBar? {
        return navBar ?? modalNavigationBarDict[uniqueIdentifier]?.item ?? self.navigationController?.navigationBar
    }
    
    private func getNavigationItem(overrideIfExists navItem: UINavigationItem? = nil) -> UINavigationItem {
        return navItem ?? self.navigationItem
    }
    
    private func getTitleSearchBar() -> UISearchBar? {
        return self.navigationItem.titleView as? UISearchBar
    }
    
    private func setupNavigationAndStyle() {
        let navBar = self.getNavigationBar()
        let colorStyle = getColorStyle()
        navBar?.isTranslucent = colorStyle.isTranslucent
        
        if let navC = self.navigationController {
            navC.setupNavigationConvenienceSettings()
        }
        
        refreshNavigationElements(animated: false)
        
        didSetupDict[uniqueIdentifier] = true
    }
    
    public var didSetupCustomNavigationAndStyle: Bool {
        return didSetupDict[uniqueIdentifier] ?? false
    }
    
    // MARK: - Handle bar button items
    @discardableResult public func set(title: String,
                                       left: [NavBarItemType] = [],
                                       right: [NavBarItemType] = [],
                                       overrideModalSuperview: UIView? = nil) -> (UILabel, [UIButton?], [UIButton?], UINavigationBar?, UIView?) {
        var shadowView: UIImageView?
        if self.navigationController == nil {
            if overrideModalSuperview != nil {
                print("[Warning] Please remove the overrideModalSuperview value when an UINavigationController is present for your UIViewController, because it will not be used.")
            }
            (_, shadowView) = addOverlayNavigationBarElements(to: overrideModalSuperview ?? self.view)
        } else {
            shadowView = addShadowViewIfNeeded(to: self.view)
        }
        
        let titleLabel = change(titleTo: title)
        let leftButtonsGroup = change(leftNavBarItems: left)
        let rightButtonsGroup = change(rightNavBarItems: right)
        
        setupNavigationAndStyle()
        
        return (titleLabel, leftButtonsGroup, rightButtonsGroup, getNavigationBar(), shadowView)
    }
    
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
        let label = UILabel.build(with: title, initialFrame: defaultFrame, and: getColorStyle())
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
        let duration = self.navigationController?.getAnimatedElementsUpdateDuration() ?? defaultAnimationTime
        refeshNavigationElementsAction(with: navBar, navItem: navItem, duration: animated ? duration : 0)
    }
    
    // MARK: - Handle actions and button creation
    private func get(navBarItems items: [NavBarItemType], isLeft: Bool) -> ([UIBarButtonItem], [UIButton?]) {
        let colorStyle = getColorStyle()
        let newItems: [(UIBarButtonItem, UIButton?, Bool)] = items.compactMap({
            if $0.systemItem != nil {
                return UIBarButtonItem.buildSystemItem(with: $0,
                                                       target: self,
                                                       selector: (isLeft
                                                        ? #selector(pressedSystemLeft(item:))
                                                        : #selector(pressedSystemRight(item:))),
                                                       and: colorStyle)
            }
            return UIBarButtonItem.build(with: $0, initialFrame: defaultFrame, and: colorStyle)
        })
        newItems.enumerated().forEach({ (index, element) in
            if let button = element.1 {
                button.setNavBarItemType(to: items[index])
                button.addTarget(self,
                                 action: (isLeft
                                    ? #selector(pressedLeft(button:))
                                    : #selector(pressedRight(button:))),
                                 for: .touchDown)
            }
        })
        var buttons = [UIButton?]()
        let barItems: [UIBarButtonItem] = newItems.map {
            buttons.append($0.1)
            return $0.0
        }
        
        return (barItems, buttons)
    }
    
    @objc internal func pressedLeft(button: UIButton) {
        guard let type = button.getNavBarItemType() else {
            print("Failed to get type for left button")
            return
        }
        navBarItemPressed(with: type, button: button, isLeft: true)
    }
    
    @objc internal func pressedRight(button: UIButton) {
        guard let type = button.getNavBarItemType() else {
            print("Failed to get type for right button")
            return
        }
        navBarItemPressed(with: type, button: button, isLeft: false)
    }
    
    @objc internal func pressedSystemLeft(item: UIBarButtonItem) {
        guard let type = item.getNavBarItemType() else {
            print("Failed to get type for left system button")
            return
        }
        navBarItemPressed(with: type, button: nil, isLeft: true)
    }
    
    @objc internal func pressedSystemRight(item: UIBarButtonItem) {
        guard let type = item.getNavBarItemType() else {
            print("Failed to get type for right system button")
            return
        }
        navBarItemPressed(with: type, button: nil, isLeft: false)
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
            dismissScreen()
            return true
        }
        return false
    }
}

extension UIViewController {
    public func dismissScreen(animated: Bool = true, completion: (()->())? = nil) {
        guard let navC = self.navigationController else {
            self.dismiss(animated: animated, completion: completion)
            return
        }
        if navC.viewControllers.count == 1 {
            navC.dismiss(animated: animated, completion: completion)
            return
        }
        navC.popViewController(animated: animated)
        let delay = self.navigationController?.getAnimatedTransitionDuration() ?? defaultDelayForPopCompletion
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: completion ?? { /* empty */ })
    }
}

extension UIViewController {
    // MARK: - Manager overlays outside an UINavigationController
    fileprivate func removeOverlayNavigationBar() {
        shadowOverlayViewDict[uniqueIdentifier]?.item?.removeFromSuperview()
        shadowOverlayViewDict[uniqueIdentifier] = nil
        maskStatusBarViewDict[uniqueIdentifier]?.item?.removeFromSuperview()
        maskStatusBarViewDict[uniqueIdentifier] = nil
        modalNavigationBarDict[uniqueIdentifier]?.item?.removeFromSuperview()
        modalNavigationBarDict[uniqueIdentifier] = nil
    }
    
    fileprivate func addOverlayNavigationBarElements(to superView: UIView) -> (UINavigationBar, UIImageView?) {
        removeOverlayNavigationBar()
        
        // Get shadowView if present
        let shadowView = addShadowViewIfNeeded(to: superView)
        
        // Setup Navigation Bar
        let navBar = UINavigationBar(frame: defaultFrame)
        navBar.items = [self.navigationItem]
        
        let maskView = UIView(frame: navBar.frame)
        maskView.backgroundColor = getColorStyle().background
        
        if let shadowView = shadowView {
            superView.insertSubview(navBar, aboveSubview: shadowView)
            superView.insertSubview(maskView, aboveSubview: shadowView)
        } else {
            superView.insertSubview(navBar, at: 0)
            superView.insertSubview(maskView, at: 0)
        }
        
        modalNavigationBarDict[uniqueIdentifier] = WEAK(with: navBar)
        navBar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            navBar.topAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.topAnchor),
            navBar.leadingAnchor.constraint(equalTo: superView.leadingAnchor),
            navBar.trailingAnchor.constraint(equalTo: superView.trailingAnchor),
            ])
        
        NSLayoutConstraint.activate([
            maskView.topAnchor.constraint(equalTo: superView.topAnchor),
            maskView.leadingAnchor.constraint(equalTo: superView.leadingAnchor),
            maskView.trailingAnchor.constraint(equalTo: superView.trailingAnchor),
            maskView.bottomAnchor.constraint(equalTo: navBar.bottomAnchor)
            ])
        
        maskStatusBarViewDict[uniqueIdentifier] = WEAK(with: maskView)
        maskView.translatesAutoresizingMaskIntoConstraints = false
        
        // Finish with the shadow view
        shadowView?.bottomAnchor.constraint(equalTo: navBar.bottomAnchor, constant: shadowOverlayExtraHeight).isActive = true
        
        return (navBar, shadowView)
    }
    
    fileprivate func addShadowViewIfNeeded(to superView: UIView) -> UIImageView? {
        let colorStyle = getColorStyle()
        
        guard colorStyle.shadow != .clear else { return nil }
        
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleToFill
        imageView.image = UIImage.Placeholders.backgroundShadow
        imageView.tintColor = colorStyle.shadow.withAlphaComponent(colorStyle.shadowAlpha)
        imageView.isUserInteractionEnabled = false
        
        shadowOverlayViewDict[uniqueIdentifier] = WEAK(with: imageView)
        
        superView.insertSubview(imageView, at: 0)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: superView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: superView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: superView.trailingAnchor),
            ])
        
        return imageView
    }
    
}

extension UIViewController {
    // MARK: - Manage SearchBars in for titleView
    fileprivate func addSearchBarInTitleView(with placeholder: String) -> UISearchBar {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let searchBar = getSearchBar(with: placeholder)
        
        getNavigationItem().titleView = searchBar
        
        searchBar.heightAnchor.constraint(equalToConstant: defaultItemHeight).isActive = true
        
        return searchBar
    }
    
    private func getSearchBar(with placeholder: String) -> UISearchBar {
        let searchBar = UISearchBar()
        setup(searchBar: searchBar, with: placeholder)
        return searchBar
    }
    
    private func setup(searchBar: UISearchBar, with placeholder: String) {
        let colorStyle = getColorStyle()
        
        searchBar.setAppearance(with: colorStyle)
        searchBar.placeholder = placeholder
        searchBar.configure()
    }
    
    // MARK: - Manage UIImageViews
    fileprivate func addImageView(with image: UIImage?) -> UIImageView {
        let imageView = getImageView(with: image)
        getNavigationItem().titleView = imageView
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.heightAnchor.constraint(equalToConstant: defaultItemHeight).isActive = true
        imageView.widthAnchor.constraint(greaterThanOrEqualToConstant: defaultItemWidth).isActive = true

        return imageView
    }
    
    private func getImageView(with image: UIImage?) -> UIImageView {
        let imageView = UIImageView(image: image)
        setup(imageView: imageView)
        
        return imageView
    }
    
    private func  setup(imageView: UIImageView) {
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.tintColor = getColorStyle().titleTint
    }
    
    // MARK: - Manage UIButtons
    fileprivate func addButton(with text: String, and image: UIImage?) -> UIButton {
        let button = getButton(with: text, and: image)
        getNavigationItem().titleView = button
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.heightAnchor.constraint(equalToConstant: defaultItemHeight).isActive = true
        button.widthAnchor.constraint(greaterThanOrEqualToConstant: defaultItemWidth).isActive = true
        
        return button
    }
    
    private func getButton(with text: String, and image: UIImage?) -> UIButton {
        let button = UIButton()
        setup(button: button, with: text, and: image)
        
        return button
    }
    
    private func setup(button: UIButton, with text: String, and image: UIImage?) {
        let colorStyle = getColorStyle()
        
        button.setTitle(text, for: .normal)
        button.titleLabel?.font = colorStyle.titleFont
        button.setTitleColor(colorStyle.titleTint, for: .normal)
        button.setTitleColor(colorStyle.titleTint.withAlphaComponent(0.66), for: .highlighted)
        button.setTitleColor(colorStyle.disabledTint, for: .disabled)
        
        if let imageView = button.imageView {
            setup(imageView: imageView)
            button.setImage(image, for: .normal)
            button.adjustsImageWhenHighlighted = true
            button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -defaultButtonImagePadding/2, bottom: 0, right: defaultButtonImagePadding/2)
            button.titleEdgeInsets = UIEdgeInsets(top: 0, left: defaultButtonImagePadding/2, bottom: 0, right: -defaultButtonImagePadding/2)
        }
        
        button.addTarget(self,
                         action: #selector(titleViewButtonPressed(with:)),
                         for: .touchUpInside)
    }
}

extension UIViewController {
    internal func refeshNavigationElementsAction(with navBar: UINavigationBar?, navItem: UINavigationItem?, duration: TimeInterval) {
        let navItem = getNavigationItem(overrideIfExists: navItem)
        guard let navBar = self.getNavigationBar(overrideIfExists: navBar) else {
            print("Error! No navigation bar present to configure bar style for!")
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
    
    internal func updateBarStyle(of navBar: UINavigationBar, navItem: UINavigationItem, with colorStyle: ViewControllerColorStyle) {
        guard let navBar = self.getNavigationBar(overrideIfExists: navBar) else {
            print("Error! No navigation bar present to configure bar style for!")
            return
        }
        navBar.barStyle = colorStyle.barStyle
        navBar.isTranslucent = colorStyle.isTranslucent
        
        getTitleSearchBar()?.setAppearance(with: colorStyle)
        getNavigationItem().searchController?.searchBar.setAppearance(with: colorStyle)
        
        extraNonAnimationBlock(navBar: navBar, navItem: navItem)
    }
    
    internal func updateUI(of navBar: UINavigationBar, navItem: UINavigationItem, with colorStyle: ViewControllerColorStyle) {
        guard let navigationBar = self.getNavigationBar(overrideIfExists: navBar) else {
            print("Error! No navigation bar present to configure bar style for!")
            return
        }
        
        // Setup shadow
        navigationBar.shadowImage = self.navigationController != nil ? colorStyle.underlineShadowImage : colorStyle.clearShadowImage
        
        // Setup background
        navigationBar.backgroundColor = colorStyle.background
        navigationBar.setBackgroundImage(colorStyle.backgroundImage, for: .default)
        navigationBar.barTintColor = colorStyle.background
        
        // Setup title attributes
        navigationBar.titleTextAttributes = colorStyle.titleAttr
        
        // Update buttons
        let updateBarButtonItemsBlock: ((UIBarButtonItem)->()) = { item in
            item.tintColor = colorStyle.buttonTint
            item.button?.configure(with: colorStyle)
        }
        
        navItem.leftBarButtonItems?.forEach(updateBarButtonItemsBlock)
        navItem.rightBarButtonItems?.forEach(updateBarButtonItemsBlock)
        
        extraAnimationBlock(navBar: navBar, navItem: navItem)
    }
    
    open func extraAnimationBlock(navBar: UINavigationBar, navItem: UINavigationItem) {
        // Meant to be overriden
    }
    
    open func extraNonAnimationBlock(navBar: UINavigationBar, navItem: UINavigationItem) {
        // Meant to be overriden
    }
}

internal extension UIViewController {
    
    var defaultFrame: CGRect {
        return CGRect(x: 0, y: 0, width: minimumItemWidth, height: defaultItemHeight)
    }
    
    var defaultItemHeight: CGFloat {
        return 44
    }
    
    var defaultItemWidth: CGFloat {
        return 36
    }
    
    var shadowOverlayExtraHeight: CGFloat {
        return 32
    }
    
    var defaultButtonImagePadding: CGFloat {
        return 4
    }
    
    var minimumItemWidth: CGFloat {
        return 36
    }
    
}
