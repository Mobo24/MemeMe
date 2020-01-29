//
//  SentMemesCollectionViewController.swift
//  MemeMe
//
//  Created by Mobolaji Moronfolu on 6/11/17.
//  Copyright © 2017 Mobolaji Moronfolu. All rights reserved.
//

import Foundation
import UIKit

class SentMemesCollectionViewController: UICollectionViewController{
    var memes: [Meme]!

    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate
        let object = appDelegate as! AppDelegate
        memes = object.memes
        let space:CGFloat = 3.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return memes.count
        
    }
    
    override func collectionView(_: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView?.dequeueReusableCell(withReuseIdentifier: "MemeCollectionViewCell", for:
            indexPath) as! MemeCollectionViewCell
        let memeArray = memes[(indexPath as NSIndexPath).row]
        cell.cellImageView?.image =  memeArray.memedImage
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        detailController.meme = memes[(indexPath as NSIndexPath).row]
        navigationController!.pushViewController(detailController, animated: true)

    }
    
    
    
    
}
