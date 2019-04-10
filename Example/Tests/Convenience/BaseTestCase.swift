//
//  Copyright © 2019 Stefan Brighiu. All rights reserved.
//

import XCTest
import UIKit

class BaseTestCase: XCTestCase {
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
}
