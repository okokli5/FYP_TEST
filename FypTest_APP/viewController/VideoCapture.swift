//
//  VideoCapture.swift
//  FypTest_APP


import Foundation
import AVFoundation
import UIKit

class VideoCapture:NSObject {
    
    
    let captureSession = AVCaptureSession()
    let videoOutput = AVCaptureVideoDataOutput()
    
    let predictor = Predictor()
    override init() {
        super.init()
        
        guard let captureDevice = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: captureDevice) else{return}
        captureSession.sessionPreset = AVCaptureSession.Preset.high
        captureSession.addInput(input)
        
        captureSession.addOutput(videoOutput)
        videoOutput.alwaysDiscardsLateVideoFrames = true
        }
    func startCaptureSession(){
        captureSession.startRunning()
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label:"videoDispatchQueue"))
    }
    }


extension VideoCapture: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput( _ output: AVCaptureOutput, didOutput sampleBuffer:CMSampleBuffer, from connection: AVCaptureConnection) {
        predictor.estmation(sampleBuffer: sampleBuffer)
    }
}
