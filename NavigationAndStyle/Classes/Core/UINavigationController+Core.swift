//
//  Copyright © 2019 Stefan Brighiu. All rights reserved.
//

import Foundation
import UIKit

private var blockAnimations = [Int: Bool]()

private var popDoneWithTouch = false

// MARK: - Handler Interactive slide-from-edge to back
extension UINavigationController {
    open func setupNavigationConvenienceSettings() {
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

// MARK: - UINavigationControllerDelegate event handling
extension UINavigationController: UINavigationControllerDelegate {
    open func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        popDoneWithTouch = false
        blockAnimations[uniqueIdentifier] = true
        
        if self.interactivePopGestureRecognizer?.numberOfTouches != 0 {
            popDoneWithTouch = true
        } else {
            viewController.refreshNavigationElements(with: nil, navItem: viewController.navigationItem, animated: true)
        }
    }
    
    open func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if popDoneWithTouch {
            viewController.refreshNavigationElements(with: nil, navItem: viewController.navigationItem, animated: true)
        }
        blockAnimations[uniqueIdentifier] = false
    }
    
    internal func getAnimatedTransitionDuration() -> TimeInterval {
        return Constants.defaultAnimationTime
    }
    
    internal func getAnimatedElementsUpdateDuration() -> TimeInterval {
        return getAnimatedTransitionDuration()/2
    }
}

// MARK: - InteractivePopGestureRecognizer delegate handling
extension UINavigationController: UIGestureRecognizerDelegate {
    open func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let block = blockAnimations[uniqueIdentifier] ?? false
        guard interactivePopGestureRecognizer == gestureRecognizer, viewControllers.count > 1, !block else {
            return false
        }
        return true
    }
    // TODO: - remove? default?
    open func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    open func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
    
    open func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
