//
//  Copyright © 2019 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation
import UIKit

private var models = [Int: UIViewControllerModel]()

extension UIViewController: Identifiable {
    var model: UIViewControllerModel {
        let value = models[uniqueIdentifier] ?? UIViewControllerModel()
        models[uniqueIdentifier] = value
        return value
    }
}

extension UIViewController {
    internal func getNavigationBar(overrideIfExists navBar: UINavigationBar? = nil) -> UINavigationBar? {
        return navBar ?? model.modalNavigationBar ?? self.navigationController?.navigationBar
    }
    
    internal func getNavigationItem(overrideIfExists navItem: UINavigationItem? = nil) -> UINavigationItem {
        return navItem ?? self.navigationItem
    }
}

extension UIViewController {
    
    // MARK: - Manager overlays outside an UINavigationController
    internal func cleanUIAndModelBeforeSetup() {
        model.modalNavigationBar?.removeFromSuperview()
        model.backgroundView?.removeFromSuperview()
        model.hairlineSeparatorView?.removeFromSuperview()
        model.shadowBackgroundView?.removeFromSuperview()
        model.clean()
    }
    
    internal func addMaskView(to superView: UIView) -> UIImageView {
        let maskView = UIImageView(frame: .zero)
        maskView.contentMode = .scaleAspectFill
        maskView.isUserInteractionEnabled = false
        
        maskView.backgroundColor = getColorStyle().background
        
        model.backgroundView = maskView
        
        superView.insertSubview(maskView, at: 0)
        maskView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            maskView.topAnchor.constraint(equalTo: superView.topAnchor),
            maskView.leadingAnchor.constraint(equalTo: superView.leadingAnchor),
            maskView.trailingAnchor.constraint(equalTo: superView.trailingAnchor)
            ])
        
        addHairlineSeparator(superView, maskView)
        
        return maskView
    }
    
    internal func addHairlineSeparator(_ superView: UIView, _ maskView: UIImageView) {
        let hairlineSeparatorColor = getColorStyle().hairlineSeparatorColor
        
        let hairlineView = UIView(frame: .zero)
        hairlineView.contentMode = .scaleAspectFill
        hairlineView.isUserInteractionEnabled = false
        
        hairlineView.backgroundColor = hairlineSeparatorColor
        
        model.hairlineSeparatorView = hairlineView
        
        superView.insertSubview(hairlineView, aboveSubview: maskView)
        hairlineView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            hairlineView.topAnchor.constraint(equalTo: maskView.bottomAnchor),
            hairlineView.leadingAnchor.constraint(equalTo: superView.leadingAnchor),
            hairlineView.trailingAnchor.constraint(equalTo: superView.trailingAnchor),
            hairlineView.heightAnchor.constraint(equalToConstant: ColorStyle.Defaults.heightOfHairlineSeparator)
            ])
    }
    
    internal func addShadowView(to superView: UIView) -> UIImageView? {
        let shadowView = UIImageView()
        shadowView.backgroundColor = .clear
        shadowView.contentMode = .scaleToFill
        shadowView.image = UIImage.NavigationAndStyle.backgroundShadow
        shadowView.tintColor = getColorStyle().shadow
        shadowView.isUserInteractionEnabled = false
        
        model.shadowBackgroundView = shadowView
        
        superView.insertSubview(shadowView, at: 0)
        shadowView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            shadowView.topAnchor.constraint(equalTo: superView.topAnchor),
            shadowView.leadingAnchor.constraint(equalTo: superView.leadingAnchor),
            shadowView.trailingAnchor.constraint(equalTo: superView.trailingAnchor),
            ])
        
        return shadowView
    }
    
    internal func addNavigationBarComplementElements(of navC: UINavigationController) {
        cleanUIAndModelBeforeSetup()
        
        let maskView = addMaskView(to: self.view)
        maskView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        
        let shadowView = addShadowView(to: self.view)
        shadowView?.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: Constants.shadowOverlayExtraHeight).isActive = true
    }
    
    internal func addOverlayNavigationBarElements(to superView: UIView) {
        cleanUIAndModelBeforeSetup()
        
        // Setup base mask
        let maskView = addMaskView(to: superView)
        
        // Get shadowView if needed
        let shadowView = addShadowView(to: superView)
        
        // Setup navigation Bar
        let navBar = UINavigationBar(frame: Constants.defaultFrame)
        navBar.items = [self.navigationItem]
        
        superView.insertSubview(navBar, aboveSubview: maskView)
        
        model.modalNavigationBar = navBar
        
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
