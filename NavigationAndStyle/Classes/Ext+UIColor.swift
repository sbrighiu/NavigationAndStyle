//
//  Copyright © 2019 Stefan Brighiu. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    internal func getImage(withAlpha alpha: CGFloat = 1, width: CGFloat = 1, height: CGFloat = 1) -> UIImage? {
        let rect = CGRect(x: 0, y: 0, width: width, height: height)
        
        UIGraphicsBeginImageContext(rect.size)
        defer {
            UIGraphicsEndImageContext()
        }
        
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        context.setFillColor(self.withAlphaComponent(alpha).cgColor)
        context.fill(rect)
        
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
