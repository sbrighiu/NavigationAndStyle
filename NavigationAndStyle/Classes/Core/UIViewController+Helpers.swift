//
//  Copyright © 2019 Stefan Brighiu. All rights reserved.
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
    
    internal func addBackgroundAndMaskView(to superView: UIView) -> (UIImageView, UIImageView) {
        let colorStyle = getColorStyle()
        
        let backgroundImageView = UIImageView(frame: .zero)
        backgroundImageView.backgroundColor = colorStyle.backgroundColor
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.clipsToBounds = true
        backgroundImageView.image = colorStyle.backgroundImage
        backgroundImageView.isUserInteractionEnabled = false
        
        navigationElements.backgroundImageView = backgroundImageView
        
        superView.insertSubview(backgroundImageView, at: 0)
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: superView.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: superView.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: superView.trailingAnchor)
            ])
        
        let maskImageView = UIImageView(frame: .zero)
        maskImageView.backgroundColor = colorStyle.backgroundMaskColor
        maskImageView.contentMode = .scaleAspectFill
        maskImageView.clipsToBounds = true
        maskImageView.alpha = colorStyle.backgroundMaskAlpha
        maskImageView.image = colorStyle.backgroundMaskImage
        maskImageView.isUserInteractionEnabled = false
        
        navigationElements.backgroundMaskImageView = maskImageView
        
        superView.insertSubview(maskImageView, aboveSubview: backgroundImageView)
        maskImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            maskImageView.topAnchor.constraint(equalTo: backgroundImageView.topAnchor),
            maskImageView.leadingAnchor.constraint(equalTo: backgroundImageView.leadingAnchor),
            maskImageView.trailingAnchor.constraint(equalTo: backgroundImageView.trailingAnchor),
            maskImageView.bottomAnchor.constraint(equalTo: backgroundImageView.bottomAnchor)
            ])
        
        addHairlineSeparator(superView, maskImageView)
        
        return (backgroundImageView, maskImageView)
    }
    
    internal func addHairlineSeparator(_ superView: UIView, _ maskView: UIImageView) {
        let hairlineSeparatorColor = getColorStyle().hairlineSeparatorColor
        
        let hairlineView = UIView(frame: .zero)
        hairlineView.contentMode = .scaleAspectFill
        hairlineView.clipsToBounds = true
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
        shadowView.clipsToBounds = true
        shadowView.image = ColorStyle.Defaults.backgroundShadow
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
        
        let (backgroundImageView, _) = addBackgroundAndMaskView(to: self.view)
        backgroundImageView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        
        let shadowView = addShadowView(to: self.view)
        shadowView?.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: Constants.recommendedItemHeight).isActive = true
    }
    
    internal func addOverlayNavigationBarElements(to superView: UIView) {
        navigationElements.removeFromSuperview()
        
        let (backgroundImageView, maskView) = addBackgroundAndMaskView(to: superView)
        let shadowView = addShadowView(to: superView)
        
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
        
        shadowView?.bottomAnchor.constraint(equalTo: navBar.bottomAnchor, constant: Constants.shadowExtraHeight).isActive = true
        
        backgroundImageView.bottomAnchor.constraint(equalTo: navBar.bottomAnchor).isActive = true
    }
}

// MARK: - Handle titleView
extension UIViewController {
    internal func addButtonTitleView(with type: UINavigationBarItemType) {
        var target: Any?
        var selector: Selector?
        if type.isTappable {
            target = self
            selector = #selector(pressedNavTitle)
        }
        
        let button = UIButton.build(with: type,
                                    target: target,
                                    action: selector,
                                    isLeft: nil,
                                    and: getColorStyle())
        
        if !type.isTappable {
            button.isUserInteractionEnabled = false
        }
        
        getNavigationItem().titleView = button
    }
    
    internal func addTitleImageView(with type: UINavigationBarItemType) {
        var target: Any?
        var selector: Selector?
        if type.isTappable {
            target = self
            selector = #selector(pressedNavTitle)
        }
        
        let imageView = UIImageView.build(with: type,
                                          target: target,
                                          action: selector,
                                          and: getColorStyle())
        
        getNavigationItem().titleView = imageView
    }
}

// MARK: - NavigationElementsModel management
private var models = [Int: NavigationVCModel]()

public class NavigationVCModel {
    public weak var modalNavigationBar: UINavigationBar?
    public weak var backgroundImageView: UIImageView?
    public weak var backgroundMaskImageView: UIImageView?
    public weak var hairlineSeparatorView: UIView?
    public weak var shadowBackgroundView: UIImageView?
    
    public var bottomAnchor: NSLayoutYAxisAnchor? {
        if hairlineSeparatorView?.backgroundColor == .clear {
            return backgroundImageView?.bottomAnchor
        }
        return hairlineSeparatorView?.bottomAnchor
    }
    
    internal func removeFromSuperview() {
        modalNavigationBar?.removeFromSuperview()
        backgroundImageView?.removeFromSuperview()
        backgroundMaskImageView?.removeFromSuperview()
        hairlineSeparatorView?.removeFromSuperview()
        shadowBackgroundView?.removeFromSuperview()
    }
}

extension UIViewController: Identifiable {
    public var navigationElements: NavigationVCModel {
        let model = models[uniqueIdentifier] ?? NavigationVCModel()
        models[uniqueIdentifier] = model
        return model
    }
}
