//
//  ResultViewController.swift
//  WhatDrink
//
//  Created by 박희지 on 2021/09/09.
//

import UIKit

class ResultViewController: UIViewController {
    let classificationInfo = ClassificationInfo.shared
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var goHomeButton: UIButton!
    @IBOutlet weak var grayView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    @IBAction func homeButtonTapped(_ sender: Any) {
        let drinkDetectorVC = self.storyboard?.instantiateViewController(identifier: "DrinkDetectorViewController") as! DrinkDetectorViewController
        drinkDetectorVC.modalPresentationStyle = .fullScreen
        present(drinkDetectorVC, animated: false, completion: nil)
    }
    
    func updateUI() {
        goHomeButton.layer.cornerRadius = goHomeButton.bounds.height/7
        goHomeButton.layer.masksToBounds = true
        
        grayView.layer.cornerRadius = goHomeButton.bounds.height/7
        grayView.layer.masksToBounds = true
        
        imageView.image = classificationInfo.image
        if let result = classificationInfo.result {
            resultLabel.text = result
        }
        if let info = classificationInfo.info {
            infoLabel.text = info
        }
    }
}
