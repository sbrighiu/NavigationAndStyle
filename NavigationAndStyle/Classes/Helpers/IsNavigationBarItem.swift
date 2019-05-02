//
//  Copyright © 2019 Stefan Brighiu. All rights reserved.
//

import Foundation

private var navBarItemTypes = [Int: UINavigationBarGenericItem]()

internal protocol IsNavigationBarItem: Identifiable {
    var navItemType: UINavigationBarItemType? { get }
    var barItemType: UIBarButtonItemType? { get }
    var genericItemType: UINavigationBarGenericItem? { get }
    
    func saveItemType(_ type: UINavigationBarGenericItem)
}

extension IsNavigationBarItem {
    internal var genericItemType: UINavigationBarGenericItem? {
        return navBarItemTypes[uniqueIdentifier]
    }
    
    internal var navItemType: UINavigationBarItemType? {
        return navBarItemTypes[uniqueIdentifier] as? UINavigationBarItemType
    }
    
    internal var barItemType: UIBarButtonItemType? {
        return navBarItemTypes[uniqueIdentifier] as? UIBarButtonItemType
    }
    
    internal func saveItemType(_ type: UINavigationBarGenericItem) {
        navBarItemTypes[uniqueIdentifier] = type
    }
}
