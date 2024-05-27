//
//  HomeViewModel.swift
//  NanoChallenge2
//
//  Created by Arrick Russell Adinoto on 26/05/24.
//

import SwiftUI


class HomeViewModel:ObservableObject{
    @Published var isSplashScreen:Bool = false
    @Published var opacity:Double = 1
    //@State var move:Double = 680
    
    @Published var quote:String=""
    
    @Published var timer:Timer=Timer()
    
    @Published var selected_quote="TODAY IS  A HAPPY DAY"
    @Published var quoteTimer:Timer=Timer()
    
    //@Published var glucose:String = ""
    
    @StateObject var healthKitViewModel:HealthKitViewModel = HealthKitViewModel()
    
    static var isFirstTimeOpen:Bool = true
}
