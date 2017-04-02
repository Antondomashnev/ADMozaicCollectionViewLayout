//
//  ADMozaikLayoutSectionMatrix.swift
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
enum ADMozaikLayoutSectionMatrixError : Error {
    case columnOutOfBounds
    case rowOutOfBounds
}

extension ADMozaikLayoutSectionMatrixError : CustomStringConvertible {
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

/// The `ADMozaikLayoutSectionMatrix` defines the class which describes the layout matrx
class ADMozaikLayoutSectionMatrix {
    
    /// Array representation of the matrix: 1 if cell is not empty and 0 if it's empty
    fileprivate var arrayRepresentation: [[Bool]] = []
    
    /// Number of rows in the matrix
    fileprivate var numberOfRows: Int = 0
    
    /// This is very important dictionary
    /// It contains information of the last item with specific size position
    /// E.x. the following items in the following order are added into the matrix
    /// (columns: 1, rows 1) at (column: 0, row: 0)
    /// (columns: 2, rows 2) at (column: 1, row: 0)
    /// (columns: 1, rows 2) at (column: 0, row: 1)
    /// (columns: 3, rows 3) at (column: 0, row: 3)
    /// (columns: 1, rows 1) at (column: 1, row: 1)
    /// Then the dictionary contains the following info:
    /// [
    ///  (columns: 1, rows 1): (column: 1, row: 1),
    ///  (columns: 2, rows 2): (column: 1, row: 0),
    ///  (columns: 1, rows 2): (column: 0, row: 1),
    ///  (columns: 3, rows 3): (column: 0, row: 3)
    /// ]
    /// The general idea of it, that e.x. for item with size (columns: 1, rows 1),
    /// that we can not place it earlier that that position. So we can start iterating from that position
    fileprivate var lastItemPositionOfSize: [ADMozaikLayoutSize: ADMozaikLayoutPosition] = [:]
    
    /// Number of columns in the matrix
    fileprivate let numberOfColumns: Int
    
    /// Representing section in `UICollectionView`
    fileprivate let section: Int
    
    //MARK: - Interface
    
    ///
    /// Designated initializer to create new instance of `ADMozaikLayoutSectionMatrix`
    ///
    /// - Parameter numberOfColumns: expected number of sections in layout
    /// - Parameter section:         section number for which the matrix is supposed to be used
    ///
    /// - Returns: newly created instance of `ADMozaikLayoutSectionMatrix`
    init(numberOfColumns: Int, section: ADMozaikLayoutSection) {
        self.numberOfColumns = numberOfColumns
        self.section = section
        self.arrayRepresentation = self.buildInitialArrayRepresentation(numberOfColumns: numberOfColumns)
    }
    
    ///
    /// Adds item into the layout matrix
    /// Position must be obtained only via positionForItem
    ///
    /// - Parameter size:     size of the adding item
    /// - Parameter position: position to be added at
    ///
    /// - throws: error if item (size.width + position.x) or (size.height + position.y) is out if bounds of the matrix or
    func addItem(of size: ADMozaikLayoutSize, at position: ADMozaikLayoutPosition) throws -> Void {
        let lastColumn = position.column + size.columns - 1
        guard lastColumn < arrayRepresentation.count else {
            throw ADMozaikLayoutSectionMatrixError.columnOutOfBounds
        }
        
        let lastRow = position.row + size.rows - 1
        guard lastRow < arrayRepresentation[lastColumn].count else {
            throw ADMozaikLayoutSectionMatrixError.rowOutOfBounds
        }
        
        for column in position.column...lastColumn {
            for row in position.row...lastRow {
                arrayRepresentation[column][row] = true
                lastItemPositionOfSize[size] = position
            }
        }
    }
    
    ///
    /// Calculates the first available position for the item with the given size
    /// It extends the matrix array representation if the current number of rows is not enough
    ///
    /// - Parameter size: size of the adding item
    ///
    /// - Returns: position of the item
    func positionForItem(of size: ADMozaikLayoutSize) throws -> ADMozaikLayoutPosition {
        let maximumColumn = numberOfColumns - size.columns
        if maximumColumn < 0 {
            throw ADMozaikLayoutSectionMatrixError.columnOutOfBounds
        }
        let latestPositionForItemOfSameSize: ADMozaikLayoutPosition? = lastItemPositionOfSize[size]
        if let latestRowPositionForItemOfSameSize = latestPositionForItemOfSameSize?.row {
            return self.positionForItem(of: size, startingFrom: latestRowPositionForItemOfSameSize, maximumPositionColumn: maximumColumn)
        }
        else {
            return self.positionForItem(of: size, startingFrom: 0, maximumPositionColumn: maximumColumn)
        }
    }
    
    //MARK: - Helpers
    
    fileprivate func positionForItem(of size: ADMozaikLayoutSize, startingFrom startRow: Int, maximumPositionColumn maximumColumn: Int) -> ADMozaikLayoutPosition {
        for row in startRow...numberOfRows {
            for column in 0...maximumColumn {
                let possiblePosition = ADMozaikLayoutPosition(atColumn: column, atRow: row, inSection: section)
                var isPositionFree = false
                do {
                    isPositionFree = try self.isPositionFree(possiblePosition, forItemOf: size)
                }
                catch ADMozaikLayoutSectionMatrixError.rowOutOfBounds {
                    self.extendMatrix(by: size.rows)
                    return self.positionForItem(of: size, startingFrom: row, maximumPositionColumn: maximumColumn)
                }
                catch  {
                    print(error)
                }
                if isPositionFree {
                    return possiblePosition
                }
            }
        }
        return ADMozaikLayoutPosition(atColumn: 0, atRow: 0, inSection: section)
    }
    
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
            throw ADMozaikLayoutSectionMatrixError.columnOutOfBounds
        }
        
        let lastRow = position.row + size.rows - 1
        guard lastRow < arrayRepresentation[lastColumn].count else {
            throw ADMozaikLayoutSectionMatrixError.rowOutOfBounds
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
