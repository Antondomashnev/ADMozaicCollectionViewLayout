# ADMozaicCollectionViewLayout

![](https://travis-ci.org/Antondomashnev/ADMozaicCollectionViewLayout.svg?branch=master)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/ADMozaicCollectionViewLayout.svg)](https://img.shields.io/cocoapods/v/ADMozaicCollectionViewLayout.svg)
[![codebeat badge](https://codebeat.co/badges/17a86057-b1be-497d-886a-c9cfdb17da10)](https://codebeat.co/projects/github-com-antondomashnev-admozaiccollectionviewlayout)

## What is it
`ADMozaicCollectionViewLayout` is yet another `UICollectionViewLayout` subclass that implements "brick" or "mozaic"
 layout.

![example](https://api.monosnap.com/rpc/file/download?id=CYs5aVmUdljqghadNwyYd1aVVSBh6d)

## Why do anybody need yet another one?
Because there are plenty of kind of the same layouts already:
* [CHTCollectionViewWaterfallLayout](https://github.com/chiahsien/CHTCollectionViewWaterfallLayout)
* [FMMosaicLayout](https://github.com/fmitech/FMMosaicLayout)
* [Greedo Layout](https://github.com/500px/greedo-layout-for-ios)

But this project is pure `swift` implementation, so if you don't want to mess up `objective-c` code and `swift` you are on the right page. Also, as an advantage compares to another "mozaic" layout - you're not limited to predefined sizes of cells.

## Usage

The idea behind this layout is to split `UICollectionView` bounds into some kind of "matrix".
To do this `ADMozaikCollectionViewLayout` requires `height` for rows and `width` for columns in specific section.
```swift
/// Designated initializer for `ADMozaikLayout`
///
/// - Parameter delegate: delegate/datasource for the layout
public init(delegate: ADMozaikLayoutDelegate)
```

It requires the delegate object conforms to protocol `ADMozaikLayoutDelegate`.
The first required method is to return the size of each item in layout:
```swift
/// Method should return `ADMozaikLayoutSize` for specific indexPath
///
/// - Parameter collectionView: collection view is using layout
/// - Parameter layout:         layout itself
/// - Parameter indexPath:      indexPath of item for the size it asks for
///
/// - Returns: `ADMozaikLayoutSize` struct object describes the size
func collectionView(_ collectionView: UICollectionView, mozaik layout: ADMozaikLayout, mozaikSizeForItemAt indexPath: IndexPath) -> ADMozaikLayoutSize
```

Where `ADMozaikLayoutSize` describes the size of each cell in terms of `ADMozaikCollectionViewLayout`
```swift
/**
 *  Defines the size of the layout item
 */
public struct ADMozaikLayoutSize {
  /// Columns number that item requires
  let columns: Int
  /// Rows number that item requires
  let rows: Int
}
```

The second method is to get the geometry information for each specific section of layout:
```swift
/// Method should return `ADMozaikLayoutSectionGeometryInfo` to describe specific section's geometry
///
/// - Parameters:
///   - collectionView: collection view is using layout
///   - layoyt:         layout itself
///   - section:        section to calculate geometry info for
///
/// - Returns: `ADMozaikLayoutSectionGeometryInfo` struct object describes the section's geometry
func collectonView(_ collectionView: UICollectionView, mozaik layoyt: ADMozaikLayout, geometryInfoFor section: ADMozaikLayoutSection) -> ADMozaikLayoutSectionGeometryInfo
```

Where `ADMozaikLayoutSectionGeometryInfo` describes the all geometry parameters of the section
```swift
/**
 *  Defines the layout's information
 */
public struct ADMozaikLayoutSectionGeometryInfo {
  /// array of `ADMozaikLayoutColumn` for the layout
  let columns: [ADMozaikLayoutColumn]

  /// height for each row in points
  let rowHeight: CGFloat

  /// minimum space between items
  let minimumInteritemSpacing: CGFloat

  /// minimum space between each row
  let minimumLineSpacing: CGFloat

  /// Insets for the section from top, left, right, bottom
  let sectionInset: UIEdgeInsets

  /// Height for header in section
  /// Width is currently limited to the collection view width
  let headerHeight: CGFloat

  /// Height for footer in section
  /// Width is currently limited to the collection view width
  let footerHeight: CGFloat
}
```

For the complete example please check the example project. Note that current example project is supposed to be run on iPhone 6 screen's size.

## Install

### CocoaPods

To integrate ADMozaicCollectionViewLayout into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

pod 'ADMozaicCollectionViewLayout', '~> 4.0'
```
### Carthage

To integrate ADMozaicCollectionViewLayout into your Xcode project using Carthage, specify it in your `Cartfile`:

```ruby
github "Antondomashnev/ADMozaicCollectionViewLayout" ~> 4.0
```

Run `carthage update` to build the framework and drag the built `ADMozaikCollectionViewLayout.framework` into your Xcode project.

## Migration guide

* [From 3.x to 4.x](./Docs/4_Migration_guide.md)

## License

ADMozaicCollectionViewLayout is available under the MIT license. See [LICENSE](LICENSE) for more information.
