//
//  CanvasViewController.swift
//  MyStory
//
//  Created by Jessica Choi on 7/11/16.
//  Copyright © 2016 Jessica Choi. All rights reserved.
//

import UIKit
import Photos
import SwiftHSVColorPicker

class CanvasViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var trayOriginalCenter: CGPoint!
    var trayUpOffset: CGFloat!
    var trayViewUpOffset: CGFloat!
    var trayUp: CGPoint!
    var trayDown: CGPoint!
    var trayViewUp: CGPoint!
    var trayViewDown: CGPoint!
    var newlyCreatedImage: UIImageView!
    var newlyCreatedImageOriginalCenter: CGPoint!
    var photos: [UIImage]?
    var shapes: [UIImage]?
    var alignment: Int = 0
    var trayIsUp: Bool = false
    var postTitle: String?
    var caption: String?
    var date: NSDate?
    var tags: [String]?
    var shapeColor: UIColor = UIColor.grayColor()
    var tcolor: UIColor = UIColor.blackColor()
    var colorPickerOpen: Bool = false
    var thumbnailPic: UIImage?
    var selectButton: UIButton!
    var cancelButton: UIButton!
    var backButton : UIBarButtonItem!
    
    let colorPicker = SwiftHSVColorPicker(frame: CGRectMake(10, 70, 300, 400))
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    @IBOutlet weak var cornerButton: UIButton!
    @IBOutlet weak var postView: UIView!
    @IBOutlet weak var photoScroll: UICollectionView!
    @IBOutlet weak var trayView: UIView!
    @IBOutlet weak var pictureView: UIView!
    @IBOutlet weak var dateView: UILabel!
    @IBOutlet weak var titleView: UITextView!
    @IBOutlet weak var shapeView: UICollectionView!
    @IBOutlet weak var captionView: UITextView!
    @IBOutlet weak var textFormatView: UIView!
    @IBOutlet weak var shapePickerView: UIView!
    @IBOutlet weak var previewView: UIImageView!
    @IBOutlet weak var preView: UIView!
    @IBOutlet weak var tabTrayView: UIView!
    @IBOutlet weak var arrowImage: UIImageView!
    @IBOutlet weak var layerView: UIView!
    @IBOutlet weak var textView: UIView!
    @IBOutlet weak var textColorButton: UIButton!
    @IBOutlet weak var shapeColorButton: UIButton!
    @IBOutlet weak var backgroundButtonView: UIView!
    @IBOutlet weak var colorPickerView: UIView!
    @IBOutlet weak var tagsField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.interactivePopGestureRecognizer!.enabled = false
        
        // Custom back button
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.backButton = UIBarButtonItem(title: "< Back", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(CanvasViewController.goBack))
        self.navigationItem.leftBarButtonItem = backButton
        
        cornerButton.setBackgroundImage(UIImage.init(named: "preview"), forState: UIControlState.Normal)
        self.hideKeyboardWhenTappedAround()
        colorPickerView.hidden = true
        preView.hidden = true
        
        let square = UIImage.init(named: "square")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        let rounded = UIImage.init(named: "rounded")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        let triangle = UIImage.init(named: "triangle")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        let heart = UIImage.init(named: "heart")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        let circle = UIImage.init(named: "circle")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        let star = UIImage.init(named: "star")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        let rectangle = UIImage.init(named: "rectangle")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        let rounded_rect = UIImage.init(named: "rounded-rect")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        let sun = UIImage.init(named: "sun")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        let moon = UIImage.init(named: "moon")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        let bubble = UIImage.init(named: "bubble")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        
        pictureView.hidden = false
        shapePickerView.hidden = true
        textFormatView.hidden = true
        layerView.hidden = true
        
        shapeColorButton.tintColor = shapeColor
        shapes = [square, rounded, rectangle, rounded_rect, circle, triangle, heart, star, sun, moon, bubble]
        
        trayUpOffset = 60
        trayViewUpOffset = 20
        trayDown = tabTrayView.center
        trayViewDown = trayView.center
        trayUp = CGPoint(x: tabTrayView.center.x, y: tabTrayView.center.y - trayUpOffset)
        trayViewUp = CGPoint(x: trayView.center.x, y: trayView.center.y - trayViewUpOffset)
        
        photoScroll.dataSource = self
        photoScroll.delegate = self
        shapeView.dataSource = self
        shapeView.delegate = self
        
        titleView.autocorrectionType = .No
        titleView.text = postTitle
        captionView.autocorrectionType = .No
        captionView.text = caption
        
        dateView.text = dateStr("MMMM d, YYYY")
        
        let recognizer = UIPanGestureRecognizer(target: self, action: #selector(CanvasViewController.didPanImage(_:)))
        recognizer.delegate = self
        self.photoScroll.addGestureRecognizer(recognizer)
        
        let recognizer2 = UIPanGestureRecognizer(target: self, action: #selector(CanvasViewController.didPanShape(_:)))
        recognizer2.delegate = self
        self.shapeView.addGestureRecognizer(recognizer2)
        
        let recognizer3 = UITapGestureRecognizer(target: self, action: #selector(CanvasViewController.didTapTray(_:)))
        self.tabTrayView.addGestureRecognizer(recognizer3)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidDisappear(animated: Bool) {
        if self.navigationController?.viewControllers.indexOf(self) == NSNotFound{
            print("pls")
        }
        super.viewDidDisappear(animated)
    }
    
    func goBack() {
        let refreshAlert = UIAlertController(title: "Go Back", message: "Are you sure you want to go back? Your edits will not be saved.", preferredStyle: UIAlertControllerStyle.Alert)
        
        refreshAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action: UIAlertAction!) in
            self.navigationController?.popViewControllerAnimated(true)
            self.navigationController?.interactivePopGestureRecognizer!.enabled = true
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action: UIAlertAction!) in
            
        }))
        presentViewController(refreshAlert, animated: true, completion: nil)
        
        }
    
    @IBAction func openColorPallet(sender: AnyObject) {
        cornerButton.hidden = true
        self.navigationItem.leftBarButtonItem?.enabled = false
        if colorPickerOpen == false {
            colorPickerView.hidden = false
            postView.bringSubviewToFront(colorPickerView)
            selectButton = UIButton(frame: CGRect(x: 100, y: 500, width: 25, height: 25))
            selectButton.setImage(UIImage.init(named: "check2"), forState: .Normal)
            selectButton.addTarget(self, action: #selector(selectColor), forControlEvents: .TouchUpInside)
            
            cancelButton = UIButton(frame: CGRect(x: 250, y: 500, width: 20, height: 20))
            cancelButton.setImage(UIImage.init(named: "cancel"), forState: .Normal)
            cancelButton.addTarget(self, action: #selector(cancelColorPicker), forControlEvents: .TouchUpInside)
            self.view.addSubview(colorPicker)
            self.view.addSubview(selectButton)
            self.view.addSubview(cancelButton)
            colorPicker.backgroundColor = UIColor.whiteColor()
            colorPicker.center.x = self.view.superview!.center.x
            selectButton.superview!.bringSubviewToFront(selectButton)
            colorPickerOpen = true
            if colorPicker.color == nil{
                colorPicker.setViewColor(UIColor.grayColor())
            } else{
                colorPicker.setViewColor(colorPicker.color)
            }
        }
    }
    
    func cancelColorPicker(sender: UIButton!) {
        colorPicker.removeFromSuperview()
        colorPickerOpen = false
        colorPickerView.superview!.sendSubviewToBack(colorPickerView)
        colorPickerView.hidden = true
        cancelButton.hidden = true
        selectButton.hidden = true
        cornerButton.hidden = false
        self.navigationItem.leftBarButtonItem?.enabled = true
    }
    
    func selectColor(sender: UIButton!) {
        if colorPicker.color != nil{
            if shapePickerView.hidden == false {
                shapeColor = colorPicker.color
                shapeColorButton.tintColor = shapeColor

            } else if textFormatView.hidden == false {
                tcolor = colorPicker.color
                titleView.textColor = tcolor
                captionView.textColor = tcolor
                dateView.textColor = tcolor
                textColorButton.setTitleColor(tcolor, forState: UIControlState.Normal)
                textColorButton.setTitleColor(tcolor, forState: UIControlState.Highlighted)
            } else if layerView.hidden == false {
                backgroundButtonView.backgroundColor = colorPicker.color
                postView.backgroundColor = colorPicker.color
            }
        }
        
        colorPicker.removeFromSuperview()
        colorPickerOpen = false
        colorPickerView.hidden = true
        cancelButton.hidden = true
        selectButton.hidden = true
        cornerButton.hidden = false
        self.navigationItem.leftBarButtonItem?.enabled = true
        shapeView.reloadData()
    }
    
    @IBAction func createPost(sender: AnyObject) {

        if preView.hidden == false {
            let createPostAlert = UIAlertController(title: "Save Post", message: "Are you sure you are done editing this post?", preferredStyle: UIAlertControllerStyle.Alert)
            createPostAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: {(action: UIAlertAction!) in
                self.preView.hidden = true
                self.postView.hidden = false
                self.trayView.hidden = true
                self.tabTrayView.hidden = true
                self.navigationController?.navigationBar.hidden = true
                let postImage = self.captureView()
                
                if self.thumbnailPic != nil{
                    self.thumbnailPic = self.resize(self.thumbnailPic!, newSize: CGSize(width: 200.0, height: 200.0))
                } else{
                    self.thumbnailPic = self.resize(self.photos![0], newSize: CGSize(width: 200.0, height: 200.0))
                }
                
                if let tagsStr = self.tagsField.text as String? {
                    self.tags = tagsStr.componentsSeparatedByString(",")
                }
                
                if self.photos!.count != 0 {
                    if self.postTitle != nil && self.caption != nil {
                        let newPost = Post.init(photo: postImage, title: self.titleView.text, caption: self.captionView.text, date: self.date, tags: self.tags, thumbnail: self.thumbnailPic, alignment: self.alignment)
                        self.appDelegate.posts?.insert(newPost!, atIndex: 0)
                        self.appDelegate.sortArray()
                    }
                }
                self.dismissViewControllerAnimated(true, completion: nil)
            }))
            
            createPostAlert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action: UIAlertAction!) in
            }))
            
            self.presentViewController(createPostAlert, animated: true, completion: nil)
        } else {
            cornerButton.setBackgroundImage(UIImage.init(named: "check"), forState: UIControlState.Normal)
            trayView.hidden = true
            tabTrayView.hidden = true
            previewView.image = captureView()
            postView.hidden = true
            self.navigationItem.leftBarButtonItem?.enabled = false
            preView.hidden = false
        }

    }
    
    @IBAction func alignLeft(sender: AnyObject) {
        captionView.textAlignment = NSTextAlignment.Left
        alignment = 0
    }
    
    @IBAction func alignCenter(sender: AnyObject) {
        captionView.textAlignment = NSTextAlignment.Center
        alignment = 1
    }
    
    @IBAction func alignRight(sender: AnyObject) {
        captionView.textAlignment = NSTextAlignment.Right
        alignment = 2
    }
    
    func newAssetSize(asset: PHAsset) -> CGSize {
        if(asset.pixelWidth > 1080) {
            let scale = asset.pixelWidth/1080
            return CGSize(width: 1080, height: asset.pixelHeight/scale)
        }
        return CGSize(width: asset.pixelWidth, height: asset.pixelHeight)
    }
    
    func getAssetThumbnail(asset: PHAsset) -> UIImage {
        let manager = PHImageManager.defaultManager()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        option.synchronous = true
        manager.requestImageForAsset(asset, targetSize: CGSize(width: 600.0, height: 600.0), contentMode: .AspectFit, options: option, resultHandler: {(result, info)->Void in
            thumbnail = result!
        })
        return thumbnail
    }
    
    func captureView() -> UIImage {
        self.dismissKeyboard()
        let rect = postView.bounds as CGRect
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()! as CGContextRef
        postView.layer.renderInContext(context)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
    
    @IBAction func onPhotos(sender: AnyObject) {
        pictureView.hidden = false
        textFormatView.hidden = true
        shapePickerView.hidden = true
        layerView.hidden = true
        dismissTray()
    }
    
    @IBAction func onLayers(sender: AnyObject) {
        layerView.hidden = false
        textFormatView.hidden = true
        shapePickerView.hidden = true
        pictureView.hidden = true
        dismissTray()
    }
    
    @IBAction func onText(sender: AnyObject) {
        textFormatView.hidden = false
        layerView.hidden = true
        shapePickerView.hidden = true
        pictureView.hidden = true
        dismissTray()
    }
    
    @IBAction func onShapes(sender: AnyObject) {
        layerView.hidden = true
        textFormatView.hidden = true
        shapePickerView.hidden = false
        pictureView.hidden = true
        dismissTray()
    }
    
    @IBAction func chooseThumbnail(sender: AnyObject) {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        vc.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        self.presentViewController(vc, animated: true, completion: nil)
        
        
    }
    
    
    func imagePickerController(picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        // Get the image captured by the UIImagePickerController
        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        thumbnailPic = editedImage
        // Dismiss UIImagePickerController to go back to your original view controller
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}


// COLLECTION VIEW STUFF
extension CanvasViewController: UICollectionViewDataSource{
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == photoScroll {
            return photos?.count ?? 0
        } else if collectionView == shapeView {
            return shapes!.count ?? 0
        }
        
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if collectionView == photoScroll {
            let cell = photoScroll.dequeueReusableCellWithReuseIdentifier("CollectionCell", forIndexPath: indexPath) as! CollectionCell
            let photo = photos![indexPath.row] as UIImage
            cell.cellImage.contentMode = .ScaleAspectFill
            cell.cellImage.image = photo
            return cell
            
        } else {
            let cell = shapeView.dequeueReusableCellWithReuseIdentifier("ShapeCell", forIndexPath: indexPath) as! ShapeCell
            cell.shape.image = shapes![indexPath.row]
            
            if shapeColor != UIColor.grayColor() {
                cell.shape.tintColor = shapeColor
            }
            else{
                cell.shape.tintColor = UIColor.grayColor()
            }
            return cell
        }
    }
    
    @IBAction func onExit(sender: AnyObject) {
        cornerButton.setBackgroundImage(UIImage.init(named: "preview"), forState: UIControlState.Normal)
        trayView.hidden = false
        tabTrayView.hidden = false
        postView.hidden = false
        preView.hidden = true
        self.navigationItem.leftBarButtonItem?.enabled = true
    }
}


