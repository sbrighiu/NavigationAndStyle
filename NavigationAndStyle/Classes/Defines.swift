//
//  Copyright © 2019 Stefan Brighiu. All rights reserved.
//

import Foundation

// MARK: - Constants
internal let defaultAnimationTime = 0.3

// MARK: - Log Framework Convenience
internal func logFrameworkError(_ string: String, line: Int = #line, file: String = #file) {
    print("[NavigationAndStyle-Error] \(string) [Please check your view controller presentation/navigation code and, if necessary, open an issue on https://github.com/sbrighiu/NavigationAndStyle.git with more details]")
}

internal func logFrameworkWarning(_ string: String, line: Int = #line, file: String = #file) {
    print("[NavigationAndStyle-Warning] \(string)")
}
