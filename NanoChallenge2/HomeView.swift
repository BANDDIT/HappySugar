//
//  HomeView.swift
//  NanoChallenge2
//
//  Created by Arrick Russell Adinoto on 19/05/24.
//

import SwiftUI
import HealthKit

struct HomeView: View {
    /*
    @StateObject var healthKitViewModel:HealthKitViewModel = HealthKitViewModel()
     */
    @StateObject var homeViewModel:HomeViewModel = HomeViewModel()
    
    
    @State private var latestGlucoseValue: Double?
    @State private var latestGlucoseDate: Date?
    
    private let healthStore = HKHealthStore()
    
    var body: some View {
    
        NavigationStack{
            ZStack{
                Color.orange.ignoresSafeArea()
                VStack{
                    //Text("\(healthKitViewModel.latestGlucoseValue)")
                    Spacer()
                    
   
                    Text("\(homeViewModel.quote)").frame(width:700).foregroundColor(.white).fontWeight(.black).font(.system(size:50)).onAppear{
                        var index = 0
                        homeViewModel.quoteTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
                                
                            if index < homeViewModel.selected_quote.count {
                                let charIndex = homeViewModel.selected_quote.index(homeViewModel.selected_quote.startIndex, offsetBy: index)
                                homeViewModel.quote.append(homeViewModel.selected_quote[charIndex])
                                index += 1
                            } else {
                                timer.invalidate()
                            }
                        }
                    }
                 


                    
                    Text("")

                    Spacer()

                    //if let value 
                    if let value = latestGlucoseValue{
                        Text("Glucose Prediction : \(value,specifier:"%.2f") mg/dL").foregroundColor(.white).font(.system(size:30))
                    }
                    else{
                        Text("No blood glucose data available").foregroundColor(.white).font(.system(size:30))
                    }
                    
                    Text("Normal").fontWeight(.bold).foregroundColor(.white).font(.system(size:30))
                    
                    Spacer()
                    Text("")
                    //BackgroundQuotes()
                    
                    Carrousel(homeViewModel:homeViewModel)
                    
                    Spacer()
                    Spacer()

                    BottomHomeView(homeViewModel:homeViewModel).padding()
                    
                }
            }
            .opacity(homeViewModel.opacity)
            .overlay{
                if homeViewModel.isSplashScreen{
                    SplashScreen(isSplashScreen:$homeViewModel.isSplashScreen, opacity:$homeViewModel.opacity)
                }
            }
            .onAppear{
                requestAuthorization()
                //healthKitViewModel.requestAuthorization()
                //homeViewModel.quote=""
            }
            .onDisappear{
                homeViewModel.timer.invalidate()
                homeViewModel.quoteTimer.invalidate()
                //homeViewModel.quote=""

            }
        }
        
    }
    
    private func requestAuthorization() {
        if HKHealthStore.isHealthDataAvailable() {
            let glucoseType = HKObjectType.quantityType(forIdentifier: .bloodGlucose)!
            
            let typesToRead: Set<HKObjectType> = [glucoseType]
            
            healthStore.requestAuthorization(toShare: nil, read: typesToRead) { success, error in
                if !success {
                    print("Authorization failed: \(String(describing: error))")
                    return
                }
                
                fetchLatestBloodGlucose()
            }
        }
    }
    
    private func fetchLatestBloodGlucose() {
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
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        return formatter
    }
}

struct BackgroundQuotes:View{
    var body : some View{
        ZStack{
            Text("What about a new Hobby?").rotationEffect(.degrees(-8)).foregroundColor(.white).fontWeight(.bold).font(.system(size:20)).offset(x:-270,y:-40)
            
            Text("You're gonna be lucky today").rotationEffect(.degrees(-8)).foregroundColor(.white).fontWeight(.bold).font(.system(size:20)).offset(x:-10,y:-40)
            
            Text("You will receive a good news").rotationEffect(.degrees(-8)).foregroundColor(.white).fontWeight(.bold).font(.system(size:20)).offset(x:180,y:-40)
            
            Text("Goodluck on your Exam!").rotationEffect(.degrees(-8)).foregroundColor(.white).fontWeight(.bold).font(.system(size:20)).offset(x:270,y:550)
            
            
            Text("Today is better than yesterday")
                .rotationEffect(.degrees(-8)).foregroundColor(.white).fontWeight(.bold).font(.system(size:20)).offset(x:-20,y:550)
                
            
            Text("Enjoy your day!").rotationEffect(.degrees(-8)).foregroundColor(.white).fontWeight(.bold).font(.system(size:20)).offset(x:-250,y:550)
            
            /*
            Text("Let's start our new journey")
            
             */
        }
    }
}

