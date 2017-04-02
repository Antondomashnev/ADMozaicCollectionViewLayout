//
//  ADMozaikLayoutStructs.swift
//  ADMozaikCollectionViewLayout
//
//  Created by Anton Domashnev on 16/05/16.
//  Copyright © 2016 Anton Domashnev. All rights reserved.
//

import Foundation

public typealias ADMozaikLayoutSection = Int
public typealias ADMozaikLayoutPositionRow = Int
public typealias ADMozaikLayoutPositionColumn = Int
public typealias ADMozaikLayoutSizeRows = Int
public typealias ADMozaikLayoutSizeColumns = Int

/**
 *  Defines the structure to identify the position of the layout item
 */
public struct ADMozaikLayoutPosition: AutoHashable, AutoEquatable {
    /// Column number of the item's position
    let column: ADMozaikLayoutPositionColumn
    /// Row number of the item's position
    let row: ADMozaikLayoutPositionRow
    /// Section number of the item's
    let section: ADMozaikLayoutSection
    
    ///
    /// Designated initializer for structure
    ///
    /// - parameter column: column number
    /// - parameter row:    roe number
    ///
    /// - returns: newly created `ADMozaikLayoutPosition`
    public init(atColumn column: ADMozaikLayoutPositionRow, atRow row: ADMozaikLayoutPositionColumn, inSection section: ADMozaikLayoutSection) {
        self.column = column
        self.row = row
        self.section = section
    }
}

/**
 *  Defines the size of the layout item
 */
public struct ADMozaikLayoutSize: AutoHashable, AutoEquatable {
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
public struct ADMozaikLayoutColumn: AutoEquatable {
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
}

/**
 *  Defines the layout's information
 */
public struct ADMozaikLayoutSectionGeometryInfo: AutoEquatable {
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
    
    ///
    /// Designated initializer for structure
    ///
    /// - parameter rowHeight:               height for each row in points
    /// - parameter columns:                 array of `ADMozaikLayoutColumn` for the layout
    /// - parameter minimumInteritemSpacing: minimum space between items
    /// - parameter minimumLineSpacing:      minimum space between each row
    ///
    /// - returns: newly created `ADMozaikLayoutColumn`
    public init(rowHeight: CGFloat, columns: [ADMozaikLayoutColumn], minimumInteritemSpacing: CGFloat = 0, minimumLineSpacing: CGFloat = 0, sectionInset: UIEdgeInsets = UIEdgeInsets.zero) {
        self.columns = columns
        self.rowHeight = rowHeight
        self.minimumLineSpacing = minimumLineSpacing
        self.minimumInteritemSpacing = minimumInteritemSpacing
        self.sectionInset = sectionInset
    }
    
    ///
    /// Checks whether the geometry info is valid
    ///
    /// - returns: true if the info has non zero columns number and non zero rowHeight
    public func isValid() -> Bool {
        return self.columns.count > 0 && self.rowHeight > 0
    }
}


