//
//  PostDetailViewController.swift
//  MyStory
//
//  Created by Jessica Choi on 7/7/16.
//  Copyright © 2016 Jessica Choi. All rights reserved.
//

import UIKit
import ActiveLabel
import MessageUI
import Social

class PostDetailViewController: UIViewController {

    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var tagsLabel: UILabel!
    @IBOutlet weak var postView: UIView!
    @IBOutlet weak var tagsScrollView: UIScrollView!

    
    var post : Post?
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailImageView.image = post?.photo
        tagsLabel.text = combineStrings(post!.tags)
        tagsScrollView.contentSize.width = tagsLabel.intrinsicContentSize().width
        tagsLabel.sizeToFit()
        self.navigationItem.title = "Post"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func combineStrings(array: [String]?) -> String{
        var newString = ""
        if array != nil {
            for item in array!{
                let trimmed = item.stringByTrimmingCharactersInSet(
                    NSCharacterSet.whitespaceAndNewlineCharacterSet())
                newString += "#\(trimmed)    "
            }
        }
        return newString
    }
    
    @IBAction func onSave(sender: AnyObject) {
        let titleAlertController = UIAlertController(title: "Photo Saved", message:
            "Photo successfully saved to camera roll.", preferredStyle: UIAlertControllerStyle.Alert)
        titleAlertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(titleAlertController, animated: true, completion: nil)
        UIImageWriteToSavedPhotosAlbum((post?.photo)!, nil, nil, nil);
    }
    
    func captureView() -> UIImage {
        let rect = postView.bounds as CGRect
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()! as CGContextRef
        postView.layer.renderInContext(context)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
    
    @IBAction func onDeleteButton(sender: AnyObject) {
        let deleteAlert = UIAlertController(title: "Remove Post", message: "Are you sure you want to remove this post? This cannot be undone.", preferredStyle: UIAlertControllerStyle.Alert)
        deleteAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: {(action: UIAlertAction!) in
            let index = self.indexOfPostWithTitle(self.post!) as Int
            self.appDelegate.posts!.removeAtIndex(index)
            self.navigationController?.popViewControllerAnimated(true)
        }))
        deleteAlert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action: UIAlertAction!) in
        }))
        self.presentViewController(deleteAlert, animated: true) {}
    }
    
    func indexOfPostWithTitle(post: Post) -> Int {
        var i = 0
        for cur in appDelegate.posts! {
            if cur.title == post.title {
                return i
            }
            i += 1
        }
        return -1
    }
    
    @IBAction func postTwitter(sender: AnyObject) {
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter){
            let twitterSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            twitterSheet.setInitialText("Made with Commemor∞")
            twitterSheet.addImage(detailImageView.image)
            
            self.presentViewController(twitterSheet, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Account", message: "Please login to a Twitter account to share.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }

    @IBAction func postFacebook(sender: AnyObject) {
            if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook){
                let facebookSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
                facebookSheet.setInitialText("Made with Commemor∞")
                facebookSheet.addImage(detailImageView.image)
                
                self.presentViewController(facebookSheet, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "Account", message: "Please login to a Facebook account to share.", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
}

extension PostDetailViewController: MFMailComposeViewControllerDelegate{
    func sendMail(image: UIImage) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setSubject("Check out this date in my life!")
            mail.setMessageBody("Made with Commemor∞", isHTML: false)
            let imageData: NSData = UIImagePNGRepresentation(image)!
            mail.addAttachmentData(imageData, mimeType: "image/png", fileName: "imageName")
            self.presentViewController(mail, animated: true, completion: nil)
        }
    }
    
    func mailComposeController(controller: MFMailComposeViewController,
                               didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func showSendMailErrorAlert(){
        let sendMailErrorAlert = UIAlertController(title: "Could not send email", message: "Your device could not send the email. Please check email configuration and try again.", preferredStyle: .Alert)
        sendMailErrorAlert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: {(action: UIAlertAction!) in}))
        self.presentViewController(sendMailErrorAlert, animated: true) {}
    }
    
    @IBAction func onEmailButton(sender: AnyObject) {
        sendMail(detailImageView.image!)
    }
    
}

extension PostDetailViewController: MFMessageComposeViewControllerDelegate{
    func sendMessage(image: UIImage){
        if MFMessageComposeViewController.canSendText(){
            let message = MFMessageComposeViewController()
            message.messageComposeDelegate = self
            message.body = "Made with Commemor∞"
            let imageData: NSData = UIImagePNGRepresentation(image)!
            message.addAttachmentData(imageData, typeIdentifier: "public.data", filename: "image.png")
            self.presentViewController(message, animated: true, completion: nil)
        }
    }
    
    func messageComposeViewController(controller: MFMessageComposeViewController, didFinishWithResult result: MessageComposeResult) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func onMessageButton(sender: AnyObject) {
        sendMessage(detailImageView.image!)
    }
    
}