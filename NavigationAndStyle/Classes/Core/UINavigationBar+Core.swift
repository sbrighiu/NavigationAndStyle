//
//  Copyright © 2019 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationBar: Identifiable {
    func changeToTransparent() {
        self.isTranslucent = true
        
        self.backgroundColor = .clear
        self.barTintColor = .clear
        
        self.setBackgroundImage(UIImage(), for: .default)
        self.shadowImage = UIImage()
    }
}
