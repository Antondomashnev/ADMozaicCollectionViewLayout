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
        let info1 = ADMozaikLayoutGeometryInfo(rowHeight: 10, columns: [column])
        XCTAssertTrue(info1.isValid())
        
        let info2 = ADMozaikLayoutGeometryInfo(rowHeight: 0.1, columns: [column])
        XCTAssertTrue(info2.isValid())
        
        let info3 = ADMozaikLayoutGeometryInfo(rowHeight: 1010, columns: [column])
        XCTAssertTrue(info3.isValid())
    }
    
    func testThatIsValidReturnsFalseIfInfoHasZeroColumnsCountAndNonZeroRowHeight() {
        let info1 = ADMozaikLayoutGeometryInfo(rowHeight: 10, columns: [])
        XCTAssertFalse(info1.isValid())
        
        let info2 = ADMozaikLayoutGeometryInfo(rowHeight: 0.1, columns: [])
        XCTAssertFalse(info2.isValid())
        
        let info3 = ADMozaikLayoutGeometryInfo(rowHeight: 1010, columns: [])
        XCTAssertFalse(info3.isValid())
    }
    
    func testThatIsValidReturnsFalseIfInfoHasNonZeroColumnsCountAndZeroRowHeight() {
        let column = ADMozaikLayoutColumn(width: 10)
        let info1 = ADMozaikLayoutGeometryInfo(rowHeight: 0, columns: [column])
        XCTAssertFalse(info1.isValid())
    }
    
    func testThatIsValidReturnsFalseIfInfoHasZeroColumnsCountAndZeroRowHeight() {
        let info1 = ADMozaikLayoutGeometryInfo(rowHeight: 0, columns: [])
        XCTAssertFalse(info1.isValid())
    }
    
}
