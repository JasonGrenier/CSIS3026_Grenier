//
//  ViewControllerSettings.swift
//  Cupload
//
//  Created by Jason Grenier on 1/29/23.
//

import SwiftKeychainWrapper
import UIKit

class ViewControllerSettings: UIViewController {

    
    
    @IBAction func logoutButtonSettings(_ sender: UIButton) {
        print("Logout button was pressed")
            // ID
            KeychainWrapper.standard.set("", forKey: "username")
            // Username
            KeychainWrapper.standard.set("", forKey: "ID")
            // Firstname
            KeychainWrapper.standard.set("", forKey: "firstName")
            // Lastname
            KeychainWrapper.standard.set("", forKey: "lastName")
            // Phone number
            KeychainWrapper.standard.set("", forKey: "phoneNumber")
            // Token
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewControllerLogin = storyboard.instantiateViewController(identifier: "ViewControllerLogin")
        DispatchQueue.main.async{
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(viewControllerLogin)
        }
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
