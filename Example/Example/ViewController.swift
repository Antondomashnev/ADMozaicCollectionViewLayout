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

    @IBOutlet var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.collectionViewLayout = self.createLayout()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView.reloadData()
    }

    //MARK: - Helpers
    
    private func createLayout() -> ADMozaikLayout {
        let thirdOfScreen: CGFloat = (CGRectGetWidth(UIScreen.mainScreen().bounds) - 2) / 3

        let columns: [ADMozaikLayoutColumn]
        if (CGRectGetWidth(UIScreen.mainScreen().bounds) - 2) % 3 == 0 {
            columns = [ADMozaikLayoutColumn(width: thirdOfScreen), ADMozaikLayoutColumn(width: thirdOfScreen), ADMozaikLayoutColumn(width: thirdOfScreen)]
        }
        else {
            columns = [ADMozaikLayoutColumn(width: thirdOfScreen), ADMozaikLayoutColumn(width: thirdOfScreen + 1), ADMozaikLayoutColumn(width: thirdOfScreen)]
        }
        
        let layout = ADMozaikLayout(rowHeight: thirdOfScreen, columns: columns)
        layout.delegate = self
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        return layout;
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

