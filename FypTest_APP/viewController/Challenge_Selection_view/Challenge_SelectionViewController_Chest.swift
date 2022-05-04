//
//  Challenge_SelectionViewController_Chest.swift
//  FypTest_APP
//
//  Created by kin ming ching on 4/5/2022.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class Challenge_SelectionViewController_Chest: UIViewController {

    @IBOutlet weak var Time_limitLBL: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        GetUserData()
    }
    
    func GetUserData(){
        let ref = Database.database().reference()
        let user = Auth.auth().currentUser
        if let user = user {
            ref.child("User_Challenge_Selection").child(user.uid).observeSingleEvent(of: .value, with: { snapshot in
          // Get user value
            let value = snapshot.value as? NSDictionary
           // let body = value?["Bodypart"] as? String ?? ""
            let Time_MINUS = value?["Time_Limit_Text"] as? String ?? ""
            //show user selected session
            self.Time_limitLBL.text = Time_MINUS
        }) { error in
          print(error.localizedDescription)
        }
    }
    }

}
