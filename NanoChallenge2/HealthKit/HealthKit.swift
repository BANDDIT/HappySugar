//
//  HealthKit.swift
//  NanoChallenge2
//
//  Created by Arrick Russell Adinoto on 27/05/24.
//

import Foundation
import SwiftUI
import HealthKit

class HealthKitViewModel:ObservableObject{
    @Published var latestGlucoseValue: Double?
    @Published var latestGlucoseDate: Date?
    
    private let healthStore = HKHealthStore()
    
    public func requestAuthorization() {
        if HKHealthStore.isHealthDataAvailable() {
            let glucoseType = HKObjectType.quantityType(forIdentifier: .bloodGlucose)!
            
            let typesToRead: Set<HKObjectType> = [glucoseType]
            
            healthStore.requestAuthorization(toShare: nil, read: typesToRead) { success, error in
                if !success {
                    print("Authorization failed: \(String(describing: error))")
                    return
                }
                
                self.fetchLatestBloodGlucose()
            }
        }
    }
    
    public func fetchLatestBloodGlucose() {
        let glucoseType = HKObjectType.quantityType(forIdentifier: .bloodGlucose)!
        
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        let limit = 1
        let query = HKSampleQuery(sampleType: glucoseType, predicate: nil, limit: limit, sortDescriptors: [sortDescriptor]) { (query, results, error) in
            if let error = error {
                print("Error fetching blood glucose samples: \(error.localizedDescription)")
                return
            }
            
            guard let sample = results?.first as? HKQuantitySample else {
                return
            }
            
            DispatchQueue.main.async {
                self.latestGlucoseValue = sample.quantity.doubleValue(for: HKUnit(from: "mg/dL"))
                self.latestGlucoseDate = sample.endDate
            }
        }
        
        healthStore.execute(query)
    }
    
    public var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        return formatter
    }
}
