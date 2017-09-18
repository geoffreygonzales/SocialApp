//
//  PostCell.swift
//  SocialApp
//
//  Created by Geoffrey on 9/6/17.
//  Copyright © 2017 Geoffrey. All rights reserved.
//

import UIKit
import Firebase

class PostCell: UITableViewCell
{
        @IBOutlet weak var profileImage : UIImageView!
        @IBOutlet weak var userNameLabel : UILabel!
        @IBOutlet weak var postImage : UIImageView!
        @IBOutlet weak var caption : UITextView!
        @IBOutlet weak var likesLabel : UILabel!
        
        var post : Post!
        
        override func awakeFromNib()
        {
                super.awakeFromNib()
        }
        
        func configureCell(post : Post, img : UIImage? = nil)
        {
                self.post = post
                self.caption.text = post.caption
                likesLabel.text = String(post.likes)
                
                if img != nil
                {
                        self.postImage.image = img
                }
                        else
                        {
                                let ref = Storage.storage().reference(forURL : post.imageURL)
                                
                                ref.getData(maxSize: 2 * 1024 * 1024, completion: { (data, error) in
                                        if error != nil
                                        {
                                                print("Unable to download image from Firebase Sotrage")
                                        }
                                        else
                                        {
                                                print("Image Sucessfully downloaded form FIrebase Storage")
                                                if let imageData = data
                                                {
                                                        if let img = UIImage(data: imageData)
                                                        {
                                                                self.postImage.image = img
                                                                FeedVC.imageCache.setObject(img, forKey : post.imageURL as NSString)
                                                        }
                                                }
                                        }
                                })
                        }
}









}











