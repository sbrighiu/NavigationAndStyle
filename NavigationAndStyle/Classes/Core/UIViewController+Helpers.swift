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
        
        let maskView = addMaskView(to: superView)
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
        
        maskView.bottomAnchor.constraint(equalTo: navBar.bottomAnchor).isActive = true
    }
}

// MARK: - NavigationElementsModel management
private var models = [Int: NavigationElementsModel]()

public class NavigationElementsModel {
    public weak var modalNavigationBar: UINavigationBar?
    public weak var backgroundImageView: UIImageView?
    public weak var hairlineSeparatorView: UIView?
    public weak var shadowBackgroundView: UIImageView?
    
    public weak var titleImageView: UIImageView?
    public weak var titleViewButton: UIButton?
    
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
