//
//  Copyright © 2019 Stefan Brighiu. All rights reserved.
//

import XCTest
import UIKit
@testable import NavigationAndStyle

class UsageTests: BaseTestCase {
    
    override func setUp() {
        ViewControllerColorStyle.Constants.defaultColorStyle = ViewControllerColorStyle(statusBarStyle: .lightContent,
                                                                                        background: .white,
                                                                                        primary: .black,
                                                                                        secondary: .black)
    }
    
    func test_buttonActions() {
        let barItemLeftType1 = NavBarItemType.title(anyText)
        let barItemLeftType2 = NavBarItemType.title(otherText)
        let barItemRightType = NavBarItemType.image(anyImage)
        
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
        
        let (_, leftButtons, rightButtons, _, _) = rootVC.set(title: anyText, left: [barItemLeftType1, barItemLeftType2], right: [barItemRightType])
        let buttonLeft1 = leftButtons.first!
        let buttonLeft2 = leftButtons.last!
        let buttonRight = rightButtons.first!
        
        XCTAssert(leftButtons.count == 2)
        XCTAssert(rightButtons.count == 1)
        
        rootVC.perform(#selector(rootVC.pressedLeft(button:)), with: buttonLeft1)
        rootVC.perform(#selector(rootVC.pressedLeft(button:)), with: buttonLeft2)
        rootVC.perform(#selector(rootVC.pressedRight(button:)), with: buttonRight)
        
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
        
        let (_, leftButtons, rightButtons, _, _) = rootVC.set(title: anyText)
        let button = rootVC.change(titleToButtonWithTitle: anyText)
        
        XCTAssert(leftButtons.count == 0)
        XCTAssert(rightButtons.count == 0)
        
        rootVC.perform(#selector(rootVC.titleViewButtonPressed(with:)), with: button)
        
        waitForExpectations(timeout: 1.0, handler: nil)
        
        XCTAssert(foundButton === button)
    }
    
    func test_systemButtonActions() {
        let barItemLeftType = NavBarItemType.systemItem(.cancel)
        let barItemRightType = NavBarItemType.systemItem(.save)
        
        let exp = expectation(description: "waiting")
        exp.expectedFulfillmentCount = 2
        let callback: SpyCallback = { (type, button, isLeft) in
            exp.fulfill()
            XCTAssert(button == nil)
            XCTAssert((isLeft && barItemLeftType === type) || (!isLeft && barItemRightType === type))
        }
        makeSUT(callback: callback)
        
        let (_, leftButtons, rightButtons, navBar, _) = rootVC.set(title: anyText, left: [barItemLeftType], right: [barItemRightType])
        XCTAssert(leftButtons.first! == nil && leftButtons.last! == nil && leftButtons.count == 1)
        XCTAssert(rightButtons.first! == nil && rightButtons.last! == nil && leftButtons.count == 1)
        
        let barItemLeft = navBar!.items!.last!.leftBarButtonItem!
        let barItemRight = navBar!.items!.last!.rightBarButtonItem!
        
        rootVC.perform(#selector(rootVC.pressedSystemLeft(item:)), with: barItemLeft)
        rootVC.perform(#selector(rootVC.pressedSystemRight(item:)), with: barItemRight)
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func test_modalPresentTest() {
        let exp = expectation(description: "waiting")
        exp.expectedFulfillmentCount = 1
        
        let vc = UIViewController()
        vc.set(title: anyText)
        
        makeNavSUT()
        rootNavVC.set(title: otherText)
        
        rootNavVC.navigationController?.present(vc, animated: true, completion: {
            exp.fulfill()
        })
        
        waitForExpectations(timeout: 1.0, handler: nil)
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
            
            foundVC = self?.rootNavVC.navigationController?.topViewController
        })
        
        waitForExpectations(timeout: 1.0, handler: nil)
        
        XCTAssert(foundVC === vc)
    }
    
}
