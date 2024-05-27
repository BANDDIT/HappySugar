//
//  DrinkWaterViewModel.swift
//  NanoChallenge2
//
//  Created by Arrick Russell Adinoto on 26/05/24.
//

import Foundation
import SwiftUI

class DrinkWaterViewModel:ObservableObject{
    
    @Published var maxHeight: CGFloat = UIScreen.main.bounds.height/3
    
    @Published var sliderProgress:CGFloat = 0
    @Published var sliderHeight:CGFloat = 0
    @Published var lastDragValue:CGFloat = 0
    @Published var amountOfWater:String = "0"
    
    func updateWaterHeight(){
        do{
            
            var waterAmount:Double = (amountOfWater as NSString).doubleValue
            if waterAmount>600{
                waterAmount = 600
                amountOfWater = "600"
            }
            else if waterAmount<0{
                waterAmount = 0
                amountOfWater = "0"
            }
                     
            sliderProgress = CGFloat(waterAmount/600)
            sliderHeight = sliderProgress * maxHeight
        }
        catch{
            amountOfWater = "0"
        }
    }
}
