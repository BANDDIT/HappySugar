//
//  ExerciseViewModel.swift
//  NanoChallenge2
//
//  Created by Arrick Russell Adinoto on 25/05/24.
//

import Foundation
import SwiftUI

class ExerciseViewModel:ObservableObject{
    @Published var calories:String="0"
    @Published  var caloriesBefore:String="0"
    
    @Published  var addActivity:String=""
    @Published  var addCalories:String=""
    
    @Published  var dropOpacity:Double=0
    
    @Published  var activityList:[ActivityCalories]=[]//[FoodGlucose(name:"Nasi Goreng",glucose:112),FoodGlucose(name:"Ayam Bakar",glucose:112),FoodGlucose(name:"Ice Lemon Tea",glucose:112)]
    
    @Published  var allActivity:[ActivityCalories]=[ActivityCalories(name:"Nasi Goreng",calories:112),ActivityCalories(name:"Ayam Bakar",calories:112),ActivityCalories(name:"Ice Lemon Tea",calories:112)]
    
    @Published  var rotation:Double=0
    @Published  var plusBg:Color=Color.red
    @Published var plusColor:Color=Color.white
    
    @Published var addMoreOption:Bool=false
    
    @Published  var totalCalories:Double=0
    
    @Published  var frameMenuHeight:Double=216
    @Published  var offsetY:CGFloat=200
    
    public func submit(){
        activityList.removeAll()
        calories="0"
        totalCalories=0
    }
    
    public func caloriesTextFieldOnChange(){
        if calories==""{
            if let doubleGlucoseBefore = Double(caloriesBefore){
                totalCalories = totalCalories - doubleGlucoseBefore
                caloriesBefore = "0"
            }
        }
        else{
            if let doubleGlucose = Double(calories){
                
                if let doubleGlucoseBefore = Double(caloriesBefore){
                    totalCalories = totalCalories - doubleGlucoseBefore + doubleGlucose
                    caloriesBefore = String(doubleGlucose)
                }
            }
        }
    }
    
    public func setAddMoreOptionTrue(){
        addMoreOption = true
        
        frameMenuHeight = frameMenuHeight + 108
        
        offsetY = offsetY + 54
    }
    
    public func onClickDropDown(){
        dropOpacity = abs(dropOpacity-1)
        rotation=abs(rotation-45)
        if plusBg==Color.red{
            plusBg=Color.white
            plusColor=Color.red
        }
        else{
            plusBg=Color.red
            plusColor=Color.white
        }
        
        if addMoreOption{
            frameMenuHeight = frameMenuHeight - 108
            offsetY = offsetY - 54
        }
        
        addMoreOption=false
    }
    
    public func addActivityTags(activity:ActivityCalories){
        activityList.append(activity)
        totalCalories = totalCalories + activity.calories
    }
}
