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
enum ADMozaikLayoutMatrixError : ErrorType {
    case ColumnOutOfBounds
    case RowOutOfBounds
}

extension ADMozaikLayoutMatrixError : CustomStringConvertible {
    var description: String {
        switch self {
        case .ColumnOutOfBounds:
            return "Invalid column. Out of bounds"
            
        case .RowOutOfBounds:
            return "Invalid row. Out of bounds"
        }
    }
}

//*************************************************************************//

/// The `ADMozaikLayoutMatrix` defines the class which describes the layout matrx
class ADMozaikLayoutMatrix {
    
    /// Array representation of the matrix: 1 if cell is not empty and 0 if it's empty
    private var arrayRepresentation: [[Bool]] = []
    
    /// Number of rows in the matrix
    private let numberOfRows: Int
    
    /// Number of columns in the matrix
    private let numberOfColumns: Int
 
    //MARK: - Interface
    
    /**
     Designated initializer to create new instance of `ADMozaikLayoutMatrix`
     
     - parameter numberOfRows: expected number of rows in layout
     - parameter columns:      number of coumns in layout
     
     - returns: newly created instance of `ADMozaikLayoutMatrix`
     */
    init(numberOfRows: Int, numberOfColumns: Int) {
        self.numberOfRows = numberOfRows
        self.numberOfColumns = numberOfColumns
        self.arrayRepresentation = self.buildArrayRepresentation(numberOfRows, numberOfColumns: numberOfColumns)
    }

    /**
     Adds item into the layout matrix
     
     - parameter size:     size of the adding item
     - parameter position: position to be added at
     
     - throws: error if item (size.width + position.x) or (size.height + position.y) is out if bounds of the matrix or
     */
    func addItemWithSize(size: ADMozaikLayoutSize, atPosition position: ADMozaikLayoutPosition) throws -> Void {
        let lastColumn = position.column + size.columns - 1
        guard lastColumn < arrayRepresentation.count else {
            throw ADMozaikLayoutMatrixError.ColumnOutOfBounds
        }
        
        let lastRow = position.row + size.rows - 1
        guard lastRow < arrayRepresentation[lastColumn].count else {
            throw ADMozaikLayoutMatrixError.RowOutOfBounds
        }
        
        for column in position.column...lastColumn {
            for row in position.row...lastRow {
                arrayRepresentation[column][row] = true
            }
        }
    }
    
    /**
     Calculates the first available position for the item with the given size
     
     - parameter size: size of the adding item
     
     - returns: position of the item, returns nil if there is no available position fir the item
     */
    func positionForItemWithSize(size: ADMozaikLayoutSize) -> ADMozaikLayoutPosition? {
        let maximumColumn = self.numberOfColumns - size.columns
        let maximumRow = self.numberOfRows - size.rows
        
        if maximumRow < 0 || maximumColumn < 0 {
            return nil
        }
        
        for row in 0...maximumRow {
            for column in 0...maximumColumn {
                let possiblePosition = ADMozaikLayoutPosition(column: column, row: row)
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
    
    private func buildArrayRepresentation(numberOfRows: Int, numberOfColumns: Int) -> [[Bool]] {
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
    
    private func isPositionFree(position: ADMozaikLayoutPosition, forItemWithSize size: ADMozaikLayoutSize) throws -> Bool {
        let lastColumn = position.column + size.columns - 1
        guard lastColumn < arrayRepresentation.count else {
            throw ADMozaikLayoutMatrixError.ColumnOutOfBounds
        }
        
        let lastRow = position.row + size.rows - 1
        guard lastRow < arrayRepresentation[lastColumn].count else {
            throw ADMozaikLayoutMatrixError.RowOutOfBounds
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