//
//  TrainingSelectionViewController.swift
//  FypTest_APP
//
//  Created by kin ming ching on 15/1/2022.
//

import UIKit
import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore

class TrainingSelectionViewController: UIViewController {
    //var
    var BICEPS = false;
    var TRICEPS = false;
    var CHEST = false;
    var BACK = false;
    //var of program amount
    var trainSet = 0;
    var trainamount = 6;
    //btn outlet use to set stroke
    @IBOutlet var BicepsOutBtn: UIButton!
    @IBOutlet var TricepsOutBtn: UIButton!
    @IBOutlet var ChestOutBtn: UIButton!
    @IBOutlet var BackOutBtn: UIButton!
    //label amount
    
    @IBOutlet var SetAmountLabel: UILabel!
    @IBOutlet var TrainAmountLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SetAmountLabel.text = String(trainSet);
        TrainAmountLabel.text = String(trainamount);
    }
    
//Btn func
    @IBAction func BicepsBtn(_ sender: Any) {
        BICEPS = true;
        TRICEPS = false;
        CHEST = false;
        BACK = false;
        CheckBSelect()
    }
    @IBAction func TricepsBtn(_ sender: Any) {
        BICEPS = false;
        TRICEPS = true;
        CHEST = false;
        BACK = false;
        CheckBSelect()
    }
    @IBAction func ChestBtn(_ sender: Any) {
        BICEPS = false;
        TRICEPS = false;
        CHEST = true;
        BACK = false;
        CheckBSelect()
    }
    @IBAction func BackBtn(_ sender: Any) {
        BICEPS = false;
        TRICEPS = false;
        CHEST = false;
        BACK = true;
        CheckBSelect()
    }
    
    func CheckBSelect(){
        if (BICEPS == true){
            self.BicepsOutBtn.backgroundColor = UIColor(red: 95/255, green: 201/255, blue: 200/255, alpha: 0.5)
            self.TricepsOutBtn.backgroundColor = UIColor.white
            self.ChestOutBtn.backgroundColor = UIColor.white
            self.BackOutBtn.backgroundColor = UIColor.white
        }else if(TRICEPS == true){
            self.TricepsOutBtn.backgroundColor = UIColor(red: 95/255, green: 201/255, blue: 200/255, alpha: 0.5)
            self.BicepsOutBtn.backgroundColor = UIColor.white
            self.ChestOutBtn.backgroundColor = UIColor.white
            self.BackOutBtn.backgroundColor = UIColor.white
        }else if(CHEST == true){
            self.ChestOutBtn.backgroundColor = UIColor(red: 95/255, green: 201/255, blue: 200/255, alpha: 0.5)
            self.TricepsOutBtn.backgroundColor = UIColor.white
            self.BicepsOutBtn.backgroundColor = UIColor.white
            self.BackOutBtn.backgroundColor = UIColor.white
        }else if(BACK == true){
            self.BackOutBtn.backgroundColor = UIColor(red: 95/255, green: 201/255, blue: 200/255, alpha: 0.5)
            self.ChestOutBtn.backgroundColor = UIColor.white
            self.TricepsOutBtn.backgroundColor = UIColor.white
            self.BicepsOutBtn.backgroundColor = UIColor.white
        }
    }
    //show Alert
    func showAlertM(){
        let alert = UIAlertController(title: "amount can't < 0!!!!", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok!", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    func showAlertP(){
        let alert = UIAlertController(title: "amount can't > 6", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok!", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    func showAlertAP(){
        let alert = UIAlertController(title: "amount can't > 30", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok!", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    //Set btn
    @IBAction func minBtn(_ sender: Any) {
        if trainSet > 0{
            trainSet -= 1
            SetAmountLabel.text = String(trainSet)
        }else{
            showAlertM()
        }
    }
    
    @IBAction func trainsetplus(_ sender: Any) {
        if trainSet <= 5{
            trainSet+=1
            SetAmountLabel.text = String(trainSet)
        }else{
            showAlertP()
        }
    }
    //amount Btn
    @IBAction func amountminBtn(_ sender: Any) {
        if trainamount > 0{
            trainamount -= 1
            TrainAmountLabel.text = String(trainamount)
        }else{
            showAlertM()
        }
    }
    
    @IBAction func amountPlusBtn(_ sender: Any) {
        if trainamount <= 29{
            trainamount += 1
            TrainAmountLabel.text = String(trainamount)
        }else{
            showAlertAP()
        }
    }
    //to Selected body part page
    func toTrainBRecord(){
        let namestoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = namestoryboard.instantiateViewController(withIdentifier: "TR1") as! TrainingRecord1ViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    func toTrainTRecord(){
        let namestoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = namestoryboard.instantiateViewController(withIdentifier: "TR2") as! TrainingRecord2ViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    func toTrainCRecord(){
        let namestoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = namestoryboard.instantiateViewController(withIdentifier: "TR3") as! TrainingRecord3ViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    func toTrainBARecord(){
        let namestoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = namestoryboard.instantiateViewController(withIdentifier: "TR4") as! TrainingRecord4ViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func NextPageBtnOnTap(_ sender: Any) {
        //firebase setup
        let ref = Database.database().reference()
        
        if BICEPS == true{
            ref.child("Record").child("Record1").setValue(["BodyPart": "BICEPS" as NSString,"TrainSetAmount": SetAmountLabel.text!,"TrainAmount":TrainAmountLabel.text!])
            //TO next page
            toTrainBRecord()
        }else if TRICEPS == true{
            ref.child("Record").child("Record1").setValue(["BodyPart": "TRICEPS" as NSString,"TrainSetAmount": SetAmountLabel.text!,"TrainAmount":TrainAmountLabel.text!])
            //To next page
            toTrainTRecord()
        }else if CHEST == true{
            ref.child("Record").child("Record1").setValue(["BodyPart": "CHEST" as NSString,"TrainSetAmount": SetAmountLabel.text!,"TrainAmount":TrainAmountLabel.text!])
            //To next page
            toTrainCRecord()
        }else if BACK == true{
            ref.child("Record").child("Record1").setValue(["BodyPart": "BACK" as NSString,"TrainSetAmount": SetAmountLabel.text!,"TrainAmount":TrainAmountLabel.text!])
            //To next page
            toTrainBARecord()
        }
    }
}
