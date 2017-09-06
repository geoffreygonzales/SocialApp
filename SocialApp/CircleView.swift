//
//  Circle.swift
//  SocialApp
//
//  Created by Geoffrey on 8/31/17.
//  Copyright © 2017 Geoffrey. All rights reserved.
//

import UIKit

class CircleView : UIImageView
{
        override func awakeFromNib()
        {
                super.awakeFromNib()

        }
        
        override func layoutSubviews()
        {
                super.layoutSubviews()
                
                layer.cornerRadius = self.frame.width / 2
        }
   

}
