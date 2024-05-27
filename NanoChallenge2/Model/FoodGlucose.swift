//
//  FoodGlucose.swift
//  NanoChallenge2
//
//  Created by Arrick Russell Adinoto on 25/05/24.
//

import Foundation
import SwiftData

@Model
class FoodGlucose:Identifiable{
     var id :String
     var name:String
     var glucose:Double

     init(name:String, glucose:Double){
         self.id = UUID().uuidString
         self.name = name
         self.glucose = glucose
     }
     
 }
 
