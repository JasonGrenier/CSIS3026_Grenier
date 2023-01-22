//
//  ViewController.swift
//  Cupload
//
//  Created by Jason Grenier on 1/19/23.
//

import Alamofire
import UIKit



class ViewControllerLogin: UIViewController {
    // Initialization of storyboard elements
    let URL_LOGIN = "https://localhost:8888/CuploadServer/cupload_login_process.php"
    
    @IBOutlet weak var cuploadLogoBase: UIImageView!
    @IBOutlet weak var cuploadTitleBase: UITextView!
    @IBOutlet weak var cuploadBioBase: UITextView!
    @IBOutlet weak var usernameInputBase: UITextField!
    @IBOutlet weak var passwordInputBase: UITextField!
    @IBAction func loginButtonBase(_ sender: UIButton) {
        let URL_LOGIN_PARAMETERS = URL_LOGIN + "?username=" + usernameInputBase.text! +
        "&password=" + passwordInputBase.text!;
        
        var request = URLRequest(url: URL(string: URL_LOGIN_PARAMETERS)!)
        request.httpMethod = "POST"
        //request.httpBody = try? JSONSerialization.data(withJSONObject: userInput, options: [])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        //print(request);
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            //print(response!)
            do {
                let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                print(json)
            } catch {
                print("error")
            }
        })

        task.resume()
    }
    
    @IBAction func signupButtonBase(_ sender: UIButton) {
        //change view to RegisterScreen
        print("Signup button was pressed")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("View loaded")
        
    }

}


