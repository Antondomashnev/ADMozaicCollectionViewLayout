//
//  InitFromCodeExampleViewController.swift
//  Example
//
//  Created by Anton Domashnev on 23/02/2017.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import UIKit
import ADMozaikCollectionViewLayout

class InitFromCodeExampleViewController: UIViewController, ADMozaikLayoutDelegate, UICollectionViewDataSource {
    fileprivate let ADMozaikCollectionViewLayoutExampleImagesCount = 22
    
    fileprivate var layoutType: ADMozaikLayoutType = .portrait
    
    fileprivate var portraitLayout: ADMozaikLayout {
        let layout = ADMozaikLayout(delegate: self)
        return layout;
    }
    
    fileprivate var landscapeLayout: ADMozaikLayout {
        let layout = ADMozaikLayout(delegate: self)
        return layout;
    }
    
    @IBOutlet var collectionView: UICollectionView!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        layoutType = UIScreen.main.bounds.width > UIScreen.main.bounds.height ? .landscape : .portrait
        self.setCollectionViewLayout(animated: false, of: layoutType)
    }
    
    //MARK: - Helpers
    
    fileprivate func setCollectionViewLayout(animated: Bool, of type: ADMozaikLayoutType) {
        self.collectionView.collectionViewLayout.invalidateLayout()
        if type == .landscape {
            self.collectionView.setCollectionViewLayout(self.landscapeLayout, animated: animated)
        }
        else {
            self.collectionView.setCollectionViewLayout(self.portraitLayout, animated: animated)
        }
    }
    
    //MARK: - ADMozaikLayoutDelegate
    
    func collectionView(_ collectionView: UICollectionView, mozaik layout: ADMozaikLayout, mozaikSizeForItemAt indexPath: IndexPath) -> ADMozaikLayoutSize {
        if indexPath.item == 0 {
            return ADMozaikLayoutSize(numberOfColumns: 1, numberOfRows: 1)
        }
        if indexPath.item % 8 == 0 {
            return ADMozaikLayoutSize(numberOfColumns: 2, numberOfRows: 2)
        }
        else if indexPath.item % 6 == 0 {
            return ADMozaikLayoutSize(numberOfColumns: 3, numberOfRows: 1)
        }
        else if indexPath.item % 4 == 0 {
            return ADMozaikLayoutSize(numberOfColumns: 1, numberOfRows: 3)
        }
        else {
            return ADMozaikLayoutSize(numberOfColumns: 1, numberOfRows: 1)
        }
    }
    
    func collectonView(_ collectionView: UICollectionView, mozaik layoyt: ADMozaikLayout, geometryInfoFor section: ADMozaikLayoutSection) -> ADMozaikLayoutSectionGeometryInfo {
        let rowHeight: CGFloat = layoutType == .portrait ? 93 : 110
        let columns = layoutType == .portrait ? [ADMozaikLayoutColumn(width: 93), ADMozaikLayoutColumn(width: 93), ADMozaikLayoutColumn(width: 93), ADMozaikLayoutColumn(width: 93)] : [ADMozaikLayoutColumn(width: 110), ADMozaikLayoutColumn(width: 110), ADMozaikLayoutColumn(width: 111), ADMozaikLayoutColumn(width: 111), ADMozaikLayoutColumn(width: 110), ADMozaikLayoutColumn(width: 110)]
        let geometryInfo = ADMozaikLayoutSectionGeometryInfo(rowHeight: rowHeight,
                                                             columns: columns,
                                                             minimumInteritemSpacing: 1,
                                                             minimumLineSpacing: 1,
                                                             sectionInset: UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0),
                                                             headerHeight: 44, footerHeight: 22)
        return geometryInfo
    }
    
    //MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ADMozaikLayoutHeader", for: indexPath)
        }
        else {
            return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ADMozaikLayoutFooter", for: indexPath)
        }
    }
    
    //MARK: - UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ADMozaikLayoutCell", for: indexPath) as UICollectionViewCell
        let sectionLabel: UILabel = cell.viewWithTag(1001) as! UILabel
        sectionLabel.text = "\(indexPath.section)"
        let imageView: UIImageView = cell.viewWithTag(1000) as! UIImageView
        imageView.image = UIImage(named: "\((indexPath as NSIndexPath).item % ADMozaikCollectionViewLayoutExampleImagesCount)")
        return cell
    }
    
    //MARK: - Orientation
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil) { context in
            self.layoutType = size.width > size.height ? .landscape : .portrait
            self.setCollectionViewLayout(animated: false, of: self.layoutType)
        }
    }
}
