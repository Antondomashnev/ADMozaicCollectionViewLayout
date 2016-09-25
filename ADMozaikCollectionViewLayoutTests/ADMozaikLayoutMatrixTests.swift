//
//  ADMozaikLayoutMatrixTests.swift
//  ADMozaikCollectionViewLayout
//
//  Created by Anton Domashnev on 25/05/16.
//  Copyright © 2016 Anton Domashnev. All rights reserved.
//

import XCTest
import Nimble

@testable import ADMozaikCollectionViewLayout

class ADMozaikLayoutMatrixTests: XCTestCase {
    
    var matrixLayout: ADMozaikLayoutMatrix!
    
    override func setUp() {
        super.setUp()
        self.matrixLayout = ADMozaikLayoutMatrix(numberOfColumns: 3)
    }
    
    override func tearDown() {
        self.matrixLayout = nil
        super.tearDown()
    }
    
    func testThatEmptyMatrixShouldReturnTopLeftPositionForNewItem() {
        do {
            let position: ADMozaikLayoutPosition = try self.matrixLayout.positionForItem(of: ADMozaikLayoutSize(numberOfColumns: 2, numberOfRows: 2))
            expect(position.column).to(equal(0))
            expect(position.row).to(equal(0))
        }
        catch { fatalError() }
    }
    
    func testThatEmptyMatrixShouldReturnCorrectPositionForNewItemHigherThanPossible() {
        do {
            let position: ADMozaikLayoutPosition = try self.matrixLayout.positionForItem(of: ADMozaikLayoutSize(numberOfColumns: 2, numberOfRows: 5))
            expect(position.column).to(equal(0))
            expect(position.row).to(equal(0))
        }
        catch { fatalError() }
    }
    
    func testThatFilledMatrixShouldExtendMatrixHeightIfThereIsNoSpaceLeft() {
        do {
            var position = try self.matrixLayout.positionForItem(of: ADMozaikLayoutSize(numberOfColumns: 3, numberOfRows: 3))
            try self.matrixLayout.addItem(of: ADMozaikLayoutSize(numberOfColumns: 3, numberOfRows: 3), at: position)
            position = try self.matrixLayout.positionForItem(of: ADMozaikLayoutSize(numberOfColumns: 1, numberOfRows: 1))
            try self.matrixLayout.addItem(of: ADMozaikLayoutSize(numberOfColumns: 1, numberOfRows: 1), at: position)
            position = try self.matrixLayout.positionForItem(of: ADMozaikLayoutSize(numberOfColumns: 2, numberOfRows: 2))
            expect(position.column).to(equal(1))
            expect(position.row).to(equal(3))
        }
        catch { fatalError() }
    }
    
    func testThatPositionForItemWithSizeShouldReturnCorrectPosition() {
        do {
            var position = try self.matrixLayout.positionForItem(of: ADMozaikLayoutSize(numberOfColumns: 3, numberOfRows: 2))
            try self.matrixLayout.addItem(of: ADMozaikLayoutSize(numberOfColumns: 1, numberOfRows: 1), at: position)
            position = try self.matrixLayout.positionForItem(of: ADMozaikLayoutSize(numberOfColumns: 3, numberOfRows: 2))
            expect(position.row).to(equal(1))
            expect(position.column).to(equal(0))
            
            try self.matrixLayout.addItem(of: ADMozaikLayoutSize(numberOfColumns: 3, numberOfRows: 2), at: position)
            position = try self.matrixLayout.positionForItem(of: ADMozaikLayoutSize(numberOfColumns: 2, numberOfRows: 1))
            expect(position.row).to(equal(0))
            expect(position.column).to(equal(1))
        }
        catch { fatalError() }
    }
}
