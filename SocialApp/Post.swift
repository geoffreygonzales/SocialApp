//
//  Post.swift
//  SocialApp
//
//  Created by Geoffrey on 9/13/17.
//  Copyright © 2017 Geoffrey. All rights reserved.
//

import Foundation
import Firebase

class Post
{
            private var _CAPTION : String!
            private var _IMAGEURL : String!
            private var _LIKES : Int!
            private var _POSTKEY : String!
            private var _POSTREF : DatabaseReference!
            
            var caption : String
            {
                        return _CAPTION
            }
            
            var imageURL : String
            {
                        return _IMAGEURL
            }
            
            var likes : Int
            {
                        return _LIKES
            }
            
            var postKey : String
            {
                        return _POSTKEY
            }
            
            init(caption : String, imageURL : String, likes : Int )
            {
                        self._CAPTION = caption
                        self._IMAGEURL = imageURL
                        self._LIKES = likes
            }
            
            init(postKey : String, postData : Dictionary<String, Any>)
            {
                        self._POSTKEY = postKey
                        
                        if let caption = postData["caption"] as? String
                        {
                                    self._CAPTION = caption
                        }
                        
                        if let imageUrl = postData["imageUrl"] as? String
                        {
                                    self._IMAGEURL = imageUrl
                        }
                        
                        if let likes = postData["likes"] as? Int
                        {
                                    self._LIKES = likes
                        }
                        
                        _POSTREF = Dataservice.ds.REF_POSTS.child(_POSTKEY)
            }
            
            func adjustLikes (addLike : Bool)
            {
                        if addLike
                        {
                                    _LIKES = _LIKES + 1
                        }
                        else
                        {
                                   _LIKES = _LIKES - 1
                        }
                        
                        _POSTREF.child("likes").setValue(_LIKES)
            }
            
}


















