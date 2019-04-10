//
//  Copyright © 2019 Stefan Brighiu. All rights reserved.
//

import Foundation
import UIKit

private var blockAnimations = [Int: Bool]()
private var defaultAnimationDuration: TimeInterval = defaultAnimationTime

private var popDoneWithTouch = false

// MARK: - Handler Interactive slide-from-edge to back
extension UINavigationController {
    open func setupNavigationConvenienceSettings() {
        self.view.backgroundColor = .clear
        
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
        }
    }
    
    open func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if popDoneWithTouch {
            viewController.refreshNavigationElements(with: nil, navItem: viewController.navigationItem, animated: true)
        }
        blockAnimations[uniqueIdentifier] = false
    }
    
    open func navigationController(_ navigationController: UINavigationController,
                                   animationControllerFor operation: UINavigationController.Operation,
                                   from fromVC: UIViewController,
                                   to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        toVC.refreshNavigationElements(with: nil, navItem: toVC.navigationItem, animated: true)
        return getAnimatedTransitionManager(for: operation)
    }
    
    open func getAnimatedTransitionManager(for operation: UINavigationController.Operation) -> UIViewControllerAnimatedTransitioning? {
        return PushPopTransition(operation: operation, duration: defaultAnimationDuration)
    }
    
    internal func getAnimatedTransitionDuration() -> TimeInterval {
        return getAnimatedTransitionManager(for: .push)?.transitionDuration(using: nil) ?? defaultAnimationDuration
    }
    
    internal func getAnimatedElementsUpdateDuration() -> TimeInterval {
        return getAnimatedTransitionDuration()/2
    }
    
}

// MARK: - Custom push pop animation
fileprivate class PushPopTransition: NSObject, UIViewControllerAnimatedTransitioning {
    let duration: TimeInterval
    let navigationControllerOperation: UINavigationController.Operation
    
    init(operation: UINavigationController.Operation, duration: TimeInterval = defaultAnimationDuration) {
        self.navigationControllerOperation = operation
        self.duration = duration
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
            let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to),
            let fromView = fromVC.view,
            let toView = toVC.view {
            
            let containerView = transitionContext.containerView
            
            var directionMultiplier: CGFloat = 1.0
            if self.navigationControllerOperation == .push {
                directionMultiplier = +1.0
                
            } else if self.navigationControllerOperation == .pop {
                directionMultiplier = -1.0
            }
            
            containerView.clipsToBounds = false
            containerView.addSubview(toView)
            
            var fromViewEndFrame = fromView.frame
            fromViewEndFrame.origin.x -= (containerView.frame.width * directionMultiplier)
            
            let toViewEndFrame = transitionContext.finalFrame(for: toVC)
            var toViewStartFrame = toViewEndFrame
            toViewStartFrame.origin.x += (containerView.frame.width * directionMultiplier)
            toView.frame = toViewStartFrame
            
            UIView.animate(withDuration: transitionDuration(using: transitionContext),
                           delay: 0,
                           options: [.beginFromCurrentState,
                                     .allowUserInteraction,
                                     .allowAnimatedContent,
                                     .curveEaseInOut],
                           animations: {
                            toView.frame = toViewEndFrame
                            fromView.frame = fromViewEndFrame
                            
            }, completion: { completed in
                fromView.removeFromSuperview()
                transitionContext.completeTransition(completed)
                containerView.clipsToBounds = true
            })
        }
    }
}

extension UINavigationController: UIGestureRecognizerDelegate {
    open func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let block = blockAnimations[uniqueIdentifier] ?? false
        guard interactivePopGestureRecognizer == gestureRecognizer, viewControllers.count > 1, !block else {
            return false
        }
        return true
    }
    
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
