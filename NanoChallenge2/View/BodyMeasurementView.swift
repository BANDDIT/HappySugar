//
//  BodyMeasurementView.swift
//  NanoChallenge2
//
//  Created by Arrick Russell Adinoto on 25/05/24.
//

import SwiftUI

struct BodyMeasurementView: View {
    
    @StateObject var bodyMeasurementViewModel:BodyMeasurementViewModel = BodyMeasurementViewModel()
    
    var body: some View {
        NavigationStack{
            ZStack{
                Color.blue.ignoresSafeArea()
                VStack(alignment:.leading){
                    HeightSection(bodyMeasurementViewModel:bodyMeasurementViewModel)
                    
                    Text("")
                    Text("")
                    Text("")
                    
                    Spacer()
                    
                    WeightSection(bodyMeasurementViewModel: bodyMeasurementViewModel)
                    
                    Spacer()
                    Text("")
                    Text("")
                    Text("")
                    
                    //Age
                    
                    AgeSection(bodyMeasurementViewModel: bodyMeasurementViewModel)
                    
                    Spacer()
                    Text("")
                    Spacer()
                    Spacer()

                    SexSection(bodyMeasurementViewModel: bodyMeasurementViewModel)
                    
                    Spacer()
                    Spacer()
                    Spacer()
                    
                    Button(action:{
                        withAnimation{
                            bodyMeasurementViewModel.inputCheck()
                        }
                    },label:{
                        Text("Next").font(.system(size:25)).fontWeight(.heavy).frame(width:120,height:50).background(.white).cornerRadius(180).foregroundColor(.blue)
                    })
                    
                    
                }.frame(width:500,height:950,alignment:.leading).background(.blue)
                
            }
            .overlay{
                if bodyMeasurementViewModel.isError{
                    ErrorAlertView(errorMessage:bodyMeasurementViewModel.errorMessage,isPresented:$bodyMeasurementViewModel.isError)
                     
                }
            }
        }
    }

}

struct SexSection:View{
    @ObservedObject var bodyMeasurementViewModel:BodyMeasurementViewModel

    var body : some View{
        ZStack{
            VStack(alignment:.leading){
                Text("Sex").fontWeight(.black).foregroundColor(.white).font(.system(size:30))
                VStack{
                    HStack{
                        Text("\(bodyMeasurementViewModel.sex)").padding(.leading,10).font(.system(size:30))
                        Spacer()
                        Button(action:{
                            withAnimation{
                                bodyMeasurementViewModel.dropDownEffect()
                            }
                        },label:{
                            Image(systemName:"arrowtriangle.down.fill").font(.system(size:20)).rotationEffect(.degrees(bodyMeasurementViewModel.rotationEffect))
                        })
                        .padding(.trailing,15)
                    }.frame(width:400,height:50).background(.blue).foregroundColor(.white).cornerRadius(5)
                }.frame(width:405,height:55).background(.white).cornerRadius(5)
                
                SexSectionDropDown(bodyMeasurementViewModel: bodyMeasurementViewModel)
            }
            

        }
    }
}

struct SexSectionDropDown:View{
    @ObservedObject var bodyMeasurementViewModel:BodyMeasurementViewModel
    
    var body : some View{
        VStack(spacing:0){
            Button(action:{
                withAnimation{
                    bodyMeasurementViewModel.sex="Male"
                }
            },label:{
                VStack{
                    Text("Male").foregroundColor(.blue).padding(.leading,10).font(.system(size:30)).fontWeight(.medium)
                }.frame(width:405,height:54,alignment:.leading).background(.white)
            })
            
            VStack{
                Text("").frame(width:385,height:1).background(.blue)
            }.frame(width:405,height:1,alignment:.center).background(.white)
            
            Button(action:{
                withAnimation{
                    bodyMeasurementViewModel.sex="Female"
                }
            },label:{
                VStack{
                    Text("Female").foregroundColor(.blue).padding(.leading,10).font(.system(size:30)).fontWeight(.medium)
                }.frame(width:405,height:54,alignment:.leading).background(.white)
            })
            
            
            VStack{
                Text("").frame(width:385,height:1).background(.blue)
            }.frame(width:405,height:1,alignment:.center).background(.white)
            
            Button(action:{
                withAnimation{
                    bodyMeasurementViewModel.sex="Prefer Not To Say"
                }
            },label:{
                VStack{
                    Text("Prefer Not To Say").foregroundColor(.blue).padding(.leading,10).font(.system(size:30)).fontWeight(.medium)
                }.frame(width:405,height:54,alignment:.leading).background(.white)
            })
            
        }.frame(width:405,height:164).background(.white).cornerRadius(10).opacity(bodyMeasurementViewModel.isDropDown)
    }
}

struct AgeSection:View{
    @ObservedObject var bodyMeasurementViewModel:BodyMeasurementViewModel
    var body : some View{
        VStack(alignment:.leading){
            Text("Age").fontWeight(.black).foregroundColor(.white).font(.system(size:30))
            VStack{
                VStack{
                    TextField("",text:$bodyMeasurementViewModel.age).foregroundColor(.white).padding(.leading,10).font(.system(size:30))
                }.frame(width:400,height:50).background(.blue).cornerRadius(5)
            }.frame(width:405,height:55).background(.white).cornerRadius(5)
        }
    }
}

struct WeightSection:View{
    @ObservedObject var bodyMeasurementViewModel:BodyMeasurementViewModel
    var body : some View{
        VStack(alignment:.leading){
            Text("Weight (kg)").fontWeight(.black).foregroundColor(.white).font(.system(size:30))
            VStack{
                VStack{
                    TextField("",text:$bodyMeasurementViewModel.weight).foregroundColor(.white).padding(.leading,10).font(.system(size:30))
                }.frame(width:400,height:50).background(.blue).cornerRadius(5)
            }.frame(width:405,height:55).background(.white).cornerRadius(5)
        }
    }
}


struct HeightSection:View{
    @ObservedObject var bodyMeasurementViewModel:BodyMeasurementViewModel
    var body : some View{
        VStack(alignment:.leading){
            Text("Height (cm)").fontWeight(.black).foregroundColor(.white).font(.system(size:30))
            VStack{
                VStack{
                    TextField("",text:$bodyMeasurementViewModel.height).foregroundColor(.white).padding(.leading,10).font(.system(size:25))
                }.frame(width:400,height:50).background(.blue).cornerRadius(5)
            }.frame(width:405,height:55).background(.white).cornerRadius(5)
        }
    }
}

#Preview {
    BodyMeasurementView()
}
