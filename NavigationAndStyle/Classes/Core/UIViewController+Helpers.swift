//
//  Copyright © 2019 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation
import UIKit

private var modalNavigationBarDict = [Int: WEAK<UINavigationBar>]()
private var maskStatusBarViewDict = [Int: WEAK<UIImageView>]()
private var shadowOverlayViewDict = [Int: WEAK<UIImageView>]()

extension UIViewController: Identifiable {
    
    internal func getNavigationBar(overrideIfExists navBar: UINavigationBar? = nil) -> UINavigationBar? {
        return navBar ?? modalNavigationBarDict[uniqueIdentifier]?.item ?? self.navigationController?.navigationBar
    }
    
    internal func getNavigationItem(overrideIfExists navItem: UINavigationItem? = nil) -> UINavigationItem {
        return navItem ?? self.navigationItem
    }
    
    internal func getTitleSearchBar() -> UISearchBar? {
        return self.navigationItem.titleView as? UISearchBar
    }
    
    internal func getMaskView() -> UIImageView? {
        return maskStatusBarViewDict[uniqueIdentifier]?.item
    }
}

extension UIViewController {
    
    // MARK: - Manager overlays outside an UINavigationController
    internal func removeOverlayNavigationBar() {
        shadowOverlayViewDict[uniqueIdentifier]?.item?.removeFromSuperview()
        shadowOverlayViewDict[uniqueIdentifier] = nil
        maskStatusBarViewDict[uniqueIdentifier]?.item?.removeFromSuperview()
        maskStatusBarViewDict[uniqueIdentifier] = nil
        modalNavigationBarDict[uniqueIdentifier]?.item?.removeFromSuperview()
        modalNavigationBarDict[uniqueIdentifier] = nil
    }
    
    internal func addMaskViewIfNeeded(to superView: UIView) -> UIImageView {
        let maskView = UIImageView(frame: .zero)
        maskView.contentMode = .scaleAspectFill
        maskView.isUserInteractionEnabled = false
        
        if let colorStyle = getColorStyle() {
            maskView.backgroundColor = colorStyle.background
        } else {
            maskView.backgroundColor = .clear
        }
        
        maskStatusBarViewDict[uniqueIdentifier] = WEAK(with: maskView)
        
        superView.insertSubview(maskView, at: 0)
        maskView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            maskView.topAnchor.constraint(equalTo: superView.topAnchor),
            maskView.leadingAnchor.constraint(equalTo: superView.leadingAnchor),
            maskView.trailingAnchor.constraint(equalTo: superView.trailingAnchor)
            ])
        
        return maskView
    }
    
    internal func addShadowViewIfNeeded(to superView: UIView) -> UIImageView? {
        guard let colorStyle = getColorStyle(), colorStyle.shadow != .clear else { return nil }
        
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleToFill
        imageView.image = UIImage.NavigationAndStyle.backgroundShadow
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
    
    internal func addNavigationBarComplementElements(of navC: UINavigationController) -> (UINavigationBar, UIImageView, UIImageView?) {
        removeOverlayNavigationBar()
        
        let maskView = addMaskViewIfNeeded(to: self.view)
        maskView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        
        let shadowView = addShadowViewIfNeeded(to: self.view)
        shadowView?.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: Constants.shadowOverlayExtraHeight).isActive = true
        
        return (navC.navigationBar, maskView, shadowView)
    }
    
    internal func addOverlayNavigationBarElements(to superView: UIView) -> (UINavigationBar, UIImageView, UIImageView?) {
        removeOverlayNavigationBar()
        
        // Setup base mask
        let maskView = addMaskViewIfNeeded(to: superView)
        
        // Get shadowView if present
        let shadowView = addShadowViewIfNeeded(to: superView)
        
        // Setup Navigation Bar
        let navBar = UINavigationBar(frame: Constants.defaultFrame)
        navBar.items = [self.navigationItem]
        
        superView.insertSubview(navBar, aboveSubview: maskView)
        
        modalNavigationBarDict[uniqueIdentifier] = WEAK(with: navBar)
        navBar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            navBar.topAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.topAnchor),
            navBar.leadingAnchor.constraint(equalTo: superView.leadingAnchor),
            navBar.trailingAnchor.constraint(equalTo: superView.trailingAnchor),
            ])
        
        // Finish with the shadow view
        shadowView?.bottomAnchor.constraint(equalTo: navBar.bottomAnchor, constant: Constants.shadowOverlayExtraHeight).isActive = true
        
        // Finish with the mask view
        maskView.bottomAnchor.constraint(equalTo: navBar.bottomAnchor).isActive = true
        
        return (navBar, maskView, shadowView)
    }
}

// MARK: - Manage titleView elements creation
extension UIViewController {
    // MARK: Manage UISearchBars
    internal func addSearchBarInTitleView(with placeholder: String) -> UISearchBar {
        let searchBar = getSearchBar(with: placeholder)
        
        getNavigationItem().titleView = searchBar
        
        searchBar.heightAnchor.constraint(equalToConstant: Constants.defaultItemHeight).isActive = true
        
        return searchBar
    }
    
