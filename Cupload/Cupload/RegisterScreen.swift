//
//  RegisterScreen.swift
//  Cupload
//
//  Created by Jason Grenier on 1/21/23.
//
import Alamofire
import SwiftUI

class RegisterScreen: UIViewController{
    
    @IBOutlet var firstNameRegister: UITextField!
    @IBOutlet var lastNameRegister: UITextField!
    @IBOutlet var emailRegister: UITextField!
    @IBOutlet var usernameRegister: UITextField!
    @IBOutlet var passwordRegister: UITextField!
    
    
    @IBAction func signupButtonRegister(_ sender: UIButton) {
        print(firstNameRegister.text ?? "Error")
        print(lastNameRegister.text ?? "Error")
        print(emailRegister.text ?? "Error")
        print(usernameRegister.text ?? "Error")
        print(passwordRegister.text ?? "Error")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
}
