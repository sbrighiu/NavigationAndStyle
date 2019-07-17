//
//  Copyright © 2019 Stefan Brighiu. All rights reserved.
//

import UIKit
import NavigationAndStyle

private extension UIBarButtonItemType {
    struct left {
        static let backWithText: UIBarButtonItemType = {
            return .titleAndImage(NSLocalizedString("Back", comment: ""), image: UIImage.NavigationAndStyle.backArrow, autoDismiss: true)
        }()
        static let backWithTwoLinesText: UIBarButtonItemType = {
            return .titleAndImage(NSLocalizedString("Back\nto the future", comment: ""), image: UIImage.NavigationAndStyle.backArrow, secondLineAttributes: [.foregroundColor: UIColor.white.withAlphaComponent(0.75)], autoDismiss: true)
        }()
    }
    
    struct right {
        static let cancel: UIBarButtonItemType = {
            return .systemItem(.cancel)
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
            return UINavigationBarItemType.label("Something")
        }()
        static var twoRowLabel: UINavigationBarItemType = {
            return UINavigationBarItemType.largeTitle("Native Title", andLabelTitle: "Something\nSomething", secondLineAttributes: [.foregroundColor: UIColor.white.withAlphaComponent(0.75)])
        }()
        static var twoRowLabel2: UINavigationBarItemType = {
            return UINavigationBarItemType.largeTitle("Native Title 2", andLabelTitle: "Something\nSomething", secondLineAttributes: [.foregroundColor: UIColor.black.withAlphaComponent(0.75)])
        }()
        static var button: UINavigationBarItemType = {
            return UINavigationBarItemType.button("Dismiss", autoDismiss: true)
        }()
        static var twoRowButton: UINavigationBarItemType = {
            return UINavigationBarItemType.button("Dismiss\nTap me", secondLineAttributes: [.foregroundColor: UIColor.white.withAlphaComponent(0.75)], autoDismiss: true)
        }()
        static var imageView: UINavigationBarItemType = {
            return UINavigationBarItemType.largeTitle("Native Title", andImage: UIImage(named: "yin-yang")!, autoDismiss: true)
        }()
        static var imageViewButton: UINavigationBarItemType = {
            return UINavigationBarItemType.imageView(UIImage(named: "yin-yang")!, isTappable: true, autoDismiss: true)
        }()
    }
}

var numberOfVC = 0

class ViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView?

    var alternativeStyle: Bool = false

    var shrinkCase: Bool = false

    override func viewWillLayoutSubviews() {
        if shrinkCase {
            self.checkIfLargeTitleIsVisible { [weak self] largeTitleActive in
                if largeTitleActive, navigationItem.rightBarButtonItem?.barItemType == nil {
                    self?.change(leftItems: [])
                    self?.change(rightItems: [UIBarButtonItemType.generic.settings])
                } else if !largeTitleActive, navigationItem.leftBarButtonItem?.barItemType == nil {
                    self?.change(leftItems: [UIBarButtonItemType.generic.settings])
                    self?.change(rightItems: [])
                }
            }
        }

        super.viewWillLayoutSubviews()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        numberOfVC += 1

        if (self.navigationController?.viewControllers.count ?? 0) > 1 {
            self.hidesBottomBarWhenPushed = true
        }

        if numberOfVC.isMultiple(of: 2) {
            alternativeStyle = true
        }
        
        if let navC = self.navigationController {
            if let scrollView = scrollView {
                shrinkCase = true
                set(title: UINavigationBarItemType.middle.twoRowLabel2)
                setLargeTitle(andDock: scrollView)
                setShrinkOnScroll(basedOn: scrollView)

                // MARK: - Possible fix for out of bounds large title
                if let mainView = scrollView.subviews.first {
                    let possibleDesignFixForLargeTitle = UIView()
                    possibleDesignFixForLargeTitle.backgroundColor = .white

                    scrollView.addSubview(possibleDesignFixForLargeTitle)

                    possibleDesignFixForLargeTitle.translatesAutoresizingMaskIntoConstraints = false
                    NSLayoutConstraint.activate([
                        possibleDesignFixForLargeTitle.bottomAnchor.constraint(equalTo: mainView.topAnchor),
                        possibleDesignFixForLargeTitle.leftAnchor.constraint(equalTo: mainView.leftAnchor),
                        possibleDesignFixForLargeTitle.widthAnchor.constraint(equalToConstant: 250),
                        possibleDesignFixForLargeTitle.heightAnchor.constraint(equalToConstant: 28)
                        ])
                }

            } else {
                if UIApplication.shared.delegate?.window??.rootViewController != self.navigationController {
                    set(title: UINavigationBarItemType.middle.twoRowButton,
                        rightItems: [UIBarButtonItemType.right.dismiss,
                                     UIBarButtonItemType.right.temp])

                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
                        self?.change(rightItems: [UIBarButtonItemType.right.new,
                                                  UIBarButtonItemType.right.dismiss])
                    }
                } else if navC.viewControllers.count == 1 {
                    set(title: .title("Simple native title"),
                        leftItems: [UIBarButtonItemType.generic.settings])
                    setLargeTitle(andDock: nil)

                } else if navC.viewControllers.count == 2 {
                    set(title: UINavigationBarItemType.middle.button,
                        leftItems: [UIBarButtonItemType.generic.back],
                        rightItems: [UIBarButtonItemType.right.cancel])

                } else if navC.viewControllers.count == 3 {
                    set(title: UINavigationBarItemType.middle.imageView,
                        leftItems: [UIBarButtonItemType.left.backWithTwoLinesText],
                        rightItems: [UIBarButtonItemType.right.cancel])
                    setLargeTitle(andDock: nil)

                } else if navC.viewControllers.count == 4 {
                    set(title: UINavigationBarItemType.middle.imageViewButton,
                        leftItems: [UIBarButtonItemType.left.backWithText],
                        rightItems: [UIBarButtonItemType.right.cancel])

                } else {
                    set(title: UINavigationBarItemType.middle.label,
                        leftItems: [UIBarButtonItemType.left.backWithText],
                        rightItems: [UIBarButtonItemType.right.cancel])
                }
            }
        } else {
            if let scrollView = scrollView {
                set(title: UINavigationBarItemType.middle.twoRowLabel2,
                    leftItems: [UIBarButtonItemType.generic.settings])
                dockViewToNavigationBar(scrollView, constant: 0)
            } else {
                set(title: UINavigationBarItemType.middle.button,
                    leftItems: [UIBarButtonItemType.right.cancel])
            }
        }
    }
    
    @IBAction func showProblematicModal(_ sender: Any) {
        guard let tabBarController = self.navigationController?.tabBarController else { return }

        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewControllerModal") as! ViewController

        tabBarController.present(vc, animated: true, completion: nil)
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
    
    override func getNavigationBarStyle() -> NavigationBarStyle {
        if navigationController == nil {
            if let _ = scrollView {
                return NavigationBarStyle(statusBarStyle: .default,
                                          backgroundColor: .white,
                                          titleColor: .black,
                                          buttonTitleColor: .black,
                                          imageTint: .black)
            } else {
                self.view.backgroundColor = .black
                if alternativeStyle {
                    return NavigationBarStyle.transparent(statusBarStyle: .lightContent,
                                                          titleColor: .white,
                                                          buttonTitleColor: .white,
                                                          imageTint: .white)
                } else {
                    return NavigationBarStyle(statusBarStyle: .default,
                                              backgroundColor: .white,
                                              titleColor: .black,
                                              buttonTitleColor: .black,
                                              imageTint: .black)
                }
            }
        } else {
            if navigationController?.viewControllers.count == 1 {
                return NavigationBarStyle(statusBarStyle: .lightContent,
                                          backgroundImage: UIImage(named: "example-image")!,
                                          backgroundMaskColor: UIColor.red,
                                          backgroundMaskAlpha: 0.7,
                                          titleColor: .white,
                                          buttonTitleColor: .white,
                                          imageTint: .white)
                
            } else if navigationController?.viewControllers.count == 2 {
                return NavigationBarStyle(statusBarStyle: .lightContent,
                                          backgroundColor: .red,
                                          titleColor: .white,
                                          buttonTitleColor: .white,
                                          imageTint: .white)
                
            } else if navigationController?.viewControllers.count == 3 {
                return NavigationBarStyle.transparent(statusBarStyle: .lightContent,
                                                      shadow: UIColor.black.withAlphaComponent(0.33),
                                                      titleColor: .white,
                                                      buttonTitleColor: .white,
                                                      imageTint: .white)
                
            } else if navigationController?.viewControllers.count == 4 {
                return NavigationBarStyle(statusBarStyle: .lightContent,
                                          backgroundColor: .black,
                                          titleColor: .white,
                                          buttonTitleColor: .white,
                                          imageTint: .white)
                
            }
        }
        return NavigationBarStyle.default
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return getNavigationBarStyle().statusBarStyle
    }
}
