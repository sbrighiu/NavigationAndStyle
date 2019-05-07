//
//  Copyright © 2019 Stefan Brighiu. All rights reserved.
//

import UIKit
import NavigationAndStyle

private extension UIBarButtonItemType {
    struct left {
        static let close: UIBarButtonItemType = {
            return .image(UIImage.NavigationAndStyle.close, extendTapAreaBy: 24, autoDismiss: true)
        }()
        static let back: UIBarButtonItemType = {
            return .image(UIImage.NavigationAndStyle.backArrow, extendTapAreaBy: 32, autoDismiss: true)
        }()
        static let backWithText: UIBarButtonItemType = {
            return .titleAndImage(NSLocalizedString("Back", comment: ""), image: UIImage.NavigationAndStyle.backArrow, autoDismiss: true)
        }()
        static let settings: UIBarButtonItemType = {
            return .image(UIImage.NavigationAndStyle.settings, extendTapAreaBy: 24)
        }()
    }
    
    struct right {
        static let cancel: UIBarButtonItemType = {
            return .systemItem(UIBarButtonItem.SystemItem.cancel)
        }()
        static let dismiss: UIBarButtonItemType = {
            return .title(NSLocalizedString("Dismiss", comment: ""), autoDismiss: true)
        }()
        static let new: UIBarButtonItemType = {
            return .title(NSLocalizedString("New", comment: ""))
        }()
        static let temp: UIBarButtonItemType = {
            return .title(NSLocalizedString("Temp", comment: ""))
        }()
    }
}

private extension UINavigationBarItemType {
    struct middle {
        static var label: UINavigationBarItemType = {
            return UINavigationBarItemType.label("Label")
        }()
        static var button: UINavigationBarItemType = {
            return UINavigationBarItemType.button("Button", autoDismiss: true)
        }()
    }
}

var numberOfVC = 0

class ViewController: UIViewController {
    
    var alternativeStyle: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        numberOfVC += 1
        
        if numberOfVC.isMultiple(of: 2) {
            alternativeStyle = true
        }
        
        if let navC = self.navigationController {
            if UIApplication.shared.delegate?.window??.rootViewController != self.navigationController {
                set(title: UINavigationBarItemType.middle.button,
                    rightItems: [UIBarButtonItemType.right.dismiss,
                                 UIBarButtonItemType.right.temp])
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
                    self?.change(rightItems: [UIBarButtonItemType.right.new,
                                              UIBarButtonItemType.right.dismiss])
                }
            } else if navC.viewControllers.count == 1 {
                set(title: UINavigationBarItemType.middle.label,
                    leftItems: [UIBarButtonItemType.left.settings])
                
            } else if navC.viewControllers.count == 2 {
                set(title: UINavigationBarItemType.middle.button,
                    leftItems: [UIBarButtonItemType.left.back],
                    rightItems: [UIBarButtonItemType.right.cancel])
                
            } else {
                set(title: UINavigationBarItemType.middle.label,
                    leftItems: [UIBarButtonItemType.left.backWithText],
                    rightItems: [UIBarButtonItemType.right.cancel])
            }
        } else {
            set(title: UINavigationBarItemType.middle.button,
                leftItems: [UIBarButtonItemType.left.close])
        }
    }
    
    override func navBarTitlePressed(with type: UINavigationBarItemType) {
        let alert = UIAlertController.init(title: "titleView tapped", message: nil, preferredStyle: .alert)
        self.present(alert, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            alert.dismiss(animated: true, completion: nil)
        }
    }
    
    override func navBarItemPressed(with type: UIBarButtonItemType, isLeft: Bool) {
        if type == UIBarButtonItemType.right.cancel {
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
    
    override func willAutomaticallyDismiss() {
        print("Screen dismissed via auto-dismiss")
    }
    
    @IBAction func dismissModal() {
        dismiss(animated: true, completion: nil)
    }
    
    override func getColorStyle() -> ColorStyle {
        if navigationController == nil {
            self.view.backgroundColor = .black
            if alternativeStyle {
                return ColorStyle.transparent(statusBarStyle: .lightContent,
                                              titleColor: .white,
                                              buttonTitleColor: .white,
                                              imageTint: .white)
            } else {
                return ColorStyle(statusBarStyle: .default,
                                  backgroundColor: .white,
                                  titleColor: .black,
                                  buttonTitleColor: .black,
                                  imageTint: .black)
            }
        } else {
            if navigationController?.viewControllers.count == 1 {
                return ColorStyle(statusBarStyle: .lightContent,
                                  backgroundImage: UIImage(named: "example-image")!,
                                  backgroundMaskColor: UIColor.red,
                                  backgroundMaskAlpha: 0.7,
                                  titleColor: .white,
                                  buttonTitleColor: .white,
                                  imageTint: .white)
                
            } else if navigationController?.viewControllers.count == 2 {
                return ColorStyle(statusBarStyle: .lightContent,
                                  backgroundColor: .red,
                                  titleColor: .white,
                                  buttonTitleColor: .white,
                                  imageTint: .white)
                
            } else if navigationController?.viewControllers.count == 3 {
                return ColorStyle.transparent(statusBarStyle: .lightContent,
                                              shadow: UIColor.black.withAlphaComponent(0.33),
                                              titleColor: .white,
                                              buttonTitleColor: .white,
                                              imageTint: .white)
                
            } else if navigationController?.viewControllers.count == 4 {
                return ColorStyle(statusBarStyle: .lightContent,
                                  backgroundColor: .black,
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
