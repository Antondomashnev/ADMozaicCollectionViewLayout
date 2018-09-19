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

class ADMozaikLayoutHeader: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.red.withAlphaComponent(0.5)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var reuseIdentifier: String? {
        return "ADMozaikLayoutHeader"
    }
}

class ADMozaikLayoutFooter: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.yellow.withAlphaComponent(0.5)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var reuseIdentifier: String? {
        return "ADMozaikLayoutFooter"
    }
}

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
    
    /// Use case when there are two sections with f & f use cases
    case h
    
    /// Use case when there are three sections with different use cases (a, c, e)
    case i
    
    /// Use case when there is one section with header and d use case
    case j
    
    /// Use case when there is one section with header, footer and a use case
    case k
    
    /// Use case when there are two sections with header, footer and (j, k) use case
    case l
    
    /// Use case when the content mode is ordered there are two columns and interitem and interline space are zero
    case m
    
    var sectionInset: UIEdgeInsets {
        switch self {
        case .d:
            return UIEdgeInsets(top: 5, left: 3, bottom: 0, right: 3)
        case .k:
            return UIEdgeInsets(top: 4, left: 0, bottom: 0, right: 0)
        default:
            return UIEdgeInsets.zero
        }
    }
    
    var headerHeight: CGFloat {
        switch self {
        case .j:
            return 22
        case .k:
            return 33
        default:
            return 0
        }
    }
    
    var footerHeight: CGFloat {
        switch self {
        case .k:
            return 44
        default:
            return 0
        }
    }
    
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
        case .h:
            return ADMozaikLayoutTestsUseCase.f.minimumLineSpacing
        case .i:
            return 0
        case .j:
            return ADMozaikLayoutTestsUseCase.d.minimumLineSpacing
        case .k:
            return ADMozaikLayoutTestsUseCase.a.minimumLineSpacing
        case .l:
            return 0
        case .m:
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
        case .h:
            return ADMozaikLayoutTestsUseCase.f.minimumInteritemSpacing
        case .i:
            return 0
        case .j:
            return ADMozaikLayoutTestsUseCase.d.minimumInteritemSpacing
        case .k:
            return ADMozaikLayoutTestsUseCase.a.minimumInteritemSpacing
        case .l:
            return 0
        case .m:
            return 0
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
            return [ADMozaikLayoutColumn(width: 103), ADMozaikLayoutColumn(width: 104), ADMozaikLayoutColumn(width: 103)]
        case .e:
            return [ADMozaikLayoutColumn(width: 78.5), ADMozaikLayoutColumn(width: 78.5), ADMozaikLayoutColumn(width: 78.5), ADMozaikLayoutColumn(width: 78.5)]
        case .f:
            return [ADMozaikLayoutColumn(width: 63), ADMozaikLayoutColumn(width: 63), ADMozaikLayoutColumn(width: 64), ADMozaikLayoutColumn(width: 63), ADMozaikLayoutColumn(width: 63)]
        case .g:
            return [ADMozaikLayoutColumn(width: 107), ADMozaikLayoutColumn(width: 106), ADMozaikLayoutColumn(width: 107)]
        case .h:
            return ADMozaikLayoutTestsUseCase.f.columns
        case .i:
            return []
        case .j:
            return ADMozaikLayoutTestsUseCase.d.columns
        case .k:
            return ADMozaikLayoutTestsUseCase.a.columns
        case .l:
            return []
        case .m:
            return [ADMozaikLayoutColumn(width: 160), ADMozaikLayoutColumn(width: 160)]
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
            return 103
        case .e:
            return 78.5
        case .f:
            return 63
        case .g:
            return 107
        case .h:
            return ADMozaikLayoutTestsUseCase.f.rowHeight
        case .i:
            return 0
        case .j:
            return ADMozaikLayoutTestsUseCase.d.rowHeight
        case .k:
            return ADMozaikLayoutTestsUseCase.a.rowHeight
        case .l:
            return 0
        case .m:
            return 60
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
        case .h:
            return 10
        case .i:
            return 5
        case .j:
            return ADMozaikLayoutTestsUseCase.a.numberOfItems
        case .k:
            return 7
        case .l:
            return 5
        case .m:
            return 6
        }
    }
    
    var numberOfSections: Int {
        switch self {
        case .a:
            return 1
        case .b:
            return 1
        case .c:
            return 1
        case .d:
            return 1
        case .e:
            return 1
        case .f:
            return 1
        case .g:
            return 0
        case .h:
            return 2
        case .i:
            return 3
        case .j:
            return 1
        case .k:
            return 1
        case .l:
            return 2
        case .m:
            return 1
        }
    }
    
    var underlyingUseCases: [ADMozaikLayoutTestsUseCase]? {
        switch self {
        case .i:
            return [ADMozaikLayoutTestsUseCase.a, ADMozaikLayoutTestsUseCase.c, ADMozaikLayoutTestsUseCase.e]
        case .l:
            return [ADMozaikLayoutTestsUseCase.k, ADMozaikLayoutTestsUseCase.k]
        default:
            return nil
        }
    }
    
    var contentMode: ADMozaikLayoutSectionContentMode {
        switch self {
        case .m:
            return .ordered
        default:
            return .fill
        }
    }
}

