//
//  ADMozaikLayoutCacheTests.swift
//  ADMozaikCollectionViewLayout
//
//  Created by Anton Domashnev on 01/06/16.
//  Copyright © 2016 Anton Domashnev. All rights reserved.
//

import XCTest
import Nimble

@testable import ADMozaikCollectionViewLayout

private class ADMozaikLayoutCacheTestsCollectionView: UICollectionView {
    
    private override func numberOfSections() -> Int {
        return 1
    }
    
    private override func numberOfItemsInSection(section: Int) -> Int {
        return 10
    }
    
}

private class ADMozaikLayoutCacheTestsADMozaikLayoutDelegate: NSObject, ADMozaikLayoutDelegate {
    
    private func collectionView(collectionView: UICollectionView, layout: UICollectionViewLayout, mozaikSizeForItemAtIndexPath: NSIndexPath) -> ADMozaikLayoutSize {
        return ADMozaikLayoutSize(columns: mozaikSizeForItemAtIndexPath.section, rows: mozaikSizeForItemAtIndexPath.item)
    }
    
}

class ADMozaikLayoutCacheTests: XCTestCase {
    
    var layoutCache: ADMozaikLayoutCache!
    private var collectionView: ADMozaikLayoutCacheTestsCollectionView!
    private var layoutDelegate: ADMozaikLayoutCacheTestsADMozaikLayoutDelegate!
    
    override func setUp() {
        super.setUp()
        self.collectionView = ADMozaikLayoutCacheTestsCollectionView(frame: CGRectZero, collectionViewLayout: UICollectionViewFlowLayout())
        self.layoutDelegate = ADMozaikLayoutCacheTestsADMozaikLayoutDelegate()
        self.layoutCache = ADMozaikLayoutCache(collectionView: self.collectionView, mozaikLayoutDelegate: self.layoutDelegate)
    }
    
    override func tearDown() {
        self.collectionView = nil
        self.layoutCache = nil
        super.tearDown()
    }
    
    func testThatNumberOfItemsInSectionShouldReturnCorrectValue() {
        expect(self.layoutCache.numberOfItemsInSection(0)).to(equal(10))
        expect(self.layoutCache.numberOfItemsInSection(0)).to(equal(10))
    }
    
    func testThatNumberOfSectionsShouldReturnCorrectValue() {
        expect(self.layoutCache.numberOfSections()).to(equal(1))
        expect(self.layoutCache.numberOfSections()).to(equal(1))
    }
    
    func testThatMozaikSizeForItemAtIndexPathShouldReturnCorrectValue() {
        let size1 = self.layoutCache.mozaikSizeForItemAtIndexPath(NSIndexPath(forItem: 1, inSection: 1))
        let size2 = self.layoutCache.mozaikSizeForItemAtIndexPath(NSIndexPath(forItem: 2, inSection: 2))
        expect(size1.columns).to(equal(1))
        expect(size1.rows).to(equal(1))
        expect(size2.columns).to(equal(2))
        expect(size2.rows).to(equal(2))
        
        let cachedSize1 = self.layoutCache.mozaikSizeForItemAtIndexPath(NSIndexPath(forItem: 1, inSection: 1))
        let cachedSize2 = self.layoutCache.mozaikSizeForItemAtIndexPath(NSIndexPath(forItem: 2, inSection: 2))
        expect(cachedSize1.columns).to(equal(1))
        expect(cachedSize1.rows).to(equal(1))
        expect(cachedSize2.columns).to(equal(2))
        expect(cachedSize2.rows).to(equal(2))
    }

}
