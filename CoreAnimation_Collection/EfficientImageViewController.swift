//
//  EfficientImageViewController.swift
//  CoreAnimation_Collection
//
//  Created by ray on 16/2/17.
//  Copyright © 2016年 ray. All rights reserved.
//

import UIKit

class EfficientImageViewController: UIViewController, UICollectionViewDataSource {
    
    let imagePaths = NSBundle.mainBundle().pathsForResourcesOfType("png", inDirectory: "Vacation Photos")
    let cellID = "cellID"
    let cache = NSCache.init()
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .Vertical
        layout.minimumInteritemSpacing = 10.0
        layout.minimumLineSpacing = 10.0
        layout.itemSize = CGSizeMake(200, 150)
        
        let collectionView = UICollectionView.init(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.dataSource = self
        return collectionView

    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
       
        self.view.addSubview(collectionView)
        collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: cellID)
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imagePaths.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellID, forIndexPath: indexPath)
        
        //add image view
        let imageTag = 99
        var imageView = cell.viewWithTag(imageTag) as! UIImageView?
        if imageView == nil {
            imageView = UIImageView.init(frame: cell.contentView.bounds)
            imageView?.tag = 99
            cell.contentView.addSubview(imageView!)
        }
        
        //set or load image for this index
        imageView?.image = self.loadImageAtIndex(indexPath.item);
        
        //preload image for previous and next index
        if (indexPath.item < self.imagePaths.count - 1)
        {
            self.loadImageAtIndex(indexPath.item + 1);
        }
        if (indexPath.item > 0)
        {
            self.loadImageAtIndex(indexPath.item - 1);
        }
        
        return cell
    }
    
    func loadImageAtIndex(index: Int) -> UIImage? {
    
        var image = cache.objectForKey(index) as! UIImage?
        if image != nil {
            return image
        }

        //switch to background thread
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            //load image
            let imagePath = self.imagePaths[index];
//            UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
            image = UIImage.init(contentsOfFile: imagePath)
            
            //redraw image using device context
            UIGraphicsBeginImageContextWithOptions(image!.size, true, 0);
            image!.drawAtPoint(CGPointZero);
            image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            //set image for correct image view
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                //cache the image
                self.cache.setObject(image!, forKey:index);
                
                //display the image
                let indexPath = NSIndexPath.init(forRow: index, inSection: 0)
                let cell = self.collectionView.cellForItemAtIndexPath(indexPath);
                let imageView = cell?.contentView.subviews.last as! UIImageView?
                imageView?.image = image;
            })
        })
        
        return nil
    }
    
    
}
