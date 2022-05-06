//
//  Challenge_SelectionViewController_Triceps.swift
//  FypTest_APP
//
//  Created by kin ming ching on 4/5/2022.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class Challenge_SelectionViewController_Triceps: UIViewController {
    
    @IBOutlet weak var Time_limitLBL: UILabel!
    
    var videosName = "Sit"
    
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
    
    // pass data to videoView
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? VideoViewController {
                
            destination.videoName = self.videosName
            
        }
    }
}
