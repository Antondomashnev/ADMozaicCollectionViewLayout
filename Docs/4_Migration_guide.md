## ADMozaicCollectionViewLayout 4.0 Migration Guide

This guide is provided in order to ease the transition from 3.x version of `ADMozaicCollectionViewLayout` to the 4.x version.

### New features

* Support of sections
* Support of supplementary views: headers and footers

### Limitations

* Supplementary view widths is calculated automatically and can not be customized at the moment

### Modified objects

* `ADMozaikLayout`
* `ADMozaikLayoutDelegate`

### New objects

* `ADMozaikLayoutSectionGeometryInfo`

### Migration

#### Initialization

__Old:__
```swift
let columns = [ADMozaikLayoutColumn(width: 93), ADMozaikLayoutColumn(width: 93), ADMozaikLayoutColumn(width: 93), ADMozaikLayoutColumn(width: 93)]
let layout = ADMozaikLayout(rowHeight: 93, columns: columns)
layout.delegate = self
layout.minimumLineSpacing = 1
layout.minimumInteritemSpacing = 1
```

__New:__
```swift
let layout = ADMozaikLayout(delegate: self)
...
func collectonView(_ collectionView: UICollectionView, mozaik layoyt: ADMozaikLayout, geometryInfoFor section: ADMozaikLayoutSection) -> ADMozaikLayoutSectionGeometryInfo {
  let rowHeight: CGFloat = 93
  let columns = [ADMozaikLayoutColumn(width: 93), ADMozaikLayoutColumn(width: 93), ADMozaikLayoutColumn(width: 93), ADMozaikLayoutColumn(width: 93)]
  let geometryInfo = ADMozaikLayoutSectionGeometryInfo(rowHeight: rowHeight,
                                                       columns: columns,
                                                       minimumInteritemSpacing: 1,
                                                       minimumLineSpacing: 1)
  return geometryInfo
}
```

#### Supplementary view usage

As was mentioned before there is only support of custom height for supplementary views.
To have a header or footer please implement following:
```swift
func collectonView(_ collectionView: UICollectionView, mozaik layoyt: ADMozaikLayout, geometryInfoFor section: ADMozaikLayoutSection) -> ADMozaikLayoutSectionGeometryInfo {
  let geometryInfo = ADMozaikLayoutSectionGeometryInfo(rowHeight: ...,
                                                       columns: ...,
                                                       headerHeight: your_header_height_here
                                                       footerHeight: your_footer_height_here)
  return geometryInfo
}

func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
  if kind == UICollectionElementKindSectionHeader {
      return your_header_view
  }
  else {
      return your_footer_view
  }
}
```
