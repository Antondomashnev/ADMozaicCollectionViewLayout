//
//  InitFromStoryboardExampleViewController.swift
//  Example
//
//  Created by Anton Domashnev on 23/02/2017.
//  Copyright © 2017 Anton Domashnev. All rights reserved.
//

import UIKit
import ADMozaikCollectionViewLayout

class InitFromStoryboardExampleViewController: UIViewController, ADMozaikLayoutDelegate, UICollectionViewDataSource {
    
    fileprivate let ADMozaikCollectionViewLayoutExampleImagesCount = 22
    
    @IBOutlet var mozaikLayout: ADMozaikLayout!
    @IBOutlet var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        mozaikLayout.geometryInfo = ADMozaikLayoutGeometryInfo(rowHeight: 110, columns: [ADMozaikLayoutColumn(width: 93), ADMozaikLayoutColumn(width: 93), ADMozaikLayoutColumn(width: 93), ADMozaikLayoutColumn(width: 93)])
        mozaikLayout.delegate = self
    }
    
    //MARK: - ADMozaikLayoutDelegate
    
    func collectionView(_ collectionView: UICollectionView, mozaik layout: UICollectionViewLayout, mozaikSizeForItemAt indexPath: IndexPath) -> ADMozaikLayoutSize {
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
    
    //MARK: - UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10000
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ADMozaikLayoutCell", for: indexPath) as UICollectionViewCell
        let imageView: UIImageView = cell.viewWithTag(1000) as! UIImageView
        imageView.image = UIImage(named: "\((indexPath as NSIndexPath).item % ADMozaikCollectionViewLayoutExampleImagesCount)")
        return cell
    }
    
    //MARK: - Orientation
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
}
