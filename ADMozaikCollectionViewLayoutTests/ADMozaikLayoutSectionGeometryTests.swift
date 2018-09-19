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
    }

    override func tearDown() {
        self.layoutGeometry = nil
        super.tearDown()
    }
    
    // MARK: - Helpers
    
    func buildLayoutGeometryWith(header: Bool, footer: Bool) -> ADMozaikLayoutSectionGeometry {
        let layoutColumns: [ADMozaikLayoutColumn] = [ADMozaikLayoutColumn(width: 105.0),
                                                     ADMozaikLayoutColumn(width: 106.0),
                                                     ADMozaikLayoutColumn(width: 105.0)]
        let geometryInfo = ADMozaikLayoutSectionGeometryInfo(rowHeight: 105.0, columns: layoutColumns, minimumInteritemSpacing: 1.0, minimumLineSpacing: 2.0, sectionInset: UIEdgeInsets(top: 3, left: 1, bottom: 2, right: 1), headerHeight: header ? 44 : 0, footerHeight: footer ? 88 : 0)
        return ADMozaikLayoutSectionGeometry(geometryInfo: geometryInfo)
    }
    
    // MARK: - Tests
    
    func testThatFrameForItemWithMozaikSizeShouldReturnCorrectFrame() {
        layoutGeometry = buildLayoutGeometryWith(header: true, footer: true)
        
        let frame1 = layoutGeometry.frameForItem(withMozaikSize: ADMozaikLayoutSize(numberOfColumns: 2, numberOfRows: 2), at: ADMozaikLayoutPosition(atColumn: 0, atRow: 0, inSection: 0))
        expect(frame1.width).to(equal(212))
        expect(frame1.height).to(equal(212))
        expect(frame1.origin.y).to(equal(47))
        expect(frame1.origin.x).to(equal(1))
        
        let frame2 = layoutGeometry.frameForItem(withMozaikSize: ADMozaikLayoutSize(numberOfColumns: 1, numberOfRows: 1), at: ADMozaikLayoutPosition(atColumn: 2, atRow: 2, inSection: 0))
        expect(frame2.width).to(equal(105))
        expect(frame2.height).to(equal(105))
        expect(frame2.origin.x).to(equal(214))
        expect(frame2.origin.y).to(equal(261))
    }
    
    func testThatFrameForSupplementaryViewShouldReturnNilForFooterWithZeroHeight() {
        layoutGeometry = buildLayoutGeometryWith(header: true, footer: false)
        
        expect(self.layoutGeometry.frameForSupplementaryView(of: UICollectionView.elementKindSectionFooter)).to(beNil())
    }
    
    func testThatFrameForSupplementaryViewShouldReturnNilForHeaderWithZeroHeight() {
        layoutGeometry = buildLayoutGeometryWith(header: false, footer: true)
        
        expect(self.layoutGeometry.frameForSupplementaryView(of: UICollectionView.elementKindSectionHeader)).to(beNil())
    }
    
    func testThatFrameForSupplementaryViewShouldReturnCorrectFrameForHeaderWithNonZeroHeight() {
        layoutGeometry = buildLayoutGeometryWith(header: true, footer: true)
        layoutGeometry.registerElement(with: CGRect(x: 0, y: 45, width: 212, height: 212))
        
        let expectedFrame = CGRect(x: 1, y: 3, width: 318, height: 44)
        expect(self.layoutGeometry.frameForSupplementaryView(of: UICollectionView.elementKindSectionHeader)).to(equal(expectedFrame))
    }
    
    func testThatFrameForSupplementaryViewShouldReturnCorrectFrameForFooterWithNonZeroHeight() {
        layoutGeometry = buildLayoutGeometryWith(header: true, footer: true)
        layoutGeometry.registerElement(with: CGRect(x: 1, y: 47, width: 212, height: 212))
        layoutGeometry.registerElement(with: CGRect(x: 214, y: 47, width: 105, height: 105))
        layoutGeometry.registerElement(with: CGRect(x: 214, y: 154, width: 105, height: 212))
        
        let expectedFrame = CGRect(x: 1, y: 366, width: 318, height: 88)
        expect(self.layoutGeometry.frameForSupplementaryView(of: UICollectionView.elementKindSectionFooter)).to(equal(expectedFrame))
    }
    
    func testThatRegisterElementShouldCalculateContentHeightCorrectly() {
        layoutGeometry = buildLayoutGeometryWith(header: true, footer: true)
        layoutGeometry.registerElement(with: CGRect(x: 1, y: 47, width: 212, height: 212))
        layoutGeometry.registerElement(with: CGRect(x: 214, y: 47, width: 105, height: 105))
        
        expect(self.layoutGeometry.contentHeight).to(equal(261))
    }
}
