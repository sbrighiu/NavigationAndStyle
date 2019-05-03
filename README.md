# NavigationAndStyle

[![CI Status](https://img.shields.io/travis/sbrighiu/NavigationAndStyle.svg?style=flat)](https://travis-ci.org/sbrighiu/NavigationAndStyle)
[![Version](https://img.shields.io/cocoapods/v/NavigationAndStyle.svg?style=flat)](https://cocoapods.org/pods/NavigationAndStyle)
[![License](https://img.shields.io/cocoapods/l/NavigationAndStyle.svg?style=flat)](https://cocoapods.org/pods/NavigationAndStyle)
[![Platform](https://img.shields.io/cocoapods/p/NavigationAndStyle.svg?style=flat)](https://cocoapods.org/pods/NavigationAndStyle)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

NavigationAndStyle is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'NavigationAndStyle'
```

## Description

NavigationAndStyle is an extension on UIViewController and UINavigationController to allow for:
- slide to back feature, even when not using the default back button used by Apple
- fast and easy setup and customization of UINavigationBars look and content, using as less code as possible
- minimize the need for subclassing every UIViewController to allow for these features
- enable automatic dismissal from the titleView/barButtonItem tap, removing boilerplate code
- instant theme switching, by simply changing the ColorStyle and calling `triggerColorStyleRefresh()`

### General usage

To use the extension, add this code to your UIViewController
```
import NavigationAndStyle

// ...

let cancelItem: UIBarButtonItemType = .systemItem(.cancel)

override func viewDidLoad() {
    super.viewDidLoad()

    // ...

    // Always call in viewDidLoad
    // Always call set() method to configure view controller with color style and other important UI elements (see below)
    set(title: .button("Button", autoDismiss: true),
    leftItems: [.image(UIImage.NavigationAndStyle.backArrow, extendTapAreaBy: 32, autoDismiss: true)],
    rightItems: [cancelItem])

    // ...
}

override func navBarTitlePressed(with type: UINavigationBarItemType) {
    // Do something when titleView is pressed
}

override func navBarItemPressed(with type: UIBarButtonItemType, isLeft: Bool) {
    if type == cancelItem {
        // Do something when Cancel button is pressed
    }
}

override func willAutomaticallyDismiss() {
    // Screen was dismissed via the `autoDismiss: true` option set on any tappable element set
}
```

### UINavigationBar enhancements

For starters, the UINavigationBar is always set to be fully transparent, since animations of its background is not the smoothest. To fix the cases we actually need a solid background, a hairlineSeparator or even a background shadow for dynamic content, these elements are managed separately and added to the view hierarchy when the `set(...)` method is called, in viewDidLoad (recomended calling it only once :)).

To access these elements just call .navigationElements on the controller. This variable will always contain the custom background elements, and also the bottomAnchor of all these elements.
```
public weak var modalNavigationBar: UINavigationBar?
public weak var backgroundImageView: UIImageView?
public weak var hairlineSeparatorView: UIView?
public weak var shadowBackgroundView: UIImageView?

public var bottomAnchor: NSLayoutYAxisAnchor? {
    if hairlineSeparatorView?.backgroundColor == .clear {
        return backgroundImageView?.bottomAnchor
    }
    return hairlineSeparatorView?.bottomAnchor
}
```

Even if the UIViewController does not have an UINavigationContoller, a `modalNavigationBar` is added to the view hierarchy to preserve the same alignment, style and functionality.

To change navigation bar items or title view elements, please use these methods
```
func change(title type: UINavigationBarItemType)
func change(leftItems items: [UIBarButtonItemType], animated: Bool)
func change(rightItems items: [UIBarButtonItemType], animated: Bool)
```

#### UINavigationBarItemType - how does it work

This class was created to define types for titleView elements possible using this extension. 
Currently, we can choose from
- a label
- a button

Other options not listed like UISearchBar, UIImageView and UIButton with image and text are left to the developer to handle as they see fit for their use case.

Tapping the button elements will call `navBarTitlePressed(with type: UINavigationBarItemType)`, unless the `autoDismiss` parameter is used.

Method used for setting the titleView is
- self.navigationItem.titleView = ...

#### UIBarButtonItemType - how does it work

This class was created to define types of UIBarButtonItems possible using this extension.
Currently, we can choose from
- a button with text
- a button with image
- a button with image and text
- a systemItem

Other options not listed like custom views/buttons/raw barButtonItems are left to the developer to handle as they see fit for their use case, as adding options for them limit their usage.

Tapping the bar items will call `navBarItemPressed(with type: UIBarButtonItemType, isLeft: Bool)`, unless the `autoDismiss` parameter is used.

Methods used for setting the bar items are
- setLeftBarButtonItems([...], animated: animated)
- setRightBarButtonItems([...].reversed, animated: animated)

`Please note that the right bar button items list has been reversed to allow for left to right readability.`

#### Other things to note

Every type of element has an `autoDismiss: Bool` paramenter to allow for automatic dismissal without passing through the designated tap methods. These elements will call `willAutomaticallyDismiss()` just before dismissal, allowing for simple operations to be called by the developer.

Other options could be added in the future, but the way the navigation bar works, animates and renders elements makes it very difficult to add more options, keep a smooth animation and a small code footprint.

### ColorStyle - how does it work

A ColorStyle defines the way the status bar and the navigation bar look:
- status bar management (check below how to enable/customize)
- background image and/or color
- hairlineSeparator color
- backgroundShadow color - useful for transparent navigation bars with dynamic content below
- title and buttons font and color
- image tint color
- highlight alpha used
- disabled elements color

Using different ColorStyles for all UIViewControllers, the Example project shows how animations to/from new/previous controllers are fluid and not jarred.

It can be initialised using the init method (check Defaults struct below for more details)
```
init(statusBarStyle: UIStatusBarStyle = .default,
     background: UIColor = Defaults.navigationBarBackgroundColor,
     backgroundImage: UIImage? = nil,
     hairlineSeparatorColor: UIColor = .clear,
     shadow: UIColor = .clear,
     titleFont: UIFont = Defaults.titleFont,
     titleColor: UIColor = Defaults.darkTextColor,
     buttonFont: UIFont = Defaults.buttonFont,
     buttonTitleColor: UIColor = Defaults.blueColor,
     imageTint: UIColor = Defaults.blueColor,
     highlightAlpha: CGFloat = Defaults.highlightAlpha,
     disabledColor: UIColor = Defaults.disabledColor)
```
, or by using the convenience variables `ColorStyle.default` (as close to the default Apple look as possible) and `ColorStyle.transparent` (trimmed down version of the init method).

A personalised ColorStyle can be set directly on the UINavigationController or on each UIViewController.
This is done by adding the follwing code into the UIViewController/UINavigationController of your choice:
```
override func getColorStyle() -> ColorStyle {
    return ColorStyle.transparent
}
```

By default, the `getColorStyle` method looks like this
```
extension UIViewController: CanHaveColorStyle {
    open func getColorStyle() -> ColorStyle {
        return navigationController?.getColorStyle() ?? ColorStyle.global
    }
}
```

The default value for static variable `ColorStyle.global` is `ColorStyle.default` and can be changed to allow for a different default style.

### Status bar change handling

To allow for automatic status bar update based on the ColorStyle set on UIViewController, please add the following code:
```
override var preferredStatusBarStyle: UIStatusBarStyle {
    return getColorStyle().statusBarStyle
}
```
Note: `View controller-based status bar appearance` or `UIViewControllerBasedStatusBarAppearance` entry in Info.plist needs to be removed or set to YES for this to work.

### Assets and general customization

For assets included in the extension, we have 5 images included in struct `UIImage.NavigationAndStyle`:
- back icon
- forward icon
- settings icon
- close icon
- background shadow image used for navigation bar background

ColorStyle uses default values located in struct `ColorStyle.Defaults`, declared as static variables:
- highlightAlpha: CGFloat = 0.66
- titleFont: UIFont = .boldSystemFont(ofSize: 17)
- buttonFont: UIFont = .systemFont(ofSize: 17)
- disabledColor: UIColor = .lightGray
- blueColor: UIColor = UIButton(frame: .zero).tintColor
- darkTextColor: UIColor = .darkText
- navigationBarBackgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1)
- hairlineSeparatorColor = UIColor(red: 0.11, green: 0.11, blue: 0.11, alpha: 0.13)
- heightOfHairlineSeparator: CGFloat = 1
- backgroundShadow = UIImage.NavigationAndStyle.backgroundShadow

## Author

Stefan B., sbrighiu@gmail.com

## License

NavigationAndStyle is available under the MIT license. See the LICENSE file for more info.
