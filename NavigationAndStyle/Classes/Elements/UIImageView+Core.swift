//
//  Copyright © 2019 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    internal func configure(with colorStyle: ColorStyle) {
        self.contentMode = .scaleAspectFit
        self.clipsToBounds = true
        self.tintColor = colorStyle.imageTint
    }
    
}
