//
//  CameraViewController.swift
//  WhatDrink
//
//  Created by 박희지 on 2021/09/06.
//

import UIKit

class CameraViewController: UIViewController {
    @IBOutlet weak var previewView: PreviewView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var switchButton: UIButton!
    @IBOutlet weak var blurBGView: UIVisualEffectView!
    @IBOutlet weak var captureButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setupUI() {
        captureButton.layer.cornerRadius = captureButton.bounds.height/2
        captureButton.layer.masksToBounds = true
        
        blurBGView.layer.cornerRadius = blurBGView.bounds.height/2
        blurBGView.layer.masksToBounds = true
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        
    }
    @IBAction func switchButtonTapped(_ sender: Any) {
        
    }
    @IBAction func captureButtonTapped(_ sender: Any) {
        
    }
    
}
