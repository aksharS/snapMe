//
//  AuthViewController.swift
//  SnapMe
//
//  Created by Akshar Shrivats on 7/24/19.
//  Copyright © 2019 Akshar Shrivats. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class AuthViewController: UIViewController {
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var topButton: UIButton!
    @IBOutlet weak var bottomButton: UIButton!
    
    var loginMode = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func topTapped(_ sender: Any) {
        if let email = emailTextField.text {
            if let password = passwordTextField.text {
                if loginMode {
                    Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                        if error == nil {
                            print ("User Signed In")
                            self.performSegue(withIdentifier: "authSuccess", sender: nil)
                        } else {
                            print (error as Any)
                        }
                    }
                } else {
                    Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                        if error == nil {
                            if let uid = result?.user.uid{
                                Database.database().reference().child("users").child(uid).child("email").setValue(email)
                            }
                            print ("User Created")
                            self.performSegue(withIdentifier: "authSuccess", sender: nil)
                        } else {
                            print (error as Any)
                        }
                    }
                }
            }
        }
    }
    
    
    @IBAction func bottomTapped(_ sender: Any) {
        if loginMode {
            loginMode = false
            topButton.setTitle("Sign Up", for: .normal)
            bottomButton.setTitle("Login", for: .normal)
        } else {
            loginMode = true
            topButton.setTitle("Login", for: .normal)
            bottomButton.setTitle("Sign Up", for: .normal)
        }
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
