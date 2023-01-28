//
//  HomeTabViewController.swift
//  Cupload
//
//  Created by Jason Grenier on 1/24/23.
//

import UIKit
import SwiftKeychainWrapper

class HomeTabViewController: UIViewController {

    
    @IBOutlet weak var userNameLabelHome: UILabel!
    @IBOutlet weak var idLabelHome: UILabel!
    
    @IBOutlet weak var firstNameLabelHome: UILabel!
    
    @IBOutlet weak var lastNameLabelHome: UILabel!
    
    @IBOutlet weak var phoneNumberLabelHome: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        DispatchQueue.main.async{
            self.userNameLabelHome.text = KeychainWrapper.standard.string(forKey: "username")
            self.idLabelHome.text = KeychainWrapper.standard.string(forKey: "ID")
            self.firstNameLabelHome.text = KeychainWrapper.standard.string(forKey: "firstName")
            self.lastNameLabelHome.text = KeychainWrapper.standard.string(forKey: "lastName")
            self.phoneNumberLabelHome.text = KeychainWrapper.standard.string(forKey: "phoneNumber")
        }
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
