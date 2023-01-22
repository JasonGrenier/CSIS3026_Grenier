//
//  ViewControllerRegister.swift
//  Cupload
//
//  Created by Jason Grenier on 1/22/23.
//

import Alamofire
import UIKit

class ViewControllerRegister: UIViewController {
    
    let URL_REGISTER = "http://localhost:8888/CuploadServer/cupload_register_process.php"
    
    @IBOutlet weak var firstNameRegister: UITextField!
    @IBOutlet weak var phoneNumberRegister: UITextField!
    @IBOutlet weak var lastNameRegister: UITextField!
    @IBOutlet weak var emailRegister: UITextField!
    @IBOutlet weak var usernameRegister: UITextField!
    @IBOutlet weak var passwordRegister: UITextField!
    @IBAction func signupButtonRegister(_ sender: UIButton) {

        let URL_REGISTER_PARAMETERS = URL_REGISTER + "?firstName=" + firstNameRegister.text! +
        "&lastName=" + lastNameRegister.text! +
        "&username=" + usernameRegister.text! +
        "&password=" + passwordRegister.text! +
        "&phoneNumber=" + phoneNumberRegister.text! +
        "&email=" + emailRegister.text!;
        
        var request = URLRequest(url: URL(string: URL_REGISTER_PARAMETERS)!)
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
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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

