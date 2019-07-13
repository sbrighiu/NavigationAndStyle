//
//  Copyright © 2019 Stefan Brighiu. All rights reserved.
//

import XCTest
@testable import NavigationAndStyle

class Tests: XCTestCase {
    
    // MARK: - Preparation and convenience
    var rootVC: SpyVC!
    var rootNavVC: SpyVC!
    
    func makeSUT(callback: SpyCallback? = nil, titleViewSpyCallback: TitleViewButtonSpyCallback? = nil) {
        rootVC = UIWindow.makeContextWithVC(buttonCallback: callback, titleViewButtonSpyCallback: titleViewSpyCallback)
    }
    
    func makeNavSUT(callback: SpyCallback? = nil, titleViewSpyCallback: TitleViewButtonSpyCallback? = nil) {
        rootNavVC = UIWindow.makeContextWithNavC(buttonCallback: callback, titleViewButtonSpyCallback: titleViewSpyCallback)
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
        NavigationBarStyle.global = NavigationBarStyle(statusBarStyle: .default,
                                       backgroundColor: .clear,
                                       shadow: .black,
                                       titleColor: .white,
                                       buttonTitleColor: .white,
                                       imageTint: .white)
    }
    
    // MARK: - Test setup
    func test_setupNotCalled() {
        NavigationBarStyle.global = NavigationBarStyle.transparent().new(backgroundImage: nil)
        
        makeSUT()
        XCTAssertFalse(rootVC.didSetupCustomNavigationAndStyle)
    }
    
    func test_setup() {
        NavigationBarStyle.global = NavigationBarStyle()
        
        makeSUT()
        rootVC.set(title: anyTitleItem)
        XCTAssert(rootVC.didSetupCustomNavigationAndStyle)
    }
    
    func test_setupWithTitle() {
        NavigationBarStyle.global = NavigationBarStyle.default
        
        makeSUT()
        rootVC.set(title: anyTitleItem)
        
        XCTAssert((rootVC.navigationItem.titleView as! UIButton).titleLabel!.text == anyText)
    }
    
    // MARK: - Functionality tests
    func test_logMethods() {
        logFrameworkError("Testing")
        logFrameworkWarning("Testing")
    }
    
    func test_modalVC() {
        makeSUT()
        rootVC.set(title: anyTitleItem)
        XCTAssert(rootVC.didSetupCustomNavigationAndStyle)
    }
    
    func test_navVC() {
        makeNavSUT()
        rootNavVC.set(title: anyTitleItem,
                      leftItems: [.image(UIImage.NavigationAndStyle.backArrow)],
                      rightItems: [.image(UIImage.NavigationAndStyle.forwardArrow)])
        
        let navC = rootNavVC.navigationController!
        XCTAssert(rootNavVC.navigationElements.modalNavigationBar == nil)
        XCTAssert(rootNavVC.navigationElements.shadowBackgroundView!.superview === rootNavVC.view)
        XCTAssert(navC.delegate === (navC as UINavigationControllerDelegate))
        XCTAssert(navC.interactivePopGestureRecognizer!.delegate === (navC as UINavigationControllerDelegate))
        XCTAssert(navC.navigationBar.isTranslucent == true)
        XCTAssert(rootNavVC.didSetupCustomNavigationAndStyle)
    }
    
    func test_bottomAnchor_exists() {
        makeNavSUT()
        rootNavVC.set(title: anyTitleItem,
                      leftItems: [.image(UIImage.NavigationAndStyle.backArrow)],
                      rightItems: [.image(UIImage.NavigationAndStyle.forwardArrow)])
        
        XCTAssert(rootNavVC.navigationElements.bottomAnchor != nil)
        
        NavigationBarStyle.global = NavigationBarStyle.default
        
        makeNavSUT()
        rootNavVC.set(title: anyTitleItem,
                      leftItems: [.image(UIImage.NavigationAndStyle.backArrow)],
                      rightItems: [.image(UIImage.NavigationAndStyle.forwardArrow)])
        
        XCTAssert(rootNavVC.navigationElements.bottomAnchor != nil)
    }
    
    func test_oneLeftButton() {
        makeSUT()
        rootVC.set(title: anyTitleItem, leftItems: [UIBarButtonItemType.title(anyText)])
        
        XCTAssertNotNil(rootVC.navigationItem.leftBarButtonItem)
    }
    
    func test_multipleLeftButtons() {
        makeSUT()
        rootVC.set(title: anyTitleItem,
                   leftItems: [.titleAndImage(NSLocalizedString("Back\nto the future", comment: ""), image: UIImage.NavigationAndStyle.backArrow, secondLineAttributes: [.foregroundColor: UIColor.white.withAlphaComponent(0.75)], autoDismiss: true),
                               .title(anyText, extendTapAreaBy: 8)])
        
        XCTAssert(rootVC.navigationItem.leftBarButtonItems!.count == 2)
    }
    
    func test_oneRightButton() {
        makeSUT()
        rootVC.set(title: anyTitleItem, rightItems: [UIBarButtonItemType.title(anyText, extendTapAreaBy: 16)])
        
        XCTAssertNotNil(rootVC.navigationItem.rightBarButtonItem)
    }
    
