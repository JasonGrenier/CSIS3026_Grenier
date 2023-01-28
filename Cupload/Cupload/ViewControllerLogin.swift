//
//  ViewController.swift
//  Cupload
//
//  Created by Jason Grenier on 1/19/23.
//

import UIKit
import SwiftKeychainWrapper

extension ViewControllerLogin {

    func hideKeyBoard(){
        // Declare a Tap Gesture Recognizer which will dismiss keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissMyKeyboard))
        // Add tap gesture to view
        view.addGestureRecognizer(tap)
    }
    @objc func dismissMyKeyboard(){
    // Dismiss the active keyboard.
    view.endEditing(true)
    }
    // This collects the data that needs to be stored locally, and is passed to the Main Tab View Controller
    // MARK: Work on response catching here
    func collectUserData(){
        // Data must be read in from the main thread
        DispatchQueue.main.async {
            let URL_COLLECT_USER_DATA = "http://localhost:8888/CuploadServer/cupload_send_user_data_process.php?username=" + self.usernameInputBase.text!;
            var request = URLRequest(url: URL(string: URL_COLLECT_USER_DATA)!)
            request.httpMethod = "POST"
            //request.httpBody = try? JSONSerialization.data(withJSONObject: userInput, options: [])
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            //print(request);
            let session = URLSession.shared
            DispatchQueue.main.async {
                let task = session.dataTask(with: request, completionHandler: { [self] data, response, error -> Void in
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                        print(json)
                        // Enable pop up if user data is not validated
                        if(json["errorCode"]) as! Int == 1{
                            DispatchQueue.main.async{
                                self.showErrorDialog(errorMessage: json["errorMessage"] as! String)
                            }
                            
                        } else {
                            DispatchQueue.main.async {
                                // ID
                                KeychainWrapper.standard.set(json["id"] as! String, forKey: "ID")
                                // Username
                                KeychainWrapper.standard.set(json["user_name"] as! String, forKey: "ID")
                                // Firstname
                                KeychainWrapper.standard.set(json["first_name"] as! String, forKey: "firstName")
                                // Lastname
                                KeychainWrapper.standard.set(json["last_name"] as! String, forKey: "lastName")
                                // Phone number
                                KeychainWrapper.standard.set(json["phone_number"] as! String, forKey: "phoneNumber")
                                // Token
                            }
                        }
                    } catch {
                        print("error")
                    }
                })
                task.resume()
            }
        }
        
    }

}


class ViewControllerLogin: UIViewController {
    // Initialization of storyboard elements
    let URL_LOGIN = "http://localhost:8888/CuploadServer/cupload_login_process.php"
    
    func showErrorDialog(errorMessage: String) {
        //Creating UIAlertController and
        //Setting title and message for the alert dialog
        let errorAlertController = UIAlertController(title: "Alert", message: errorMessage, preferredStyle: .alert)
        
        // Cancel button to release the alert controller from the screen
        let releaseAction = UIAlertAction(title: "OK", style: .cancel){
            (_) in
        }
        
        errorAlertController.addAction(releaseAction)
        
        // Presenting the dialog box within the main thread
        DispatchQueue.main.async {
            self.present(errorAlertController, animated: true, completion: nil)
        }
        
    }
    
    
    @IBOutlet weak var usernameInputBase: UITextField!
    
    @IBOutlet weak var passwordInputBase: UITextField!
    
    
    @IBAction func loginButtonBase(_ sender: Any) {
        print("Login Button was pressed")
        // Client side validation
        if(usernameInputBase.text!.count < 4 || passwordInputBase.text!.count < 4){
            var errorMessage = "";
            if(usernameInputBase.text!.count < 4){
                errorMessage += "Invalid username\n"
            }
            if(passwordInputBase.text!.count < 8){
                errorMessage += "Invalid password"
            }
            
            showErrorDialog(errorMessage: errorMessage)
            // Server side validation
        } else {
            let URL_LOGIN_PARAMETERS = URL_LOGIN + "?username=" +
            usernameInputBase.text! + "&password=" +
            passwordInputBase.text!;
            var request = URLRequest(url: URL(string: URL_LOGIN_PARAMETERS)!)
            request.httpMethod = "POST"
            //request.httpBody = try? JSONSerialization.data(withJSONObject: userInput, options: [])
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            print(request);
            let session = URLSession.shared
            DispatchQueue.main.async {
                let task = session.dataTask(with: request, completionHandler: { [self] data, response, error -> Void in
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                        // Enable pop up if user data is not validated
                        if(json["errorCode"]) as! Int == 1{
                            DispatchQueue.main.async{
                                self.showErrorDialog(errorMessage: json["errorMessage"] as! String)
                            }
                            
                        } else {
                            // Establish user information
                            collectUserData()
                            // Show Home Tab View Controller
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            DispatchQueue.main.async{
                                // User defualts are used for storing data locally
                                UserDefaults.standard.set(self.usernameInputBase.text, forKey: "username")
                                let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabViewController")
                                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
                            }
                        }
                    } catch {
                        print("error")
                    }
                })
                task.resume()
            }
            
        }
    }
    
    @IBAction func signupButtonBase(_ sender: UIButton) {
        // Changes view to RegisterScreen via Storyboard
        print("Signup button was pressed")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewControllerRegister = storyboard.instantiateViewController(identifier: "ViewControllerRegister")
        DispatchQueue.main.async{
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(viewControllerRegister)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("View loaded")
        hideKeyBoard()
        /* if(KeychainWrapper.standard.string(forKey: "username") == ""){
         print("User is logged out")
         
         } else {
         print("User is logged in")
         DispatchQueue.main.async{
         let storyboard = UIStoryboard(name: "Main", bundle: nil)
         let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabViewController")
         (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
         }
         }
         */
    }
}
