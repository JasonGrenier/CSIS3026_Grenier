//
//  ViewController.swift
//  Cupload
//
//  Created by Jason Grenier on 1/19/23.
//

import Alamofire
import UIKit



class Base: UIViewController {
    // Initialization of storyboard elements
    let URL_LOGIN = "localhost:8888/CuploadServer/cupload_login_process"
    @IBOutlet weak var cuploadLogoBase: UIImageView!
    @IBOutlet weak var cuploadTitleBase: UITextView!
    @IBOutlet weak var cuploadBioBase: UITextView!
    @IBOutlet weak var usernameInputBase: UITextField!
    @IBOutlet weak var passwordInputBase: UITextField!
    @IBAction func loginButtonBase(_ sender: UIButton){
        let userInput: Parameters=[
            "user_name": usernameInputBase.text!,
            "pass_word": passwordInputBase.text!
        ]
    }
    @IBOutlet weak var noAccountTextBase: UITextView!
    @IBAction func signupButtonBase(_ sender: UIButton){
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

