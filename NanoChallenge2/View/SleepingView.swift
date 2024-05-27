//
//  SleepingView.swift
//  NanoChallenge2
//
//  Created by Arrick Russell Adinoto on 25/05/24.
//

import SwiftUI


struct SleepingView: View {

    
    @StateObject var sleepingViewModel:SleepingViewModel = SleepingViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack{
            Color.purple.ignoresSafeArea()
            VStack{
                Spacer()
                
                GifImage("Sleep").frame(width:680,height:450).cornerRadius(30).shadow(radius: 20).padding(.bottom,35)

                Spacer()
                SleepProgressBar(sleepingViewModel:sleepingViewModel)
                Spacer()
                SleepButton(sleepingViewModel:sleepingViewModel)
                Spacer()
                
                Button(action:{

                },label:{
                    VStack{
                        Text("+ Sleep Hour").font(.system(size:25)).fontWeight(.black).padding([.trailing,.leading],40).padding([.top,.bottom],25).foregroundColor(.purple)
                    }
                    .background(.white).cornerRadius(90)
                })
                
                Spacer()
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar{
            ToolbarItem(placement:.topBarLeading){
                Button(action:{
                    dismiss()
                },label:{
                    Image(systemName: "chevron.backward").foregroundColor(.white)
                    Text("Back").foregroundColor(.white)
                })
            }
        }
    }
}


struct SleepButton:View{
    @ObservedObject var sleepingViewModel:SleepingViewModel
    var body : some View{
        HStack{
            Button(action:{
                withAnimation{
                    sleepingViewModel.minusSleepHour()
                }
            },label:{
                Image(systemName:"minus").foregroundColor(.purple).frame(width:60,height:60).background(.white).cornerRadius(180).font(.system(size:40))
            })
            
            Text("  \(sleepingViewModel.sleepHour)  ").foregroundColor(.white).font(.system(size:60))

            Button(action:{
                withAnimation{
                    sleepingViewModel.plusSleepHour()
                }
            },label:{
                Image(systemName:"plus").foregroundColor(.purple).frame(width:60,height:60).background(.white).cornerRadius(180).font(.system(size:40))
            })
        }
    }
}

struct SleepProgressBar:View{
    @ObservedObject var sleepingViewModel:SleepingViewModel
    var body : some View{
        ZStack{
            VStack{
            }.frame(width:sleepingViewModel.progress,height:25).background(sleepingViewModel.getColor())
        }.frame(width:700,height:25,alignment:.leading).background(.white).cornerRadius(180).shadow(radius:10)
    }
}
/*
#Preview {
    NavigationStack{
        SleepingView()
    }
}
*/
