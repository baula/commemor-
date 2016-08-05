//
//  PersistencyManager.swift
//  MyStory
//
//  Created by Jessica Choi on 7/19/16.
//  Copyright © 2016 Jessica Choi. All rights reserved.
//

import UIKit

class PersistencyManager: NSObject {
    private var posts = [Post]()

    func getPosts() -> [Post]{
        return posts
    }
    
    func addPost(post: Post, index: Int){
        if (posts.count >= index){
            posts.insert(post, atIndex: index)
        }
        else{
            posts.append(post)
        }
    }
    
    func deletePostAtIndex(index: Int){
        posts.removeAtIndex(index)
    }
}
