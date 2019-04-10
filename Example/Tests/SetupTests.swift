//
//  Copyright © 2019 Stefan Brighiu. All rights reserved.
//

import XCTest
import NavigationAndStyle

class SetupTests: BaseTestCase {
    
    override func setUp() {
        ViewControllerColorStyle.Constants.defaultColorStyle = ViewControllerColorStyle(statusBarStyle: .default,
                                                                                        background: .clear,
                                                                                        shadow: .black,
                                                                                        primary: .white,
                                                                                        secondary: .white,
                                                                                        underlineShadow: .red)
    }
    
    func test_setupNotCalled() {
        makeSUT()
        XCTAssertFalse(rootVC.didSetupCustomNavigationAndStyle)
    }
    
    func test_modalVC() {
        makeSUT()
        rootVC.set(title: anyText)
        XCTAssert(rootVC.didSetupCustomNavigationAndStyle)
    }
    
    func test_modalVC_customSuperview() {
        makeSUT()
        
        let scrollView = createAndAddScrollView(to: rootVC.view)
        let (_, _, _, navBar, shadowView) = rootVC.set(title: anyText, overrideModalSuperview: scrollView)
        
        XCTAssert(navBar?.superview === scrollView)
        XCTAssert(shadowView!.superview === scrollView)
        XCTAssert(rootVC.didSetupCustomNavigationAndStyle)
    }
    
    func test_navVC() {
        makeNavSUT()
        let (_, _, _, navBar, shadowView) = rootNavVC.set(title: anyText,
                                                          left: [.image(UIImage.Placeholders.backArrow)],
                                                          right: [.image(UIImage.Placeholders.forwardArrow)])
        
        let navC = rootNavVC.navigationController!
        XCTAssert(navC.navigationBar === navBar)
        XCTAssert(shadowView!.superview === rootNavVC.view)
        XCTAssert(navC.delegate === (navC as UINavigationControllerDelegate))
        XCTAssert(navC.interactivePopGestureRecognizer!.delegate === (navC as UINavigationControllerDelegate))
        XCTAssert(navC.navigationBar.isTranslucent == rootNavVC.getColorStyle().isTranslucent)
        XCTAssert(rootNavVC.didSetupCustomNavigationAndStyle)
    }
    
    func test_navVC_customSuperview() {
        makeNavSUT()
        
        let scrollView = createAndAddScrollView(to: rootNavVC.view)
        let (_, _, _, _, shadowView) = rootNavVC.set(title: anyText, overrideModalSuperview: scrollView)
        
        XCTAssert(shadowView!.superview !== scrollView) // Will always be ignored when using an UINavigationController since the superview is handled by the navigation controller and cannot be changed
        XCTAssert(rootNavVC.didSetupCustomNavigationAndStyle)
    }
    
    func test_setupWithTitle() {
        makeSUT()
        rootVC.set(title: anyText)
        
        XCTAssert((rootVC.navigationItem.titleView as! UILabel).text == anyText)
    }
    
    func test_oneLeftButton() {
        makeSUT()
        rootVC.set(title: anyText, left: [NavBarItemType.title(anyText)])
        
        XCTAssertNotNil(rootVC.navigationItem.leftBarButtonItem)
    }
    
    func test_multipleLeftButtons() {
        makeSUT()
        rootVC.set(title: anyText,
                   left: [NavBarItemType.title(anyText),
                          NavBarItemType.title(otherText)])
        
        XCTAssert(rootVC.navigationItem.leftBarButtonItems!.count == 2)
    }
    
    func test_oneRightButton() {
        makeSUT()
        rootVC.set(title: anyText, right: [NavBarItemType.title(anyText)])
        
        XCTAssertNotNil(rootVC.navigationItem.rightBarButtonItem)
    }
    
    func test_multipleRightButtons() {
        makeSUT()
        rootVC.set(title: anyText,
                   right: [NavBarItemType.title(anyText),
                           NavBarItemType.title(otherText),
                           NavBarItemType.image(UIImage.Placeholders.close)])
        
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
    
    func test_replaceTitleWithSearchBar() {
        makeSUT()
        rootVC.set(title: anyText)
        
        XCTAssert((rootVC.navigationItem.titleView as! UILabel).text == anyText)
        
        let searchBar = rootVC.change(titleToSearchBarWithPlaceholder: otherText)
        
        let resultSearchBar = rootVC.navigationItem.titleView as! UISearchBar
        XCTAssert(resultSearchBar === searchBar)
        XCTAssert(resultSearchBar.placeholder == otherText)
        
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
                   right: [NavBarItemType.title(anyText),
                           NavBarItemType.imageAndTitle(anyImage, title: otherText),
                           NavBarItemType.image(UIImage.Placeholders.close)])
        
        XCTAssert(rootVC.navigationItem.rightBarButtonItems!.count == 3)
        
        rootVC.change(rightNavBarItems: [.systemItem(.cancel)])
        
        XCTAssert(rootVC.navigationItem.rightBarButtonItems!.count == 1)
        
        rootVC.set(title: anyText,
                   right: [NavBarItemType.title(anyText),
                           NavBarItemType.title(otherText),
                           NavBarItemType.image(UIImage.Placeholders.close)])
        
        XCTAssert(rootVC.navigationItem.rightBarButtonItems!.count == 3)
    }
    
    func test_replaceLeftItems() {
        makeSUT()
        rootVC.set(title: anyText,
                   left: [NavBarItemType.systemItem(.cancel)])
        
        XCTAssert((rootVC.navigationItem.leftBarButtonItems ?? []).count == 1)
        
        rootVC.change(leftNavBarItems: [])
        
        XCTAssert((rootVC.navigationItem.leftBarButtonItems ?? []).count == 0)
        
        rootVC.set(title: anyText,
                   left: [NavBarItemType.systemItem(.cancel)])
        
        XCTAssert((rootVC.navigationItem.leftBarButtonItems ?? []).count == 1)
    }
    
}
