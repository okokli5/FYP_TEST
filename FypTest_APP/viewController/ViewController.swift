//
//  ViewController.swift
//  FypTest_APP

import UIKit
import AVFoundation
import AudioToolbox
import Firebase
import FirebaseAuth

class ViewController: UIViewController {

    let videoCapture = VideoCapture()
    var previewLayer: AVCaptureVideoPreviewLayer?
    //user data and user train amount count
    public var User_ActionAmount: Int = 0
    public var User_TrainSetAmount: Int = 0
    var TrainSetCount: Int = 0
    var Actioncount: Int = 0
    var pointLayer = CAShapeLayer()
    //Duration
    //image icon
    @IBOutlet weak var IconImageView: UIImageView!
    private let iconImage: UIImageView = {
        let iconimage = UIImageView(frame: CGRect(x: 20, y: 64, width: 60, height: 60))
        iconimage.image = UIImage(named: "Icon_110_Biceps")
        return iconimage}()
    
    //background
    @IBOutlet weak var BackgroundLBL: UILabel!
    private let backgroundLBL: UILabel = {
        let Label = UILabel(frame: CGRect(x: 0, y: 0, width: 414, height: 136))
        Label.backgroundColor = UIColor(red: 81/255, green: 57/255, blue: 0/255, alpha: 0.65)
        Label.bounds.origin = CGPoint(x:0, y: 0)
        Label.textColor = UIColor.white
        return Label }()
    //TEXT Label
    @IBOutlet weak var TitleLBL: UILabel!
    private let titleLBL: UILabel = {
        let Label = UILabel(frame: CGRect(x: 78, y: 64, width: 122, height: 63))
        Label.text = "BICEPS\nTRAINING"
        Label.bounds.origin = CGPoint(x: 78, y:64)
        Label.numberOfLines = 2
        Label.font = UIFont.boldSystemFont(ofSize: Label.font.pointSize)
        Label.textColor = UIColor.white
        return Label }()
    
    @IBOutlet weak var SETSLBL: UILabel!
    private let SetSLBL: UILabel = {
        let Label = UILabel(frame: CGRect(x: 346, y: 14, width: 63, height: 39))
        Label.text = "SET"
        Label.bounds.origin = CGPoint(x: 346, y: 14)
        Label.textColor = UIColor.lightGray
        return Label }()
    
    @IBOutlet weak var REPSLBL: UILabel!
    private let RepSLBL: UILabel = {
        let Label = UILabel(frame: CGRect(x: 348, y: 89, width: 63, height: 39))
        Label.text = "REPS"
        Label.bounds.origin = CGPoint(x: 348, y: 89)
        Label.textColor = UIColor.lightGray
        return Label }()
    
    @IBOutlet weak var DurationTLBL: UILabel!
    private let durationsLBL: UILabel = {
        let Label = UILabel(frame: CGRect(x: 30, y: 11, width: 109, height: 21))
        Label.text = "DURATION"
        Label.bounds.origin = CGPoint(x: 30, y: 11)
        Label.textColor = UIColor.lightGray
        return Label }()
    //traing count
    @IBOutlet weak var TotalActionLBL: UILabel!
    private let totalLabel: UILabel = {
        let Label = UILabel(frame: CGRect(x: 305, y: 84, width: 63, height: 44))
        Label.bounds.origin = CGPoint(x: 305, y: 84)
        Label.textColor = UIColor.white
        return Label }()
    
    @IBOutlet weak var TrainSETLBL: UILabel!
    private let trainLabel: UILabel = {
        let Label = UILabel(frame: CGRect(x: 297, y: 61, width: 61, height: 44))
        Label.bounds.origin = CGPoint(x: 297, y: 61)
        Label.textColor = UIColor.white
        return Label }()
    
    @IBOutlet weak var TrainingCount: UILabel!
    private let trainingcLabel: UILabel = {
        let Label = UILabel(frame: CGRect(x: 252, y: 66, width: 68, height: 62))
        Label.text = "0"
        Label.bounds.origin = CGPoint(x: 252, y: 66)
        Label.font = Label.font.withSize(22)
        Label.textColor = UIColor.white
        return Label }()
    //time
    @IBOutlet weak var DurationLBL: UILabel!
    private let durationLabel: UILabel = {
        let Label = UILabel(frame: CGRect(x: 30, y: 30, width: 88, height: 24))
        Label.text = "08:00"
        Label.font = Label.font.withSize(20)
        Label.bounds.origin = CGPoint(x: 30, y: 30)
        Label.textColor = UIColor.white
        return Label }()
    