class ADMozaikLayoutTestsViewController: UIViewController, ADMozaikLayoutDelegate, UICollectionViewDataSource {
    
    var collectionView: UICollectionView!
    var useCase: ADMozaikLayoutTestsUseCase!
    var colors: [[UIColor]]! = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpCollectionView()
        
        let availableColors = [
                               [UIColor(red: 0.09803921569, green: 0.462745098, blue: 0.8235294118, alpha: 1),
                                UIColor(red: 0.1294117647, green: 0.5882352941, blue: 0.9529411765, alpha: 1),
                                UIColor(red: 0.7333333333, green: 0.8705882353, blue: 0.9843137255, alpha: 1),
                                UIColor(red: 0.3764705882, green: 0.4901960784, blue: 0.5450980392, alpha: 1),
                                UIColor(red: 0.1294117647, green: 0.1294117647, blue: 0.1294117647, alpha: 1),
                                UIColor(red: 0.4470588235, green: 0.4470588235, blue: 0.4470588235, alpha: 1),
                                UIColor(red: 0.7137254902, green: 0.7137254902, blue: 0.7137254902, alpha: 1)],
                               [UIColor(red: 0.9882352941, green: 0.3960784314, blue: 0.2745098039, alpha: 1),
                                UIColor(red: 0.8549019608, green: 0.0823529411, blue: 0.2313725490, alpha: 1),
                                UIColor(red: 0.8823529412, green: 0.5058823529, blue: 0.4705882353, alpha: 1),
                                UIColor(red: 0.3725490196, green: 0.1490196078, blue: 0.08235294118, alpha: 1),
                                UIColor(red: 0.431372549, green: 0.1607843137, blue: 0.1882352941, alpha: 1),
                                UIColor(red: 0.8901960784, green: 0.1764705882, blue: 0.2980392157, alpha: 1),
                                UIColor(red: 0.4901960784, green: 0.1921568627, blue: 0.231372549, alpha: 1)],
                               [UIColor(red: 0.9333333333, green: 0.6078431373, blue: 0.05882352941, alpha: 1),
                                UIColor(red: 1, green: 0.8470588235, blue: 0.4588235294, alpha: 1),
                                UIColor(red: 0.9960784314, green: 0.9333333333, blue: 0.4705882353, alpha: 1),
                                UIColor(red: 1, green: 0.7294117647, blue: 0, alpha: 1),
                                UIColor(red: 1, green: 0.8745098039, blue: 0, alpha: 1),
                                UIColor(red: 1, green: 0.9647058824, blue: 0.4901960784, alpha: 1),
                                UIColor(red: 1, green: 0.7450980392, blue: 0, alpha: 1)]
                              ]
        for section in 0..<self.useCase.numberOfSections {
            var colorsInSection: [UIColor] = []
            for itemNumber in 0..<self.useCase.numberOfItems {
                colorsInSection.append(availableColors[section][itemNumber % availableColors[section].count])
            }
            colors.append(colorsInSection)
        }
    }
    
    //MARK: - UI
    
    func setUpCollectionView() {
        let layout = ADMozaikLayout(delegate: self)
        self.collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        self.view.addSubview(self.collectionView)
        self.collectionView.dataSource = self
        self.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "ADMozaikLayoutCell")
        self.collectionView.register(ADMozaikLayoutFooter.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "ADMozaikLayoutFooter")
        self.collectionView.register(ADMozaikLayoutHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "ADMozaikLayoutHeader")
    }
    
    //MARK: - ADMozaikLayoutDelegate
    
    func collectonView(_ collectionView: UICollectionView, mozaik layoyt: ADMozaikLayout, contentModeFor section: ADMozaikLayoutSection) -> ADMozaikLayoutSectionContentMode {
        if let underlyingUseCase = self.useCase.underlyingUseCases?[section] {
            return underlyingUseCase.contentMode
        }
        return useCase.contentMode
    }
    
    func collectonView(_ collectionView: UICollectionView, mozaik layoyt: ADMozaikLayout, geometryInfoFor section: ADMozaikLayoutSection) -> ADMozaikLayoutSectionGeometryInfo {
        if let underlyingUseCase = self.useCase.underlyingUseCases?[section] {
            return ADMozaikLayoutSectionGeometryInfo(rowHeight: underlyingUseCase.rowHeight, columns: underlyingUseCase.columns, minimumInteritemSpacing: underlyingUseCase.minimumInteritemSpacing, minimumLineSpacing: underlyingUseCase.minimumLineSpacing, sectionInset: underlyingUseCase.sectionInset, headerHeight: underlyingUseCase.headerHeight, footerHeight: underlyingUseCase.footerHeight)
        }
        return ADMozaikLayoutSectionGeometryInfo(rowHeight: useCase.rowHeight, columns: useCase.columns, minimumInteritemSpacing: useCase.minimumInteritemSpacing, minimumLineSpacing: useCase.minimumLineSpacing, sectionInset: useCase.sectionInset, headerHeight: useCase.headerHeight, footerHeight: useCase.footerHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if let underlyingUseCase = self.useCase.underlyingUseCases?[section] {
            return CGSize(width: 0, height: underlyingUseCase.footerHeight)
        }
        return CGSize(width: 0, height: useCase.footerHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if let underlyingUseCase = self.useCase.underlyingUseCases?[section] {
            return CGSize(width: 0, height: underlyingUseCase.headerHeight)
        }
        return CGSize(width: 0, height: useCase.headerHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ADMozaikLayoutHeader", for: indexPath)
            return view
        }
        else {
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ADMozaikLayoutFooter", for: indexPath)
            return view
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, mozaik layout: ADMozaikLayout, mozaikSizeForItemAt indexPath: IndexPath) -> ADMozaikLayoutSize {
        var useCase = self.useCase!
        if let underlyingUseCase = self.useCase.underlyingUseCases?[indexPath.section] {
            useCase = underlyingUseCase
        }
        
        switch useCase {
        case .f:
            fallthrough
        case .h:
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
        case .m:
            if (indexPath as NSIndexPath).item == 3 {
                return ADMozaikLayoutSize(numberOfColumns: 2, numberOfRows: 1)
            }
            else if (indexPath as NSIndexPath).item == 4 {
                return ADMozaikLayoutSize(numberOfColumns: 2, numberOfRows: 2)
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
        return self.useCase.numberOfSections
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.useCase.numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ADMozaikLayoutCell", for: indexPath) as UICollectionViewCell
        cell.backgroundColor = self.colors[indexPath.section][(indexPath as NSIndexPath).item]
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
    
    func testADMozaikLayoutRepresentationWithTwoSectionsWithSameComplexLayout() {
        self.viewController = ADMozaikLayoutTestsViewController()
        self.viewController.useCase = .h
        self.viewController.view.frame = self.testingFrame()
        self.viewController.collectionView.reloadData()
        
        self.FBSnapshotVerifyView(self.viewController.view)
    }
    
    func testADMozaikLayoutRepresentationWithThreeSectionsWithDifferentLayout() {
        self.viewController = ADMozaikLayoutTestsViewController()
        self.viewController.useCase = .i
        self.viewController.view.frame = self.testingFrame()
        self.viewController.collectionView.reloadData()
        
        self.FBSnapshotVerifyView(self.viewController.view)
    }
    
    func testADMozaikLayoutRepresentationWithOneSectionAndHeader() {
        self.viewController = ADMozaikLayoutTestsViewController()
        self.viewController.useCase = .j
        self.viewController.view.frame = self.testingFrame()
        self.viewController.collectionView.reloadData()
        
        self.FBSnapshotVerifyView(self.viewController.view)
    }
    
    func testADMozaikLayoutRepresentationWithOneSectionAndHeaderAndFooter() {
        self.viewController = ADMozaikLayoutTestsViewController()
        self.viewController.useCase = .k
        self.viewController.view.frame = self.testingFrame()
        self.viewController.collectionView.reloadData()
        
        self.FBSnapshotVerifyView(self.viewController.view)
    }
    
    func testADMozaikLayoutRepresentationWithTwoSectionsWithHeaderAndFooters() {
        self.viewController = ADMozaikLayoutTestsViewController()
        self.viewController.useCase = .l
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
    
    func testADMozaikLayoutRepresentationWithOrderedContentMode() {
        self.viewController = ADMozaikLayoutTestsViewController()
        self.viewController.useCase = .m
        self.viewController.view.frame = self.testingFrame()
        self.viewController.collectionView.reloadData()
        
        self.FBSnapshotVerifyView(self.viewController.view)
    }
    
    //MARK - Private
    
    fileprivate func testingFrame() -> CGRect {
        return CGRect(x: 0, y: 0, width: 320, height: 568)
    }
    
}
