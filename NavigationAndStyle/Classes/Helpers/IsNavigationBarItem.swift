//
//  Copyright © 2019 Stefan Brighiu. All rights reserved.
//

import Foundation

private var navBarItemTypes = [Int: UINavigationBarGenericItem]()

protocol IsNavigationBarItem: Identifiable {
    var navItemType: UINavigationBarItemType? { get }
    var barItemType: UIBarButtonItemType? { get }
    var genericItemType: UINavigationBarGenericItem? { get }
    
    func saveItemType(_ type: UINavigationBarGenericItem)
}

extension IsNavigationBarItem {
    var genericItemType: UINavigationBarGenericItem? {
        return navBarItemTypes[uniqueIdentifier]
    }
    
    var navItemType: UINavigationBarItemType? {
        return navBarItemTypes[uniqueIdentifier] as? UINavigationBarItemType
    }
    
    var barItemType: UIBarButtonItemType? {
        return navBarItemTypes[uniqueIdentifier] as? UIBarButtonItemType
    }
    
    func saveItemType(_ type: UINavigationBarGenericItem) {
        navBarItemTypes[uniqueIdentifier] = type
    }
}
