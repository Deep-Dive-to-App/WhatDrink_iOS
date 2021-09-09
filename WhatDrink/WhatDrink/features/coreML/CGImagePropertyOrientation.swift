//
//  CGImagePropertyOrientation.swift
//  WhatDrink
//
//  Created by 박희지 on 2021/09/09.
//

import UIKit
import ImageIO

// UIImageOrientation을 CGImagePropertyOrientation으로 컨버팅
extension CGImagePropertyOrientation {
    init(_ orientation: UIImage.Orientation) {
        switch orientation {
        case .up: self = .up
        case .upMirrored: self = .upMirrored
        case .down: self = .down
        case .downMirrored: self = .downMirrored
        case .left: self = .left
        case .leftMirrored: self = .leftMirrored
        case .right: self = .right
        case .rightMirrored: self = .rightMirrored
        }
    }
}
