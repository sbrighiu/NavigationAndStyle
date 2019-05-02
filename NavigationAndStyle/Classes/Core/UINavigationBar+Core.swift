//
//  Copyright © 2019 Stefan Brighiu. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationBar {
    internal func setupAndChangeToTransparent() {
        self.isTranslucent = true
        
        self.backgroundColor = .clear
        self.barTintColor = .clear
        
        self.setBackgroundImage(UIImage(), for: .default)
        self.shadowImage = UIImage()
    }
}
