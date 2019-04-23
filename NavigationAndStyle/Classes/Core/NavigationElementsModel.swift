//
//  Copyright © 2019 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation
import UIKit

public class NavigationElementsModel {
    public weak var modalNavigationBar: UINavigationBar?
    public weak var backgroundView: UIImageView?
    public weak var hairlineSeparatorView: UIView?
    public weak var shadowBackgroundView: UIImageView?
    
    public var bottomAnchor: NSLayoutYAxisAnchor? {
        if hairlineSeparatorView?.backgroundColor == .clear {
            return backgroundView?.bottomAnchor
        }
        return hairlineSeparatorView?.bottomAnchor ?? backgroundView?.bottomAnchor
    }
}