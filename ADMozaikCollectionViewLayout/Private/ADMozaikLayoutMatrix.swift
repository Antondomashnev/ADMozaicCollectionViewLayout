//
//  ADMozaikLayoutMatrix.swift
//  ADMozaikCollectionViewLayout
//
//  Created by Anton Domashnev on 16/05/16.
//  Copyright © 2016 Anton Domashnev. All rights reserved.
//

import Foundation

/**
 Enum with error types specific to mozaic layout matrix
 
 - ColumnOutOfBounds: mozaic's layout column is out of bounds
 - RowOutOfBounds:    mozaic's layout row is out of bounds
 */
enum ADMozaikLayoutMatrixError : Error {
    case columnOutOfBounds
    case rowOutOfBounds
}

extension ADMozaikLayoutMatrixError : CustomStringConvertible {
    var description: String {
        switch self {
        case .columnOutOfBounds:
            return "Invalid column. Out of bounds"
            
        case .rowOutOfBounds:
            return "Invalid row. Out of bounds"
        }
    }
}

//*************************************************************************//

/// The `ADMozaikLayoutMatrix` defines the class which describes the layout matrx
class ADMozaikLayoutMatrix {
    
    /// Array representation of the matrix: 1 if cell is not empty and 0 if it's empty
    fileprivate var arrayRepresentation: [[Bool]] = []
    
    /// Number of rows in the matrix
    fileprivate let numberOfRows: Int
    
    /// Number of columns in the matrix
    fileprivate let numberOfColumns: Int
 
    //MARK: - Interface
    
    ///
    /// Designated initializer to create new instance of `ADMozaikLayoutMatrix`
    ///
    /// - parameter numberOfRows: expected number of rows in layout
    /// - parameter columns:      number of coumns in layout
    ///
    /// - returns: newly created instance of `ADMozaikLayoutMatrix`
    init(numberOfRows: Int, numberOfColumns: Int) {
        self.numberOfRows = numberOfRows
        self.numberOfColumns = numberOfColumns
        self.arrayRepresentation = self.buildArrayRepresentation(numberOfRows, numberOfColumns: numberOfColumns)
    }

    ///
    /// Adds item into the layout matrix
    ///
    /// - parameter size:     size of the adding item
    /// - parameter position: position to be added at
    ///
    /// - throws: error if item (size.width + position.x) or (size.height + position.y) is out if bounds of the matrix or
    func addItemWithSize(_ size: ADMozaikLayoutSize, atPosition position: ADMozaikLayoutPosition) throws -> Void {
        let lastColumn = position.column + size.columns - 1
        guard lastColumn < arrayRepresentation.count else {
            throw ADMozaikLayoutMatrixError.columnOutOfBounds
        }
        
        let lastRow = position.row + size.rows - 1
        guard lastRow < arrayRepresentation[lastColumn].count else {
            throw ADMozaikLayoutMatrixError.rowOutOfBounds
        }
        
        for column in position.column...lastColumn {
            for row in position.row...lastRow {
                arrayRepresentation[column][row] = true
            }
        }
    }
    
    ///
    /// Calculates the first available position for the item with the given size
    ///
    /// - parameter size: size of the adding item
    ///
    /// - returns: position of the item, returns nil if there is no available position fir the item
    func positionForItemWithSize(_ size: ADMozaikLayoutSize) -> ADMozaikLayoutPosition? {
        let maximumColumn = self.numberOfColumns - size.columns
        let maximumRow = self.numberOfRows - size.rows
        
        if maximumRow < 0 || maximumColumn < 0 {
            return nil
        }
        
        for row in 0...maximumRow {
            for column in 0...maximumColumn {
                let possiblePosition = ADMozaikLayoutPosition(atColumn: column, atRow: row)
                var isPositionFree = false
                do {
                    try isPositionFree = self.isPositionFree(possiblePosition, forItemWithSize: size)
                }
                catch {
                    print(error)
                }
                if isPositionFree {
                    return possiblePosition
                }
            }
        }
        return nil
    }
    
    //MARK: - Helpers
    
    fileprivate func buildArrayRepresentation(_ numberOfRows: Int, numberOfColumns: Int) -> [[Bool]] {
        var arrayRepresentation: [[Bool]] = []
        for _ in 0..<numberOfColumns {
            var rows: [Bool] = []
            for _ in 0..<numberOfRows {
                rows.append(false)
            }
            arrayRepresentation.append(rows)
        }
        return arrayRepresentation
    }
    
    fileprivate func isPositionFree(_ position: ADMozaikLayoutPosition, forItemWithSize size: ADMozaikLayoutSize) throws -> Bool {
        let lastColumn = position.column + size.columns - 1
        guard lastColumn < arrayRepresentation.count else {
            throw ADMozaikLayoutMatrixError.columnOutOfBounds
        }
        
        let lastRow = position.row + size.rows - 1
        guard lastRow < arrayRepresentation[lastColumn].count else {
            throw ADMozaikLayoutMatrixError.rowOutOfBounds
        }
        
        for column in position.column...lastColumn {
            for row in position.row...lastRow {
                if arrayRepresentation[column][row] {
                    return false
                }
            }
        }
        
        return true
    }
}
