//
//  NanoChallenge2App.swift
//  NanoChallenge2
//
//  Created by Arrick Russell Adinoto on 18/05/24.
//

import SwiftUI
import SwiftData

@main
struct NanoChallenge2App: App {
    
    var container:ModelContainer
    
    init(){
        do{
            let config = ModelConfiguration(for: FoodGlucose.self,ActivityCalories.self)
            
            container = try ModelContainer(for:FoodGlucose.self, ActivityCalories.self, configurations: config)
        }
        catch{
            fatalError("Failed to configure SwiftData container.")
        }
    }
    
    
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
        .modelContainer(container)
    }
}
