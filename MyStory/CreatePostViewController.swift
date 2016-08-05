//
//  CreatePostViewController.swift
//  MyStory
//
//  Created by Jessica Choi on 7/7/16.
//  Copyright © 2016 Jessica Choi. All rights reserved.
//

import UIKit
import BSImagePicker
import Photos
import MBProgressHUD

class CreatePostViewController: UIViewController{

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var titleFieldLabel: UILabel!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var captionField: UITextView!
    @IBOutlet weak var selectedPhotoScroll: UICollectionView!
    @IBOutlet weak var captionFieldBackground: UIView!
    @IBOutlet weak var doneTyping: UIButton!
    @IBOutlet weak var charCountLabel: UILabel!
    
    var collectionVC: CollectionViewController?
    var photos: [UIImage] = []
    var photosCounter: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        captionFieldBackground.layer.borderColor = UIColor.grayColor().CGColor
        captionFieldBackground.layer.borderWidth = 0.5
        charCountLabel.textColor = UIColor(white: 0.74, alpha: 1.0)
        
        captionField.text = "Enter a description... (max 200 characters)"
        captionField.textColor = UIColor.grayColor()
        captionField.textAlignment = NSTextAlignment.Left
        captionField.delegate = self
        selectedPhotoScroll.delegate = self
        selectedPhotoScroll.dataSource = self
        titleField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func textFieldDidBeginEditing(textField: UITextField) {
        doneTyping.hidden = false                   // show OK button when selected
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        doneTyping.hidden = true                    // hide OK button when done
    }
    
    
    func newAssetSize(asset: PHAsset) -> CGSize {
        if(asset.pixelWidth > 1080) {
            let scale = asset.pixelWidth/1080
            return CGSize(width: 1080, height: asset.pixelHeight/scale)
        }
        return CGSize(width: asset.pixelWidth, height: asset.pixelHeight)
    }
    
    @IBAction func photoLibrary(sender: AnyObject) {
        let vc = BSImagePickerViewController()
        vc.maxNumberOfSelections = 10
        photosCounter = 0
        bs_presentImagePickerController(vc, animated: true,
                select: { (asset: PHAsset) -> Void in
            self.photosCounter += 1
            }, deselect: { (asset: PHAsset) -> Void in
                self.photosCounter -= 1
            }, cancel: { (assets: [PHAsset]) -> Void in
                dispatch_async(dispatch_get_main_queue(), {
                    MBProgressHUD.hideHUDForView(self.view, animated: true)
                })
            }, finish: { (assets: [PHAsset]) -> Void in
                self.photos = []
                for asset in assets {
                    let image = self.getAssetThumbnail(asset)
                    self.photos.append(image)
                }
                dispatch_async(dispatch_get_main_queue(), {
                    self.selectedPhotoScroll.reloadData()
                    MBProgressHUD.hideHUDForView(self.view, animated: true)
                })
            }, completion:{() -> Void in
                MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            }
        )
    }
    
    func textViewDidChange(textView: UITextView) {
        let chars = 200 - captionField.text.characters.count
        charCountLabel.text = String(chars)
        if(chars < 11) {
            charCountLabel.textColor = UIColor.redColor()
        } else {
            charCountLabel.textColor = UIColor(white: 0.74, alpha: 1.0)
        }
        
    }

    func getAssetThumbnail(asset: PHAsset) -> UIImage {
        let manager = PHImageManager.defaultManager()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        option.synchronous = true
        manager.requestImageForAsset(asset, targetSize: newAssetSize(asset), contentMode: .AspectFit, options: option, resultHandler: {(result, info)->Void in
            thumbnail = result!
        })
        return thumbnail
    }
    
    @IBAction func cancelPost(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func onDoneTyping(sender: AnyObject) {
        dismissKeyboard()
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if captionField.text.characters.count > 200 {
            let characterAlert = UIAlertController(title: "Caption", message: "Character count exceeds 200!", preferredStyle: UIAlertControllerStyle.Alert)
            characterAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: {(action: UIAlertAction!) in
            }))
            self.presentViewController(characterAlert, animated: true, completion: nil)
            return false
        }
        return true
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(segue.identifier == "CanvasSegue") {
            if photos.count != 0 && photosCounter == photos.count{
                let postTitle = titleField.text
                var caption = captionField.text
                if caption == "Enter a description... (max 200 characters)" {
                   caption = ""
               }
                
                let date = datePicker.date
                if postTitle != "" {
                    let canvasViewController = segue.destinationViewController as! CanvasViewController
                    canvasViewController.photos = photos
                    canvasViewController.postTitle = postTitle
                    canvasViewController.caption = caption
                    canvasViewController.date = date
                }
                else{
                    let titleAlertController = UIAlertController(title: "No Title", message:
                        "Please name the post.", preferredStyle: UIAlertControllerStyle.Alert)
                    titleAlertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                    
                    self.presentViewController(titleAlertController, animated: true, completion: nil)
                }
                
            }
            else if photos.count != photosCounter{
                let alertController2 = UIAlertController(title: "Photos Not Loaded", message: "Please wait for all the photos to load.", preferredStyle: UIAlertControllerStyle.Alert)
                alertController2.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                
                self.presentViewController(alertController2, animated: true, completion: nil)
            }
            else{
                let alertController = UIAlertController(title: "Photos Not Selected", message:
                    "Please select at least one photo.", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        }
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UIViewController: UITextFieldDelegate{
    public func textFieldShouldReturn(textField: UITextField) -> Bool {
        for view in self.view.subviews as [UIView]{
            if let textField = view as? UITextField{
                textField.resignFirstResponder()
            }
        }
        return true
    }
}

extension CreatePostViewController: UITextViewDelegate{
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.text == "Enter a description... (max 200 characters)" {
            textView.text = ""
        }
        doneTyping.hidden = false
        textView.textColor = UIColor.blackColor()
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        doneTyping.hidden = true
        if textView.text == "" {
            textView.text = "Enter a description... (max 200 characters)"
            textView.textColor = UIColor.grayColor()
            
        }
    }
}

extension CreatePostViewController: UINavigationControllerDelegate{}

extension CreatePostViewController: UICollectionViewDelegate{}

extension CreatePostViewController: UICollectionViewDataSource{
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count ?? 0
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = selectedPhotoScroll.dequeueReusableCellWithReuseIdentifier("SelectedCell", forIndexPath: indexPath) as! SelectedCell
        let photo = photos[indexPath.row] as UIImage
        cell.cellImage.contentMode = .ScaleAspectFill
        cell.cellImage.image = photo
        return cell
        
    }
}