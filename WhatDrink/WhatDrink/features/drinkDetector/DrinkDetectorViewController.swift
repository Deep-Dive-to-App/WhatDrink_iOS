//
//  ViewController.swift
//  WhatDrink
//
//  Created by 박희지 on 2021/09/06.
//

import UIKit

class DrinkDetectorViewController: UIViewController {

    let classificationInfo = ClassificationInfo.shared
    @IBOutlet weak var detectDrinkButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
    }
    
    func setupUI() {
        // ui 관련 코드
        detectDrinkButton.layer.cornerRadius = detectDrinkButton.bounds.height/7
        detectDrinkButton.layer.masksToBounds = true
    }

    @IBAction func detectDrinkButtonTapped(_ sender: Any) {
        classificationInfo.count += 1
        let storyboard = UIStoryboard(name: "Camera", bundle: nil)
        let cameraVC = storyboard.instantiateViewController(identifier: "CameraViewController") as! CameraViewController
        cameraVC.modalPresentationStyle = .fullScreen
        present(cameraVC, animated: false, completion: nil)
        
    }
    
}

