//
//  SlideshowViewController.swift
//  MyStory
//
//  Created by Baula Xu on 7/28/16.
//  Copyright © 2016 Jessica Choi. All rights reserved.
//

import UIKit

class SlideshowViewController: UIViewController,UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var slidePosts: [Post] = []
    var frame: CGRect = CGRectMake(0, 0, 0, 0)
    var pageControl : UIPageControl = UIPageControl(frame: CGRectMake(90, 590, 200, 50))
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        slidePosts = appDelegate.posts!
        configurePageControl()
        
        scrollView.delegate = self
        for index in 0..<slidePosts.count{
            
            frame.origin.x = self.scrollView.frame.size.width * CGFloat(index)
            frame.size = self.scrollView.frame.size
            self.scrollView.pagingEnabled = true
            let subView = UIImageView(frame: frame)
            subView.image = slidePosts[index].photo
            self.scrollView.addSubview(subView)
        }
        
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * CGFloat(slidePosts.count), self.scrollView.frame.size.height)
        pageControl.addTarget(self, action: #selector(SlideshowViewController.changePage(_:)), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    
    func configurePageControl() {
        
        self.pageControl.numberOfPages = slidePosts.count
        self.pageControl.currentPage = 0
        self.pageControl.pageIndicatorTintColor = UIColor.grayColor()
        self.pageControl.currentPageIndicatorTintColor = UIColor.blackColor()
        self.view.addSubview(pageControl)
        
    }
    
    // MARK : TO CHANGE WHILE CLICKING ON PAGE CONTROL
    func changePage(sender: AnyObject) -> () {
        let x = CGFloat(pageControl.currentPage) * scrollView.frame.size.width
        scrollView.setContentOffset(CGPointMake(x, 0), animated: true)
    }
    
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func onExit(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
