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
    
    /**
     Designated initializer for structure
     
     - parameter column: column number
     - parameter row:    roe number
     
     - returns: newly created `ADMozaikLayoutPosition`
     */
    public init(column: Int, row: Int) {
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
    
    /**
     Designated initializer for structure
     
     - parameter columns: number of colums (basically the width)
     - parameter rows:    number of rows (basically the height)
     
     - returns: newly created `ADMozaikLayoutSize`
     */
    public init(columns: Int, rows: Int) {
        self.columns = columns
        self.rows = rows
    }
    
    /**
     Calculates number of total cells in mozaik layout that item fills
     
     - returns: number of required mozaik cells for item
     */
    public func totalCells() -> Int {
        return self.columns * self.rows
    }
}

/**
 *  Defines the layput's column
 */
public struct ADMozaikLayoutColumn {
    /// Width of the column in points
    let width: CGFloat
    
    /**
     Designated initializer for structure
     
     - parameter width: column's width in points
     
     - returns: newly created `ADMozaikLayoutColumn`
     */
    public init(width: CGFloat) {
        self.width = width
    }
}