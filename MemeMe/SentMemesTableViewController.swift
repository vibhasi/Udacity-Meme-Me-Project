//
//  SentMemesTableViewController.swift
//  MemeMe
//
//  Created by Abhishek Singh on 4/9/18.
//  Copyright © 2018 vibha. All rights reserved.
//

import UIKit

class SentMemesTableViewController: UITableViewController {

    var sentMemes: [Meme]?{
        
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        
        return appdelegate.memes
    }
    
    override func viewDidLoad() {
       
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
         self.clearsSelectionOnViewWillAppear = true

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
         self.navigationItem.leftBarButtonItem = self.editButtonItem
         self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addMeme))
         NotificationCenter.default.addObserver(self, selector: #selector(memeDidUpdate), name: NSNotification.Name(rawValue: "memeDidUpdate"), object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
      //  NotificationCenter.default.removeObserver(self)
    }

    @objc func memeDidUpdate(){
        print("memes:\(sentMemes?.count ?? 0)")
        self.tableView.reloadData()
        
    }
    
    @objc func addMeme(){
        
      //  performSegue(withIdentifier: "AddMeme", sender: self)
        let addMemeVC = self.storyboard!.instantiateViewController(withIdentifier: "AddMemeNavigation") as! UINavigationController
            present(addMemeVC, animated: true, completion: nil)
        
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sentMemes?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListViewCell", for: indexPath) as! ListViewCell

        // Configure the cell...
        if  let meme = sentMemes?[indexPath.row]{
        cell.memedImageView?.image = meme.memedImage
        cell.memedImageView?.contentMode = .scaleAspectFill
            cell.nameLabel?.text = meme.topText ?? "" + "" + meme.bottomText! 
        }
        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
           (UIApplication.shared.delegate as! AppDelegate).memes.remove(at: indexPath.row)
            tableView.reloadData()
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    

}
