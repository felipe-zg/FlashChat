//
//  RegisterViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import Firebase
import Toaster

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    @IBAction func registerPressed(_ sender: UIButton) {
        if let email = emailTextfield.text, let password = passwordTextfield.text {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    ToastView.appearance().backgroundColor = .red
                    ToastView.appearance().textColor = .white
                    ToastView.appearance().font = .boldSystemFont(ofSize: 14)
                    Toast(text: e.localizedDescription, delay: 0, duration: Delay.long).show()
                }else {
                    self.emailTextfield.text = ""
                    self.passwordTextfield.text = ""
                    self.performSegue(withIdentifier: K.Segues.registerSegue, sender: self)
                }
            }
        }
    }
    
}
