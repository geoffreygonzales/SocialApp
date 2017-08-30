//
//  ViewController.swift
//  SocialApp
//
//  Created by Geoffrey on 8/22/17.
//  Copyright © 2017 Geoffrey. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FBSDKCoreKit
import FBSDKLoginKit
import SwiftKeychainWrapper

class SignInVC : UIViewController, UITextFieldDelegate
{

        @IBOutlet var mainView: UIView!
        @IBOutlet weak var emailField: UITextField!
        @IBOutlet weak var passwordField: UITextField!
        @IBOutlet weak var loginButton: UIButton!
 
        
        override func viewDidLoad()
        {
                super.viewDidLoad()
                
                emailField.delegate = self
                passwordField.delegate = self

                // Width
                let screenWidth = UIScreen.main.bounds.width
//                let fieldAndButtonWidth = screenWidth * 0.7
                let fieldAndButtonWidth = screenWidth * 0.8

                emailField.frame.size.width = fieldAndButtonWidth
                passwordField.frame.size.width = fieldAndButtonWidth
                loginButton.frame.size.width = fieldAndButtonWidth
                
                // Height
                let screenHeight = UIScreen.main.bounds.height
//                let fieldAndButtonHeight = screenHeight * 0.0598
                let fieldAndButtonHeight = screenHeight * 0.07
                emailField.frame.size.height = fieldAndButtonHeight
                passwordField.frame.size.height = fieldAndButtonHeight
                loginButton.frame.size.height = fieldAndButtonHeight
                
                // Origin Y
                let originY = screenHeight * 0.5757
                let inputSpace = (screenHeight * 0.0475) + emailField.frame.height
                emailField.frame.origin.y = originY
                passwordField.frame.origin.y = originY + inputSpace
                loginButton.frame.origin.y = originY + (inputSpace * 2)
                
                // Origin X
                let originX = (screenWidth / 2) - (emailField.frame.width / 2)
                emailField.frame.origin.x = originX
                passwordField.frame.origin.x = originX
                loginButton.frame.origin.x = originX
                
        }
        
        override func viewDidAppear(_ animated: Bool)
        {
                if let _ = KeychainWrapper.standard.string(forKey: KEY_UID)
                {
                        print("ID found in keychain")
                        performSegue(withIdentifier: "goToFeed", sender: nil)
                }
        }
        
        func firebaseAuth(_ credential : AuthCredential)
        {
                Auth.auth().signIn(with: credential) { (user, error) in
                        
                        if error != nil {
                                print("Euable to autheticate with Firebase")
                        } else {
                                print("Sucessfully authenicated with Firebase")
                                
                                if let user = user
                                {
                                        self.completeSignIn(id: user.uid)
                                }
                        }
                }
        }

        @IBAction func signInTapped(_ sender: Any)
        {
                if let email = emailField.text, let password = passwordField.text
                {
                        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                                
                                if error == nil
                                {
                                        print("Email User Aunthecatied with Firebase")
                                        
                                        if let user = user
                                        {
                                                self.completeSignIn(id: user.uid)
                                        }
                                        
                                }
                                else
                                {
                                        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                                                
                                                if error != nil
                                                {
                                                        print("Unable to Authentiate with Firebase using email")
                                                }
                                                else
                                                {
                                                        print("Sucessfully authentied with firebase email")
                                                        
                                                        if let user = user
                                                        {
                                                                self.completeSignIn(id: user.uid)
                                                        }
                                                }
                                        })
                                }
                        })
                }
        }
        
        func completeSignIn(id : String)
        {
                KeychainWrapper.standard.set(id, forKey: KEY_UID)
                print("Data saved to keychain")
                
                performSegue(withIdentifier: "goToFeed", sender: nil)
        }

        // Keyboard UI Stuff 
        
        func textFieldDidBeginEditing(_ emailField: UITextField)
        {
                print("Text Field Did Begin Editing")
                
                // Moving View Up
                let currentMainViewOriginY = mainView.frame.origin.y
                mainView.frame.origin.y = currentMainViewOriginY - 200
        }
        
//        func textFieldDidBeginEditing(passwordField textField: UITextField) {
//                print("Text Field Did Begin Editing")
//                
//                // Moving View Up
//                let currentMainViewOriginY = mainView.frame.origin.y
//                mainView.frame.origin.y = currentMainViewOriginY - 80
//        }
        
//        func textFieldDidEndEditing(emailField textField: UITextField) {
//                print("Text Field Did Begin Editing")
//                
//                let currentMainViewOriginY = mainView.frame.origin.y
//                mainView.frame.origin.y = currentMainViewOriginY + 50
//        }
        
        func textFieldDidEndEditing(_ textField: UITextField)
        {
                print("Text Field Did Begin Editing")
                
                let currentMainViewOriginY = mainView.frame.origin.y
                mainView.frame.origin.y = currentMainViewOriginY + 200
        }

        func textFieldShouldReturn(_ textField: UITextField) -> Bool
        {
                self.view.endEditing(true)
                print("Return Pressed")
                return true
        }
        
        
        
        
}
































