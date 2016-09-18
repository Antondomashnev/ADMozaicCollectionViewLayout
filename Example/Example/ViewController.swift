//
//  ViewController.swift
//  Example
//
//  Created by Anton Domashnev on 31/05/16.
//  Copyright © 2016 Anton Domashnev. All rights reserved.
//

import UIKit
import ADMozaikCollectionViewLayout

class ViewController: UIViewController, ADMozaikLayoutDelegate, UICollectionViewDataSource {

    private let ADMozaikCollectionViewLayoutExampleImagesCount = 22
    
    @IBOutlet var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.collectionViewLayout = self.createLayout()
        self.collectionView.collectionViewLayout.collectionViewContentSize()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView.reloadData()
    }

    //MARK: - Helpers
    
    private func createLayout() -> ADMozaikLayout {
        let columns = [ADMozaikLayoutColumn(width: 93), ADMozaikLayoutColumn(width: 93), ADMozaikLayoutColumn(width: 93), ADMozaikLayoutColumn(width: 93)]
        let layout = ADMozaikLayout(rowHeight: 93, columns: columns)
        layout.delegate = self
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        return layout;
    }
    
    //MARK: - ADMozaikLayoutDelegate
    
    func collectionView(collectionView: UICollectionView, layout: UICollectionViewLayout, mozaikSizeForItemAtIndexPath indexPath: NSIndexPath) -> ADMozaikLayoutSize {
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
        let imageView: UIImageView = cell.viewWithTag(1000) as! UIImageView
        imageView.image = UIImage(named: "\(indexPath.item % ADMozaikCollectionViewLayoutExampleImagesCount)")
        return cell
    }
    
}

