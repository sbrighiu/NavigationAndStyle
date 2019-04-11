//
//  Copyright © 2019 Stefan Brighiu. All rights reserved.
//

import Foundation
import UIKit

private var blockAnimations = [Int: Bool]()

private var popDoneWithTouch = false

protocol NavigationC {
    var navigationBar: UINavigationBar { get }
    
    func setupNavigationConvenienceSettings(from vc: UIViewController)
}

// MARK: - Handler Interactive slide-from-edge to back
extension UINavigationController: NavigationC {
    open func setupNavigationConvenienceSettings(from vc: UIViewController) {
        if self.delegate == nil {
            self.interactivePopGestureRecognizer?.removeTarget(self, action: nil)
            self.interactivePopGestureRecognizer?.isEnabled = true
            self.interactivePopGestureRecognizer?.delegate = self
            self.interactivePopGestureRecognizer?.addTarget(self, action: #selector(handleGestures(_:)))
            
            self.delegate = self
        }
    }
    
    @objc func handleGestures(_ gesture: UIGestureRecognizer) {
        switch gesture.state {
        case .began:
            blockAnimations[uniqueIdentifier] = true
        case .cancelled,
             .ended,
             .failed:
            blockAnimations[uniqueIdentifier] = false
        default: break
        }
    }
}

// MARK: - Helper methods for those who customize even more and want to retain interactive pop functionality
extension UINavigationController {
    public func gestureRecognizerShouldBeginAction(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let block = blockAnimations[uniqueIdentifier] ?? false
        guard interactivePopGestureRecognizer == gestureRecognizer, viewControllers.count > 1, !block else {
            return false
        }
        return true
    }
    
    public func gestureRecognizerAction(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    public func navigationControllerAction(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        popDoneWithTouch = false
        blockAnimations[uniqueIdentifier] = true
        
        if self.interactivePopGestureRecognizer?.state == .began {
            popDoneWithTouch = true
        } else {
            viewController.triggerColorStyleRefresh(with: nil, navItem: viewController.navigationItem)
        }
    }
    
    public func navigationControllerAction(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if popDoneWithTouch {
            viewController.triggerColorStyleRefresh(with: nil, navItem: viewController.navigationItem)
        }
        blockAnimations[uniqueIdentifier] = false
    }
}

// MARK: - Boilerplate
// MARK: UINavigationControllerDelegate event handling
extension UINavigationController: UINavigationControllerDelegate {
    open func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        navigationControllerAction(navigationController, willShow: viewController, animated: animated)
    }
    
    open func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        navigationControllerAction(navigationController, didShow: viewController, animated: animated)
    }
}

// MARK: InteractivePopGestureRecognizer delegate handling
extension UINavigationController: UIGestureRecognizerDelegate {
    open func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return gestureRecognizerShouldBeginAction(gestureRecognizer)
    }
    
    open func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return gestureRecognizerAction(gestureRecognizer, shouldBeRequiredToFailBy: otherGestureRecognizer)
    }
}
