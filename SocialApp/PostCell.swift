//
//  PostCell.swift
//  SocialApp
//
//  Created by Geoffrey on 9/6/17.
//  Copyright © 2017 Geoffrey. All rights reserved.
//

import UIKit

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
        
        func configureCell(post : Post)
        {
                self.post = post
                self.caption.text = post.caption
                likesLabel.text = String(post.likes)
        }
        
}





