    internal func getSearchBar(with placeholder: String) -> UISearchBar {
        let searchBar = UISearchBar()
        setup(searchBar: searchBar, with: placeholder)
        return searchBar
    }
    
    internal func setup(searchBar: UISearchBar, with placeholder: String) {
        setAppearance(for: searchBar)
        searchBar.placeholder = placeholder
        searchBar.configure()
    }
    
    internal func setAppearance(for searchBar: UISearchBar?) {
        if let colorStyle = getColorStyle() {
            searchBar?.setAppearance(with: colorStyle.buttonTitleColor, and: colorStyle.disabledColor)
        } else {
            searchBar?.setAppearance(with: ColorStyle.Defaults.systemBarButtonItemTint, and: ColorStyle.Defaults.disabledColor)
        }
    }
    
    // MARK: Manage UIImageViews
    internal func addImageView(with image: UIImage?) -> UIImageView {
        let imageView = getImageView(with: image)
        getNavigationItem().titleView = imageView
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.heightAnchor.constraint(equalToConstant: Constants.defaultItemHeight).isActive = true
        imageView.widthAnchor.constraint(greaterThanOrEqualToConstant: Constants.defaultItemWidth).isActive = true
        
        return imageView
    }
    
    internal func getImageView(with image: UIImage?) -> UIImageView {
        let imageView = UIImageView(image: image)
        setup(imageView: imageView)
        
        return imageView
    }
    
    internal func setup(imageView: UIImageView) {
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        
        if let colorStyle = getColorStyle() {
            imageView.tintColor = colorStyle.titleColor
        } else {
            imageView.tintColor = ColorStyle.Defaults.systemNavigationBarTitleTextColor
        }
    }
    
    // MARK: Manage UIButtons
    internal func addButton(with text: String, and image: UIImage?) -> UIButton {
        let button = getButton(with: text, and: image)
        getNavigationItem().titleView = button
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.heightAnchor.constraint(equalToConstant: Constants.defaultItemHeight).isActive = true
        button.widthAnchor.constraint(greaterThanOrEqualToConstant: Constants.defaultItemWidth).isActive = true
        
        return button
    }
    
    internal func getButton(with text: String, and image: UIImage?) -> UIButton {
        let button = UIButton(frame: Constants.defaultFrame)
        setup(button: button, with: text, and: image)
        
        return button
    }
    
    internal func setup(button: UIButton, with text: String, and image: UIImage?) {
        button.setTitle(text, for: .normal)
        
        if let colorStyle = getColorStyle() {
            button.titleLabel?.font = colorStyle.titleFont
            button.setTitleColor(colorStyle.titleColor, for: .normal)
            button.setTitleColor(colorStyle.titleColor.withAlphaComponent(ColorStyle.Defaults.alphaWhenTapped), for: .highlighted)
            button.setTitleColor(colorStyle.disabledColor, for: .disabled)
        } else {
            button.titleLabel?.font = ColorStyle.Defaults.titleFont
            button.setTitleColor(ColorStyle.Defaults.systemNavigationBarTitleTextColor, for: .normal)
            button.setTitleColor(ColorStyle.Defaults.systemNavigationBarTitleTextColor.withAlphaComponent(ColorStyle.Defaults.alphaWhenTapped), for: .highlighted)
            button.setTitleColor(ColorStyle.Defaults.systemNavigationBarTitleTextColor, for: .disabled)
        }
        
        if let imageView = button.imageView {
            setup(imageView: imageView)
            button.setImage(image, for: .normal)
            button.adjustsImageWhenHighlighted = true // TODO: - Check insets if only title or only image
            if !text.isEmpty {
                button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -Constants.defaultButtonImagePadding/2, bottom: 0, right: Constants.defaultButtonImagePadding/2)
                button.titleEdgeInsets = UIEdgeInsets(top: 0, left: Constants.defaultButtonImagePadding/2, bottom: 0, right: -Constants.defaultButtonImagePadding/2)
            }
        }
        
        button.addTarget(self,
                         action: #selector(titleViewButtonPressed(with:)),
                         for: .touchUpInside)
    }
    
    // MARK: Manage UILabels
    internal func addLabel(with text: String) -> UILabel {
        let label = UILabel(frame: Constants.defaultFrame)
        setup(label: label, with: text)
        
        return label
    }
    
    func setup(label: UILabel, with text: String) {
        label.text = text
        if let colorStyle = getColorStyle() {
            label.textColor = colorStyle.titleColor
            label.font = colorStyle.titleFont
        } else {
            label.font = ColorStyle.Defaults.titleFont
            label.textColor = ColorStyle.Defaults.systemNavigationBarTitleTextColor
        }
    }
}
