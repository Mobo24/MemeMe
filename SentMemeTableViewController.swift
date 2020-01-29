//
//  SentMemeTableViewController.swift
//  MemeMe
//
//  Created by Mobolaji Moronfolu on 6/19/17.
//  Copyright © 2017 Mobolaji Moronfolu. All rights reserved.
//

import Foundation
import UIKit

class SentMemeTableViewController: UITableViewController{
    var memes: [Meme]!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate
        let object = appDelegate as! AppDelegate
       memes = object.memes
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
         let cell = tableView.dequeueReusableCell(withIdentifier: "MemeCell")!
        let memeArray = memes[(indexPath as NSIndexPath).row]
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let tvControl = self.storyboard!.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        _ = self.memes[(indexPath as NSIndexPath).row]
        self.navigationController!.pushViewController(tvControl, animated: true)
    }

}
