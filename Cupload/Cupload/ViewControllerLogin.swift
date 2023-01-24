//
//  ViewController.swift
//  Cupload
//
//  Created by Jason Grenier on 1/19/23.
//

import Alamofire
import UIKit

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

}


class ViewControllerLogin: UIViewController {
    // Initialization of storyboard elements
    let URL_LOGIN = "http://192.168.0.45:8888/CuploadServer/cupload_login_process.php"
    
    @IBOutlet weak var usernameInputBase: UITextField!
    @IBOutlet weak var passwordInputBase: UITextField!
    var homePageValidity = 0;
    
    
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
    
    @IBAction func loginButtonBase(_ sender: UIButton) {
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
            //print(request);
            let session = URLSession.shared
            DispatchQueue.main.async {
                let task = session.dataTask(with: request, completionHandler: { [self] data, response, error -> Void in
                    print(response ?? "RESPONSE ERROR")
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                        // Enable pop up if user data is not validated
                        if(json["errorCode"]) as! Int == 1{
                            showErrorDialog(errorMessage: json["errorMessage"] as! String)
                            homePageValidity = 1;
                        }
                    } catch {
                        print("error")
                    }
                })
                task.resume()
            }
            if(homePageValidity == 1){
                DispatchQueue.main.async{
                    self.showErrorDialog(errorMessage: "User is now logged in.")
                }
                
            }
        
        }
        
    }
    @IBAction func signupButtonBase(_ sender: UIButton) {
        // Changes view to RegisterScreen via Storyboard
        print("Signup button was pressed")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("View loaded")
        hideKeyBoard()
    }

}
