//
//  ADMozaikLayoutTests.swift
//  ADMozaikCollectionViewLayout
//
//  Created by Anton Domashnev on 02/06/16.
//  Copyright © 2016 Anton Domashnev. All rights reserved.
//

import FBSnapshotTestCase
import UIKit

@testable import ADMozaikCollectionViewLayout

class ADMozaikLayoutTestsViewController: UIViewController, ADMozaikLayoutDelegate, UICollectionViewDataSource {
    
    var collectionView: UICollectionView!
    var minimumLineSpacing: CGFloat = 0
    var minimumInteritemSpacing: CGFloat = 0
    var numberOfColumns: CGFloat = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpCollectionView()
    }
    
    //MARK: - UI
    
    func setUpCollectionView() {
        
        let thirdOfScreen: CGFloat = (CGRectGetWidth(UIScreen.mainScreen().bounds) - (self.numberOfColumns - 1)) / self.numberOfColumns
        let columns: [ADMozaikLayoutColumn]
        if (CGRectGetWidth(UIScreen.mainScreen().bounds) - (self.numberOfColumns - 1)) % self.numberOfColumns == 0 {
            columns = [ADMozaikLayoutColumn(width: thirdOfScreen), ADMozaikLayoutColumn(width: thirdOfScreen), ADMozaikLayoutColumn(width: thirdOfScreen)]
        }
        else {
            columns = [ADMozaikLayoutColumn(width: thirdOfScreen), ADMozaikLayoutColumn(width: thirdOfScreen + 1), ADMozaikLayoutColumn(width: thirdOfScreen)]
        }
        
        let layout = ADMozaikLayout(rowHeight: thirdOfScreen, columns: columns)
        layout.delegate = self
        layout.minimumLineSpacing = self.minimumLineSpacing
        layout.minimumInteritemSpacing = self.minimumInteritemSpacing
        
        self.collectionView = UICollectionView(frame: UIScreen.mainScreen().bounds, collectionViewLayout: layout)
        self.view.addSubview(self.collectionView)
        self.collectionView.dataSource = self
        self.collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "ADMozaikLayoutCell")
    }
    
    //MARK: - ADMozaikLayoutDelegate
    
    func collectionView(collectionView: UICollectionView, layout: UICollectionViewLayout, mozaikSizeForItemAtIndexPath: NSIndexPath) -> ADMozaikLayoutSize {
        return ADMozaikLayoutSize(columns: 1, rows: 1)
    }
    
    //MARK: - UICollectionViewDataSource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ADMozaikLayoutCell", forIndexPath: indexPath) as UICollectionViewCell
        cell.backgroundColor = UIColor(red: CGFloat(arc4random_uniform(100)) / 100, green: CGFloat(arc4random_uniform(100)) / 100, blue: CGFloat(arc4random_uniform(100)) / 100, alpha: 1)
        return cell
    }
    
}

//******************************************************//

class ADMozaikLayoutTests: FBSnapshotTestCase {
    
    var viewController: ADMozaikLayoutTestsViewController!
    
    override func setUp() {
        super.setUp()
        self.recordMode = true
    }
    
    override func tearDown() {
        self.viewController = nil
        super.tearDown()
    }
    
    func testADMozaikLayoutRepresentationWithoutInsetsAndThreeColumns() {
        self.viewController = ADMozaikLayoutTestsViewController()
        self.viewController.minimumLineSpacing = 0
        self.viewController.minimumInteritemSpacing = 0
        self.viewController.numberOfColumns = 3
        self.viewController.view.frame = UIScreen.mainScreen().bounds
        self.viewController.collectionView.reloadData()
        
        self.FBSnapshotVerifyView(self.viewController.view)
    }
    
}
