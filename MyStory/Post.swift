//
//  Post.swift
//  MyStory
//
//  Created by Jessica Choi on 7/7/16.
//  Copyright © 2016 Jessica Choi. All rights reserved.
//

import UIKit

struct PropertyKey {
    static let dateKey = "date"
    static let photoKey = "photo"
    static let titleKey = "title"
    static let captionKey = "caption"
    static let tagsKey = "tags"
    static let thumbnailKey = "thumbnail"
    static let alignmentKey = "alignment"
}

class Post: NSObject, NSCoding {
    
    var date: NSDate?
    var title: String?
    var photo: UIImage?
    var caption: String?
    var tags: [String]?
    var thumbnail: UIImage?
    var alignment: Int?
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("posts")
    
    init?(photo: UIImage?, title: String?, caption: String?, date: NSDate?, tags: [String]?, thumbnail: UIImage?, alignment: Int) {
        self.date = date
        self.photo = photo
        self.title = title
        self.caption = caption
        self.tags = tags
        self.thumbnail = thumbnail
        self.alignment = alignment
        
        super.init()
    }
    
    
    deinit{
        self.date = nil
        self.title = nil
        self.caption = nil
        self.photo = nil
        self.tags = nil
        self.thumbnail = nil
        self.alignment = 0
    }

    func encodeWithCoder(aCoder: NSCoder){
        aCoder.encodeObject(date, forKey: PropertyKey.dateKey)
        aCoder.encodeObject(photo, forKey: PropertyKey.photoKey)
        aCoder.encodeObject(caption, forKey: PropertyKey.captionKey)
        aCoder.encodeObject(title, forKey: PropertyKey.titleKey)
        aCoder.encodeObject(tags, forKey: PropertyKey.tagsKey)
        aCoder.encodeObject(thumbnail, forKey: PropertyKey.thumbnailKey)
        aCoder.encodeObject(alignment, forKey: PropertyKey.alignmentKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let date = aDecoder.decodeObjectForKey(PropertyKey.dateKey) as? NSDate
        let photo = aDecoder.decodeObjectForKey(PropertyKey.photoKey) as? UIImage
        let title = aDecoder.decodeObjectForKey(PropertyKey.titleKey) as! String
        let caption = aDecoder.decodeObjectForKey(PropertyKey.captionKey) as! String
        let tags = aDecoder.decodeObjectForKey(PropertyKey.tagsKey) as? [String]
        let thumbnail = aDecoder.decodeObjectForKey(PropertyKey.thumbnailKey) as? UIImage
        let alignment = aDecoder.decodeObjectForKey(PropertyKey.alignmentKey) as? Int ?? 0
        
        self.init(photo: photo, title: title, caption: caption, date: date, tags: tags, thumbnail: thumbnail, alignment: alignment)
    }
    
    func dateStr(format: String) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = format
        let dateString = dateFormatter.stringFromDate(date!)
        return dateString
    }
}