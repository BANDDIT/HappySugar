//
//  DrinkWaterView.swift
//  NanoChallenge2
//
//  Created by Arrick Russell Adinoto on 19/05/24.
//

import SwiftUI

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension View {
    func roundedCorner(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners) )
    }
}

struct DrinkWaterView: View {
    
    @StateObject var drinkWaterViewModel:DrinkWaterViewModel = DrinkWaterViewModel()

    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack{
            VStack{
                Spacer()
                WaterBottle(drinkWaterViewModel: drinkWaterViewModel)
                TextFieldWater(drinkWaterViewModel: drinkWaterViewModel)
                                
                Button(action:{

                },label:{
                    VStack{
                        Text("+ WATER").font(.system(size:25)).fontWeight(.black).padding([.trailing,.leading],40).padding([.top,.bottom],25)
                    }
                    .background(.white).cornerRadius(90)
                })
                
                Spacer()
            }
            .frame(maxWidth:.infinity,maxHeight:.infinity)
            //.frame(maxWidth:.infinity, maxHeight:.infinity)
            .background(Color.blue.ignoresSafeArea()).preferredColorScheme(.dark)
           
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

struct TextFieldWater:View{
    @ObservedObject var drinkWaterViewModel:DrinkWaterViewModel
    
    var body : some View{
        HStack{
            VStack(spacing:5){
                TextField("",text:$drinkWaterViewModel.amountOfWater).multilineTextAlignment(.center).font(.system(size:40)).onChange(of:drinkWaterViewModel.amountOfWater){
                    withAnimation{
                        drinkWaterViewModel.updateWaterHeight()
                    }
                }
                Text("").frame(width:100,height:1).background(.white)
            }
            Text("mL").font(.system(size:40)).fontWeight(.bold)
        }
        .frame(width:210,height:200).background(.blue)
    }
}

struct WaterBottle:View{
    @ObservedObject var drinkWaterViewModel:DrinkWaterViewModel
    
    var body : some View{
        ZStack(alignment:.bottom){
            Rectangle().fill(Color.white)
            Rectangle().fill(Color.blue).opacity(0.5).frame(height:drinkWaterViewModel.sliderHeight)
            
        }.frame(width:250,height:drinkWaterViewModel.maxHeight).roundedCorner(35,corners : [.bottomLeft,.bottomRight])
            .overlay{
                Text("\(Int(drinkWaterViewModel.sliderProgress * 600)) mL").font(.title).fontWeight(.bold).foregroundColor(.black).padding(.vertical,10).padding(.horizontal,18).cornerRadius(10).padding(.vertical,30)
        }
         .gesture(DragGesture(minimumDistance:0).onChanged({ (value) in
             withAnimation{
                 let translation = value.translation
                 drinkWaterViewModel.sliderHeight = -translation.height + drinkWaterViewModel.lastDragValue
                 
                 //limiting slider height value ..
                 drinkWaterViewModel.sliderHeight = drinkWaterViewModel.sliderHeight > drinkWaterViewModel.maxHeight ? drinkWaterViewModel.maxHeight : drinkWaterViewModel.sliderHeight
                 
                 drinkWaterViewModel.sliderHeight = drinkWaterViewModel.sliderHeight >= 0 ? drinkWaterViewModel.sliderHeight : 0
                 
                 //updating progress
                 let progress = drinkWaterViewModel.sliderHeight/drinkWaterViewModel.maxHeight
                 drinkWaterViewModel.sliderProgress = progress <= 1.0 ? progress : 1
             }
             
        }).onEnded({ (value) in
            withAnimation{
                //storing last drag value for restoration
                drinkWaterViewModel.sliderHeight = drinkWaterViewModel.sliderHeight > drinkWaterViewModel.maxHeight ? drinkWaterViewModel.maxHeight : drinkWaterViewModel.sliderHeight
                
                //negative height...
                drinkWaterViewModel.sliderHeight = drinkWaterViewModel.sliderHeight >= 0 ? drinkWaterViewModel.sliderHeight : 0
                
                drinkWaterViewModel.lastDragValue = drinkWaterViewModel.sliderHeight
                
                drinkWaterViewModel.amountOfWater = String(Int(drinkWaterViewModel.sliderProgress * 600))
            }
        }))
    }
    
}
/*
#Preview {
    NavigationStack{
        DrinkWaterView()
    }
}
*/









