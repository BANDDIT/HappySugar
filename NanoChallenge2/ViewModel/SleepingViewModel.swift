//
//  SleepingViewModel.swift
//  NanoChallenge2
//
//  Created by Arrick Russell Adinoto on 27/05/24.
//

import Foundation
import SwiftUI

class SleepingViewModel:ObservableObject{
    @Published var sleepHour:Int = 8
    @Published var progress:Double=700
    @Published var progressColor: Color = .blue
    
    
    public func getColor() -> Color{
        if sleepHour<=3{
            return .red
        }
        else if sleepHour<=5{
            return .orange
        }
        else if sleepHour<=7{
            return .green
        }
        return .blue
    }
    
    public func minusSleepHour(){
        sleepHour = sleepHour - 1
        updateProgress()
    }
    
    public func plusSleepHour(){
        sleepHour = sleepHour - 1
        updateProgress()
    }
    
    public func updateProgress(){
        progress = Double(sleepHour)/8 * 700
        
        if sleepHour <= -1{
            sleepHour=0
        }
    }
}
