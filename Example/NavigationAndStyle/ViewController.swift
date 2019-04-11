//
//  Copyright © 2019 Stefan Brighiu. All rights reserved.
//

import UIKit
import NavigationAndStyle

private extension UIBarButtonItemType {
    
    struct left {
        static let close: UIBarButtonItemType = {
            return .image(UIImage.NavigationAndStyle.close, autoDismiss: true, contentEdgeInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16))
        }()
        static let back: UIBarButtonItemType = {
            return .image(UIImage.NavigationAndStyle.backArrow, autoDismiss: true, contentEdgeInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16))
        }()
        static let settings: UIBarButtonItemType = {
            return .image(UIImage.NavigationAndStyle.settings)
        }()
    }
    
    struct right {
        static let cancel: UIBarButtonItemType = {
            return .systemItem(UIBarButtonItem.SystemItem.cancel)
        }()
        static let dismiss: UIBarButtonItemType = {
            return .title(NSLocalizedString("Dismiss", comment: ""))
        }()
        static let new: UIBarButtonItemType = {
            return .title(NSLocalizedString("New", comment: ""))
        }()
        static let temp: UIBarButtonItemType = {
            return .title(NSLocalizedString("Temp", comment: ""))
        }()
        static func button(title: String, target: Any, selector: Selector) -> UIBarButtonItemType {
            let button = UIButton(type: .detailDisclosure)
            button.tintColor = .red
            button.addTarget(target, action: selector, for: .touchDown)
            return UIBarButtonItemType.button(button)
        }
        static var customView: (UIBarButtonItemType, UIView) = {
            let view = UIView()
            view.backgroundColor = .red
            view.layer.cornerRadius = 11
            return (UIBarButtonItemType.view(view), view)
        }()
        static func rawBarItem(target: Any, selector: Selector) -> UIBarButtonItemType {
            let barButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: target, action: selector)
            barButtonItem.tintColor = .red
            return UIBarButtonItemType.raw(barButtonItem)
        }
    }
    
}

var numberOfVC = 0

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        numberOfVC += 1
        
        if let navC = self.navigationController {
            if navC.viewControllers.count == 2 {
                _ = set(title: "\(numberOfVC)", left: [UIBarButtonItemType.left.back], right: [UIBarButtonItemType.right.cancel])
                
            } else if navC.viewControllers.count == 3 {
                _ = set(title: "\(numberOfVC)", left: [UIBarButtonItemType.left.back], right: [UIBarButtonItemType.right.button(title: "Hello", target: self, selector: #selector(pressedCustomButton(button:)))])
            
            } else if navC.viewControllers.count == 4 {
                let (item, view) = UIBarButtonItemType.right.customView
                _ = set(title: "\(numberOfVC)", left: [UIBarButtonItemType.left.back], right: [item])
                NSLayoutConstraint.activate([
                    view.heightAnchor.constraint(equalToConstant: 22),
                    view.widthAnchor.constraint(equalToConstant: 22)
                    ])
                
            } else if navC.viewControllers.count > 4 {
                _ = set(title: "\(numberOfVC)", left: [UIBarButtonItemType.left.back], right: [UIBarButtonItemType.right.cancel])
                
            } else if UIApplication.shared.delegate?.window??.rootViewController != self.navigationController {
                _ = set(title: "\(numberOfVC)", right: [UIBarButtonItemType.right.dismiss, UIBarButtonItemType.right.temp])
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
                    _ = self?.change(rightNavBarItems: [UIBarButtonItemType.right.new, UIBarButtonItemType.right.dismiss])
                }
            } else {
                _ = set(title: "Test", left: [UIBarButtonItemType.left.settings], right: [UIBarButtonItemType.right.rawBarItem(target: self, selector: #selector(pressedCustomBarButtonItem(barButtonItem:)))])
            }
        } else {
            _ = set(title: "\(numberOfVC)", left: [UIBarButtonItemType.left.close], right: [UIBarButtonItemType.right.dismiss])
            _ = change(titleToImageViewWithImage: UIImage.NavigationAndStyle.settings)
        }
    }
    
    @objc func pressedCustomBarButtonItem(barButtonItem: UIBarButtonItem) {
        showAlertForAction(of: "<Custom barButtonItem>", isLeft: false)
    }
    
    @objc func pressedCustomButton(button: UIButton) {
        showAlertForAction(of: "<Custom button>", isLeft: false)
    }
    
    override func titleViewButtonPressed(with button: UIButton) {
        let alert = UIAlertController.init(title: "TitleView button with text: \(button.titleLabel?.text ?? "<none>") tapped", message: nil, preferredStyle: .alert)
        self.present(alert, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            alert.dismiss(animated: true, completion: nil)
        }
    }
    
    override func navBarItemPressed(with type: UIBarButtonItemType, button: UIButton?, isLeft: Bool) {
        if shouldAutomaticallyDismissFor(type) { return }
        
        if type == UIBarButtonItemType.right.cancel || type == UIBarButtonItemType.right.dismiss {
            if let navC = self.navigationController, self != self.navigationController?.viewControllers.first {
                navC.popToRootViewController(animated: true)
            } else {
                self.dismiss(animated: true)
            }
            return
        }
        
        showAlertForAction(of: type.description, isLeft: isLeft)
    }
    
    func showAlertForAction(of tag: String, isLeft: Bool) {
        let text = "\(isLeft ? "Left" : "Right")Tag: .\(tag) action triggered"
        let alert = UIAlertController.init(title: text, message: nil, preferredStyle: .alert)
        self.present(alert, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
            alert.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func dismissModal() {
        dismiss(animated: true, completion: nil)
    }
    
    override func getColorStyle() -> ColorStyle {
        if navigationController?.viewControllers.count == 1 {
            self.view.backgroundColor = .white
            return ColorStyle()
            
        } else if navigationController?.viewControllers.count == 2 {
            self.view.backgroundColor = .white
            return ColorStyle(statusBarStyle: .lightContent,
                              background: .red,
                              titleColor: .white,
                              buttonTitleColor: .white,
                              imageTint: .white)
            
        } else if navigationController?.viewControllers.count == 3 {
            self.view.backgroundColor = .white
            return ColorStyle(statusBarStyle: .default,
                              background: .clear,
                              shadow: UIColor.white.withAlphaComponent(0.66),
                              titleColor: .black,
                              buttonTitleColor: .black,
                              imageTint: .black)
            
        } else if navigationController == nil {
            if !numberOfVC.isMultiple(of: 2) {
                self.view.backgroundColor = .white
                return ColorStyle(statusBarStyle: .lightContent,
                                  background: .red,
                                  titleColor: .white,
                                  buttonTitleColor: .white,
                                  imageTint: .white)
            } else {
                self.view.backgroundColor = .black
                return ColorStyle(statusBarStyle: .default,
                                  background: .clear,
                                  shadow: UIColor.white.withAlphaComponent(0.66),
                                  titleColor: .black,
                                  buttonTitleColor: .black,
                                  imageTint: .black)
            }
        }
        return ColorStyle(statusBarStyle: .lightContent,
                          background: .black,
                          titleColor: .white,
                          buttonTitleColor: .white,
                          imageTint: .white)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return getColorStyle().statusBarStyle
    }
    
}
