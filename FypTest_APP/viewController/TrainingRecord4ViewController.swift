//
//  TrainingRecord4ViewController.swift
//  FypTest_APP


import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
class TrainingRecord4ViewController: UIViewController {

    @IBOutlet weak var TrainAmount: UILabel!
    @IBOutlet weak var TrainSetLabel: UILabel!
    
    var videosName = "Stand"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GetUserData()
    }
    
    func GetUserData(){
        let ref = Database.database().reference()
        let user = Auth.auth().currentUser
        if let user = user {
        ref.child("User_Train_Selection").child(user.uid).observeSingleEvent(of: .value, with: { snapshot in
          // Get user value
            let value = snapshot.value as? NSDictionary
           // let body = value?["Bodypart"] as? String ?? ""
            let TrainAmount = value?["TrainAmount"] as? String ?? ""
            let TrainsetAmount = value?["TrainSetAmount"] as? String ?? ""
            //show user selected session
            self.TrainSetLabel.text =  String(TrainsetAmount)
            self.TrainAmount.text = String(TrainAmount)
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
