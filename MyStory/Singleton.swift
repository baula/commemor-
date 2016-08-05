//
//  Singleton.swift
//  MyStory
//
//  Created by Jessica Choi on 7/19/16.
//  Copyright © 2016 Jessica Choi. All rights reserved.
//

import UIKit

class Singleton: NSObject {
    private let persistencyManager : PersistencyManager

    class var sharedInstance : Singleton{
        struct Static{
            static let instance = Singleton()
        }
        return Static.instance
    }
    override init() {
        persistencyManager = PersistencyManager()
        super.init()
    }
    
    func getPosts() -> [Post]{
        return persistencyManager.getPosts()
    }
    
    func addPost(post: Post, index: Int){
        persistencyManager.addPost(post, index: index)
    }
    
    func deletePostAtIndex(index: Int){
        persistencyManager.deletePostAtIndex(index)
        
    }

}