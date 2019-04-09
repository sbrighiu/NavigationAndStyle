//
//  Copyright © 2019 Stefan Brighiu. All rights reserved.
//

import Foundation
import UIKit

// This value masks the fact that UISearchBar does not support
// removing the background shadow before rendering (UISearchController),
// and by applying a white background and rounding the corners,
// we hotfix this issue and leave the search bar looking
// as clean as possible. This value should be bigger than 8-12.
private let cornerRadiusForSearchBarHotfix: CGFloat = 34/2

extension UISearchBar {
    
    fileprivate var textField: UITextField? {
        return self.value(forKey: "searchField") as? UITextField
    }
    
    internal func setAppearance(with colorStyle: ViewControllerColorStyle) {
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes(
            [NSAttributedString.Key.foregroundColor: colorStyle.buttonTint],
            for: .normal)
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes(
            [NSAttributedString.Key.foregroundColor: colorStyle.disabledTint],
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
                
                if backgroundView.layer.cornerRadius != cornerRadiusForSearchBarHotfix {
                    backgroundView.layer.cornerRadius = cornerRadiusForSearchBarHotfix
                }
            }
        }
    }
    
}
