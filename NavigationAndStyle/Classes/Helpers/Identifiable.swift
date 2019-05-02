//
//  Copyright © 2019 Stefan Brighiu. All rights reserved.
//

import Foundation

internal protocol Identifiable: class {
    var uniqueIdentifier: Int { get }
}

extension Identifiable {
    internal var uniqueIdentifier: Int {
        return ObjectIdentifier(self).hashValue
    }
}
