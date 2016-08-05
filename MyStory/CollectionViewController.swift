//
//  CollectionViewController.swift
//  MyStory
//
//  Created by Jessica Choi on 7/7/16.
//  Copyright © 2016 Jessica Choi. All rights reserved.
//

import UIKit
import Photos

class CollectionViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchCollectionView: UICollectionView!
    @IBOutlet weak var segControl: UISegmentedControl!
    
    var filteredPosts : [Post]?
    var isMoreDataLoading = false
    var postCount = 12
    var tap: UITapGestureRecognizer?
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        
        searchCollectionView.dataSource = self
        searchCollectionView.delegate = self
        self.searchBar.delegate = self
        self.navigationItem.titleView = searchBar
        searchBar.tintColor = UIColor.blueColor()
        
        let flow = searchCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flow.minimumInteritemSpacing = 1
        flow.minimumLineSpacing = 1
        
        self.filteredPosts = appDelegate.posts
    }
    
    override func viewWillAppear(animated: Bool) {
        let searchText = searchBar.text
        filterPosts(searchText!)
        searchCollectionView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let cell = sender as? CollectionCell {
            searchBar.resignFirstResponder()
            let indexPath = searchCollectionView.indexPathForCell(cell)
            let post = filteredPosts![indexPath!.row]
            
            if(segue.identifier == "DetailSegue") {
                let detailViewController = segue.destinationViewController as! PostDetailViewController
                detailViewController.hidesBottomBarWhenPushed = true
                detailViewController.post = post
            }
        }
    }

    override func dismissKeyboard() {
        print("tap")
        searchBar.resignFirstResponder()
        searchCollectionView.removeGestureRecognizer(tap!)
    }
}

extension CollectionViewController: UICollectionViewDelegate{

}

extension CollectionViewController: UICollectionViewDataSource{
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let filteredPosts = filteredPosts {
            return filteredPosts.count
        }
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = searchCollectionView.dequeueReusableCellWithReuseIdentifier("CollectionCell", forIndexPath: indexPath) as! CollectionCell
        let post = filteredPosts![indexPath.row]
        cell.cellDate.text = post.dateStr("MMM d, YYYY")
        if post.thumbnail != nil {
            cell.cellImage.image = post.thumbnail
        }
        return cell
    }


}

extension CollectionViewController: UIScrollViewDelegate{
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            let scrollViewContentHeight = searchCollectionView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - searchCollectionView.bounds.size.height
            
            if(scrollView.contentOffset.y > scrollOffsetThreshold && searchCollectionView.dragging) {
                isMoreDataLoading = true
                postCount += 5
                isMoreDataLoading = false
            }
        }
    }

}

extension CollectionViewController: UISearchBarDelegate{

    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        filterPosts(searchText)
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchCollectionView.addGestureRecognizer(tap!)
    }
    
    func filterPosts(searchText: String) {
        if searchText.isEmpty {
            filteredPosts = appDelegate.posts
        } else if segControl.selectedSegmentIndex == 0 {
            filteredPosts = appDelegate.posts!.filter({(post: Post) -> Bool in
                let dateFull = post.dateStr("MMMM d, YYYY")
                let dateShort = post.dateStr("MMM d, YYYY")
                
                if dateFull.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil || dateShort.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil {
                    return true
                } else {
                    return false
                }
            })
        } else if segControl.selectedSegmentIndex == 1 {
            filteredPosts = appDelegate.posts!.filter({(post: Post) -> Bool in
                let title = post.title! as String
                if title.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil
                {
                    return true
                } else {
                    return false
                }
            })
        } else if segControl.selectedSegmentIndex == 2 {
            filteredPosts = appDelegate.posts!.filter({(post: Post) -> Bool in
                var result = false
                let tags = post.tags! as [String]
                for tag in tags {
                    if tag.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil {
                        result = true
                    }
                }
                return result
            })
        }
        searchCollectionView.reloadData()
    }
    
    @IBAction func segChange(sender: AnyObject) {
        let searchText = searchBar.text
        filterPosts(searchText!)
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        filteredPosts = appDelegate.posts
        searchCollectionView.reloadData()
    }
}