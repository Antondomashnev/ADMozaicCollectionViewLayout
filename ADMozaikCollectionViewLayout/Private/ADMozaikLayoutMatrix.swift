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
    fileprivate var numberOfRows: Int = 0
    
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
    init(numberOfColumns: Int) {
        self.numberOfColumns = numberOfColumns
        self.arrayRepresentation = self.buildInitialArrayRepresentation(numberOfColumns: numberOfColumns)
    }

    ///
    /// Adds item into the layout matrix
    /// Position must be obtained only via positionForItem
    ///
    /// - parameter size:     size of the adding item
    /// - parameter position: position to be added at
    ///
    /// - throws: error if item (size.width + position.x) or (size.height + position.y) is out if bounds of the matrix or
    func addItem(of size: ADMozaikLayoutSize, at position: ADMozaikLayoutPosition) throws -> Void {
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
    /// It extends the matrix array representation if the current number of rows is not enough
    ///
    /// - parameter size: size of the adding item
    ///
    /// - returns: position of the item
    func positionForItem(of size: ADMozaikLayoutSize) throws -> ADMozaikLayoutPosition {
        let maximumColumn = numberOfColumns - size.columns
        if maximumColumn < 0 {
            throw ADMozaikLayoutMatrixError.columnOutOfBounds
        }
        
        for row in 0...numberOfRows {
            for column in 0...maximumColumn {
                let possiblePosition = ADMozaikLayoutPosition(atColumn: column, atRow: row)
                var isPositionFree = false
                do {
                    try isPositionFree = self.isPositionFree(possiblePosition, forItemOf: size)
                }
                catch {
                    print(error)
                }
                if isPositionFree {
                    return possiblePosition
                }
            }
        }
        self.extendMatrix(by: size.rows)
        
        do {
            return try self.positionForItem(of: size)
        }
        catch {
            fatalError((error as! CustomStringConvertible).description)
        }
    }
    
    //MARK: - Helpers
    
    fileprivate func extendMatrix(by rowsCount: Int) {
        for column in 0..<numberOfColumns {
            var rows: [Bool] = arrayRepresentation[column]
            for _ in 0..<rowsCount {
                rows.append(false)
            }
            arrayRepresentation[column] = rows
            numberOfRows += rowsCount
        }
    }
    
    fileprivate func buildInitialArrayRepresentation(numberOfColumns: Int) -> [[Bool]] {
        var arrayRepresentation: [[Bool]] = []
        for _ in 0..<numberOfColumns {
            let rows: [Bool] = []
            arrayRepresentation.append(rows)
        }
        return arrayRepresentation
    }
    
    fileprivate func isPositionFree(_ position: ADMozaikLayoutPosition, forItemOf size: ADMozaikLayoutSize) throws -> Bool {
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
