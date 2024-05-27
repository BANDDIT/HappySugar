//
//  BodyMeasurementViewModel.swift
//  NanoChallenge2
//
//  Created by Arrick Russell Adinoto on 27/05/24.
//

import Foundation

class BodyMeasurementViewModel:ObservableObject{
    @Published var sex:String="Male"
    @Published var height:String="160"
    
    @Published var weight:String="60"
    @Published var age:String="60"
    
    @Published var isDropDown:Double = 0
    @Published var rotationEffect:Double = 0
    
    @Published var isError:Bool = false
    
    @Published var isNavigate:Bool = false
    
    @Published var errorMessage:String=""
    
    
    public func dropDownEffect(){
        isDropDown = abs(isDropDown-1)
        rotationEffect = abs(rotationEffect - 180)
    }
    
    public func inputCheck(){
        if let doubleHeight = Double(height){
            if let doubleWeight = Double(weight){
                if let age = Int(age){
                    isNavigate = true
                    print("Masuk2")
              
                }
                else{
                    errorMessage = "You should fill your age."
                    isError = true
                }
            }
            else{
                errorMessage = "You should fill your weight."
                isError = true
            }
        }
        else{
            errorMessage = "You should fill your height."
            isError = true
        }
    }
}
