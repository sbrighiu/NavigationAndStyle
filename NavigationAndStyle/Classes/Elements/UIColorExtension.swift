//
//  Copyright © 2019 Stefan Brighiu. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    func image(of size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { [weak self] rendererContext in
            self?.setFill()
            rendererContext.fill(CGRect(origin: .zero, size: size))
        }
    }
}
