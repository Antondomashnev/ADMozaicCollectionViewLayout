# ADMozaikCollectionViewLayout

## What is it
`ADMozaikCollectionViewLayout` is yet another `UICollectionViewLayout` subclass that implements "brick" or "mozaik" 
like layout. 

<img src="http://i.giphy.com/aEuFnblI9AQ24.gif" width="375" />

## Why do anybody need yet another one?
Because there are plenty of kind of the same layouts already:
* [CHTCollectionViewWaterfallLayout](https://travis-ci.org/Antondomashnev/ADPuzzleAnimation.svg?branch=master)
* [FMMosaicLayout](https://github.com/fmitech/FMMosaicLayout)
* [Greedo Layout](https://github.com/500px/greedo-layout-for-ios) 

But this project is pure `swift` implementation, so if you don't want to mess up `objective-c` code and `swift` you are on the right page. 
And also this project has some advantages you can find below=)

## Usage

The idea behind this layout is to split `UICollectionView` bounds into kind of "matrix". 
To do this `ADMozaikCollectionViewLayout` requires row `height` and `width` for each column.
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

Also it requires the delegate object that is conformed to protocol `ADMozaikLayoutDelegate` to get the size of each cell
```swift
/**
 Method should return `ADMozaikLayoutSize` for specific indexPath
     
 - parameter collectionView: collection view is using layout
 - parameter layout:         layout itself
 - parameter indexPath:      indexPath of item for the size it asks for
 
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
For the complete exaple please check the example project. Note that current examplr project is supposed to be run on iPhone 6 screen's size.
