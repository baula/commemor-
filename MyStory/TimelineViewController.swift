//
//  TimelineViewController.swift
//  MyStory
//
//  Created by Jessica Choi on 7/7/16.
//  Copyright © 2016 Jessica Choi. All rights reserved.
//

import UIKit
import ActiveLabel

class TimelineViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var directionsLabel: UILabel!
    
    var isMoreDataLoading = false
    var postCount : Int = 5
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func viewWillAppear(animated: Bool) {
        tableView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let cell = sender as? TableCell {
            let indexPath = tableView.indexPathForCell(cell)
            let post = appDelegate.posts![indexPath!.row]
            
            if(segue.identifier == "DetailSegue") {
                let detailViewController = segue.destinationViewController as! PostDetailViewController
                detailViewController.hidesBottomBarWhenPushed = true
                detailViewController.post = post
            }
        }
    }
}

extension TimelineViewController: UITableViewDelegate {
}

extension TimelineViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if appDelegate.posts?.count != 0 {
            directionsLabel.hidden = true
        }
        return appDelegate.posts?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : TableCell!
        
        if(indexPath.row % 2 == 0) {
            cell = tableView.dequeueReusableCellWithIdentifier("TableCell", forIndexPath: indexPath) as! TableCell
        } else {
            cell = tableView.dequeueReusableCellWithIdentifier("TableCell2", forIndexPath: indexPath) as! TableCell
        }
        
        let post = appDelegate.posts![indexPath.row]
        cell.titleLabel.text = post.title
        cell.dateLabel.text = post.dateStr("MMM d, YYYY")
        cell.tableCellImage.image = post.thumbnail
        cell.tableCellImage.layer.cornerRadius = cell.tableCellImage.frame.size.height/2
        cell.tableCellImage.layer.masksToBounds = true
        cell.imageBorder.layer.cornerRadius = cell.imageBorder.frame.size.height/2
        cell.imageBorder.layer.masksToBounds = true
        return cell
    }
    
    @IBAction func startEditing(sender: UIBarButtonItem){
        if tableView.editing{
            tableView.setEditing(false, animated: false)
            editButtonItem().style = UIBarButtonItemStyle.Plain
            editButtonItem().title = "Edit"
        }
        else{
            tableView.setEditing(true, animated: true)
            editButtonItem().style = .Done
            editButtonItem().title = "Done"
        }
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        if self.editing == false{
            return UITableViewCellEditingStyle.None
        }
        if self.editing && indexPath.row == appDelegate.posts!.count {
            return UITableViewCellEditingStyle.Insert
        }
        else{
            return UITableViewCellEditingStyle.Delete
        }
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete{
            appDelegate.posts?.removeAtIndex(indexPath.row)
            self.startEditing(editButtonItem())
            tableView.reloadData()
        }
    }
    
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        let itemToMove = appDelegate.posts![sourceIndexPath.row]
        appDelegate.posts?.removeAtIndex(sourceIndexPath.row)
        appDelegate.posts?.insert(itemToMove, atIndex: destinationIndexPath.row)
    }

}

extension TimelineViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.dragging) {
                isMoreDataLoading = true
                postCount += 5
                //                loadPosts()
                isMoreDataLoading = false
            }
        }
    }
}
