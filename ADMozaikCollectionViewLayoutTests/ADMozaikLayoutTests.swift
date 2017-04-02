//
//  ADMozaikLayoutTests.swift
//  ADMozaikCollectionViewLayout
//
//  Created by Anton Domashnev on 02/06/16.
//  Copyright © 2016 Anton Domashnev. All rights reserved.
//

import FBSnapshotTestCase
import XCTest
import UIKit

@testable import ADMozaikCollectionViewLayout

enum ADMozaikLayoutTestsUseCase {
    /// Use case when there are three columns and interitem and interline space are zero
    case a
    
    /// Use case when there are three columns and interitem is 2 and interline space is zero
    case b
    
    /// Use case when there are three columns and interitem is 0 and interline space is 2
    case c
    
    /// Use case when there are three columns and interitem is 2 and interline space is 2
    case d
    
    /// Use case when there are four columns and interitem is 2 and interline space is 2
    case e
    
    /// Use case when there are three columns and interitem is 2 and interline space is 2 and complex layout
    case f
    
    /// Use case when there are no sections
    case g
    
    var minimumLineSpacing: CGFloat {
        switch self {
        case .a:
            return 0
        case .b:
            return 0
        case .c:
            return 2
        case .d:
            return 2
        case .e:
            return 2
        case .f:
            return 1
        case .g:
            return 0
        }
    }
    
    var minimumInteritemSpacing: CGFloat {
        switch self {
        case .a:
            return 0
        case .b:
            return 2
        case .c:
            return 0
        case .d:
            return 2
        case .e:
            return 2
        case .f:
            return 1
        case .g:
            return 1
        }
    }
    
    var columns: [ADMozaikLayoutColumn] {
        switch self {
        case .a:
            return [ADMozaikLayoutColumn(width: 107), ADMozaikLayoutColumn(width: 106), ADMozaikLayoutColumn(width: 107)]
        case .b:
            return [ADMozaikLayoutColumn(width: 105), ADMozaikLayoutColumn(width: 106), ADMozaikLayoutColumn(width: 105)]
        case .c:
            return [ADMozaikLayoutColumn(width: 107), ADMozaikLayoutColumn(width: 106), ADMozaikLayoutColumn(width: 107)]
        case .d:
            return [ADMozaikLayoutColumn(width: 105), ADMozaikLayoutColumn(width: 106), ADMozaikLayoutColumn(width: 105)]
        case .e:
            return [ADMozaikLayoutColumn(width: 78.5), ADMozaikLayoutColumn(width: 78.5), ADMozaikLayoutColumn(width: 78.5), ADMozaikLayoutColumn(width: 78.5)]
        case .f:
            return [ADMozaikLayoutColumn(width: 63), ADMozaikLayoutColumn(width: 63), ADMozaikLayoutColumn(width: 64), ADMozaikLayoutColumn(width: 63), ADMozaikLayoutColumn(width: 63)]
        case .g:
            return [ADMozaikLayoutColumn(width: 107), ADMozaikLayoutColumn(width: 106), ADMozaikLayoutColumn(width: 107)]
        }
    }
    
    var rowHeight: CGFloat {
        switch self {
        case .a:
            return 107
        case .b:
            return 105
        case .c:
            return 107
        case .d:
            return 105
        case .e:
            return 78.5
        case .f:
            return 63
        case .g:
            return 107
        }
    }
    
    var numberOfItems: Int {
        switch self {
        case .a:
            return 40
        case .b:
            return 40
        case .c:
            return 40
        case .d:
            return 40
        case .e:
            return 40
        case .f:
            return 40
        case .g:
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
        self.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "ADMozaikLayoutCell")
    }
    
    //MARK: - ADMozaikLayoutDelegate
    
    func collectionView(_ collectionView: UICollectionView, mozaik layout: UICollectionViewLayout, mozaikSizeForItemAt indexPath: IndexPath) -> ADMozaikLayoutSize {
        switch self.useCase! {
        case .f:
            if (indexPath as NSIndexPath).item % 8 == 0 {
                return ADMozaikLayoutSize(numberOfColumns: 2, numberOfRows: 2)
            }
            else if (indexPath as NSIndexPath).item % 6 == 0 {
                return ADMozaikLayoutSize(numberOfColumns: 3, numberOfRows: 1)
            }
            else if (indexPath as NSIndexPath).item % 4 == 0 {
                return ADMozaikLayoutSize(numberOfColumns: 1, numberOfRows: 3)
            }
            else {
                return ADMozaikLayoutSize(numberOfColumns: 1, numberOfRows: 1)
            }
        default:
            return ADMozaikLayoutSize(numberOfColumns: 1, numberOfRows: 1)
        }
        
    }
    
