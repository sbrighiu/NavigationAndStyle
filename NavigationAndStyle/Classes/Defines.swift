//
//  Copyright © 2019 Stefan Brighiu. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Constants
internal struct Constants {
    static var recommendedItemHeight: CGFloat {
        return 44
    }
    
    static var shadowExtraHeight: CGFloat {
        return 32
    }
}

// MARK: - Log Framework errors and warnings
internal func logFrameworkError(_ string: String, line: Int = #line, file: String = #file) {
    print("[NavigationAndStyle-Error {\(file):\(line)}] \(string) [Please check your view controller presentation/navigation code and, if necessary, open an issue on https://github.com/sbrighiu/NavigationAndStyle.git with more details]")
}

internal func logFrameworkWarning(_ string: String, line: Int = #line, file: String = #file) {
    print("[NavigationAndStyle-Warning {\(file):\(line)}] \(string)")
}

// MARK: - UIImage Examples
public extension UIImage {
    class NavigationAndStyle {
        private static var bundle: Bundle = {
            return Bundle(url: Bundle(identifier: "org.cocoapods.NavigationAndStyle")!.url(forResource: "Resources", withExtension: "bundle")!)!
        }()
        public static var backArrow: UIImage! = {
            return UIImage(named: "backward_glyph", in: bundle, compatibleWith: nil)!.withRenderingMode(.alwaysTemplate)
        }()
        public static var close: UIImage! = {
            return UIImage(named: "close", in: bundle, compatibleWith: nil)!.withRenderingMode(.alwaysTemplate)
        }()
        public static var forwardArrow: UIImage! = {
            return UIImage(named: "forward_glyph", in: bundle, compatibleWith: nil)!.withRenderingMode(.alwaysTemplate)
        }()
        public static var settings: UIImage! = {
            return UIImage(named: "settings", in: bundle, compatibleWith: nil)!.withRenderingMode(.alwaysTemplate)
        }()
        public static var backgroundShadow: UIImage! = {
            return UIImage(named: "shadowBlackToClear", in: bundle, compatibleWith: nil)!.withRenderingMode(.alwaysTemplate)
        }()
    }
}
