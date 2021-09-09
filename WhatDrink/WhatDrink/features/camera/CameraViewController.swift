//
//  CameraViewController.swift
//  WhatDrink
//
//  Created by 박희지 on 2021/09/06.
//

import UIKit
import AVFoundation
import Photos

class CameraViewController: UIViewController {
    let captureSession = AVCaptureSession()
    var videoDeviceInput: AVCaptureDeviceInput!    // 전면, 후면 전환 가능하므로 var
    var photoOutput: AVCapturePhotoOutput = {
        let output = AVCapturePhotoOutput()
        // 고해상도
        output.isHighResolutionCaptureEnabled = true
        return output
    }()
    
    let sessionQueue = DispatchQueue(label: "session Queue")
    let videoDeviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera, .builtInWideAngleCamera, .builtInTrueDepthCamera], mediaType: .video, position: .unspecified)
    
    @IBOutlet weak var previewView: PreviewView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var switchButton: UIButton!
    @IBOutlet weak var blurBGView: UIVisualEffectView!
    @IBOutlet weak var captureButton: UIButton!
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        previewView.session = captureSession
        // 초기 설정
        sessionQueue.async {
            self.setupSession()
            self.startSession()
        }
        setupUI()
    }
    
    func setupUI() {
        captureButton.layer.cornerRadius = captureButton.bounds.height/2
        captureButton.layer.masksToBounds = true
        
        blurBGView.layer.cornerRadius = blurBGView.bounds.height/2
        blurBGView.layer.masksToBounds = true
    }
    
    // 카메라 전환 액션함수
    @IBAction func backButtonTapped(_ sender: Any) {
        
    }
    @IBAction func switchButtonTapped(_ sender: Any) {
        sessionQueue.async {
            /// 반대편 카메라 찾기
            let currentVideoDevice = self.videoDeviceInput.device
            let currentPosition = currentVideoDevice.position
            let isFront = currentPosition == .front
            let preferredPosition: AVCaptureDevice.Position = isFront ? .back: .front
            
            /// 새로운 디바이스로 세션 update
            let devices = self.videoDeviceDiscoverySession.devices
            var newVideoDevice: AVCaptureDevice?
            
            newVideoDevice = devices.first(where: {device in
                return preferredPosition == device.position
            })
            
            if let newDevice = newVideoDevice {
                do {
                    let videoDeviceInput = try AVCaptureDeviceInput(device: newDevice)
                    self.captureSession.beginConfiguration()
                    self.captureSession.removeInput(self.videoDeviceInput)
                    
                    /// 새 device input 추가
                    if self.captureSession.canAddInput(videoDeviceInput) {
                        self.captureSession.addInput(videoDeviceInput)
                        self.videoDeviceInput = videoDeviceInput
                    } else {
                        self.captureSession.addInput(self.videoDeviceInput)
                    }
                    self.captureSession.commitConfiguration()
                } catch let error {
                    print("error occured while creating device input: \(error.localizedDescription)")
                }
            }
        }
    }
    @IBAction func captureButtonTapped(_ sender: Any) {
        let videoPreviewLayerOrientation = self.previewView.videoPreviewLayer.connection?.videoOrientation
        sessionQueue.async {
            let connection = self.photoOutput.connection(with: .video)
            connection?.videoOrientation = videoPreviewLayerOrientation!
            let setting = AVCapturePhotoSettings()
            self.photoOutput.capturePhoto(with: setting, delegate: self)
        }
    }
    
}

// MARK: - Setup session & preview
extension CameraViewController {
    func setupSession() {
        /// setting
        captureSession.sessionPreset = .high        // 고화질
        captureSession.beginConfiguration()
        
        /// add video input
        var defaultVideoDevice: AVCaptureDevice?
        guard let camera = videoDeviceDiscoverySession.devices.first else {     // 세션에서 기기 찾아오기
            captureSession.commitConfiguration()
            return
        }
        do {
            let vidoeDeviceInput = try AVCaptureDeviceInput(device: camera)
            if captureSession.canAddInput(vidoeDeviceInput) {
                captureSession.addInput(vidoeDeviceInput)
                self.videoDeviceInput = vidoeDeviceInput
            } else {
                captureSession.commitConfiguration()
                return
            }
        } catch let error {
            captureSession.commitConfiguration()
            return
        }
        
        /// add photo output
        photoOutput.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])], completionHandler: nil)   // 사진 저장 형식
        if captureSession.canAddOutput(photoOutput) {
            captureSession.addOutput(photoOutput)
        } else {
            captureSession.commitConfiguration()
            return
        }
        captureSession.commitConfiguration()
    }
    
    func startSession() {
        sessionQueue.async {
            if !self.captureSession.isRunning {
                self.captureSession.startRunning()
            }
        }
    }
    
    func stopSession() {
        sessionQueue.async {
            if self.captureSession.isRunning {
                self.captureSession.stopRunning()
            }
        }
    }
}

extension CameraViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard error == nil else { return }
        guard let imageData = photo.fileDataRepresentation() else { return }
        guard let image = UIImage(data: imageData) else { return }
    }
}
