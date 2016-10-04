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
* [CHTCollectionViewWaterfallLayout](https://travis-ci.org/Antondomashnev/ADPuzzleAnimation.svg?branch=master)
* [FMMosaicLayout](https://github.com/fmitech/FMMosaicLayout)
* [Greedo Layout](https://github.com/500px/greedo-layout-for-ios)

But this project is pure `swift` implementation, so if you don't want to mess up `objective-c` code and `swift` you are on the right page. Also, as an advantage compares to another "mozaic" layout - you're not limited to predefined sizes of cells.

## Usage

The idea behind this layout is to split `UICollectionView` bounds into some kind of "matrix".
To do this `ADMozaikCollectionViewLayout` requires `height` for rows and `width` for columns.
```swift
/**
 Designated initializer to create new instance of `ADMozaikLayout`

 - parameter rowHeight: height for each row
 - parameter columns:   array of `ADMozaikLayoutColumn` for the layout

 - returns: newly created instance of `ADMozaikLayout`
 */
public init(rowHeight: CGFloat, columns: [ADMozaikLayoutColumn])
```
Where `ADMozaikLayoutColumn` is the column description
```swift
/**
 *  Defines the layout's column
 */
public struct ADMozaikLayoutColumn {
    /// Width of the column in points
    let width: CGFloat
}
```

Also, it requires the delegate object that is conformed to protocol `ADMozaikLayoutDelegate` to get the size of each cell
```swift
/**
 Method should return `ADMozaikLayoutSize` for specific indexPath

 - parameter collectionView: collection view is using layout
 - parameter layout:         layout itself
 - parameter indexPath:      indexPath of an item for the size it asks for

 - returns: `ADMozaikLayoutSize` struct object describes the size
 */
func collectionView(collectionView: UICollectionView, layout: UICollectionViewLayout, mozaikSizeForItemAtIndexPath indexPath: NSIndexPath) -> ADMozaikLayoutSize
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
For the complete example please check the example project. Note that current example project is supposed to be run on iPhone 6 screen's size.

## Limitation
This is the early bird release so this layout doesn't support headers, footers and sections at the moment. It's on my roadmap but PRs are very welcome=)

## Easy to install

### CocoaPods

To integrate ADPuzzleAnimation into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

pod 'ADMozaicCollectionViewLayout', '~> 2.0'
```
### Carthage

To integrate ADMozaicCollectionViewLayout into your Xcode project using Carthage, specify it in your `Cartfile`:

```ruby
github "Antondomashnev/ADMozaicCollectionViewLayout" ~> 2.0
```

Run `carthage update` to build the framework and drag the built `ADMozaikCollectionViewLayout.framework` into your Xcode project.
