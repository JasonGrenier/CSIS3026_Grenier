//
//  ViewControllerRegister.swift
//  Cupload
//
//  Created by Jason Grenier on 1/22/23.
//

import UIKit
import SwiftKeychainWrapper

extension ViewControllerRegister {

    func hideKeyBoard(){
        // Declare a Tap Gesture Recognizer which will dismiss keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissMyKeyboard))
        // Add tap gesture to view
        view.addGestureRecognizer(tap)
    }
    @objc func dismissMyKeyboard(){
    // Dismiss the active keyboard
    view.endEditing(true)
    }
    
    // This collects the data that needs to be stored locally
    func collectUserData(){
        // Data must be read in from the main thread
        DispatchQueue.main.async {
            let URL_COLLECT_USER_DATA = "http://localhost:8888/CuploadServer/cupload_send_user_data_process.php?username=" + self.usernameRegister.text!;
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
                                KeychainWrapper.standard.set(json["user_name"] as! String, forKey: "username")
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

class ViewControllerRegister: UIViewController {
    
    let URL_REGISTER = "http://localhost:8888/CuploadServer/cupload_register_process.php"
    // Connected outlets from View Controller Register on storyboard
    @IBOutlet weak var firstNameRegister: UITextField!
    @IBOutlet weak var phoneNumberRegister: UITextField!
    @IBOutlet weak var lastNameRegister: UITextField!
    @IBOutlet weak var usernameRegister: UITextField!
    @IBOutlet weak var passwordRegister: UITextField!
    
    @IBOutlet weak var confirmPasswordRegister: UITextField!
    
    @IBAction func backButtonRegister(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewControllerLogin = storyboard.instantiateViewController(identifier: "ViewControllerLogin")
        DispatchQueue.main.async{
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(viewControllerLogin)
        }
    }
    
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
    
    @IBAction func signupButtonRegister(_ sender: UIButton) {
        //var homePageValidity = 0;
        var errorMessage = "";
        //print(firstNameRegister.text!.count)
        //print(lastNameRegister.text!.count)
        if(firstNameRegister.text!.count < 2){
            errorMessage += "Invalid first name\n";
        }
        if(lastNameRegister.text!.count < 2){
            errorMessage += "Invalid last name\n";
        }
        if(usernameRegister.text!.count < 4){
            errorMessage += "Invalid username\n";
        }
        if(passwordRegister.text!.count < 8){
            errorMessage += "Invalid password\n";
        }
        if(phoneNumberRegister.text!.count < 7){
            errorMessage += "Invalid phone number";
        }
        if(errorMessage.count > 0){
            showErrorDialog(errorMessage: errorMessage)
        } else {
            let URL_REGISTER_PARAMETERS = URL_REGISTER + "?firstName=" + firstNameRegister.text! +
            "&lastName=" + lastNameRegister.text! +
            "&username=" + usernameRegister.text! +
            "&password=" + passwordRegister.text! +
            "&phoneNumber=" + phoneNumberRegister.text!
            
            //print(URL_REGISTER_PARAMETERS)
            var request = URLRequest(url: URL(string: URL_REGISTER_PARAMETERS)!)
            request.httpMethod = "POST"
            //request.httpBody = try? JSONSerialization.data(withJSONObject: userInput, options: [])
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            //print(request);
            let session = URLSession.shared
            DispatchQueue.main.async {
                let task = session.dataTask(with: request, completionHandler: { [self] data, response, error -> Void in
                    //print(response!)
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                        // Enable pop up
                        if(json["errorCode"]) as! Int == 1{
                            DispatchQueue.main.async{
                                self.showErrorDialog(errorMessage: json["errorMessage"] as! String)
                            }
                        } else {
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            collectUserData()
                                let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabViewController")
                            DispatchQueue.main.async{
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
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        hideKeyBoard()
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


