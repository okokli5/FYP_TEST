//
//  ViewController.swift
//  FypTest_APP

import UIKit
import AVFoundation
import AudioToolbox
import Firebase
import FirebaseAuth

class SitTraining_ViewController: UIViewController {

    let sitTraining_videoCapture = SitTraining_VideoCapture()
    
    var previewLayer: AVCaptureVideoPreviewLayer?
    //user data and user train amount count
    public var User_ActionAmount: Int = 0
    public var User_TrainSetAmount: Int = 0
    var TrainSetCount: Int = 0
    var Actioncount: Int = 0
    var Accuracy_STR : String = ""
   
    var pointLayer = CAShapeLayer()
    //time
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = .current
        formatter.locale = .current
        formatter.dateFormat = "MM/dd/yyyy-HH:mm:a"
        return formatter
    }()
    let formatter2: DateFormatter = {
        let formatter2 = DateFormatter()
        formatter2.timeZone = .current
        formatter2.locale = .current
        formatter2.dateFormat = "MM-dd-yyyy-HH:mm:a"
        return formatter2
    }()
    //image icon
    private let iconImage: UIImageView = {
        let iconimage = UIImageView(frame: CGRect(x: 20, y: 125, width: 60, height: 60))
        iconimage.image = UIImage(named: "Icon_110_Triceps")
        return iconimage}()
    //background
    private let backgroundLBL: UILabel = {
        let Label = UILabel(frame: CGRect(x: 0, y: 78, width: 414, height: 110))
        Label.backgroundColor = UIColor(red: 81/255, green: 57/255, blue: 0/255, alpha: 0.6)
        Label.bounds.origin = CGPoint(x:0, y: 30)
        Label.textColor = UIColor.white
        return Label }()
    //TEXT Label

    private let titleLBL: UILabel = {
        let Label = UILabel(frame: CGRect(x: 78, y: 125, width: 122, height: 63))
        Label.text = "TRICEPS\nTRAINING"
        Label.bounds.origin = CGPoint(x: 78, y:125)
        Label.numberOfLines = 2
        Label.font = UIFont.boldSystemFont(ofSize: Label.font.pointSize)
        Label.textColor = UIColor.white
        return Label }()
    
    private let SetSLBL: UILabel = {
        let Label = UILabel(frame: CGRect(x: 348, y: 98, width: 63, height: 39))
        Label.text = "SET"
        Label.bounds.origin = CGPoint(x: 348, y: 108)
        Label.font = UIFont.boldSystemFont(ofSize: Label.font.pointSize)
        Label.textColor = UIColor.lightGray
        return Label }()
    
    private let RepSLBL: UILabel = {
        let Label = UILabel(frame: CGRect(x: 348, y: 148, width: 63, height: 39))
        Label.text = "REPS"
        Label.bounds.origin = CGPoint(x: 348, y: 148)
        Label.font = UIFont.boldSystemFont(ofSize: Label.font.pointSize)
        Label.textColor = UIColor.lightGray
        return Label }()
    
    private let durationsLBL: UILabel = {
        let Label = UILabel(frame: CGRect(x: 35, y: 80, width: 109, height: 21))
        Label.text = "TIME"
        Label.bounds.origin = CGPoint(x: 35, y: 80)
        Label.font = UIFont.boldSystemFont(ofSize: Label.font.pointSize)
        Label.textColor = UIColor.lightGray
        return Label }()
    //traing count
    private let totalLabel: UILabel = {
        let Label = UILabel(frame: CGRect(x: 310, y: 144, width: 63, height: 44))
        Label.bounds.origin = CGPoint(x: 305, y: 144)
        Label.font = UIFont.boldSystemFont(ofSize: Label.font.pointSize)
        Label.textColor = UIColor.white
        return Label }()
    
    private let trainsetLabel: UILabel = {
        let Label = UILabel(frame: CGRect(x: 300, y: 95, width: 61, height: 44))
        Label.bounds.origin = CGPoint(x: 300, y: 95)
        Label.font = Label.font.withSize(25)
        Label.font = UIFont.boldSystemFont(ofSize: Label.font.pointSize)
        Label.textColor = UIColor.white
        return Label }()
    
    private let trainingcLabel: UILabel = {
        let Label = UILabel(frame: CGRect(x: 295, y: 126, width: 68, height: 62))
        Label.text = "0"
        Label.bounds.origin = CGPoint(x: 295, y: 126)
        Label.font = UIFont.boldSystemFont(ofSize: Label.font.pointSize)
        Label.font = Label.font.withSize(25)
        Label.textColor = UIColor.white
        return Label }()
    //time
    private let durationLabel: UILabel = {
        let Label = UILabel(frame: CGRect(x: 40, y: 95, width: 100, height: 24))
        Label.text = "00:00"
        Label.font = Label.font.withSize(20)
        Label.bounds.origin = CGPoint(x: 30, y: 60)
        Label.font = UIFont.boldSystemFont(ofSize: Label.font.pointSize)
        Label.textColor = UIColor.white
        return Label }()
    
    var isThrowDetected = false
    
    //time count
    var timer:Timer = Timer()
    var Time_S : Int = 0
    var timerCounting:Bool = false
    
    func timerc(){
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {[weak self] timer in
                guard let self = self else { return }
                self.Time_S += 1
                let time = self.secondsToMinutesSconds(seconds: self.Time_S)
                let timeString = self.makeTimeString(minutes: time.0, seconds: time.1)
                self.durationLabel.text = timeString
 
                
                if(self.TrainSetCount == self.User_TrainSetAmount && self.Actioncount == 0){
                    self.timer.invalidate()
                    }
            })
    }
    
    
    func secondsToMinutesSconds(seconds: Int) -> (Int,Int){
        return (((seconds%3600)/60),((seconds % 3600)%60))
    }
    
    func makeTimeString(minutes: Int, seconds : Int) -> String{
        var timeString = ""
        timeString += String(format: "%02d", minutes)
        timeString += ":"
        timeString += String(format: "%02d", seconds)
        return timeString
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //get start time
        Addstartdate()
        //get firebase data
        Read_Data()
        //setup camera
        setupVideoPreview()
        //pose detection
        sitTraining_videoCapture.sitTraining_Predictor.delegate = self
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        timer.invalidate()
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

            let U_ActionAmount = (actionamount as NSString).integerValue
            let U_TrainSetAmount = (TrainSetAmount as NSString).integerValue
            self.User_TrainSetAmount = U_TrainSetAmount
            self.User_ActionAmount = U_ActionAmount
            self.totalLabel.text = "/\(actionamount)"
            self.trainingcLabel.text = "\(self.TrainSetCount)"
            self.trainsetLabel.text = "\(self.TrainSetCount)/\(TrainSetAmount)"
          // ...
        }) { error in
          print(error.localizedDescription)
            }}
    }

    var time3 : String = ""
    func Addstartdate(){
        let date = Date()
        time3 = formatter2.string(from: date)
    }
    //time count
    var timer_Set:Timer = Timer()
    var Time_S2 : Int = 0
    var User_Set_Timer: String = ""
    //timer main
    func timer_Set1(){
            timer_Set = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {timer_Set in
                self.Time_S2 += 1
                //call function second to min
                let time_Set = self.secondsToMinutesSconds(seconds: self.Time_S)
                //call function
                let timeString2 = self.makeTimeString(minutes: time_Set.0, seconds: time_Set.1)
                print("time Of Set: \(timeString2)")
                self.User_Set_Timer = timeString2
                //Reset timer
                //stop timer
                if(self.TrainSetCount == self.User_TrainSetAmount && self.Actioncount == 0){
                    self.timer_Set.invalidate()
                    }
            })
    }
    
    func Check_amount(){
        let user = Auth.auth().currentUser
        //check the user action equal the user amount setting
        if let user = user {
            if((Actioncount<User_ActionAmount)&&(TrainSetCount != User_TrainSetAmount)){
                Actioncount += 1
                trainingcLabel.text = "\(Actioncount)"
                if((Actioncount == User_ActionAmount)&&(TrainSetCount < User_TrainSetAmount)){
                    TrainSetCount += 1
                    Actioncount = 0
                    trainingcLabel.text = "\(Actioncount)"
                    trainsetLabel.text = "\(TrainSetCount)/\(String(User_TrainSetAmount))"
                    //save user set detail
                    let db = Firestore.firestore()
                    let date = Date()
                    let time4 = formatter.string(from: date)
                    db.collection("RecordofSet").document(user.uid).collection("User_Start_Date \(time3)").document("TrainingRecord\(TrainSetCount)").setData([
                                "lastUpdated":time4,
                                "Accuracy": self.Accuracy_STR,
                                "User_Train_Set": String(self.TrainSetCount),
                                "Total_Time": self.durationLabel.text!,
                                "TimeOfset": self.User_Set_Timer
                            ])
                    if((TrainSetCount == User_TrainSetAmount)){
                    //show alert & save data to firebase
                        let db = Firestore.firestore()
                        let date = Date()
                        let time1 = formatter.string(from: date)
                        let time2 = formatter2.string(from: date)
                        let gymTypeName = "Triceps"
 
                        db.collection("Record").document(user.uid).collection("data").document("TrainingRecord \(String(time2))").setData([
                                    "lastUpdated":time1,
                                    "GymType": gymTypeName,
                                    "Accuracy": self.Accuracy_STR,
                                    "User_Train_Set": self.TrainSetCount,
                                    "User_Train_Amount": User_ActionAmount,
                                    "User_Time": self.durationLabel.text!,
                                    "User_SetDetail_Collection": "User_Start_Date \(self.time3)",
                                    "Record_URL": "Record/Triceps.jpg"
                                ])
                            //show alertf
                            showAlertF()
                    }
                }
            }
        }
    }
    func toRecordPage(){
        let recordTableViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.recordTableViewController) as? RecordTableViewController
        self.navigationController?.pushViewController(recordTableViewController!, animated: true)
    }
    func toHomePage(){
        let firstPageNavigationController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.firstPageNavigationController) as? FirstPageNavigationController
        view.window?.rootViewController = firstPageNavigationController
        view.window?.makeKeyAndVisible()
    }
    func showAlertF(){
        let alert = UIAlertController(title: "Fininsh Training", message: "did you want to check your Record?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Sure!", style: .default, handler: {action in self.toRecordPage()}))
        alert.addAction(UIAlertAction(title: "no!", style: .cancel, handler: {action in self.toHomePage()}))
        present(alert, animated: true)
    }
    
    //test function
    func Add_Amount(){
        Actioncount+=1
    }
    
    private func setupVideoPreview(){
        sitTraining_videoCapture.startCaptureSession()
        previewLayer = AVCaptureVideoPreviewLayer(session: sitTraining_videoCapture.captureSession)
        
        guard let previewLayer = previewLayer else {
            return }
        
        view.layer.addSublayer(previewLayer)
        previewLayer.frame = view.frame
        
        //add point layout
        view.layer.addSublayer(pointLayer)
        pointLayer.frame = view.frame
        pointLayer.strokeColor = UIColor.green.cgColor
        
        //display top bar of user information
        view.addSubview(iconImage)
        view.addSubview(backgroundLBL)
        view.addSubview(titleLBL)
        view.addSubview(SetSLBL)
        view.addSubview(RepSLBL)
        view.addSubview(durationsLBL)
        view.addSubview(totalLabel)
        view.addSubview(trainsetLabel)
        view.addSubview(trainingcLabel)
        view.addSubview(durationLabel)
        
        //call timer function
        timerc()
    }
}

extension SitTraining_ViewController: SitTrainingDelegte{
    func SitTraining(sitTraining_predictor: SitTraining_Predictor, didLableAction action: String, with confience: Double) {
        print("Detected: \(action),Confidence: \(confience)")
        print("\(TrainSetCount) && Action Count\(Actioncount)")
        if action == "SitCorrect" && confience > 0.70 && isThrowDetected == false{
            
            print("Throw detected")
            isThrowDetected = true
            DispatchQueue.main.asyncAfter(deadline: .now()+3){
                self.isThrowDetected = false
            }
            DispatchQueue.main.async {
                //get confience
                self.Accuracy_STR = "\(String(format: "%.2f",confience * 100)) %"
                //when detected alert
                AudioServicesPlayAlertSound(SystemSoundID(1331))
                //upload label
                self.Check_amount()
            }
        }
    }
    
    func SitTraining(sitTraining_predictor: SitTraining_Predictor, didFindNewRecognizedPoints point: [CGPoint]) {
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
