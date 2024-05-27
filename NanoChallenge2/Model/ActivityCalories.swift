//
//  ActivityCalories.swift
//  NanoChallenge2
//
//  Created by Arrick Russell Adinoto on 25/05/24.
//

import Foundation
import SwiftData
/*
struct ActivityCalories: Identifiable{//Pake Hashable
    var id = UUID()
    var name: String
    var calories: Double
}
*/

@Model
class ActivityCalories:Identifiable{
     var id :String
     var name:String
     var calories:Double

     init(name:String, calories:Double){
         self.id = UUID().uuidString
         self.name = name
         self.calories = calories
     }
     
 }
 
 
