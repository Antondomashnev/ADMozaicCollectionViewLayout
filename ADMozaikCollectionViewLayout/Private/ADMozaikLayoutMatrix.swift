//
//  ADMozaikLayoutMatrix.swift
//  ADMozaikCollectionViewLayout
//
//  Created by Anton Domashnev on 16/05/16.
//  Copyright © 2016 Anton Domashnev. All rights reserved.
//

import Foundation

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

class ADMozaikLayoutMatrix {
    
    private var arrayRepresentation: [[Bool]] = []
    
    private let numberOfRows: Int
    
    private let numberOfColumns: Int
 
    //MARK: - Interface
    
    init(numberOfRows: Int, numberOfColumns: Int) {
        self.numberOfRows = numberOfRows
        self.numberOfColumns = numberOfColumns
        self.arrayRepresentation = self.buildArrayRepresentation(numberOfRows, numberOfColumns: numberOfColumns)
    }

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