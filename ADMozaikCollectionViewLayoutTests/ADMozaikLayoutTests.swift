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

enum ADMozaikLayoutTestsUseCase {
    /// Use case when there are three columns and interitem and interline space are zero
    case A
    
    /// Use case when there are three columns and interitem is 2 and interline space is zero
    case B
    
    /// Use case when there are three columns and interitem is 0 and interline space is 2
    case C
    
    /// Use case when there are three columns and interitem is 2 and interline space is 2
    case D
    
    /// Use case when there are four columns and interitem is 2 and interline space is 2
    case E
    
    /// Use case when there are three columns and interitem is 2 and interline space is 2 and complex layout
    case F
    
    /// Use case when there are no sections
    case G
    
    var minimumLineSpacing: CGFloat {
        switch self {
        case A:
            return 0
        case B:
            return 0
        case C:
            return 2
        case D:
            return 2
        case E:
            return 2
        case F:
            return 1
        case G:
            return 0
        }
    }
    
    var minimumInteritemSpacing: CGFloat {
        switch self {
        case A:
            return 0
        case B:
            return 2
        case C:
            return 0
        case D:
            return 2
        case E:
            return 2
        case F:
            return 1
        case G:
            return 1
        }
    }
    
    var columns: [ADMozaikLayoutColumn] {
        switch self {
        case A:
            return [ADMozaikLayoutColumn(width: 107), ADMozaikLayoutColumn(width: 106), ADMozaikLayoutColumn(width: 107)]
        case B:
            return [ADMozaikLayoutColumn(width: 105), ADMozaikLayoutColumn(width: 106), ADMozaikLayoutColumn(width: 105)]
        case C:
            return [ADMozaikLayoutColumn(width: 107), ADMozaikLayoutColumn(width: 106), ADMozaikLayoutColumn(width: 107)]
        case D:
            return [ADMozaikLayoutColumn(width: 105), ADMozaikLayoutColumn(width: 106), ADMozaikLayoutColumn(width: 105)]
        case E:
            return [ADMozaikLayoutColumn(width: 78.5), ADMozaikLayoutColumn(width: 78.5), ADMozaikLayoutColumn(width: 78.5), ADMozaikLayoutColumn(width: 78.5)]
        case F:
            return [ADMozaikLayoutColumn(width: 63), ADMozaikLayoutColumn(width: 63), ADMozaikLayoutColumn(width: 64), ADMozaikLayoutColumn(width: 63), ADMozaikLayoutColumn(width: 63)]
        case G:
            return [ADMozaikLayoutColumn(width: 107), ADMozaikLayoutColumn(width: 106), ADMozaikLayoutColumn(width: 107)]
        }
    }
    
    var rowHeight: CGFloat {
        switch self {
        case A:
            return 107
        case B:
            return 105
        case C:
            return 107
        case D:
            return 105
        case E:
            return 78.5
        case F:
            return 63
        case G:
            return 107
        }
    }
    
    var numberOfItems: Int {
        switch self {
        case A:
            return 40
        case B:
            return 40
        case C:
            return 40
        case D:
            return 40
        case E:
            return 40
        case F:
            return 40
        case G:
            return 40
        }
    }
}

class ADMozaikLayoutTestsViewController: UIViewController, ADMozaikLayoutDelegate, UICollectionViewDataSource {
    
    var collectionView: UICollectionView!
    var useCase: ADMozaikLayoutTestsUseCase!
    var colors: [UIColor]! = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpCollectionView()
        
