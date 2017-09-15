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
        
        var posts = [Post]()
        var imagePicker : UIImagePickerController!
        
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
                        cell.configureCell(post: post)
                        return cell
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
}