    func test_multipleRightButtons() {
        makeSUT()
        rootVC.set(title: anyTitleItem,
                   rightItems: [UIBarButtonItemType.title(anyText),
                                UIBarButtonItemType.title(otherText),
                                UIBarButtonItemType.image(UIImage.NavigationAndStyle.close)])
        
        XCTAssert(rootVC.navigationItem.rightBarButtonItems!.count == 3)
    }
    
    func test_replaceTitle() {
        makeSUT()
        rootVC.set(title: anyTitleItem)
        
        var temp = rootVC.navigationItem.titleView as! UIButton
        
        rootVC.change(title: UINavigationBarItemType.label("Something\nSomething", secondLineAttributes: [.foregroundColor: UIColor.white.withAlphaComponent(0.75)]))
        
        XCTAssert((rootVC.navigationItem.titleView as! UIButton) !== temp)
        temp = rootVC.navigationItem.titleView as! UIButton
        
        rootVC.set(title: .imageView(anyImage))
        
        XCTAssert(rootVC.navigationItem.titleView !== temp)
    }
    
    func test_replaceRightItems() {
        makeSUT()
        rootVC.set(title: anyTitleItem,
                   rightItems: [UIBarButtonItemType.title(anyText, extendTapAreaBy: 8),
                                UIBarButtonItemType.titleAndImage(otherText, image: anyImage),
                                UIBarButtonItemType.image(UIImage.NavigationAndStyle.close),
                                UIBarButtonItemType.image(UIImage.NavigationAndStyle.settings)])
        
        XCTAssert(rootVC.navigationItem.rightBarButtonItems!.count == 4)
        
        rootVC.change(rightItems: [.systemItem(.cancel)])
        
        XCTAssert(rootVC.navigationItem.rightBarButtonItems!.count == 1)
        
        rootVC.set(title: anyTitleItem,
                   rightItems: [UIBarButtonItemType.title(anyText),
                                UIBarButtonItemType.title(otherText),
                                UIBarButtonItemType.image(UIImage.NavigationAndStyle.close)])
        
        XCTAssert(rootVC.navigationItem.rightBarButtonItems!.count == 3)
    }
    
    func test_replaceLeftItems() {
        makeSUT()
        rootVC.set(title: anyTitleItem,
                   leftItems: [UIBarButtonItemType.systemItem(.cancel)])
        
        XCTAssert((rootVC.navigationItem.leftBarButtonItems ?? []).count == 1)
        
        rootVC.change(leftItems: [])
        
        XCTAssert((rootVC.navigationItem.leftBarButtonItems ?? []).count == 0)
        
        rootVC.set(title: anyTitleItem,
                   leftItems: [UIBarButtonItemType.systemItem(.cancel)])
        
        XCTAssert((rootVC.navigationItem.leftBarButtonItems ?? []).count == 1)
    }
    
