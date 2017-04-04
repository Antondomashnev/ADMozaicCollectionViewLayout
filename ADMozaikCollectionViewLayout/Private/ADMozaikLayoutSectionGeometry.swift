//
//  ADMozaikLayoutSectionGeometry.swift
//  ADMozaikCollectionViewLayout
//
//  Created by Anton Domashnev on 29/05/16.
//  Copyright © 2016 Anton Domashnev. All rights reserved.
//

import Foundation
import CoreGraphics

/// The `ADMozaikLayoutSectionGeometry` defines the class that represent the geometry of collection view layout
class ADMozaikLayoutSectionGeometry {
    
    /// Layout content height (dynamically calculated)
    private(set) var contentHeight: CGFloat = 0
    
    /// Sections geometry information
    private let geometryInfo: ADMozaikLayoutSectionGeometryInfo
    
    /// Layout content width
    private let contentWidth: CGFloat
    
    ///
    /// Initializes the layout geometry instance
    ///
    /// - Parameter geometryInfo: section geometry information
    ///
    /// - Returns: newly created layout geometry instance
    init(geometryInfo: ADMozaikLayoutSectionGeometryInfo) {
        let columnsWidth = geometryInfo.columns.reduce(0) { return $0 + $1.width }
        let interitemSpacing = geometryInfo.minimumInteritemSpacing * CGFloat(geometryInfo.columns.count - 1)
        self.contentWidth = columnsWidth + interitemSpacing
        self.geometryInfo = geometryInfo
    }
    
    //MARK: - Interface
    
    /// Registers the given geometry `CGRect` as a part of a section's geometry
    /// The method helps to maintain the `contentHeight` valid
    /// Please always register only frames that were calculated with the following methods:
    /// frameForItem(withMozaikSize:at:)
    ///
    ///
    /// - Parameter geometry: <#geometry description#>
    func registerElement(with geometry: CGRect) {
        contentHeight = max(geometry.maxY, contentHeight - geometryInfo.sectionInset.bottom) + geometryInfo.sectionInset.bottom
    }
 
    /// Calculates the geometry size in points for the item with the given size at the given position
    ///
    /// - Parameter size:     size of the item in terms of mozaik layout
    /// - Parameter position: position of the item in mozaik layout
    ///
    /// - Returns: geometry size of the item
    func frameForItem(withMozaikSize size: ADMozaikLayoutSize, at position: ADMozaikLayoutPosition) -> CGRect {
        var width: CGFloat = 0.0
        for column in position.column...(position.column + size.columns - 1) {
            width += geometryInfo.columns[column].width
        }
        width += CGFloat(size.columns - 1) * geometryInfo.minimumInteritemSpacing
        let height = CGFloat(size.rows) * geometryInfo.rowHeight + CGFloat(size.rows - 1) * geometryInfo.minimumLineSpacing;
        let xOffset = xOffsetForItem(at: position)
        let yOffset = yOffsetForItem(at: position)
        return CGRect(x: xOffset, y: yOffset, width: width, height: height)
    }
    
    /// Calculates the size of supplementary view in section
    ///
    /// - Parameter kind: kind of the supplementary view to calculate size for
    ///
    /// - Returns: frame for the view, nil in case of no presense of the supplementary view of given kind
    func frameForSupplementaryView(of kind: String) -> CGRect? {
        if kind == UICollectionElementKindSectionFooter {
            return geometryInfo.footerHeight > 0 ? CGRect(x: geometryInfo.sectionInset.left, y: contentHeight - geometryInfo.sectionInset.bottom, width: contentWidth, height: geometryInfo.footerHeight) : nil
        }
        else if kind == UICollectionElementKindSectionHeader {
            return geometryInfo.headerHeight > 0 ? CGRect(x: geometryInfo.sectionInset.left, y: geometryInfo.sectionInset.top, width: contentWidth, height: geometryInfo.headerHeight) : nil
        }
        fatalError("Unknown supplementary view kind: \(kind)")
    }
    
    // MARK: - Helpers
    
    ///
    /// Calculates the x origin for the item at the given position
    ///
    /// - Parameter position: position of the item in mozaik layout
    ///
    /// - Returns: geometry x offset of the item
    private func xOffsetForItem(at position: ADMozaikLayoutPosition) -> CGFloat {
        var xOffset: CGFloat = geometryInfo.sectionInset.left
        if position.column == 0 {
            return xOffset
        }
        for column in 0...position.column - 1 {
            xOffset += geometryInfo.columns[column].width + geometryInfo.minimumInteritemSpacing
        }
        return xOffset
    }
    
    ///
    /// Calculates the y origin for the item at the given position
    ///
    /// - Parameter position: position of the item in mozaik layout
    ///
    /// - Returns: geometry y offset of the item
    private func yOffsetForItem(at position: ADMozaikLayoutPosition) -> CGFloat {
        return (geometryInfo.rowHeight + geometryInfo.minimumLineSpacing) * CGFloat(position.row) + geometryInfo.sectionInset.top + geometryInfo.headerHeight
    }
}
