//
//  ADMozaikLayoutStructs.swift
//  ADMozaikCollectionViewLayout
//
//  Created by Anton Domashnev on 16/05/16.
//  Copyright © 2016 Anton Domashnev. All rights reserved.
//

import Foundation

/**
 *  Defines the structure to identify the position of the layout item
 */
public struct ADMozaikLayoutPosition {
    /// Column number of the item's position
    let column: Int
    /// Row number of the item's position
    let row: Int
    
    ///
    /// Designated initializer for structure
    ///
    /// - parameter column: column number
    /// - parameter row:    roe number
    ///
    /// - returns: newly created `ADMozaikLayoutPosition`
    public init(atColumn column: Int, atRow row: Int) {
        self.column = column
        self.row = row
    }
}

/**
 *  Defines the size of the layout item
 */
public struct ADMozaikLayoutSize {
    /// Columns number that item requires
    let columns: Int
    /// Rows number that item requires
    let rows: Int
    
    ///
    /// Designated initializer for structure
    ///
    /// - parameter columns: number of colums (basically the width)
    /// - parameter rows:    number of rows (basically the height)
    ///
    /// - returns: newly created `ADMozaikLayoutSize`
    public init(numberOfColumns columns: Int, numberOfRows rows: Int) {
        self.columns = columns
        self.rows = rows
    }
    
    ///
    /// Calculates number of total cells in mozaik layout that item fills
    ///
    /// - returns: number of required mozaik cells for item
    public func totalCells() -> Int {
        return self.columns * self.rows
    }
}

/**
 *  Defines the layout's column
 */
public struct ADMozaikLayoutColumn {
    /// Width of the column in points
    let width: CGFloat
    
    ///
    /// Designated initializer for structure
    ///
    /// - parameter width: column's width in points
    ///
    /// - returns: newly created `ADMozaikLayoutColumn`
    public init(width: CGFloat) {
        self.width = width
    }
    
    //MARK: - Equatable
    
    public static func ==(lhs: ADMozaikLayoutColumn, rhs: ADMozaikLayoutColumn) -> Bool {
        return lhs.width == rhs.width
    }
}

/**
 *  Defines the layout's information
 */
public struct ADMozaikLayoutGeometryInfo: Equatable {
    /// array of `ADMozaikLayoutColumn` for the layout
    let columns: [ADMozaikLayoutColumn]
    
    /// height for each row in points
    let rowHeight: CGFloat
    
    ///
    /// Designated initializer for structure
    ///
    /// - parameter rowHeight: height for each row in points
    /// - parameter columns:   array of `ADMozaikLayoutColumn` for the layout
    ///
    /// - returns: newly created `ADMozaikLayoutColumn`
    public init(rowHeight: CGFloat, columns: [ADMozaikLayoutColumn]) {
        self.columns = columns
        self.rowHeight = rowHeight
    }
    
    ///
    /// Checks whether the geometry info is valid
    ///
    /// - returns: true if the info has non zero columns number and non zero rowHeight
    public func isValid() -> Bool {
        return self.columns.count > 0 && self.rowHeight > 0
    }

    //MARK: - Equatable
    
    public static func ==(lhs: ADMozaikLayoutGeometryInfo, rhs: ADMozaikLayoutGeometryInfo) -> Bool {
        return lhs.rowHeight == rhs.rowHeight && lhs.columns.elementsEqual(rhs.columns, by: { (column1, column2) -> Bool in
            return column1 == column2
        })
    }
}


