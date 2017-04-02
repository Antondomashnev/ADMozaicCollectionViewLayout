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
    
    /// Layout content height
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
        self.contentWidth = columnsWidth + interitemSpacing + geometryInfo.sectionInset.left + geometryInfo.sectionInset.right
        self.geometryInfo = geometryInfo
    }
    
    //MARK: - Interface
 
    ///
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
        updateContentHeight(withLastlyCalculated: height + yOffsetForItem(at: position))
        return CGRect(x: xOffset, y: yOffset, width: width, height: height)
    }
    
    /// Calculates the size of supplementary view in section
    ///
    /// - Parameter kind: kind of the supplementary view to calculate size for
    ///
    /// - Returns: size for the view
    func sizeForSupplementaryView(of kind: String) -> CGSize {
        if kind == UICollectionElementKindSectionFooter {
            return CGSize(width: contentWidth, height: geometryInfo.footerHeight)
        }
        else if kind == UICollectionElementKindSectionHeader {
            return CGSize(width: contentWidth, height: geometryInfo.headerHeight)
        }
        fatalError("Unknown supplementary view kind: \(kind)")
    }
    
    // MARK: - Helpers
    
    /// This method inteds to update the conten height after each y or size calculation of the item:
    /// By item it means: cell or supplementary view
    ///
    /// - Parameter maxY: bottom of the lastly calculated frame
    private func updateContentHeight(withLastlyCalculated maxY: CGFloat) {
        contentHeight = max(maxY, contentHeight) + geometryInfo.sectionInset.bottom
    }
    
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
