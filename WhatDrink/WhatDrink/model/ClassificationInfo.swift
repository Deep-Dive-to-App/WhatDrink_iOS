//
//  ClassificationInfo.swift
//  WhatDrink
//
//  Created by 박희지 on 2021/09/09.
//

import UIKit

class ClassificationInfo {
    // 싱글톤 패턴
    static let shared = ClassificationInfo()
    
    var image: UIImage?
    var prediction: String?
    var result: String? {
        switch prediction {
        case "0":
            return "코카콜라"
        case "1":
            return "펩시콜라"
        case "2":
            return "칠성사이다"
        case "3":
            return "웰치스포도"
        case "4":
            return "초코에몽"
        case "5":
            return "비락식혜"
        case "6":
            return "밀키스"
        case "7":
            return "봉봉"
        case "8":
            return "포카리스웨트"
        case "9":
            return "스프라이트"
        default:
            return "음료 아님"
        }
    }
    var info: String? {
        switch prediction {
        case "0":
            return "콜라"
        case "1":
            return "콜라"
        case "2":
            return "사이다"
        case "3":
            return "포도맛 탄산음료"
        case "4":
            return "초코우유"
        case "5":
            return "식혜음료"
        case "6":
            return "밀키한 탄산음료"
        case "7":
            return "포도 알갱이가 들어간 포도음료"
        case "8":
            return "이온음료"
        case "9":
            return "사이다"
        default:
            return "음료를 알아내지 못했습니다."
        }
    }
    
    private init() {}
}
