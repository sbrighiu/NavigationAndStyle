//
//  Copyright © 2019 Stefan Brighiu. All rights reserved.
//

import UIKit
import NavigationAndStyle

private extension NavBarItemType {
    struct right {
        static let systemItem: NavBarItemType = {
            return .systemItem(UIBarButtonItem.SystemItem.cancel, autoDismiss: true)
        }()
        static let overlay: NavBarItemType = {
            return .title("Oo.", autoDismiss: false)
        }()
        static let dismiss: NavBarItemType = {
            return .title(NSLocalizedString("Dismiss", comment: ""), autoDismiss: true)
        }()
        static let old: NavBarItemType = {
            return .title(NSLocalizedString("Old", comment: ""))
        }()
        static let new: NavBarItemType = {
            return .image(UIImage.Placeholders.settings)
        }()
    }
    struct left {
        static let overlay: NavBarItemType = {
            return .image(UIImage.Placeholders.close, autoDismiss: true, contentEdgeInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16))
        }()
        static let back: NavBarItemType = {
            return .image(UIImage.Placeholders.backArrow, autoDismiss: true, contentEdgeInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16))
        }()
        static let extra: NavBarItemType = {
            return .title(".oO")
        }()
    }
}

var numberOfVC = 1

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let navC = self.navigationController {
            if navC.viewControllers.count > 1 {
                _ = set(title: "\(numberOfVC)", left: [
                    NavBarItemType.left.back,
                    NavBarItemType.left.extra
                    ], right: [
                        NavBarItemType.right.systemItem
                    ])
            } else if UIApplication.shared.delegate?.window??.rootViewController != self.navigationController {
                _ = set(title: "\(numberOfVC)", right: [
                    NavBarItemType.right.dismiss,
                    NavBarItemType.right.old
                    ])
                _ = change(titleToSearchBarWithPlaceholder: "Search...")
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
                    _ = self?.change(rightNavBarItems: [
                        NavBarItemType.right.new,
                        NavBarItemType.right.dismiss
                        ])
                }
            } else {
                _ = set(title: "\(numberOfVC)")
                _ = change(titleToButtonWithTitle: "Settings", andImage: UIImage.Placeholders.settings)
            }
        } else {
            _ = set(title: "\(numberOfVC)", left: [
                NavBarItemType.left.overlay
                ], right: [
                    NavBarItemType.right.overlay
                ])
            _ = change(titleToImageViewWithImage: UIImage.Placeholders.settings)
        }
        
        numberOfVC += 1
    }
    
    override func titleViewButtonPressed(with button: UIButton) {
        let alert = UIAlertController.init(title: "TitleView button with text: \(button.titleLabel?.text ?? "<none>") tapped", message: nil, preferredStyle: .alert)
        self.present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            alert.dismiss(animated: true, completion: nil)
        }
    }
    
    override func navBarItemPressed(with type: NavBarItemType, button: UIButton?, isLeft: Bool) {
        if shouldAutomaticallyDismissFor(type) { return }
        
        if type == NavBarItemType.left.extra {
            showAlertForAction(of: type.description, isLeft: isLeft)
        }
        
        showAlertForAction(of: type.description, isLeft: isLeft)
    }
    
    func showAlertForAction(of tag: String, isLeft: Bool) {
        let text = "\(isLeft ? "Left" : "Right")Tag: .\(tag) action triggered"
        let alert = UIAlertController.init(title: text, message: nil, preferredStyle: .alert)
        self.present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            alert.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func dismissModal() {
        dismiss(animated: true, completion: nil)
    }
    
    override func getColorStyle() -> ViewControllerColorStyle {
        if navigationController?.viewControllers.count == 1 {
            self.view.backgroundColor = .white
            return ViewControllerColorStyle(statusBarStyle: .lightContent,
                                            background: .blue,
                                            titleTint: .white,
                                            buttonTint: .white,
                                            imageTint: .white)
            
        } else if navigationController?.viewControllers.count == 2 {
            self.view.backgroundColor = .white
            return ViewControllerColorStyle(statusBarStyle: .lightContent,
                                            background: .red,
                                            titleTint: .white,
                                            buttonTint: .white,
                                            imageTint: .white,
                                            underlineShadow: .white,
                                            underlineShadowAlpha: 0.1)
            
        } else if navigationController?.viewControllers.count == 3 {
            self.view.backgroundColor = .black
            return ViewControllerColorStyle(statusBarStyle: .default,
                                            background: .yellow,
                                            titleTint: .black,
                                            buttonTint: .black,
                                            imageTint: .black)
            
        } else if navigationController == nil {
            self.view.backgroundColor = .black
            return ViewControllerColorStyle(statusBarStyle: .default,
                                            background: .clear,
                                            shadow: .white,
                                            shadowAlpha: 1,
                                            titleTint: .black,
                                            buttonTint: .black,
                                            imageTint: .black)
        }
        return ViewControllerColorStyle(statusBarStyle: .lightContent,
                                        background: .black,
                                        primary: .white,
                                        secondary: .white)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return getColorStyle().statusBarStyle
    }
    
}
