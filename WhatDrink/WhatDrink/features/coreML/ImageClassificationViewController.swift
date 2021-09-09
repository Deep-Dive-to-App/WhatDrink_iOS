//
//  ImageClassificationViewController.swift
//  WhatDrink
//
//  Created by 박희지 on 2021/09/09.
//

import UIKit
import CoreML
import Vision
import ImageIO

class ImageClassificationViewController: UIViewController {
    var classificationInfo = ClassificationInfo.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Image Classification
    /// - Tag: MLModel Setup
    lazy var classificationRequest: VNCoreMLRequest = {
        do {
            let model = try VNCoreMLModel(for: beverage_1().model)
            
            let request = VNCoreMLRequest(model: model, completionHandler: { [weak self] request, error in
                self?.ProcessClassifications(for: request, error: error)
            })
            return request
        } catch {
            fatalError("Failed to load Vision ML model: \(error)")
        }
    }()
    
    /// - Tag: PerformRequests
    func updateClassifications(for image: UIImage) {
        self.classificationInfo.image = image
        let orientation = CGImagePropertyOrientation(image.imageOrientation)
        guard let ciImage = CIImage(image: image) else { fatalError("Unable to create \(CIImage.self) form \(image)") }
        
        DispatchQueue.global(qos: .userInitiated).async {
            let handler = VNImageRequestHandler(ciImage: ciImage, orientation: orientation)
            do {
                try handler.perform([self.classificationRequest])       // handler로 model에게 request
            } catch {
                print("Failed to perform classification.\n\(error.localizedDescription)")
            }
        }
    }
    
    /// - Tag: ProcessClassifications (분류 결과에 따른 UI 업뎃)
    func ProcessClassifications(for request: VNRequest, error: Error?) {
        DispatchQueue.main.async {
            let resultVC = self.storyboard?.instantiateViewController(identifier: "ResultViewController") as! ResultViewController
            guard let results = request.results else {
                self.classificationInfo.prediction = "분류 불가"
                self.present(resultVC, animated: false, completion: nil)
                return
            }
            let classifications = results as! [VNClassificationObservation]
            if classifications.isEmpty {
                self.classificationInfo.prediction = "알 수 없음"
            } else {
                let topClassification = classifications.prefix(1)
                let prediction = topClassification.first?.identifier
                self.classificationInfo.prediction = prediction
            }
            
            resultVC.modalPresentationStyle = .fullScreen
            self.present(resultVC, animated: false, completion: nil)
        }
    }
}
