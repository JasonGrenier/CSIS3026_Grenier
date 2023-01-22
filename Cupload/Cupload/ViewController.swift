//
//  ViewController.swift
//  Cupload
//
//  Created by Jason Grenier on 1/19/23.
//

import Alamofire
import UIKit



class ViewController: UIViewController {
    // Initialization of storyboard elements
    let URL_LOGIN = "localhost:8888/CuploadServer/cupload_login_process"
    
    
    
    
    @IBOutlet weak var cuploadLogoBase: UIImageView!
    @IBOutlet weak var cuploadTitleBase: UITextView!
    @IBOutlet weak var cuploadBioBase: UITextView!
    
    @IBOutlet weak var usernameInputBase: UITextField!
    
    @IBOutlet weak var passwordInputBase: UITextField!
    
    @IBAction func loginButtonBase(_ sender: UIButton) {
        print("Login Button pressed")
        print(usernameInputBase.text ?? "")
        print(passwordInputBase.text ?? "")
    }
    
    @IBAction func signupButtonBase(_ sender: UIButton) {
        //change view to RegisterScreen
        print("Signup button was pressed")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("This ran")
    }

}