struct BottomHomeView:View{
    @ObservedObject var homeViewModel:HomeViewModel
    
    var body : some View{
        HStack(spacing:20){

            NavigationLink(destination: ConsumeView()){
                ZStack{
                    VStack{
                        Image("Banana").resizable().frame(width:100,height:100)

                        Text("Consume").fontWeight(.bold)
                    }
                    .frame(width:176,height:147).background(Color.white)
                    .cornerRadius(20)
                }
                .frame(width:180,height:150).background(Color.blue)
                .cornerRadius(20)
            }
            
            
            NavigationLink(destination:ExerciseView()){
                ZStack{
                    VStack{
                        Image("RunningMan").resizable().frame(width:100,height:100)
                        Text("Exercise").fontWeight(.bold)
                    }
                    .frame(width:176,height:147).background(Color.white)
                    .cornerRadius(20)
                }
                .frame(width:180,height:150).background(Color.blue)
                .cornerRadius(20)
            }
            
            
            NavigationLink(destination:SleepingView()){
                ZStack{
                    VStack{
                        Image("Sleeping").resizable().frame(width:100,height:100)
                        Text("Sleeping").fontWeight(.bold)
                    }
                    .frame(width:176,height:147).background(Color.white)
                    .cornerRadius(20)
                }
                .frame(width:180,height:150).background(Color.blue)
                .cornerRadius(20)
            }
            
            NavigationLink(destination:DrinkWaterView()){
                VStack{
                    Image("Glass").resizable().frame(width:110,height:100)
                    Text("Drink Water").fontWeight(.bold).foregroundColor(Color.white)
                }
                .frame(width:140,height:150).background(Color.blue)
                .cornerRadius(20)
            }
            

        }
    
    }
}



struct ImageFrame:View{
    var image:String
    
    var body : some View{
        VStack{
            Image("\(image)")
                    .resizable().frame(width:680,height:450)
        }.frame(width:680,height:450).clipped()
    }
}

struct Carrousel:View{
    
    @ObservedObject var homeViewModel:HomeViewModel
    
    @State var move:Double = 680
    var body:some View{
        ZStack{
            VStack{
                HStack(spacing:0){
                    ImageFrame(image:"Home1")
                    ImageFrame(image:"Home2")
                    ImageFrame(image:"Home3")
                    ImageFrame(image:"Home4")
                    ImageFrame(image:"Home5")
                }
                .frame(width:680*3,height:450).offset(x:move).cornerRadius(30).clipped()
            }.frame(width:680,height:450).background(.white).cornerRadius(30).clipped()
        }.frame(width:685,height:455).background(.black).cornerRadius(30).clipped().shadow(radius:30)            .onAppear{
            homeViewModel.timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true){_ in
                //move = move + 680
                
                withAnimation(.easeInOut(duration:1)){
                    if (move + 680) < 680*3{
                        move = move + 680
                    }
                    else{
                        move = -680*2
                    }
                }
                 
            }
            
        }
    }
}


#Preview {
    HomeView()
}

/*
Design Feedback:
 -Settings gaperlu ada gpp. App sounds kalau bisa jangan suruh mereka pilih, karena app sounds adalah karakter dari app kita
 -buat icon App, kalau bisa jangan ada kata2. Icon-nya harus langsung merepresentasikan maksud
 -Terus tulisan di slash screen, kalau bisa dikasih enter, jangan terlalu lebar, manfaatin aja space yang ada
 */


/*
HStack(alignment:.top){
    
    Button(action:{
        
    },label:{
        ZStack(alignment:.topTrailing){
            
            ZStack{
                Circle().frame(width:50,height:50).foregroundColor(.yellow)
                Circle().frame(width:45,height:45).foregroundColor(.white)
                Image("Light").resizable().frame(width:35,height:35)
            }
            
            
            ZStack{
                Circle().frame(width:22,height:22).foregroundColor(.red)
                Text("5+").foregroundColor(.white).font(.system(size:12))
            }.offset(x:2,y:-2)
        }.frame(width:50,height:50)

    })
    
    Spacer()
    
    NavigationLink(destination:SettingsView()){
        Image(systemName: "gearshape.fill").resizable().frame(width:60,height:60)
    }
  
}
.padding(.trailing,20)
.padding(.leading,20)
//.background(.green)

Spacer()

VStack{
    Text("Normal")
    Text("100 mg/dL")
    Text("")
    HStack{
        Image(systemName:"chevron.right").font(.system(size:95)).foregroundColor(.blue)
    }
}
*/
