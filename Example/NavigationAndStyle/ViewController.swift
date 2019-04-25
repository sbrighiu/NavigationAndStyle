//
//  Copyright © 2019 Stefan Brighiu. All rights reserved.
//

import UIKit
import NavigationAndStyle

private extension UIBarButtonItemType {
    
    struct left {
        static let close: UIBarButtonItemType = {
            return .image(UIImage.NavigationAndStyle.close, extendTapAreaBy: 16, autoDismiss: true)
        }()
        static let back: UIBarButtonItemType = {
            return .image(UIImage.NavigationAndStyle.backArrow, extendTapAreaBy: 16, autoDismiss: true)
        }()
        static let test: UIBarButtonItemType = {
            return .title(NSLocalizedString("Test Test", comment: ""))
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
            let view = newView
            return (UIBarButtonItemType.view(view), view)
        }()
        static func rawBarItem(target: Any, selector: Selector) -> UIBarButtonItemType {
            let barButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: target, action: selector)
            barButtonItem.tintColor = .red
            return UIBarButtonItemType.raw(barButtonItem)
        }
    }
    
}

private var newView: UIView {
    let view = UIView()
    view.backgroundColor = .red
    view.layer.cornerRadius = 11
    return view
}

var numberOfVC = 0

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        numberOfVC += 1
        
        func setupExperiment() {
            let button = UIButton()
            button.setTitle("Experiment", for: .normal)
            
            let searchBar = UISearchBar(frame: .zero)
            searchBar.placeholder = NSLocalizedString("Search something", comment: "")
            
            set(titleCustomView: searchBar, left: [UIBarButtonItemType.left.close], right: [UIBarButtonItemType.right.dismiss])
            
            //            change(titleToCustomView: searchBar)
            //            self.navigationItem.titleView = view
        }
        
        if let navC = self.navigationController {
            if navC.viewControllers.count == 2 {
                set(titleButton: "Button", left: [UIBarButtonItemType.left.back], right: [UIBarButtonItemType.right.cancel])
                
            } else if navC.viewControllers.count == 3 {
                set(title: "Label", left: [UIBarButtonItemType.left.back], right: [UIBarButtonItemType.right.button(title: "Hello", target: self, selector: #selector(pressedCustomButton(button:)))])
                
            } else if navC.viewControllers.count == 4 {
                let (item, view) = UIBarButtonItemType.right.customView
                set(title: "\(numberOfVC)", left: [UIBarButtonItemType.left.back], right: [item])
                NSLayoutConstraint.activate([
                    view.heightAnchor.constraint(equalToConstant: 22),
                    view.widthAnchor.constraint(equalToConstant: 22)
                    ])
                
            } else if navC.viewControllers.count > 4 {
                setupExperiment()
                
            } else if UIApplication.shared.delegate?.window??.rootViewController != self.navigationController {
                set(titleButton: "Button", right: [UIBarButtonItemType.right.dismiss, UIBarButtonItemType.right.temp])
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
                    self?.change(rightNavBarItems: [UIBarButtonItemType.right.new, UIBarButtonItemType.right.dismiss])
                }
            } else {
                set(titleButton: "Button", left: [UIBarButtonItemType.left.test], right: [UIBarButtonItemType.right.rawBarItem(target: self, selector: #selector(pressedCustomBarButtonItem(barButtonItem:)))])
            }
        } else {
            setupExperiment()
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
        if navigationController == nil {
            self.view.backgroundColor = .black
            return ColorStyle.transparent(statusBarStyle: .lightContent,
                                          titleColor: .white,
                                          buttonTitleColor: .white,
                                          imageTint: .white)
        } else {
            if navigationController?.viewControllers.count == 2 {
                return ColorStyle(statusBarStyle: .lightContent,
                                  background: .red,
                                  titleColor: .white,
                                  buttonTitleColor: .white,
                                  imageTint: .white)
                
            } else if navigationController?.viewControllers.count == 3 {
                return ColorStyle.transparent(statusBarStyle: .default,
                                              shadow: UIColor.black.withAlphaComponent(0.33),
                                              titleColor: .white,
                                              buttonTitleColor: .white,
                                              imageTint: .white)
                
            } else if navigationController?.viewControllers.count == 4 {
                return ColorStyle(statusBarStyle: .lightContent,
                                  background: .black,
                                  titleColor: .white,
                                  buttonTitleColor: .white,
                                  imageTint: .white)
                
            }
        }
        return ColorStyle.default
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return getColorStyle().statusBarStyle
    }
    
}
