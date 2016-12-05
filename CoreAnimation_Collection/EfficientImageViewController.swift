//
//  EfficientImageViewController.swift
//  CoreAnimation_Collection
//
//  Created by ray on 16/2/17.
//  Copyright © 2016年 ray. All rights reserved.
//

import UIKit

class EfficientImageViewController: UIViewController, UICollectionViewDataSource {
    
    let imagePaths = Bundle.main.paths(forResourcesOfType: "png", inDirectory: "Vacation Photos")
    let cellID = "cellID"
    let cache = NSCache<AnyObject, AnyObject>.init()
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10.0
        layout.minimumLineSpacing = 10.0
        layout.itemSize = CGSize(width: 200, height: 150)
        
        let collectionView = UICollectionView.init(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.dataSource = self
        return collectionView

    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
       
        self.view.addSubview(collectionView)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellID)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imagePaths.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath)
        
        //add image view
        let imageTag = 99
        var imageView = cell.viewWithTag(imageTag) as! UIImageView?
        if imageView == nil {
            imageView = UIImageView.init(frame: cell.contentView.bounds)
            imageView?.tag = 99
            cell.contentView.addSubview(imageView!)
        }
        
        //set or load image for this index
        imageView?.image = self.loadImageAtIndex((indexPath as NSIndexPath).item);
        
        //preload image for previous and next index
        if ((indexPath as NSIndexPath).item < self.imagePaths.count - 1)
        {
            _ = self.loadImageAtIndex((indexPath as NSIndexPath).item + 1);
        }
        if ((indexPath as NSIndexPath).item > 0)
        {
            _ = self.loadImageAtIndex((indexPath as NSIndexPath).item - 1);
        }
        
        return cell
    }
    
    func loadImageAtIndex(_ index: Int) -> UIImage? {
    
        var image = cache.object(forKey: index as AnyObject) as! UIImage?
        if image != nil {
            return image
        }

        //switch to background thread
        DispatchQueue.global(qos: .default).async(execute: { () -> Void in
            //load image
            let imagePath = self.imagePaths[index];
//            UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
            image = UIImage.init(contentsOfFile: imagePath)
            
            //redraw image using device context
            UIGraphicsBeginImageContextWithOptions(image!.size, true, 0);
            image!.draw(at: CGPoint.zero);
            image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            //set image for correct image view
            DispatchQueue.main.async(execute: { () -> Void in
                //cache the image
                self.cache.setObject(image!, forKey:index as AnyObject);
                
                //display the image
                let indexPath = IndexPath.init(row: index, section: 0)
                let cell = self.collectionView.cellForItem(at: indexPath);
                let imageView = cell?.contentView.subviews.last as! UIImageView?
                imageView?.image = image;
            })
        })
        
        return nil
    }
    
    
}