    var isThrowDetected = false
    


    
    override func viewDidLoad() {
        super.viewDidLoad()
        //get firebase data
        Read_Data()
        //setup camera
        setupVideoPreview()
        //pose detection
        videoCapture.predictor.delegate = self
        
    }
    func Read_Data(){
        let ref = Database.database().reference()
        let user = Auth.auth().currentUser
        if let user = user {
            ref.child("User_Train_Selection").child(user.uid).observeSingleEvent(of: .value, with: { snapshot in
          // Get user value
            let value = snapshot.value as? NSDictionary
            let actionamount = value?["TrainAmount"] as?  String ?? ""
            let TrainSetAmount = value?["TrainSetAmount"] as? String ?? ""

            let User_ActionAmount = Int(actionamount)
            let User_TrainSetAmount = Int(TrainSetAmount)
            self.TotalActionLBL.text = "/\(actionamount)"
            self.TrainingCount.text = "\(self.TrainSetCount)"
            self.TrainSETLBL.text = "\(self.TrainSetCount)/\(TrainSetAmount)"
          // ...
        }) { error in
          print(error.localizedDescription)
            }}
    }

    func toRecordPage(){
        let bicepsRecordViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.bicepsRecordViewController) as? BicepsRecordViewController
        self.view.window?.rootViewController = bicepsRecordViewController
        self.view.window?.makeKeyAndVisible()
    }
    
    func Check_amount(){
        //Set firebase var
        let ref = Database.database().reference()
        let user = Auth.auth().currentUser
        //check the user action equal the user amount setting
        if let user = user {
        if ((Actioncount == User_ActionAmount) && (TrainSetCount < User_TrainSetAmount)){
            TrainSetCount += 1
            Actioncount = 0
        }else if((Actioncount<User_ActionAmount)&&(TrainSetCount != User_TrainSetAmount)){
            Actioncount += 1
        }else if((Actioncount==User_ActionAmount)&&(TrainSetCount == User_TrainSetAmount)){
            //show alert
            
            
        }
        }
        
    }
    func showAlertF(){
        
    }
    
    //test function
    func Add_Amount(){
        Actioncount+=1
    }
    
    private func setupVideoPreview(){
        videoCapture.startCaptureSession()
        previewLayer = AVCaptureVideoPreviewLayer(session: videoCapture.captureSession)
        
        guard let previewLayer = previewLayer else {
            return }
        
        view.layer.addSublayer(previewLayer)
        previewLayer.frame = view.frame
        
        view.layer.addSublayer(pointLayer)
        pointLayer.frame = view.frame
        pointLayer.strokeColor = UIColor.green.cgColor
        
        view.addSubview(iconImage)
        view.addSubview(backgroundLBL)
        view.addSubview(titleLBL)
        view.addSubview(SetSLBL)
        view.addSubview(RepSLBL)
        view.addSubview(durationsLBL)
        view.addSubview(totalLabel)
        view.addSubview(trainLabel)
        view.addSubview(trainingcLabel)
        view.addSubview(durationLabel)
    }
}

extension ViewController: PredictorDelegte{
    func predictor(predictor: Predictor, didLableAction action: String, with confience: Double) {
        print("Detected: \(action),Confidence: \(confience)")
        if action == "Biceps" && confience > 0.70 && isThrowDetected == false{
            
            print("Throw detected")
            isThrowDetected = true

            DispatchQueue.main.asyncAfter(deadline: .now()+3){
                self.isThrowDetected = false
            }
            DispatchQueue.main.async {
                //upload label
               // self.Aclabel.text = String(self.Actioncount)
                self.TrainSETLBL.text = "\(self.TrainSetCount)/\(String(self.User_TrainSetAmount))"
                //when detected alert
                AudioServicesPlayAlertSound(SystemSoundID(1331))
                self.Check_amount()
            }
        }
    }
    
    func predictor(predictor: Predictor, didFindNewRecognizedPoints point: [CGPoint]) {
        guard let previewLayer = previewLayer else {return}
        
        let convertedPoint = point.map{
            previewLayer.layerPointConverted(fromCaptureDevicePoint: $0)
    }
        let combinedPath = CGMutablePath()
        for point in convertedPoint{
            let dotPath = UIBezierPath(ovalIn: CGRect(x: point.x, y: point.y, width:10 , height: 10))
            combinedPath.addPath(dotPath.cgPath)
        }
        
        pointLayer.path = combinedPath
        
        DispatchQueue.main.async {
            self.pointLayer.didChangeValue(for: \.path)
        }
    }
}

