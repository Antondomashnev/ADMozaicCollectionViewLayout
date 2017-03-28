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
    fileprivate var portraitLayout: ADMozaikLayout {
        let columns = [ADMozaikLayoutColumn(width: 93), ADMozaikLayoutColumn(width: 93), ADMozaikLayoutColumn(width: 93), ADMozaikLayoutColumn(width: 93)]
        let layout = ADMozaikLayout(rowHeight: 93, columns: columns)
        layout.delegate = self
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        return layout;
    }
    
    fileprivate var landscapeLayout: ADMozaikLayout {
        let columns = [ADMozaikLayoutColumn(width: 110), ADMozaikLayoutColumn(width: 110), ADMozaikLayoutColumn(width: 111), ADMozaikLayoutColumn(width: 111), ADMozaikLayoutColumn(width: 110), ADMozaikLayoutColumn(width: 110)]
        let layout = ADMozaikLayout(rowHeight: 110, columns: columns)
        layout.delegate = self
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        return layout;
    }
    
    @IBOutlet var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setCollectionViewLayout(animated: false, of: UIScreen.main.bounds.width > UIScreen.main.bounds.height ? .landscape : .portrait)
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
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 50
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
            self.setCollectionViewLayout(animated: false, of: size.width > size.height ? .landscape : .portrait)
        }
    }
}