    // MARK: - Actions Tests
    func test_buttonActions() {
        let barItemLeftType1 = UIBarButtonItemType.title(anyText)
        let barItemLeftType2 = UIBarButtonItemType.title(otherText)
        let barItemRightType = UIBarButtonItemType.titleAndImage(anyText, image: anyImage)
        
        let exp = expectation(description: "waiting")
        exp.expectedFulfillmentCount = 3
        let callback: SpyCallback = { (type, isLeft) in
            exp.fulfill()
            XCTAssert((isLeft && barItemLeftType1 === type || barItemLeftType2 === type) || (!isLeft && barItemRightType === type))
        }
        makeSUT(callback: callback)
        
        rootVC.set(title: .empty, leftItems: [barItemLeftType1, barItemLeftType2], rightItems: [barItemRightType])
        
        XCTAssert(rootVC.leftButtons.count == 2)
        XCTAssert(rootVC.rightButtons.count == 1)
        
        rootVC.perform(#selector(rootVC.pressedNavLeft(item:)), with: rootVC.leftButtons.first!)
        rootVC.perform(#selector(rootVC.pressedNavLeft(item:)), with: rootVC.leftButtons.last!)
        rootVC.perform(#selector(rootVC.pressedNavRight(item:)), with: rootVC.rightButtons.first!)
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func test_titleViewButtonActions() {
        var foundType: UINavigationBarItemType?
        
        let exp = expectation(description: "waiting")
        exp.expectedFulfillmentCount = 1
        let titleViewSpyCallback: TitleViewButtonSpyCallback = { (type) in
            exp.fulfill()
            
            foundType = type
        }
        makeSUT(titleViewSpyCallback: titleViewSpyCallback)
        
        let type = anyTitleItemButton
        rootVC.set(title: type)
        
        XCTAssert(rootVC.leftButtons.count == 0)
        XCTAssert(rootVC.rightButtons.count == 0)
        
        rootVC.perform(#selector(rootVC.pressedNavTitle), with: nil)
        
        waitForExpectations(timeout: 1.0, handler: nil)
        
        XCTAssert(foundType === type)
    }
    
    func test_titleImageViewActions() {
        var foundType: UINavigationBarItemType?
        
        let exp = expectation(description: "waiting")
        exp.expectedFulfillmentCount = 1
        let titleViewSpyCallback: TitleViewButtonSpyCallback = { (type) in
            exp.fulfill()
            
            foundType = type
        }
        makeSUT(titleViewSpyCallback: titleViewSpyCallback)
        
        let type = UINavigationBarItemType.imageView(anyImage, isTappable: true, autoDismiss: false)
        rootVC.set(title: type)
        
        XCTAssert(rootVC.leftButtons.count == 0)
        XCTAssert(rootVC.rightButtons.count == 0)
        XCTAssert(rootVC.navigationItem.titleView!.gestureRecognizers!.count == 1)
        
        rootVC.perform(#selector(rootVC.pressedNavTitle), with: nil)
        
        waitForExpectations(timeout: 1.0, handler: nil)
        
        XCTAssert(foundType === type)
    }
    
    func test_systemButtonActions() {
        let barItemLeftType = UIBarButtonItemType.systemItem(.cancel)
        let barItemRightType = UIBarButtonItemType.systemItem(.save)
        
        let exp = expectation(description: "waiting")
        exp.expectedFulfillmentCount = 2
        
        let callback: SpyCallback = { (type, isLeft) in
            exp.fulfill()
            
            XCTAssert((isLeft && barItemLeftType === type) || (!isLeft && barItemRightType === type))
        }
        makeSUT(callback: callback)
        
        rootVC.set(title: anyTitleItem, leftItems: [barItemLeftType], rightItems: [barItemRightType])
        
        let leftButtons = rootVC.leftButtons
        let rightButtons = rootVC.rightButtons
        
        XCTAssert(leftButtons.first! == nil && leftButtons.last! == nil && leftButtons.count == 1)
        XCTAssert(rightButtons.first! == nil && rightButtons.last! == nil && leftButtons.count == 1)
        
        let barItemLeft = rootVC.navigationElements.modalNavigationBar!.items!.last!.leftBarButtonItem!
        let barItemRight = rootVC.navigationElements.modalNavigationBar!.items!.last!.rightBarButtonItem!
        
        rootVC.perform(#selector(rootVC.pressedNavLeft(item:)), with: barItemLeft)
        rootVC.perform(#selector(rootVC.pressedNavRight(item:)), with: barItemRight)
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func test_itemShouldAutomaticallyDismiss() {
        // Left VC
        makeSUT()
        let typeLeft = UIBarButtonItemType.title(anyText)
        rootVC.set(title: anyTitleItem, leftItems: [typeLeft])
        
        XCTAssertNotNil(rootVC.navigationItem.leftBarButtonItem)
        XCTAssert(rootVC.shouldAutomaticallyDismissFor(typeLeft) == false)
        
        // Right VC
        makeSUT()
        let typeRight = UIBarButtonItemType.title(anyText, autoDismiss: true)
        rootVC.set(title: anyTitleItem, rightItems: [typeRight])
        
        XCTAssertNotNil(rootVC.navigationItem.rightBarButtonItem)
        XCTAssert(rootVC.shouldAutomaticallyDismissFor(typeRight) == true)
        
        // Left NavVC
        makeNavSUT()
        rootNavVC.set(title: anyTitleItem, leftItems: [typeLeft])
        
        XCTAssertNotNil(rootNavVC.navigationItem.leftBarButtonItem)
        XCTAssert(rootNavVC.shouldAutomaticallyDismissFor(typeLeft) == false)
        
        // Right NavVC
        makeNavSUT()
        rootNavVC.set(title: anyTitleItem, rightItems: [typeRight])
        
        XCTAssertNotNil(rootNavVC.navigationItem.rightBarButtonItem)
        XCTAssert(rootNavVC.shouldAutomaticallyDismissFor(typeRight) == true)
        
        let exp = expectation(description: "waiting")
        exp.expectedFulfillmentCount = 1
        
        let vc = UIViewController()
        vc.set(title: anyTitleItem, rightItems: [typeRight])
        
        rootNavVC.navigationController?.pushViewController(vc, animated: false)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
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
        vc.set(title: anyTitleItem)
        
        makeNavSUT()
        rootNavVC.set(title: anyOtherTitleItem)
        
        rootNavVC.navigationController?.present(vc, animated: false, completion: {
            exp.fulfill()
            
            XCTAssert((vc.navigationItem.titleView as! UIButton).titleLabel!.text == anyText)
        })
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func test_pushPresentTest() {
        let vc = UIViewController()
        vc.set(title: anyTitleItem)
        
        makeNavSUT()
        rootNavVC.set(title: anyOtherTitleItem)
        
        rootNavVC.navigationController?.pushViewController(vc, animated: false)
        
        XCTAssert((vc.navigationItem.titleView as! UIButton).titleLabel!.text == anyText)
        
        XCTAssert(self.rootNavVC.navigationController?.topViewController === vc)
    }
    
}
