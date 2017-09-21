//
//  FeedVC.swift
//  SocialApp
//
//  Created by Geoffrey on 8/29/17.
//  Copyright © 2017 Geoffrey. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
            @IBOutlet weak var tableView : UITableView!
            @IBOutlet weak var imageAdd: UIImageView!
            @IBOutlet weak var postField: UITextField!
            
            
            var posts = [Post]()
            var imagePicker : UIImagePickerController!
            static var imageCache : NSCache<NSString, UIImage> = NSCache()
            var imageSelected = false
            
            override func viewDidLoad()
            {
                        super.viewDidLoad()
                        
                        tableView.delegate = self
                        tableView.dataSource = self
                        
                        imagePicker = UIImagePickerController()
                        imagePicker.allowsEditing = true
                        imagePicker.delegate = self
                        
                        Dataservice.ds.REF_POSTS.observe(.value, with : { (snapshot) in
                                    if let snapshot = snapshot.children.allObjects as? [DataSnapshot]
                                    {
                                                for snap in snapshot
                                                {
                                                            print("Snap \(snap)")
                                                            
                                                            if let postDict = snap.value as? Dictionary<String, Any>
                                                            {
                                                                        let key = snap.key
                                                                        let post = Post(postKey: key, postData: postDict)
                                                                        self.posts.append(post)
                                                            }
                                                }
                                    }
                                    self.tableView.reloadData()
                        })
            }
            
            func numberOfSections(in tableView: UITableView) -> Int
            {
                        return 1
            }
            
            func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
            {
                        return posts.count
            }
            
            func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
            {
                        let post = posts[indexPath.row]
                        
                        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell
                        {
                                    if let img = FeedVC.imageCache.object(forKey: post.imageURL as NSString)
                                    {
                                                cell.configureCell(post: post, img: img)
                                                
                                                return cell
                                    }
                                    else
                                    {
                                                cell.configureCell(post: post)
                                                return cell
                                    }
                        }
                        else
                        {
                                    return PostCell()
                        }
            }
            
            func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
            {
                        if let image = info[UIImagePickerControllerEditedImage] as? UIImage
                        {
                                    imageAdd.image = image
                                    imageSelected = true
                        }
                        else
                        {
                                    print("No image selected")
                        }
                        
                        imagePicker.dismiss(animated: true, completion: nil)
            }
            
            @IBAction func signOutTapped(_ sender: Any)
            {
                        let keychainResult = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
                        print("Removed ID From Keychain \(keychainResult)")
                        try! Auth.auth().signOut()
                        performSegue(withIdentifier: "backToSignIn", sender: nil)
            }
            
            @IBAction func addImageTapped(_ sender: Any)
            {
                        present(imagePicker, animated: true, completion: nil)
            }
            
            func postToFirebase (imgURL : String)
            {
                        let post : Dictionary<String, Any> =
                        [
                                    "caption" : postField.text!,
                                    "imageUrl" : imgURL,
                                    "likes" : 0
                        ]
                        
                        let firebasePost = Dataservice.ds.REF_POSTS.childByAutoId()
                        firebasePost.setValue(post)
                        
                        postField.text = ""
                        imageSelected = false
                        imageAdd.image = UIImage(named : "add-image")
                        
                        tableView.reloadData()
            }
            
            @IBAction func postButtonTapped(_ sender: Any)
            {
                        guard let caption = postField.text, caption != "" else
                        {
                                    print("caption must be entered")
                                    
                                    return
                        }
                        
                        guard let img = imageAdd.image, imageSelected == true else
                        {
                                    print("image must be selected")
                                    
                                    return
                        }
                        
                        if let imgData = UIImageJPEGRepresentation(img, 0.2)
                        {
                                    let imgUID = NSUUID().uuidString
                                    let metaData = StorageMetadata()
                                    metaData.contentType = "image/jpeg"
                                    
                                    Dataservice.ds.REF_POST_IMAGES.child(imgUID).putData(imgData, metadata: metaData) { (metaData, error) in
                                                if error != nil
                                                {
                                                            print("unable to upload imag to storage")
                                                }
                                                else
                                                {
                                                            print("sucessfully loaded image to firebase storage")
                                                            let downloadURL = metaData?.downloadURL()?.absoluteString
                                                            if let url = downloadURL
                                                            {
                                                                        self.postToFirebase(imgURL: url)
                                                            }
                                                            
                                                            self.imageSelected = false
                                                }
                                    }
                        }
                        
            }
}




























