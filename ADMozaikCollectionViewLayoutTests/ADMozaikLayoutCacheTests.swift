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
    
    fileprivate override var numberOfSections : Int {
        return 1
    }
    
    fileprivate override func numberOfItems(inSection section: Int) -> Int {
        return 10
    }
    
}

private class ADMozaikLayoutCacheTestsADMozaikLayoutDelegate: NSObject, ADMozaikLayoutDelegate {
    func collectonView(_ collectionView: UICollectionView, mozaik layoyt: ADMozaikLayout, geometryInfoFor section: ADMozaikLayoutSection) -> ADMozaikLayoutSectionGeometryInfo {
        let column = ADMozaikLayoutColumn(width: 20)
        return ADMozaikLayoutSectionGeometryInfo(rowHeight: 10, columns: [column], minimumInteritemSpacing: 2, minimumLineSpacing: 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, mozaik layout: ADMozaikLayout, mozaikSizeForItemAt indexPath: IndexPath) -> ADMozaikLayoutSize {
        return ADMozaikLayoutSize(numberOfColumns: (indexPath as NSIndexPath).section, numberOfRows: (indexPath as NSIndexPath).item)
    }
}

class ADMozaikLayoutCacheTests: XCTestCase {
    
    var layoutCache: ADMozaikLayoutCache!
    fileprivate var collectionView: ADMozaikLayoutCacheTestsCollectionView!
    fileprivate var layoutDelegate: ADMozaikLayoutCacheTestsADMozaikLayoutDelegate!
    
    override func setUp() {
        super.setUp()
        self.layoutDelegate = ADMozaikLayoutCacheTestsADMozaikLayoutDelegate()
        self.collectionView = ADMozaikLayoutCacheTestsCollectionView(frame: CGRect.zero, collectionViewLayout: ADMozaikLayout(delegate: self.layoutDelegate))
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
        let size1 = self.layoutCache.mozaikSizeForItem(atIndexPath: IndexPath(item: 1, section: 1))
        let size2 = self.layoutCache.mozaikSizeForItem(atIndexPath: IndexPath(item: 2, section: 2))
        expect(size1.columns).to(equal(1))
        expect(size1.rows).to(equal(1))
        expect(size2.columns).to(equal(2))
        expect(size2.rows).to(equal(2))
        
        let cachedSize1 = self.layoutCache.mozaikSizeForItem(atIndexPath: IndexPath(item: 1, section: 1))
        let cachedSize2 = self.layoutCache.mozaikSizeForItem(atIndexPath: IndexPath(item: 2, section: 2))
        expect(cachedSize1.columns).to(equal(1))
        expect(cachedSize1.rows).to(equal(1))
        expect(cachedSize2.columns).to(equal(2))
        expect(cachedSize2.rows).to(equal(2))
    }

}
