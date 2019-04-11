//
//  Copyright © 2019 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation
import UIKit

private var modalNavigationBarDict = [Int: WEAK<UINavigationBar>]()
private var maskStatusBarViewDict = [Int: WEAK<UIImageView>]()
private var hairlineViewDict = [Int: WEAK<UIView>]()
private var shadowOverlayViewDict = [Int: WEAK<UIImageView>]()

extension UIViewController: Identifiable {
    
    internal func getNavigationBar(overrideIfExists navBar: UINavigationBar? = nil) -> UINavigationBar? {
        return navBar ?? modalNavigationBarDict[uniqueIdentifier]?.item ?? self.navigationController?.navigationBar
    }
    
    internal func getNavigationItem(overrideIfExists navItem: UINavigationItem? = nil) -> UINavigationItem {
        return navItem ?? self.navigationItem
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
        hairlineViewDict[uniqueIdentifier]?.item?.removeFromSuperview()
        hairlineViewDict[uniqueIdentifier] = nil
        modalNavigationBarDict[uniqueIdentifier]?.item?.removeFromSuperview()
        modalNavigationBarDict[uniqueIdentifier] = nil
    }
    
    internal func addMaskView(to superView: UIView) -> UIImageView {
        let colorStyle = getColorStyle()
        
        let maskView = UIImageView(frame: .zero)
        maskView.contentMode = .scaleAspectFill
        maskView.isUserInteractionEnabled = false
        
        maskView.backgroundColor = colorStyle.background
        
        maskStatusBarViewDict[uniqueIdentifier] = WEAK(with: maskView)
        
        superView.insertSubview(maskView, at: 0)
        maskView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            maskView.topAnchor.constraint(equalTo: superView.topAnchor),
            maskView.leadingAnchor.constraint(equalTo: superView.leadingAnchor),
            maskView.trailingAnchor.constraint(equalTo: superView.trailingAnchor)
            ])
        
        // Add hairline if needed
        let hairlineSeparatorColor = getColorStyle().hairlineSeparatorColor
        if hairlineSeparatorColor != .clear {
            let hairlineView = UIView(frame: .zero)
            hairlineView.contentMode = .scaleAspectFill
            hairlineView.isUserInteractionEnabled = false
            
            hairlineView.backgroundColor = colorStyle.hairlineSeparatorColor
            
            hairlineViewDict[uniqueIdentifier] = WEAK(with: hairlineView)
            
            superView.insertSubview(hairlineView, aboveSubview: maskView)
            hairlineView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                hairlineView.topAnchor.constraint(equalTo: maskView.bottomAnchor),
                hairlineView.leadingAnchor.constraint(equalTo: superView.leadingAnchor),
                hairlineView.trailingAnchor.constraint(equalTo: superView.trailingAnchor),
                hairlineView.heightAnchor.constraint(equalToConstant: colorStyle.hairlineSeparatorHeight)
                ])
        }
        
        return maskView
    }
    
    internal func addShadowViewIfNeeded(to superView: UIView) -> UIImageView? {
        let colorStyle = getColorStyle()
        
        guard colorStyle.shadow != .clear else { return nil }
        
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleToFill
        imageView.image = UIImage.NavigationAndStyle.backgroundShadow
        imageView.tintColor = colorStyle.shadow
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
        
        let maskView = addMaskView(to: self.view)
        maskView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        
        let shadowView = addShadowViewIfNeeded(to: self.view)
        shadowView?.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: Constants.shadowOverlayExtraHeight).isActive = true
        
        return (navC.navigationBar, maskView, shadowView)
    }
    
    internal func addOverlayNavigationBarElements(to superView: UIView) -> (UINavigationBar, UIImageView, UIImageView?) {
        removeOverlayNavigationBar()
        
        // Setup base mask
        let maskView = addMaskView(to: superView)
        
        // Get shadowView if needed
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
    
    // MARK: Manage UIImageViews
    internal func addImageView(with image: UIImage?) -> UIImageView {
        let imageView = getImageView(with: image)
        getNavigationItem().titleView = imageView
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.heightAnchor.constraint(equalToConstant: Constants.defaultItemHeight).isActive = true
        imageView.widthAnchor.constraint(greaterThanOrEqualToConstant: Constants.defaultItemWidth).isActive = true
        
        if let parent = imageView.superview {
            imageView.centerXAnchor.constraint(equalTo: parent.centerXAnchor).isActive = true
        }
        
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
        
        imageView.tintColor = getColorStyle().titleColor
    }
    
    // MARK: Manage UIButtons
    internal func addButton(with text: String, and image: UIImage?) -> UIButton {
        let button = getButton(with: text, and: image)
        getNavigationItem().titleView = button
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.heightAnchor.constraint(equalToConstant: Constants.defaultItemHeight).isActive = true
        button.widthAnchor.constraint(greaterThanOrEqualToConstant: Constants.defaultItemWidth).isActive = true
        
        if let parent = button.superview {
            button.centerXAnchor.constraint(equalTo: parent.centerXAnchor).isActive = true
        }
        
        return button
    }
    
    internal func getButton(with text: String, and image: UIImage?) -> UIButton {
        let button = UIButton(frame: .zero)
        setup(button: button, with: text, and: image)
        
        return button
    }
    
    internal func setup(button: UIButton, with text: String, and image: UIImage?) {
        button.setTitle(text, for: .normal)
        
        let colorStyle = getColorStyle()
        button.titleLabel?.font = colorStyle.titleFont
        button.setTitleColor(colorStyle.titleColor, for: .normal)
        button.setTitleColor(colorStyle.highlightColor(for: colorStyle.titleColor), for: .highlighted)
        button.setTitleColor(colorStyle.disabledColor, for: .disabled)
        
        if let imageView = button.imageView, let image = image {
            setup(imageView: imageView)
            button.setImage(image, for: .normal)
            
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
        let label = getLabel(with: text)
        
        getNavigationItem().titleView = label
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.heightAnchor.constraint(equalToConstant: Constants.defaultItemHeight).isActive = true
        label.widthAnchor.constraint(greaterThanOrEqualToConstant: Constants.defaultItemWidth).isActive = true
        
        if let parent = label.superview {
            label.centerXAnchor.constraint(equalTo: parent.centerXAnchor).isActive = true
        }
        
        return label
    }
    
    internal func getLabel(with text: String) -> UILabel {
        let label = UILabel(frame: .zero)
        setup(label: label, with: text)
        
        return label
    }
    
    internal func setup(label: UILabel, with text: String) {
        let colorStyle = getColorStyle()
        
        label.text = text
        label.textAlignment = .center
        label.textColor = colorStyle.titleColor
        label.font = colorStyle.titleFont
    }
}