    //MARK: - UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        switch self.useCase! {
        case .g:
            return 0
        default:
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.useCase.numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ADMozaikLayoutCell", for: indexPath) as UICollectionViewCell
        cell.backgroundColor = self.colors[(indexPath as NSIndexPath).item]
        return cell
    }
    
}

//******************************************************//

class ADMozaikLayoutSnapshotTests: FBSnapshotTestCase {
    
    var viewController: ADMozaikLayoutTestsViewController!
    
    override func setUp() {
        super.setUp()
        self.recordMode = false
    }
    
    override func tearDown() {
        self.viewController = nil
        super.tearDown()
    }
    
    func testADMozaikLayoutRepresentationWithoutInsetsAndThreeColumns() {
        self.viewController = ADMozaikLayoutTestsViewController()
        self.viewController.useCase = .a
        self.viewController.view.frame = self.testingFrame()
        self.viewController.collectionView.reloadData()
        
        self.FBSnapshotVerifyView(self.viewController.view)
    }
    
    func testADMozaikLayoutRepresentationWithInteritemInsetsAndThreeColumns() {
        self.viewController = ADMozaikLayoutTestsViewController()
        self.viewController.useCase = .b
        self.viewController.view.frame = self.testingFrame()
        self.viewController.collectionView.reloadData()
        
        self.FBSnapshotVerifyView(self.viewController.view)
    }
    
    func testADMozaikLayoutRepresentationWithInterLineInsetsAndThreeColumns() {
        self.viewController = ADMozaikLayoutTestsViewController()
        self.viewController.useCase = .c
        self.viewController.view.frame = self.testingFrame()
        self.viewController.collectionView.reloadData()
        
        self.FBSnapshotVerifyView(self.viewController.view)
    }
    
    func testADMozaikLayoutRepresentationWithInterLineInsetsAndInterItemInsetsAndThreeColumns() {
        self.viewController = ADMozaikLayoutTestsViewController()
        self.viewController.useCase = .d
        self.viewController.view.frame = self.testingFrame()
        self.viewController.collectionView.reloadData()
        
        self.FBSnapshotVerifyView(self.viewController.view)
    }
    
    func testADMozaikLayoutRepresentationWithInterLineInsetsAndInterItemInsetsAndFourColumns() {
        self.viewController = ADMozaikLayoutTestsViewController()
        self.viewController.useCase = .e
        self.viewController.view.frame = self.testingFrame()
        self.viewController.collectionView.reloadData()
        
        self.FBSnapshotVerifyView(self.viewController.view)
    }
    
    func testADMozaikLayoutRepresentationWithComplexLayout() {
        self.viewController = ADMozaikLayoutTestsViewController()
        self.viewController.useCase = .f
        self.viewController.view.frame = self.testingFrame()
        self.viewController.collectionView.reloadData()
        
        self.FBSnapshotVerifyView(self.viewController.view)
    }
    
    func testADMozaikLayoutRepresentationWithZeroNumberOfSections() {
        self.viewController = ADMozaikLayoutTestsViewController()
        self.viewController.useCase = .g
        self.viewController.view.frame = self.testingFrame()
        self.viewController.collectionView.reloadData()
        
        self.FBSnapshotVerifyView(self.viewController.view)
    }
    
    //MARK - Private
    
    fileprivate func testingFrame() -> CGRect {
        return CGRect(x: 0, y: 0, width: 320, height: 568)
    }
    
}

//******************************************************//

class ADMozaikLayoutTests: XCTestCase {
    
    func testThatRowHeightShouldReturnRowHeightFromGeometryInfo() {
        let geometryInfo1 = ADMozaikLayoutSectionGeometryInfo(rowHeight: 10, columns: [ADMozaikLayoutColumn(width: 10)])
        let layout = ADMozaikLayout(geometryInfo: geometryInfo1, for: UIDeviceOrientation.portrait)
        
        XCTAssertTrue(layout.rowHeight == geometryInfo1.rowHeight)
    }
    
    func testThatColumnsShouldReturnColumnsFromGeometryInfo() {
        let geometryInfo1 = ADMozaikLayoutSectionGeometryInfo(rowHeight: 10, columns: [ADMozaikLayoutColumn(width: 10)])
        let layout = ADMozaikLayout(geometryInfo: geometryInfo1, for: UIDeviceOrientation.portrait)
        
        XCTAssertTrue(layout.columns.elementsEqual(geometryInfo1.columns, by: { (column1, column2) -> Bool in
            return column1 == column2
        }))
    }
}

