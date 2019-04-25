//
//  Copyright © 2019 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    internal func getNavigationBar(overrideIfExists navBar: UINavigationBar? = nil) -> UINavigationBar? {
        return navBar ?? navigationElements.modalNavigationBar ?? self.navigationController?.navigationBar
    }
    
    internal func getNavigationItem(overrideIfExists navItem: UINavigationItem? = nil) -> UINavigationItem {
        return navItem ?? self.navigationItem
    }
}

extension UIViewController {
    
    internal func addMaskView(to superView: UIView) -> UIImageView {
        let colorStyle = getColorStyle()
        
        let maskView = UIImageView(frame: .zero)
        maskView.backgroundColor = colorStyle.background
        maskView.contentMode = .scaleAspectFill
        maskView.image = colorStyle.backgroundImage
        maskView.isUserInteractionEnabled = false
        
        navigationElements.backgroundImageView = maskView
        
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
        
        navigationElements.hairlineSeparatorView = hairlineView
        
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
        
        navigationElements.shadowBackgroundView = shadowView
        
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
        navigationElements.removeFromSuperview()
        
        let maskView = addMaskView(to: self.view)
        maskView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        
        let shadowView = addShadowView(to: self.view)
        shadowView?.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: Constants.recommendedItemHeight).isActive = true
    }
    
    internal func addOverlayNavigationBarElements(to superView: UIView) {
        navigationElements.removeFromSuperview()
        
        // Setup base mask
        let maskView = addMaskView(to: superView)
        
        // Get shadowView if needed
        let shadowView = addShadowView(to: superView)
        
        // Setup navigation Bar
        let navBar = UINavigationBar()
        navBar.items = [self.navigationItem]
        
        superView.insertSubview(navBar, aboveSubview: maskView)
        
        navigationElements.modalNavigationBar = navBar
        
        navBar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            navBar.topAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.topAnchor),
            navBar.leadingAnchor.constraint(equalTo: superView.leadingAnchor),
            navBar.trailingAnchor.constraint(equalTo: superView.trailingAnchor)
            ])
        
        // Finish with the shadow view
        shadowView?.bottomAnchor.constraint(equalTo: navBar.bottomAnchor, constant: Constants.shadowExtraHeight).isActive = true
        
        // Finish with the mask view
        maskView.bottomAnchor.constraint(equalTo: navBar.bottomAnchor).isActive = true
    }
}

// MARK: - Manage titleView elements creation
extension UIViewController {
    
    internal func addCustomView(with view: UIView) -> UIView {
        view.heightAnchor.constraint(lessThanOrEqualToConstant: Constants.recommendedItemHeight).isActive = true
        view.widthAnchor.constraint(greaterThanOrEqualToConstant: Constants.recommendedItemHeight).isActive = true
        
        getNavigationItem().titleView = view
        return view
    }
        
    internal func setup(view: UIView) {
        view.backgroundColor = .clear
    }
    
    // MARK: Manage UIButtons
    internal func addButton(with text: String) -> UIButton {
        let button = UIButton(type: .custom)
        setup(button: button, with: text)
        
        getNavigationItem().titleView = button
        return button
    }
    
    internal func setup(button: UIButton, with text: String) {
        button.setTitle(text, for: .normal)
        
        let colorStyle = getColorStyle()
        button.titleLabel?.font = colorStyle.titleFont
        button.tintColor = colorStyle.titleColor
        button.setTitleColor(colorStyle.titleColor, for: .normal)
        button.setTitleColor(colorStyle.highlightColor(for: colorStyle.titleColor), for: .highlighted)
        button.setTitleColor(colorStyle.disabledColor, for: .disabled)
        
        button.addTarget(self,
                         action: #selector(titleViewButtonPressed(with:)),
                         for: .touchUpInside)
    }
    
    // MARK: Manage UILabels
    internal func addLabel(with text: String) -> UILabel {
        let label = UILabel(frame: .zero)
        setup(label: label, with: text)
        
        getNavigationItem().titleView = label
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

// MARK: - NavigationElementsModel management
private var models = [Int: NavigationElementsModel]()

public class NavigationElementsModel {
    public weak var modalNavigationBar: UINavigationBar?
    public weak var backgroundImageView: UIImageView?
    public weak var hairlineSeparatorView: UIView?
    public weak var shadowBackgroundView: UIImageView?
    
    public var customSuperview: UIView? {
        return modalNavigationBar?.superview
    }
    
    public var bottomAnchor: NSLayoutYAxisAnchor? {
        if hairlineSeparatorView?.backgroundColor == .clear {
            return backgroundImageView?.bottomAnchor
        }
        return hairlineSeparatorView?.bottomAnchor ?? backgroundImageView?.bottomAnchor
    }
    
    func removeFromSuperview() {
        modalNavigationBar?.removeFromSuperview()
        backgroundImageView?.removeFromSuperview()
        hairlineSeparatorView?.removeFromSuperview()
        shadowBackgroundView?.removeFromSuperview()
    }
}

extension UIViewController: Identifiable {
    public var navigationElements: NavigationElementsModel {
        let value = models[uniqueIdentifier] ?? NavigationElementsModel()
        models[uniqueIdentifier] = value
        return value
    }
}
