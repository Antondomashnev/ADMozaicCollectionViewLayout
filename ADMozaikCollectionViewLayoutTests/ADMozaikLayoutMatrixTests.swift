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
        self.matrixLayout = ADMozaikLayoutMatrix(numberOfRows: 4, numberOfColumns: 3)
    }
    
    override func tearDown() {
        self.matrixLayout = nil
        super.tearDown()
    }
    
    func testThatEmptyMatrixShouldReturnTopLeftPositionForNewItem() {
        let position: ADMozaikLayoutPosition = self.matrixLayout.positionForItem(withSize: ADMozaikLayoutSize(numberOfColumns: 2, numberOfRows: 2))!
        expect(position.column).to(equal(0))
        expect(position.row).to(equal(0))
    }
    
    func testThatEmptyMatrixShouldReturnNilPositionForNewItemWiderThanPossible() {
        let position: ADMozaikLayoutPosition? = self.matrixLayout.positionForItem(withSize: ADMozaikLayoutSize(numberOfColumns: 4, numberOfRows: 2))
        expect(position).to(beNil())
    }
    
    func testThatEmptyMatrixShouldReturnNilPositionForNewItemHigherThanPossible() {
        let position: ADMozaikLayoutPosition? = self.matrixLayout.positionForItem(withSize: ADMozaikLayoutSize(numberOfColumns: 2, numberOfRows: 5))
        expect(position).to(beNil())
    }
    
    func testThatFilledMatrixShouldReturnNilPositionIfTherIsNoSpaceLeft() {
        do {
            try self.matrixLayout.addItem(withSize: ADMozaikLayoutSize(numberOfColumns: 3, numberOfRows: 3), at: ADMozaikLayoutPosition(atColumn: 0, atRow: 0))
            try self.matrixLayout.addItem(withSize: ADMozaikLayoutSize(numberOfColumns: 1, numberOfRows: 1), at: ADMozaikLayoutPosition(atColumn: 0, atRow: 3))
        }
        catch {
            
        }
        let position: ADMozaikLayoutPosition? = self.matrixLayout.positionForItem(withSize: ADMozaikLayoutSize(numberOfColumns: 2, numberOfRows: 2))
        expect(position).to(beNil())
    }
    
    func testThatPositionForItemWithSizeShouldReturnCorrectPosition() {
        do {
            try self.matrixLayout.addItem(withSize: ADMozaikLayoutSize(numberOfColumns: 1, numberOfRows: 1), at: ADMozaikLayoutPosition(atColumn: 0, atRow: 0))
        }
        catch {}
        var nextPosition = self.matrixLayout.positionForItem(withSize: ADMozaikLayoutSize(numberOfColumns: 3, numberOfRows: 2))!
        expect(nextPosition.row).to(equal(1))
        expect(nextPosition.column).to(equal(0))
        
        do {
            try self.matrixLayout.addItem(withSize: ADMozaikLayoutSize(numberOfColumns: 3, numberOfRows: 2), at: nextPosition)
        }
        catch {}
        nextPosition = self.matrixLayout.positionForItem(withSize: ADMozaikLayoutSize(numberOfColumns: 2, numberOfRows: 1))!
        expect(nextPosition.row).to(equal(0))
        expect(nextPosition.column).to(equal(1))
    }
}
