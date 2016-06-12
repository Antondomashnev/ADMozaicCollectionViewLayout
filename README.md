# ADMozaicCollectionViewLayout

## What is it
`ADMozaicCollectionViewLayout` is yet another `UICollectionViewLayout` subclass that implements "brick" or "mozaic" 
 layout. 

<img src="http://i.giphy.com/aEuFnblI9AQ24.gif" width="375" />

## Why do anybody need yet another one?
Because there are plenty of kind of the same layouts already:
* [CHTCollectionViewWaterfallLayout](https://travis-ci.org/Antondomashnev/ADPuzzleAnimation.svg?branch=master)
* [FMMosaicLayout](https://github.com/fmitech/FMMosaicLayout)
* [Greedo Layout](https://github.com/500px/greedo-layout-for-ios) 

But this project is pure `swift` implementation, so if you don't want to mess up `objective-c` code and `swift` you are on the right page. Also, as an advantage compares to another "mozaic" layout - you're not limited to predefined sizes of cells.

## Usage

The idea behind this layout is to split `UICollectionView` bounds into some kind of "matrix". 
To do this `ADMozaicCollectionViewLayout` requires `height` for rows and `width` for columns.
```swift
/**
 Designated initializer to create new instance of `ADMozaicLayout`
     
 - parameter rowHeight: height for each row
 - parameter columns:   array of `ADMozaicLayoutColumn` for the layout
     
 - returns: newly created instance of `ADMozaicLayout`
 */
public init(rowHeight: CGFloat, columns: [ADMozaicLayoutColumn])
```
Where `ADMozaicLayoutColumn` is the column description
```swift
/**
 *  Defines the layout's column
 */
public struct ADMozaicLayoutColumn {
    /// Width of the column in points
    let width: CGFloat
}
```

Also, it requires the delegate object that is conformed to protocol `ADMozaicLayoutDelegate` to get the size of each cell
```swift
/**
 Method should return `ADMozaicLayoutSize` for specific indexPath
     
 - parameter collectionView: collection view is using layout
 - parameter layout:         layout itself
 - parameter indexPath:      indexPath of an item for the size it asks for
 
 - returns: `ADMozaicLayoutSize` struct object describes the size
 */
func collectionView(collectionView: UICollectionView, layout: UICollectionViewLayout, mozaicSizeForItemAtIndexPath indexPath: NSIndexPath) -> ADMozaicLayoutSize
```
Where `ADMozaicLayoutSize` describes the size of each cell in terms of `ADMozaicCollectionViewLayout`
```swift
/**
 *  Defines the size of the layout item
 */
public struct ADMozaicLayoutSize {
    /// Columns number that item requires
    let columns: Int
    /// Rows number that item requires
    let rows: Int
}
```
For the complete example please check the example project. Note that current example project is supposed to be run on iPhone 6 screen's size.

## Limitation
This is the early bird release so this layout doesn't support headers, footers and sections at the moment. It's on my roadmap but PRs are very welcome=)
