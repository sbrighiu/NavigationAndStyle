//
//  Copyright © 2019 Stefan Brighiu. All rights reserved.
//

import Foundation
import UIKit

extension UISearchBar {
    
    fileprivate var textField: UITextField? {
        return self.value(forKey: "searchField") as? UITextField
    }
    
    internal func setAppearance(with buttonTintColor: UIColor, and disabledColor: UIColor) {
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes(
            [NSAttributedString.Key.foregroundColor: buttonTintColor],
            for: .normal)
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes(
            [NSAttributedString.Key.foregroundColor: disabledColor],
            for: .disabled)
    }
    
    internal func configure() {
        self.backgroundColor = .clear
        self.isTranslucent = false
        self.searchBarStyle = .minimal
        
        if let textField = textField {
            if let backgroundView = textField.subviews.first {
                backgroundView.backgroundColor = .white
                backgroundView.clipsToBounds = true
                
                if backgroundView.layer.cornerRadius != ColorStyle.Defaults.cornerRadiusForSearchBarHotfix {
                    backgroundView.layer.cornerRadius = ColorStyle.Defaults.cornerRadiusForSearchBarHotfix
                }
            }
        }
    }
    
}
