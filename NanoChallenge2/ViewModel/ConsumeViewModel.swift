//
//  ConsumeViewModel.swift
//  NanoChallenge2
//
//  Created by Arrick Russell Adinoto on 25/05/24.
//

import Foundation
import SwiftUI

class ConsumeViewModel:ObservableObject{
    @Published var glucose:String="0"
    @Published  var glucoseBefore:String="0"
    
    @Published  var addFood:String=""
    @Published  var addGluco:String=""
    
    @Published  var dropOpacity:Double=0
    
    @Published  var foodList:[FoodGlucose]=[]//[FoodGlucose(name:"Nasi Goreng",glucose:112),FoodGlucose(name:"Ayam Bakar",glucose:112),FoodGlucose(name:"Ice Lemon Tea",glucose:112)]
    
    //@Published var allFood:[FoodGlucose]=[]//=[FoodGlucose(name:"Nasi Goreng",glucose:112),FoodGlucose(name:"Ayam Bakar",glucose:112),FoodGlucose(name:"Ice Lemon Tea",glucose:112)]
    
    @Published  var rotation:Double=0
    @Published  var plusBg:Color=Color.green
    @Published var plusColor:Color=Color.white
    
    @Published var addMoreOption:Bool=false
    
    @Published  var totalGlucose:Double=0
    
    @Published  var frameMenuHeight:Double=216
    @Published  var offsetY:CGFloat=200
    
    public func submit(){
        foodList.removeAll()
        glucose="0"
        totalGlucose=0
    }
    
    public func setAddMoreOptionTrue(){
        addMoreOption = true
        frameMenuHeight = frameMenuHeight + 108
        offsetY = offsetY + 54
    }

    public func addFoodTags(food:FoodGlucose){
        foodList.append(food)
        totalGlucose = totalGlucose + food.glucose
    }
    
    public func decreaseFrameMenu(){
        frameMenuHeight = frameMenuHeight - 54
        offsetY = offsetY - 27
    }
    
    public func onClickDropdown(){
        dropOpacity = abs(dropOpacity-1)
        rotation=abs(rotation-45)
        if plusBg==Color.green{
            plusBg=Color.white
            plusColor=Color.green
        }
        else{
            plusBg=Color.green
            plusColor=Color.white
        }
        
        if addMoreOption{
            frameMenuHeight = frameMenuHeight - 108
            offsetY = offsetY - 54
        }
        
        addMoreOption=false
    }
    
    public func deleteTags(food:FoodGlucose){
        var index = -1

        for selectedFood in foodList{
            
            index = index + 1
            
            if selectedFood.name == food.name && selectedFood.glucose == food.glucose{
                foodList.remove(at:index)
                //context.delete(selectedFood)
                totalGlucose = totalGlucose - food.glucose
                break
            }
        }
    }
    
    public func glucoseTextFieldOnChange(){
        if glucose==""{
            if let doubleGlucoseBefore = Double(glucoseBefore){
                totalGlucose = totalGlucose - doubleGlucoseBefore
                glucoseBefore = "0"
            }
        }
        else{
            if let doubleGlucose = Double(glucose){
                
                if let doubleGlucoseBefore = Double(glucoseBefore){
                    totalGlucose = totalGlucose - doubleGlucoseBefore + doubleGlucose
                    glucoseBefore = String(doubleGlucose)
                }
            }
        }
    }
}