        let availableColors = [UIColor(red: 0.09803921569, green: 0.462745098, blue: 0.8235294118, alpha: 1),
                               UIColor(red: 0.1294117647, green: 0.5882352941, blue: 0.9529411765, alpha: 1),
                               UIColor(red: 0.7333333333, green: 0.8705882353, blue: 0.9843137255, alpha: 1),
                               UIColor(red: 0.3764705882, green: 0.4901960784, blue: 0.5450980392, alpha: 1),
                               UIColor(red: 0.1294117647, green: 0.1294117647, blue: 0.1294117647, alpha: 1),
                               UIColor(red: 0.4470588235, green: 0.4470588235, blue: 0.4470588235, alpha: 1),
                               UIColor(red: 0.7137254902, green: 0.7137254902, blue: 0.7137254902, alpha: 1)]
        for itemNumber in 0..<self.useCase.numberOfItems {
            self.colors.append(availableColors[itemNumber % availableColors.count])
        }
    }
    
    //MARK: - UI
    
    func setUpCollectionView() {
        
        let layout = ADMozaikLayout(rowHeight: self.useCase.rowHeight, columns: self.useCase.columns)
        layout.delegate = self
        layout.minimumLineSpacing = self.useCase.minimumLineSpacing
        layout.minimumInteritemSpacing = self.useCase.minimumInteritemSpacing
        
        self.collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        self.view.addSubview(self.collectionView)
        self.collectionView.dataSource = self
        self.collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "ADMozaikLayoutCell")
    }
    
    //MARK: - ADMozaikLayoutDelegate
    
    func collectionView(collectionView: UICollectionView, layout: UICollectionViewLayout, mozaikSizeForItemAtIndexPath indexPath: NSIndexPath) -> ADMozaikLayoutSize {
        switch self.useCase! {
        case .F:
            if indexPath.item % 8 == 0 {
                return ADMozaikLayoutSize(columns: 2, rows: 2)
            }
            else if indexPath.item % 6 == 0 {
                return ADMozaikLayoutSize(columns: 3, rows: 1)
            }
            else if indexPath.item % 4 == 0 {
                return ADMozaikLayoutSize(columns: 1, rows: 3)
            }
            else {
                return ADMozaikLayoutSize(columns: 1, rows: 1)
            }
        default:
            return ADMozaikLayoutSize(columns: 1, rows: 1)
        }
        
    }
    
    //MARK: - UICollectionViewDataSource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        switch self.useCase! {
        case .G:
            return 0
        default:
            return 1
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.useCase.numberOfItems
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ADMozaikLayoutCell", forIndexPath: indexPath) as UICollectionViewCell
        cell.backgroundColor = self.colors[indexPath.item]
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
        self.viewController.useCase = .A
        self.viewController.view.frame = UIScreen.mainScreen().bounds
        self.viewController.collectionView.reloadData()
        
        self.FBSnapshotVerifyView(self.viewController.view)
    }
    
    func testADMozaikLayoutRepresentationWithInteritemInsetsAndThreeColumns() {
        self.viewController = ADMozaikLayoutTestsViewController()
        self.viewController.useCase = .B
        self.viewController.view.frame = UIScreen.mainScreen().bounds
        self.viewController.collectionView.reloadData()
        
        self.FBSnapshotVerifyView(self.viewController.view)
    }
    
    func testADMozaikLayoutRepresentationWithInterLineInsetsAndThreeColumns() {
        self.viewController = ADMozaikLayoutTestsViewController()
        self.viewController.useCase = .C
        self.viewController.view.frame = UIScreen.mainScreen().bounds
        self.viewController.collectionView.reloadData()
        
        self.FBSnapshotVerifyView(self.viewController.view)
    }
    
    func testADMozaikLayoutRepresentationWithInterLineInsetsAndInterItemInsetsAndThreeColumns() {
        self.viewController = ADMozaikLayoutTestsViewController()
        self.viewController.useCase = .D
        self.viewController.view.frame = UIScreen.mainScreen().bounds
        self.viewController.collectionView.reloadData()
        
        self.FBSnapshotVerifyView(self.viewController.view)
    }
    
    func testADMozaikLayoutRepresentationWithInterLineInsetsAndInterItemInsetsAndFourColumns() {
        self.viewController = ADMozaikLayoutTestsViewController()
        self.viewController.useCase = .E
        self.viewController.view.frame = UIScreen.mainScreen().bounds
        self.viewController.collectionView.reloadData()
        
        self.FBSnapshotVerifyView(self.viewController.view)
    }
    
    func testADMozaikLayoutRepresentationWithComplexLayout() {
        self.viewController = ADMozaikLayoutTestsViewController()
        self.viewController.useCase = .F
        self.viewController.view.frame = UIScreen.mainScreen().bounds
        self.viewController.collectionView.reloadData()
        
        self.FBSnapshotVerifyView(self.viewController.view)
    }
    
    func testADMozaikLayoutRepresentationWithZeroNumberOfSections() {
        self.viewController = ADMozaikLayoutTestsViewController()
        self.viewController.useCase = .G
        self.viewController.view.frame = UIScreen.mainScreen().bounds
        self.viewController.collectionView.reloadData()
        
        self.FBSnapshotVerifyView(self.viewController.view)
    }
    
    
    
}
