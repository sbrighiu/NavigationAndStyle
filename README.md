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
- slide to back feature, even when not using the default back button used by Apple.
- fast and easy setup and customization of UINavigationBars look and content.
- minimize the need for subclassing every UIViewController to allow for these features.
- enable automatic dismissal from the titleView/barButtonItem tap, removing boilerplate code.
- instant theme switching, by simply changing the NavigationBarStyle and calling `triggerNavigationBarStyleRefresh()`.

### General usage

To use the extension, add this code to your UIViewController
```
import NavigationAndStyle

// ...

let cancelItem: UIBarButtonItemType = .systemItem(.cancel)

override func viewDidLoad() {
    super.viewDidLoad()

    // ...

    // Always call set() method in viewDidLoad() to configure view controller with color style and other important UI elements (see below)
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

For starters, the UINavigationBar is always set to be fully transparent, since the background/titleView animation is not the smoothest. To fix cases were we need a solid background, a hairline separator or even a background shadow for dynamic content, these elements are managed separately and added to the view hierarchy when the `set(...)` method is called, in viewDidLoad (recomended calling it just once).

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

To dock your views to the manually created navigation bar, , use this method after you use set(..):
```
func dockViewToNavigationBar(_ view: UIView, constant: CGFloat)
```
, or the bottomAnchor value from .navigationElements.

Even if the UIViewController does not have an UINavigationContoller, a `modalNavigationBar` is added to the view hierarchy to preserve the same alignment, style and functionality.

To change navigation bar items or title view elements, please use these methods
```
func change(title type: UINavigationBarItemType)
func change(leftItems items: [UIBarButtonItemType], animated: Bool)
func change(rightItems items: [UIBarButtonItemType], animated: Bool)
```

By default, large titles are disabled. To enable large titles in a view controller, use this method after you use set(..):
```
func setLargeTitle(andDock view: UIView?)
```
Currently we only support large title view modes .never and .always.
Because we handle the background of the navigation bar as separate views, .automatic is not fully supported, making the large title go out of bounds and display under your content.

To force shrinking while scrolling, call `self.view.sendSubviewToBack(<scrollView>)`. With a bit of design updates (like updating the background of the content below the navigation bar with the textColor of the title text) the existing option could be enough for the majority of cases.

#### UINavigationBarItemType - how does it work

This class was created to define types for titleView elements possible using this extension. 
Currently, we can choose from
- a native title text
- a label
- a button
- an image
- a native title text and a label
- a native title text and a button
- a native title text and an image

Other options not listed like UISearchBar and UIButton with image and text are left to the developer to handle as they see fit for their use case. We added the UIImageView just as a convenience event though the left and right bar button item containers need to have to same width to not make the UI render without animation during view controller transitions.

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

You can call `.barItemType` on `UIBarButtonItem` objects to fetch their type.

Other options not listed like custom views/buttons/raw barButtonItems are left to the developer to handle as they see fit for their use case, as adding options for them limit their usage.

Tapping the bar items will call `navBarItemPressed(with type: UIBarButtonItemType, isLeft: Bool)`, unless the `autoDismiss` parameter is used.

Methods used for setting the bar items are
- setLeftBarButtonItems([...], animated: animated)
- setRightBarButtonItems([...].reversed, animated: animated)

`Please note that the right bar button items list has been reversed to allow for left to right readability.`

#### Other things to note

Every type of element has an `autoDismiss: Bool` paramenter to allow for automatic dismissal without passing through the designated tap methods. These elements will call `willAutomaticallyDismiss()` just before dismissal, allowing for simple operations to be called by the developer.

Other options could be added in the future, but the way the navigation bar works, animates and renders elements makes it very difficult to add more options, keep a smooth animation and a small code footprint.

### NavigationBarStyle - how does it work

A NavigationBarStyle defines the way the status bar and the navigation bar look:
- status bar management (check below how to enable/customize)
- background image and/or color
- hairlineSeparator color
- backgroundShadow color - useful for transparent navigation bars with dynamic content below
- title and buttons font and color
- image tint color
- highlight alpha used
- disabled elements color

Using different NavigationBarStyles for all UIViewControllers, the Example project shows how animations to/from new/previous controllers are fluid and not jarred.

It can be initialised using the init method (check Defaults struct below for more details)
```
init(statusBarStyle: UIStatusBarStyle = .default,
     backgroundColor: UIColor = Defaults.navigationBarBackgroundColor,
     backgroundImage: UIImage? = nil,
     backgroundMaskColor: UIColor = .clear,
     backgroundMaskImage: UIImage? = nil,
     backgroundMaskAlpha: CGFloat = 1.0,
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
, or by using the convenience variables `NavigationBarStyle.default` (as close to the default Apple look as possible) and `NavigationBarStyle.transparent` (trimmed down version of the init method).

To quickly create another NavigationBarStyle from a current one, use the convenince instance method `.new(...)`.

A personalised NavigationBarStyle can be set directly on the UINavigationController or on each UIViewController.
This is done by adding the follwing code into the UIViewController/UINavigationController of your choice:
```
override func getNavigationBarStyle() -> NavigationBarStyle {
    return NavigationBarStyle.transparent
}
```

By default, the `getNavigationBarStyle` method looks like this
```
extension UIViewController: CanHaveNavigationBarStyle {
    open func getNavigationBarStyle() -> NavigationBarStyle {
        return navigationController?.getNavigationBarStyle() ?? NavigationBarStyle.global
    }
}
```

The default value for static variable `NavigationBarStyle.global` is `NavigationBarStyle.default` and can be changed to allow for a different default style.

### Status bar update handling

To allow for automatic status bar update based on the NavigationBarStyle set on UIViewController, please add the following code:
```
override var preferredStatusBarStyle: UIStatusBarStyle {
    return getNavigationBarStyle().statusBarStyle
}
```
Note: `View controller-based status bar appearance` or `UIViewControllerBasedStatusBarAppearance` entry in Info.plist needs to be removed or set to YES for this to work.

### Assets and general customization

We have 5 assets included in the form of images in struct `UIImage.NavigationAndStyle`:
- back icon
- forward icon
- settings icon
- close icon
- background shadow image used for navigation bar background

We have 4 generic bar button items defined under `UIBarButtonItemType.generic`:
- back (autodismiss: Bool = true)
- close (autodismiss: Bool = true)
- forward (autodismiss = false)
- settings (autodismiss = false)

NavigationBarStyle uses default values located in struct `NavigationBarStyle.Defaults`, declared as static variables:
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

### More customization

Every method overriden on UIViewController and UINavigationController was written in such way that if the developer needs to override it and change its behavior, they can also add the default implementation. All methods that contain default implementation end in "<name>...Action". Example: `triggerNavigationBarStyleRefresh` and `triggerNavigationBarStyleRefreshAction`

## Author

Stefan B., sbrighiu@gmail.com

## License

NavigationAndStyle is available under the MIT license. See the LICENSE file for more info.