extension CanvasViewController: UICollectionViewDelegate{}

extension CanvasViewController: UIGestureRecognizerDelegate{
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer.isKindOfClass(UIPanGestureRecognizer) {
            let panGestureRecognizer = gestureRecognizer as! UIPanGestureRecognizer
            
            if pictureView.hidden == false {
                let velocity = panGestureRecognizer.velocityInView(photoScroll)
                if gestureRecognizer == photoScroll.panGestureRecognizer {
                    return fabs(velocity.y) < fabs(velocity.x)
                } else {
                    return fabs(velocity.y) > fabs(velocity.x)
                }
            } else if shapePickerView.hidden == false {
                let velocity = panGestureRecognizer.velocityInView(shapeView)
                if gestureRecognizer == shapeView.panGestureRecognizer {
                    return fabs(velocity.y) < fabs(velocity.x)
                } else {
                    return fabs(velocity.y) > fabs(velocity.x)
                }
            }
        }
        return true
    }
    
    func didPanShape(recognizer: UIPanGestureRecognizer){
        let translation = recognizer.translationInView(trayView)
        let panLocation = recognizer.locationInView(self.shapeView)
        
        if let pannedIndexPath = shapeView.indexPathForItemAtPoint(panLocation) {
            if let pannedCell = self.shapeView.cellForItemAtIndexPath(pannedIndexPath) as? ShapeCell {
                let cellShape = pannedCell.shape as UIImageView
                
                if recognizer.state == UIGestureRecognizerState.Began {
                    newlyCreatedImage = UIImageView(image: cellShape.image)
                    newlyCreatedImage.frame = CGRectMake(0, 0, 150, 150)
                    newlyCreatedImage.center = cellShape.superview!.center
                    newlyCreatedImage.tintColor = shapeColor
                    
                    let pinch = UIPinchGestureRecognizer(target: self, action: #selector(CanvasViewController.didPinchShape(_:)))
                    pinch.delegate = self
                    newlyCreatedImage.addGestureRecognizer(pinch)
                    
                    let rotate = UIRotationGestureRecognizer(target: self, action: #selector(CanvasViewController.didRotateShape(_:)))
                    rotate.delegate = self
                    newlyCreatedImage.addGestureRecognizer(rotate)
                    
                    let tap = UITapGestureRecognizer(target: self, action: #selector(CanvasViewController.didTapImage(_:)))
                    
                    self.newlyCreatedImage.addGestureRecognizer(tap)
                    
                    postView.addSubview(newlyCreatedImage)
                    
                    newlyCreatedImage.center.x = 100 + cellShape.center.x + CGFloat(pannedIndexPath.row) * cellShape.frame.size.width - shapeView.contentOffset.x
                    newlyCreatedImage.center.y += trayView.frame.origin.y
                    newlyCreatedImageOriginalCenter = newlyCreatedImage.center
                    
                    UIView.animateWithDuration(0.4, delay: 0.0, options: [], animations: {
                        self.newlyCreatedImage.transform = CGAffineTransformMakeScale(1.0, 1.0)
                        }, completion: nil)
                    
                    let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(CanvasViewController.onCustomPanShape(_:)))
                    newlyCreatedImage.userInteractionEnabled = true
                    newlyCreatedImage.addGestureRecognizer(panGestureRecognizer)
                } else if recognizer.state == UIGestureRecognizerState.Changed {
                    newlyCreatedImage.center = CGPoint(x: newlyCreatedImageOriginalCenter.x + translation.x, y: newlyCreatedImageOriginalCenter.y + translation.y)
                } else if recognizer.state == UIGestureRecognizerState.Ended {
                    
                }
                
                postView.bringSubviewToFront(trayView)
                postView.bringSubviewToFront(tabTrayView)
            }
        }
    }
    
    func didPanImage(recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translationInView(trayView)
        let panLocation = recognizer.locationInView(self.photoScroll)
        
        if let pannedIndexPath = photoScroll.indexPathForItemAtPoint(panLocation) {
            if let pannedCell = self.photoScroll.cellForItemAtIndexPath(pannedIndexPath) as? CollectionCell {
                let cellImage = pannedCell.cellImage as UIImageView
                
                if recognizer.state == UIGestureRecognizerState.Began {
                    newlyCreatedImage = UIImageView(image: cellImage.image)
                    
                    var width = newlyCreatedImage.image!.size.width
                    var height = newlyCreatedImage.image!.size.height
                    var scale = CGFloat(1)
                    
                    if width > height {
                        if width > 150 {
                            scale = width/CGFloat(150)
                            width = 150
                        }
                        height = height/CGFloat(scale)
                    } else {
                        if height > 150 {
                            scale = height/CGFloat(150)
                            height = 150
                        }
                        width = width/CGFloat(scale)
                    }
                    
                    newlyCreatedImage.frame = CGRectMake(0, 0, width, height)
                    newlyCreatedImage.center = cellImage.superview!.center
                    
                    let pinch = UIPinchGestureRecognizer(target: self, action: #selector(CanvasViewController.didPinch(_:)))
                    pinch.delegate = self
                    newlyCreatedImage.addGestureRecognizer(pinch)
                    
                    let rotate = UIRotationGestureRecognizer(target: self, action: #selector(CanvasViewController.didRotate(_:)))
                    rotate.delegate = self
                    newlyCreatedImage.addGestureRecognizer(rotate)
                    
                    let tap = UITapGestureRecognizer(target: self, action: #selector(CanvasViewController.didTapImage(_:)))
                    
                    self.newlyCreatedImage.addGestureRecognizer(tap)
                    
                    postView.addSubview(newlyCreatedImage)
                    
                    newlyCreatedImage.center.x = cellImage.center.x + CGFloat(pannedIndexPath.row) * cellImage.frame.size.width - photoScroll.contentOffset.x
                    newlyCreatedImage.center.y += trayView.frame.origin.y
                    newlyCreatedImageOriginalCenter = newlyCreatedImage.center
                    
                    UIView.animateWithDuration(0.4, delay: 0.0, options: [], animations: {
                        self.newlyCreatedImage.transform = CGAffineTransformMakeScale(1.0, 1.0)
                        }, completion: nil)
                    
                    let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(CanvasViewController.onCustomPanImage(_:)))
                    newlyCreatedImage.userInteractionEnabled = true
                    newlyCreatedImage.addGestureRecognizer(panGestureRecognizer)
                } else if recognizer.state == UIGestureRecognizerState.Changed {
                    newlyCreatedImage.center = CGPoint(x: newlyCreatedImageOriginalCenter.x + translation.x, y: newlyCreatedImageOriginalCenter.y + translation.y)
                } else if recognizer.state == UIGestureRecognizerState.Ended {
                    
                }
                
                postView.bringSubviewToFront(trayView)
                postView.bringSubviewToFront(tabTrayView)
            }
        }
    }
    
    // ALL OF THE CANVAS FUNCTIONALITIES
    
    func dismissTray() {
        if trayIsUp {
            UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: [], animations: {
                self.tabTrayView.center = self.trayDown
                }, completion: { (Bool) -> Void in
            })
            UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: [], animations: {
                self.trayView.center = self.trayViewDown
                }, completion: { (Bool) -> Void in
            })
            arrowImage.image = UIImage.init(named: "uparrow")
            trayIsUp = false
        }
    }
    
    func didTapImage(recognizer: UITapGestureRecognizer){
        if recognizer.state == .Began{
            newlyCreatedImage = recognizer.view as! UIImageView
        }
        if recognizer.state == .Ended{
            newlyCreatedImage = recognizer.view as! UIImageView
        }
    }
    
    func didTapTray(sender: UITapGestureRecognizer) {
        if sender.state == UIGestureRecognizerState.Ended {
            if trayIsUp {
                UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: [], animations: {
                    self.tabTrayView.center = self.trayDown
                    }, completion: { (Bool) -> Void in
                })
                UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: [], animations: {
                    self.trayView.center = self.trayViewDown
                    }, completion: { (Bool) -> Void in
                })
                arrowImage.image = UIImage.init(named: "uparrow")
                trayIsUp = false
            } else {
                UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: [], animations: {
                    self.tabTrayView.center = self.trayUp
                    }, completion:  {(Bool) -> Void in
                })
                UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: [], animations: {
                    self.trayView.center = self.trayViewUp
                    }, completion:  {(Bool) -> Void in
                })
                arrowImage.image = UIImage.init(named: "downarrow")
                trayIsUp = true
            }
        }
    }
    
    func resize(image: UIImage, newSize: CGSize) -> UIImage {
        let resizeImageView = UIImageView(frame: CGRectMake(0, 0, newSize.width, newSize.height))
        resizeImageView.contentMode = UIViewContentMode.ScaleAspectFill
        resizeImageView.image = image
        
        UIGraphicsBeginImageContext(resizeImageView.frame.size)
        resizeImageView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    func didPinch(sender: UIPinchGestureRecognizer) {
        let scale = sender.scale
        newlyCreatedImage = sender.view as! UIImageView
        if sender.state == UIGestureRecognizerState.Changed {
            newlyCreatedImage.transform = CGAffineTransformScale(newlyCreatedImage.transform, scale, scale)
            sender.scale = 1
        }
    }
    
    func didRotate(sender: UIRotationGestureRecognizer){
        let rotation = sender.rotation
        newlyCreatedImage = sender.view as! UIImageView
        if sender.state == UIGestureRecognizerState.Changed {
            newlyCreatedImage.transform = CGAffineTransformRotate(newlyCreatedImage.transform, rotation)
            sender.rotation = 0
        }
    }
    
    func didPinchShape(sender: UIPinchGestureRecognizer) {
        let scale = sender.scale
        newlyCreatedImage = sender.view as! UIImageView
        if sender.state == UIGestureRecognizerState.Changed {
            newlyCreatedImage.transform = CGAffineTransformScale(newlyCreatedImage.transform, scale, scale)
            sender.scale = 1
        }
    }
    
    func didRotateShape(sender: UIRotationGestureRecognizer){
        let rotation = sender.rotation
        newlyCreatedImage = sender.view as! UIImageView
        if sender.state == UIGestureRecognizerState.Changed {
            newlyCreatedImage.transform = CGAffineTransformRotate(newlyCreatedImage.transform, rotation)
            sender.rotation = 0
        }
    }
    
    func onCustomPanImage(sender: UIPanGestureRecognizer){
        let translation = sender.translationInView(view)
        if sender.state == UIGestureRecognizerState.Began {
            newlyCreatedImage = sender.view as! UIImageView
            newlyCreatedImageOriginalCenter = newlyCreatedImage.center
        } else if sender.state == UIGestureRecognizerState.Changed {
            newlyCreatedImage.center = CGPoint(x: newlyCreatedImageOriginalCenter.x + translation.x, y: newlyCreatedImageOriginalCenter.y + translation.y)
        }
    }
    
    func onCustomPanShape(sender: UIPanGestureRecognizer){
        let translation = sender.translationInView(view)
        if sender.state == UIGestureRecognizerState.Began {
            newlyCreatedImage = sender.view as! UIImageView
            newlyCreatedImageOriginalCenter = newlyCreatedImage.center
        } else if sender.state == UIGestureRecognizerState.Changed {
            newlyCreatedImage.center = CGPoint(x: newlyCreatedImageOriginalCenter.x + translation.x, y: newlyCreatedImageOriginalCenter.y + translation.y)
        }
    }
    
    @IBAction func onBringToFront(sender: AnyObject) {
        if newlyCreatedImage != nil{
            newlyCreatedImage.superview!.bringSubviewToFront(newlyCreatedImage)
        }
    }
    
    @IBAction func onSendToBack(sender: AnyObject) {
        if newlyCreatedImage != nil{
            newlyCreatedImage.superview!.sendSubviewToBack(newlyCreatedImage)
        }
    }
    
    @IBAction func onRemoveImage(sender: AnyObject) {
        if self.newlyCreatedImage != nil {
            let refreshAlert = UIAlertController(title: "Remove Image", message: "Are you sure you want to remove this image?", preferredStyle: UIAlertControllerStyle.Alert)
            
            refreshAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action: UIAlertAction!) in
                self.newlyCreatedImage.removeFromSuperview()
                self.newlyCreatedImage = nil
            }))
            
            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action: UIAlertAction!) in
                
            }))
            presentViewController(refreshAlert, animated: true, completion: nil)
        }
    }
    
    func dateStr(format: String) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = format
        let dateString = dateFormatter.stringFromDate(date!)
        return dateString
    }
}

