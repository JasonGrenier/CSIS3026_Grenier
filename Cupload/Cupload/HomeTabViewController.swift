//
//  HomeTabViewController.swift
//  Cupload
//
//  Created by Jason Grenier on 1/24/23.
//

import UIKit

class HomeTabViewController: UIViewController {

    
    @IBOutlet weak var userNameLabelHome: UILabel!
    @IBOutlet weak var idLabelHome: UILabel!
    
    @IBOutlet weak var firstNameLabelHome: UILabel!
    
    @IBOutlet weak var lastNameLabelHome: UILabel!
    
    @IBOutlet weak var phoneNumberLabelHome: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userNameLabelHome.text = UserDefaults.standard.string(forKey: "username")
        idLabelHome.text = UserDefaults.standard.string(forKey: "ID")
        firstNameLabelHome.text = UserDefaults.standard.string(forKey: "firstName")
        lastNameLabelHome.text = UserDefaults.standard.string(forKey: "lastName")
        phoneNumberLabelHome.text = UserDefaults.standard.string(forKey: "phoneNumber")
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
