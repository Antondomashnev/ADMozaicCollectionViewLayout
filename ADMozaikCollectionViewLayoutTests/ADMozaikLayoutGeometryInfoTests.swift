//
//  ADMozaikLayoutGeometryInfoTests.swift
//  ADMozaikCollectionViewLayout
//
//  Created by Anton Domashnev on 24/09/16.
//  Copyright © 2016 Anton Domashnev. All rights reserved.
//

import XCTest

@testable import ADMozaikCollectionViewLayout

class ADMozaikLayoutGeometryInfoTests: XCTestCase {
    
    func testThatIsValidReturnsTrueIfInfoHasNonZeroColumnsCountAndNonZeroRowHeight() {
        let column = ADMozaikLayoutColumn(width: 10)
        let info1 = ADMozaikLayoutSectionGeometryInfo(rowHeight: 10, columns: [column])
        XCTAssertTrue(info1.isValid())
        
        let info2 = ADMozaikLayoutSectionGeometryInfo(rowHeight: 0.1, columns: [column])
        XCTAssertTrue(info2.isValid())
        
        let info3 = ADMozaikLayoutSectionGeometryInfo(rowHeight: 1010, columns: [column])
        XCTAssertTrue(info3.isValid())
    }
    
    func testThatIsValidReturnsFalseIfInfoHasZeroColumnsCountAndNonZeroRowHeight() {
        let info1 = ADMozaikLayoutSectionGeometryInfo(rowHeight: 10, columns: [])
        XCTAssertFalse(info1.isValid())
        
        let info2 = ADMozaikLayoutSectionGeometryInfo(rowHeight: 0.1, columns: [])
        XCTAssertFalse(info2.isValid())
        
        let info3 = ADMozaikLayoutSectionGeometryInfo(rowHeight: 1010, columns: [])
        XCTAssertFalse(info3.isValid())
    }
    
    func testThatIsValidReturnsFalseIfInfoHasNonZeroColumnsCountAndZeroRowHeight() {
        let column = ADMozaikLayoutColumn(width: 10)
        let info1 = ADMozaikLayoutSectionGeometryInfo(rowHeight: 0, columns: [column])
        XCTAssertFalse(info1.isValid())
    }
    
    func testThatIsValidReturnsFalseIfInfoHasZeroColumnsCountAndZeroRowHeight() {
        let info1 = ADMozaikLayoutSectionGeometryInfo(rowHeight: 0, columns: [])
        XCTAssertFalse(info1.isValid())
    }
    
    func testEquatable() {
        let column = ADMozaikLayoutColumn(width: 10)
        let info1 = ADMozaikLayoutSectionGeometryInfo(rowHeight: 10, columns: [column])
        let info2 = ADMozaikLayoutSectionGeometryInfo(rowHeight: 10, columns: [column])
        
        XCTAssertTrue(info1 == info2)
        
        let column2 = ADMozaikLayoutColumn(width: 20)
        let info3 = ADMozaikLayoutSectionGeometryInfo(rowHeight: 20, columns: [column, column2])
        let info4 = ADMozaikLayoutSectionGeometryInfo(rowHeight: 20, columns: [column, column2])
        
        XCTAssertTrue(info3 == info4)
    }
    
    func testInEquatable() {
        let column = ADMozaikLayoutColumn(width: 10)
        let info1 = ADMozaikLayoutSectionGeometryInfo(rowHeight: 10, columns: [column])
        let info2 = ADMozaikLayoutSectionGeometryInfo(rowHeight: 10, columns: [])
        
        XCTAssertFalse(info1 == info2)
        
        let column2 = ADMozaikLayoutColumn(width: 20)
        let info3 = ADMozaikLayoutSectionGeometryInfo(rowHeight: 21, columns: [column, column2])
        let info4 = ADMozaikLayoutSectionGeometryInfo(rowHeight: 22, columns: [column, column2])
        
        XCTAssertFalse(info3 == info4)
    }
}
