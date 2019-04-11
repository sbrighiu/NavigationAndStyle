//
//  Copyright © 2019 Stefan Brighiu. All rights reserved.
//

import XCTest
@testable import NavigationAndStyle

class Tests: XCTestCase {
    
    // MARK: - Preparation and convenience
    var rootVC: UIViewController!
    var rootNavVC: UIViewController!
    
    func makeSUT(callback: SpyCallback? = nil, titleViewSpyCallback: TitleViewSpyCallback? = nil) {
        rootVC = UIWindow.makeContextWithVC(buttonCallback: callback, titleViewSpyCallback: titleViewSpyCallback)
    }
    
    func makeNavSUT(callback: SpyCallback? = nil, titleViewSpyCallback: TitleViewSpyCallback? = nil) {
        rootNavVC = UIWindow.makeContextWithNavC(buttonCallback: callback, titleViewSpyCallback: titleViewSpyCallback)
    }
    
    func createAndAddScrollView(to superView: UIView) -> UIScrollView {
        let scrollView = UIScrollView(frame: .zero)
        superView.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: superView.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: superView.trailingAnchor),
            scrollView.leadingAnchor.constraint(equalTo: superView.leadingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: superView.bottomAnchor),
            ])
        
        return scrollView
    }
    
    // MARK: - Setup test case
    override func setUp() {
        ColorStyle.global = ColorStyle(statusBarStyle: .default,
                                       background: .clear,
                                       shadow: .black,
                                       titleColor: .white,
                                       buttonTitleColor: .white,
                                       imageTint: .white)
    }
    
    // MARK: - Test setup
    func test_setupNotCalled() {
        makeSUT()
        XCTAssertFalse(rootVC.didSetupCustomNavigationAndStyle)
    }
    
    func test_setupWithEmptyStyle() {
        ColorStyle.global = ColorStyle()
        makeSUT()
        rootVC.set(title: anyText)
        XCTAssert(rootVC.didSetupCustomNavigationAndStyle)
    }
    
    func test_setupWithTitle() {
        ColorStyle.global = ColorStyle()
        
        makeSUT()
        rootVC.set(title: anyText)
        
        XCTAssert((rootVC.navigationItem.titleView as! UILabel).text == anyText)
    }
    
    // MARK: - Functionality tests
    func test_logMethods() {
        logFrameworkError("Testing")
        logFrameworkWarning("Testing")
    }
    
    func test_modalVC() {
        makeSUT()
        rootVC.set(title: anyText)
        XCTAssert(rootVC.didSetupCustomNavigationAndStyle)
    }
    
    func test_modalVC_customSuperview() {
        makeSUT()
        
        let scrollView = createAndAddScrollView(to: rootVC.view)
        let (_, _, _, navBar, _, shadowView) = rootVC.set(title: anyText, overrideModalSuperview: scrollView)
        
        XCTAssert(navBar.superview === scrollView)
        XCTAssert(shadowView!.superview === scrollView)
        XCTAssert(rootVC.didSetupCustomNavigationAndStyle)
    }
    
    func test_navVC() {
        makeNavSUT()
        let (_, _, _, navBar, _, shadowView) = rootNavVC.set(title: anyText,
                                                             left: [.image(UIImage.NavigationAndStyle.backArrow)],
                                                             right: [.image(UIImage.NavigationAndStyle.forwardArrow)])
        
        let navC = rootNavVC.navigationController!
        XCTAssert(navC.navigationBar === navBar)
        XCTAssert(shadowView!.superview === rootNavVC.view)
        XCTAssert(navC.delegate === (navC as UINavigationControllerDelegate))
        XCTAssert(navC.interactivePopGestureRecognizer!.delegate === (navC as UINavigationControllerDelegate))
        XCTAssert(navC.navigationBar.isTranslucent == true)
        XCTAssert(rootNavVC.didSetupCustomNavigationAndStyle)
    }
    
    func test_navVC_customSuperview() {
        makeNavSUT()
        
        let scrollView = createAndAddScrollView(to: rootNavVC.view)
        let (_, _, _, _, _, shadowView) = rootNavVC.set(title: anyText, overrideModalSuperview: scrollView)
        
        XCTAssert(shadowView!.superview !== scrollView) // Will always be ignored when using an UINavigationController since the superview is handled by the navigation controller and cannot be changed
        XCTAssert(rootNavVC.didSetupCustomNavigationAndStyle)
    }
    
    func test_oneLeftButton() {
        makeSUT()
        rootVC.set(title: anyText, left: [UIBarButtonItemType.title(anyText)])
        
        XCTAssertNotNil(rootVC.navigationItem.leftBarButtonItem)
    }
    
    func test_multipleLeftButtons() {
        makeSUT()
        rootVC.set(title: anyText,
                   left: [UIBarButtonItemType.title(anyText),
                          UIBarButtonItemType.title(otherText)])
        
        XCTAssert(rootVC.navigationItem.leftBarButtonItems!.count == 2)
    }
    
    func test_oneRightButton() {
        makeSUT()
        rootVC.set(title: anyText, right: [UIBarButtonItemType.title(anyText)])
        
        XCTAssertNotNil(rootVC.navigationItem.rightBarButtonItem)
    }
    
    func test_multipleRightButtons() {
        makeSUT()
        rootVC.set(title: anyText,
                   right: [UIBarButtonItemType.title(anyText),
                           UIBarButtonItemType.title(otherText),
                           UIBarButtonItemType.image(UIImage.NavigationAndStyle.close)])
        
        XCTAssert(rootVC.navigationItem.rightBarButtonItems!.count == 3)
    }
    
    func test_replaceTitle() {
        makeSUT()
        rootVC.set(title: anyText)
        
        XCTAssert((rootVC.navigationItem.titleView as! UILabel).text == anyText)
        
        let label = rootVC.change(titleTo: otherText)
        
        let resultLabel = rootVC.navigationItem.titleView as! UILabel
        XCTAssert(resultLabel === label)
        XCTAssert(resultLabel.text == otherText)
        
        rootVC.set(title: anyText)
        
        XCTAssert((rootVC.navigationItem.titleView as! UILabel).text == anyText)
    }
    
    func test_replaceTitleWithImageView() {
        makeSUT()
        rootVC.set(title: anyText)
        
        XCTAssert((rootVC.navigationItem.titleView as! UILabel).text == anyText)
        
        let imageView = rootVC.change(titleToImageViewWithImage: anyImage)
        
        let resultImageView = rootVC.navigationItem.titleView as! UIImageView
        XCTAssert(resultImageView === imageView)
        XCTAssert(resultImageView.image == anyImage)
        
        rootVC.set(title: anyText)
        
        XCTAssert((rootVC.navigationItem.titleView as! UILabel).text == anyText)
    }
    
    func test_replaceTitleWithButton() {
        makeSUT()
        rootVC.set(title: anyText)
        
        XCTAssert((rootVC.navigationItem.titleView as! UILabel).text == anyText)
        
        let button = rootVC.change(titleToButtonWithTitle: otherText, andImage: anyImage)
        
        let resultButton = rootVC.navigationItem.titleView as! UIButton
        XCTAssert(resultButton === button)
        XCTAssert(resultButton.imageView?.image == anyImage)
        XCTAssert(resultButton.titleLabel?.text == otherText)
        
        rootVC.set(title: anyText)
        
        XCTAssert((rootVC.navigationItem.titleView as! UILabel).text == anyText)
    }
    
    func test_replaceRightItems() {
        makeSUT()
        rootVC.set(title: anyText,
                   right: [UIBarButtonItemType.title(anyText),
                           UIBarButtonItemType.titleAndImage(otherText, image: anyImage),
                           UIBarButtonItemType.image(UIImage.NavigationAndStyle.close),
                           UIBarButtonItemType.image(UIImage.NavigationAndStyle.settings),
                           UIBarButtonItemType.button(anyButton),
                           UIBarButtonItemType.view(anyView),
                           UIBarButtonItemType.raw(anyBarButtonItem)])
        
        XCTAssert(rootVC.navigationItem.rightBarButtonItems!.count == 7)
        
        rootVC.change(rightNavBarItems: [.systemItem(.cancel)])
        
        XCTAssert(rootVC.navigationItem.rightBarButtonItems!.count == 1)
        
        rootVC.set(title: anyText,
                   right: [UIBarButtonItemType.title(anyText),
                           UIBarButtonItemType.title(otherText),
                           UIBarButtonItemType.image(UIImage.NavigationAndStyle.close)])
        
        XCTAssert(rootVC.navigationItem.rightBarButtonItems!.count == 3)
    }
    
    func test_replaceLeftItems() {
        makeSUT()
        rootVC.set(title: anyText,
                   left: [UIBarButtonItemType.systemItem(.cancel)])
        
        XCTAssert((rootVC.navigationItem.leftBarButtonItems ?? []).count == 1)
        
        rootVC.change(leftNavBarItems: [])
        
        XCTAssert((rootVC.navigationItem.leftBarButtonItems ?? []).count == 0)
        
        rootVC.set(title: anyText,
                   left: [UIBarButtonItemType.systemItem(.cancel)])
        
        XCTAssert((rootVC.navigationItem.leftBarButtonItems ?? []).count == 1)
    }
    
    // MARK: - Actions Tests
    func test_buttonActions() {
        let barItemLeftType1 = UIBarButtonItemType.title(anyText)
        let barItemLeftType2 = UIBarButtonItemType.title(otherText)
        let barItemRightType = UIBarButtonItemType.image(anyImage)
        
        var foundLeftButton1: UIButton?
        var foundLeftButton2: UIButton?
        var foundRightButton: UIButton?
        
        let exp = expectation(description: "waiting")
        exp.expectedFulfillmentCount = 3
        let callback: SpyCallback = { (type, button, isLeft) in
            exp.fulfill()
            if isLeft {
                if foundLeftButton1 == nil {
                    foundLeftButton1 = button
                } else if foundLeftButton2 == nil {
                    foundLeftButton2 = button
                }
            } else {
                foundRightButton = button
            }
            XCTAssert((isLeft && barItemLeftType1 === type || barItemLeftType2 === type) || (!isLeft && barItemRightType === type))
        }
        makeSUT(callback: callback)
        
        let (_, leftButtons, rightButtons, _, _, _) = rootVC.set(title: anyText, left: [barItemLeftType1, barItemLeftType2], right: [barItemRightType])
        let buttonLeft1 = leftButtons.first!
        let buttonLeft2 = leftButtons.last!
        let buttonRight = rightButtons.first!
        
        XCTAssert(leftButtons.count == 2)
        XCTAssert(rightButtons.count == 1)
        
        rootVC.perform(#selector(rootVC.pressedLeft(item:)), with: buttonLeft1)
        rootVC.perform(#selector(rootVC.pressedLeft(item:)), with: buttonLeft2)
        rootVC.perform(#selector(rootVC.pressedRight(item:)), with: buttonRight)
        
        waitForExpectations(timeout: 1.0, handler: nil)
        
        XCTAssert(foundLeftButton1 === buttonLeft1)
        XCTAssert(foundLeftButton2 === buttonLeft2)
        XCTAssert(foundRightButton === buttonRight)
    }
    
    func test_titleViewButtonActions() {
        var foundButton: UIButton?
        
        let exp = expectation(description: "waiting")
        exp.expectedFulfillmentCount = 1
        let titleViewSpyCallback: TitleViewSpyCallback = { (button) in
            exp.fulfill()
            
            foundButton = button
        }
        makeSUT(titleViewSpyCallback: titleViewSpyCallback)
        
        let (_, leftButtons, rightButtons, _, _, _) = rootVC.set(title: anyText)
        let button = rootVC.change(titleToButtonWithTitle: anyText)
        
        XCTAssert(leftButtons.count == 0)
        XCTAssert(rightButtons.count == 0)
        
        rootVC.perform(#selector(rootVC.titleViewButtonPressed(with:)), with: button)
        
        waitForExpectations(timeout: 1.0, handler: nil)
        
        XCTAssert(foundButton === button)
    }
    
    func test_systemButtonActions() {
        let barItemLeftType = UIBarButtonItemType.systemItem(.cancel)
        let barItemRightType = UIBarButtonItemType.systemItem(.save)
        
        let exp = expectation(description: "waiting")
        exp.expectedFulfillmentCount = 2

        let callback: SpyCallback = { (type, button, isLeft) in
            exp.fulfill()
            XCTAssert(button == nil)
            XCTAssert((isLeft && barItemLeftType === type) || (!isLeft && barItemRightType === type))
        }
        makeSUT(callback: callback)
        
        let (_, leftButtons, rightButtons, navBar, _, _) = rootVC.set(title: anyText, left: [barItemLeftType], right: [barItemRightType])
        XCTAssert(leftButtons.first! == nil && leftButtons.last! == nil && leftButtons.count == 1)
        XCTAssert(rightButtons.first! == nil && rightButtons.last! == nil && leftButtons.count == 1)
        
        let barItemLeft = navBar.items!.last!.leftBarButtonItem!
        let barItemRight = navBar.items!.last!.rightBarButtonItem!
        
        rootVC.perform(#selector(rootVC.pressedLeft(item:)), with: barItemLeft)
        rootVC.perform(#selector(rootVC.pressedRight(item:)), with: barItemRight)
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func test_itemShouldAutomaticallyDismiss() {
        // Left VC
        makeSUT()
        let typeLeft = UIBarButtonItemType.title(anyText)
        rootVC.set(title: anyText, left: [typeLeft])
        
        XCTAssertNotNil(rootVC.navigationItem.leftBarButtonItem)
        XCTAssert(rootVC.shouldAutomaticallyDismissFor(typeLeft) == false)
        
        // Right VC
        makeSUT()
        let typeRight = UIBarButtonItemType.title(anyText, autoDismiss: true)
        rootVC.set(title: anyText, right: [typeRight])
        
        XCTAssertNotNil(rootVC.navigationItem.rightBarButtonItem)
        XCTAssert(rootVC.shouldAutomaticallyDismissFor(typeRight) == true)
        
        // Left NavVC
        makeNavSUT()
        rootNavVC.set(title: anyText, left: [typeLeft])
        
        XCTAssertNotNil(rootNavVC.navigationItem.leftBarButtonItem)
        XCTAssert(rootNavVC.shouldAutomaticallyDismissFor(typeLeft) == false)
        
        // Right NavVC
        makeNavSUT()
        rootNavVC.set(title: anyText, right: [typeRight])
        
        XCTAssertNotNil(rootNavVC.navigationItem.rightBarButtonItem)
        XCTAssert(rootNavVC.shouldAutomaticallyDismissFor(typeRight) == true)
        
        let exp = expectation(description: "waiting")
        exp.expectedFulfillmentCount = 1
        
        let vc = UIViewController()
        vc.set(title: anyText, right: [typeRight])
        
        rootNavVC.navigationController?.pushViewController(vc, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            exp.fulfill()
            XCTAssert(vc.shouldAutomaticallyDismissFor(typeRight) == true)
        }
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    // MARK: - Modal presentation test
    func test_modalPresentTest() {
        let exp = expectation(description: "waiting")
        exp.expectedFulfillmentCount = 1
        
        let vc = UIViewController()
        vc.set(title: anyText)
        
        makeNavSUT()
        rootNavVC.set(title: otherText)
        
        rootNavVC.navigationController?.present(vc, animated: true, completion: {
            exp.fulfill()
            
            XCTAssert((vc.navigationItem.titleView as! UILabel).text == anyText)
        })
        
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func test_pushPresentTest() {
        let exp = expectation(description: "waiting")
        exp.expectedFulfillmentCount = 1
        
        let vc = UIViewController()
        vc.set(title: anyText)
        
        makeNavSUT()
        rootNavVC.set(title: otherText)
        
        rootNavVC.navigationController?.pushViewController(vc, animated: true)
        
        var foundVC: UIViewController?
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: { [weak self] in
            exp.fulfill()
            
            XCTAssert((vc.navigationItem.titleView as! UILabel).text == anyText)
            
            foundVC = self?.rootNavVC.navigationController?.topViewController
        })
        
        waitForExpectations(timeout: 5.0, handler: nil)
        
        XCTAssert(foundVC === vc)
    }
    
}
