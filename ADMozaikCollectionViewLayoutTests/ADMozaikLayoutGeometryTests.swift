//
//  ADMozaikLayoutGeometryTests.swift
//  ADMozaikCollectionViewLayout
//
//  Created by Anton Domashnev on 29/05/16.
//  Copyright © 2016 Anton Domashnev. All rights reserved.
//

import XCTest
import Nimble

@testable import ADMozaikCollectionViewLayout


class ADMozaikLayoutGeometryTests: XCTestCase {

    var layoutGeometry: ADMozaikLayoutGeometry!
    
    override func setUp() {
        super.setUp()
        let layoutColumns: [ADMozaikLayoutColumn] = [ADMozaikLayoutColumn(width: 106.0),
                                                     ADMozaikLayoutColumn(width: 105.0),
                                                     ADMozaikLayoutColumn(width: 106.0)]
        self.layoutGeometry = ADMozaikLayoutGeometry(layoutColumns: layoutColumns, rowHeight: 106.0)
        self.layoutGeometry.minimumInteritemSpacing = 1.0
        self.layoutGeometry.minimumLineSpacing = 2.0
    }

    override func tearDown() {
        self.layoutGeometry = nil
        super.tearDown()
    }
    
    func testThatSizeForItemWithMozaikSizeShouldReturnCorrectSize() {
        let size1 = self.layoutGeometry.sizeForItemWithMozaikSize(ADMozaikLayoutSize(columns: 2, rows: 2), atPosition: ADMozaikLayoutPosition(column: 0, row: 0))
        expect(size1.width).to(equal(212))
        expect(size1.height).to(equal(214))
        
        let size2 = self.layoutGeometry.sizeForItemWithMozaikSize(ADMozaikLayoutSize(columns: 1, rows: 1), atPosition: ADMozaikLayoutPosition(column: 2, row: 0))
        expect(size2.width).to(equal(106))
        expect(size2.height).to(equal(106))
    }
    
    func testThatXOffsetForItemAtPositionShouldReturnCorrectValue() {
        let xOffset1 = self.layoutGeometry.xOffsetForItemAtPosition(ADMozaikLayoutPosition(column: 0, row: 0))
        expect(xOffset1).to(equal(0))
        
        let offset2 = self.layoutGeometry.xOffsetForItemAtPosition(ADMozaikLayoutPosition(column: 2, row: 0))
        expect(offset2).to(equal(213))
    }
    
    func testThatYOffsetForItemAtPositionShouldReturnCorrectValue() {
        let xOffset1 = self.layoutGeometry.yOffsetForItemAtPosition(ADMozaikLayoutPosition(column: 0, row: 0))
        expect(xOffset1).to(equal(0))
        
        let offset2 = self.layoutGeometry.yOffsetForItemAtPosition(ADMozaikLayoutPosition(column: 1, row: 2))
        expect(offset2).to(equal(216))
    }
}
