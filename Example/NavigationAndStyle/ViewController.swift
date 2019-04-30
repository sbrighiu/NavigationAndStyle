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
        static let test: UIBarButtonItemType = {
            return .title(NSLocalizedString("Test", comment: ""))
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
    }
}

private extension UINavigationBarItemType {
    struct middle {
        static var label: UINavigationBarItemType = {
            return UINavigationBarItemType.title("Label")
        }()
        static var button: UINavigationBarItemType = {
            return UINavigationBarItemType.title("Button", isTappable: true)
        }()
        static var image: UINavigationBarItemType = {
            return UINavigationBarItemType.image(testImage)
        }()
        static var tappableImage: UINavigationBarItemType = {
            return UINavigationBarItemType.image(testImage, isTappable: true)
        }()
    }
    
}

let testImage = UIImage(named: "yin-yang")!.withRenderingMode(.alwaysTemplate)

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
        
        if let navC = self.navigationController {
            if UIApplication.shared.delegate?.window??.rootViewController != self.navigationController {
                set(title: UINavigationBarItemType.middle.tappableImage,
                    rightItems: [UIBarButtonItemType.right.dismiss,
                                 UIBarButtonItemType.right.temp])
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
                    self?.change(rightItems: [UIBarButtonItemType.right.new,
                                              UIBarButtonItemType.right.dismiss])
                }
            } else if navC.viewControllers.count == 1 {
                set(title: UINavigationBarItemType.middle.button,
                    leftItems: [UIBarButtonItemType.left.test])
                
            } else if navC.viewControllers.count == 2 {
                set(title: UINavigationBarItemType.middle.label,
                    leftItems: [UIBarButtonItemType.left.backWithText],
                    rightItems: [UIBarButtonItemType.right.cancel])
                
            } else {
                set(title: UINavigationBarItemType.middle.image,
                    leftItems: [UIBarButtonItemType.left.back],
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
