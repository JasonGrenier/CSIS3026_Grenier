//
//  ViewControllerRegister.swift
//  Cupload
//
//  Created by Jason Grenier on 1/22/23.
//

import Alamofire
import UIKit

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

}

class ViewControllerRegister: UIViewController {
    
    let URL_REGISTER = "http://192.168.0.45:8888/CuploadServer/cupload_register_process.php"
    // Connected outlets from View Controller Register on storyboard
    @IBOutlet weak var firstNameRegister: UITextField!
    @IBOutlet weak var phoneNumberRegister: UITextField!
    @IBOutlet weak var lastNameRegister: UITextField!
    @IBOutlet weak var usernameRegister: UITextField!
    @IBOutlet weak var passwordRegister: UITextField!
    
    @IBOutlet weak var confirmPasswordRegister: UITextField!
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
        var errorMessage = "";
        print(firstNameRegister.text!.count)
        print(lastNameRegister.text!.count)
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
            
            print(URL_REGISTER_PARAMETERS)
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
                            showErrorDialog(errorMessage: json["errorMessage"] as! String)
                        } else {
                            DispatchQueue.main.async{
                                self.showErrorDialog(errorMessage: "User is now logged in.")
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


