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
    
    func testThatFrameForItemWithMozaikSizeShouldReturnCorrectFrame() {
        let frame1 = self.layoutGeometry.frameForItem(withMozaikSize: ADMozaikLayoutSize(numberOfColumns: 2, numberOfRows: 2), at: ADMozaikLayoutPosition(atColumn: 0, atRow: 0, inSection: 0))
        expect(frame1.width).to(equal(212))
        expect(frame1.height).to(equal(212))
        expect(frame1.origin.y).to(equal(45))
        expect(frame1.origin.x).to(equal(1))
        
        let frame2 = self.layoutGeometry.frameForItem(withMozaikSize: ADMozaikLayoutSize(numberOfColumns: 1, numberOfRows: 1), at: ADMozaikLayoutPosition(atColumn: 2, atRow: 2, inSection: 0))
        expect(frame2.width).to(equal(105))
        expect(frame2.height).to(equal(105))
        expect(frame2.origin.x).to(equal(214))
        expect(frame2.origin.y).to(equal(259))
    }
    
    func testThatSizeForSupplementaryViewShouldReturnCorrectSizeForFooter() {
        expect(self.layoutGeometry.sizeForSupplementaryView(of: UICollectionElementKindSectionFooter)).to(equal(CGSize(width: 320, height: 88)))
    }
    
    func testThatSizeForSupplementaryViewShouldReturnCorrectSizeForHeader() {
        expect(self.layoutGeometry.sizeForSupplementaryView(of: UICollectionElementKindSectionHeader)).to(equal(CGSize(width: 320, height: 44)))
    }
}
