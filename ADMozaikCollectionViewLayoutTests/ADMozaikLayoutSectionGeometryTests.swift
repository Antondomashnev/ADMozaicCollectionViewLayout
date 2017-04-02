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

    var layoutGeometry: ADMozaikLayoutSectionGeometry!
    
    override func setUp() {
        super.setUp()
        let layoutColumns: [ADMozaikLayoutColumn] = [ADMozaikLayoutColumn(width: 105.0),
                                                     ADMozaikLayoutColumn(width: 106.0),
                                                     ADMozaikLayoutColumn(width: 105.0)]
        let geometryInfo = ADMozaikLayoutSectionGeometryInfo(rowHeight: 105.0, columns: layoutColumns, minimumInteritemSpacing: 1.0, minimumLineSpacing: 2.0, sectionInset: UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1), headerHeight: 44, footerHeight: 88)
        self.layoutGeometry = ADMozaikLayoutSectionGeometry(geometryInfo: geometryInfo)
    }

    override func tearDown() {
        self.layoutGeometry = nil
        super.tearDown()
    }
    
    func testThatSizeForItemWithMozaikSizeShouldReturnCorrectSize() {
        let size1 = self.layoutGeometry.sizeForItem(withMozaikSize: ADMozaikLayoutSize(numberOfColumns: 2, numberOfRows: 2), at: ADMozaikLayoutPosition(atColumn: 0, atRow: 0, inSection: 0))
        expect(size1.width).to(equal(212))
        expect(size1.height).to(equal(212))
        
        let size2 = self.layoutGeometry.sizeForItem(withMozaikSize: ADMozaikLayoutSize(numberOfColumns: 1, numberOfRows: 1), at: ADMozaikLayoutPosition(atColumn: 2, atRow: 0, inSection: 0))
        expect(size2.width).to(equal(105))
        expect(size2.height).to(equal(105))
    }
    
    func testThatXOffsetForItemAtPositionShouldReturnCorrectValue() {
        let xOffset1 = self.layoutGeometry.xOffsetForItem(at: ADMozaikLayoutPosition(atColumn: 0, atRow: 0, inSection: 0))
        expect(xOffset1).to(equal(1))
        
        let offset2 = self.layoutGeometry.xOffsetForItem(at: ADMozaikLayoutPosition(atColumn: 2, atRow: 0, inSection: 0))
        expect(offset2).to(equal(214))
    }
    
    func testThatYOffsetForItemAtPositionShouldReturnCorrectValue() {
        let xOffset1 = self.layoutGeometry.yOffsetForItem(at: ADMozaikLayoutPosition(atColumn: 0, atRow: 0, inSection: 0))
        expect(xOffset1).to(equal(1))
        
        let offset2 = self.layoutGeometry.yOffsetForItem(at: ADMozaikLayoutPosition(atColumn: 1, atRow: 2, inSection: 0))
        expect(offset2).to(equal(215))
    }
    
    func testThatSizeForSupplementaryViewShouldReturnCorrectSizeForFooter() {
        expect(self.layoutGeometry.sizeForSupplementaryView(of: UICollectionElementKindSectionFooter)).to(equal(CGSize(width: 320, height: 88)))
    }
    
    func testThatSizeForSupplementaryViewShouldReturnCorrectSizeForHeader() {
        expect(self.layoutGeometry.sizeForSupplementaryView(of: UICollectionElementKindSectionHeader)).to(equal(CGSize(width: 320, height: 44)))
    }
}
