//
//  Copyright © 2019 Stefan Brighiu. All rights reserved.
//

import Foundation

protocol Identifiable: class {
    var uniqueIdentifier: Int { get }
}

extension Identifiable {
    var uniqueIdentifier: Int {
        return ObjectIdentifier(self).hashValue
    }
}
