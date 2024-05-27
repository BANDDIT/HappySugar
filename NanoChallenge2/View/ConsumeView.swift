//
//  ConsumeView.swift
//  NanoChallenge2
//
//  Created by Arrick Russell Adinoto on 23/05/24.
//

import SwiftUI
import SwiftData

struct ConsumeView: View {
    @StateObject var consumeViewModel:ConsumeViewModel = ConsumeViewModel()
    
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack{
            Color.green.ignoresSafeArea()
            
            VStack{
                Text("")
                Text("")
                Text("")
                Text("")
                GifImage("HealthyFood").frame(width:680,height:450).cornerRadius(30).shadow(radius: 20).padding(.bottom,35)
                

                GlucoseTextField(consumeViewModel: consumeViewModel)
                GlucoseButtonAndTags(consumeViewModel: consumeViewModel)

                Spacer()
                Spacer()
                
                HStack{
                    Text("Total Glucose : ").font(.system(size:35)).foregroundColor(.white).fontWeight(.bold)
                    
                    Text("\(consumeViewModel.totalGlucose, specifier:"%.2f") mg/dL").font(.system(size:35)).foregroundColor(.white).fontWeight(.black)
                }.padding(.bottom,20)
                
                Spacer()
                Spacer()
                
                Button(action:{
                    withAnimation{
                        consumeViewModel.submit()
                    }
                },label:{
                    VStack{
                        Text("SUBMIT").foregroundColor(.red).font(.system(size:20)).fontWeight(.bold)
                    }.frame(width:120,height:60).background(.white).cornerRadius(120)
                }).shadow(radius: 5)

                Spacer()
            }
            
            GlucoseDropdown(consumeViewModel:consumeViewModel)
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

struct GlucoseTextField:View{
    @ObservedObject var consumeViewModel:ConsumeViewModel
    
    var body : some View{
        VStack(alignment:.leading){
            HStack{
                Text("Glucose : ").font(.system(size:40)).fontWeight(.medium).foregroundColor(.white)
                VStack(spacing:5){
                    TextField("",text:$consumeViewModel.glucose).multilineTextAlignment(.center).font(.system(size:40)).foregroundColor(.white).frame(width:100).onChange(of:consumeViewModel.glucose){
                        
                        consumeViewModel.glucoseTextFieldOnChange()
                        
                    }
                    Text("").frame(width:100,height:1).background(.white)
                }
                Text("mg/dL").font(.system(size:40)).fontWeight(.medium).foregroundColor(.white)
            }
            .frame(width:500).padding(.top,10).padding(.bottom,10)
            
        }
        .frame(width:600).padding(.bottom,10)
    }
}

struct GlucoseDropdown:View{
    @ObservedObject var consumeViewModel:ConsumeViewModel
    @Environment(\.modelContext) var context

    @Query var allItems:[FoodGlucose]
    
    var body : some View{
        ZStack{
            ScrollView{
                VStack(spacing:0){
                    
                    ForEach(allItems,id:\.id){ food in
                        ZStack{
                            GlucoseDropDownMenu(consumeViewModel: consumeViewModel, food: food)
                        }
                        .frame(width:496,height:54).background(.white)
                    }
                    
                    
                    if consumeViewModel.addMoreOption{
                        OpenFormForNewFood(consumeViewModel: consumeViewModel)
                    }
                    else{
                        ZStack{
                            Button(action:{
                                withAnimation{
                                    consumeViewModel.setAddMoreOptionTrue()
                                }
                            },label:{
                                HStack{
                                    Text("Add More Option").font(.system(size:20)).fontWeight(.bold).foregroundColor(.green)
                                } .frame(width:496,height:52).background(.white)
                            })
                        }
                        .frame(width:496,height:54).background(.white)
                    }

                    
                }
            }
            .frame(width:496,height:consumeViewModel.frameMenuHeight).background(.green).cornerRadius(20)
        }
        .frame(width:500,height:consumeViewModel.frameMenuHeight+2).background(.white).cornerRadius(20).offset(x:70,y:consumeViewModel.offsetY).shadow(radius:10).opacity(consumeViewModel.dropOpacity)
    }
}

struct OpenFormForNewFood:View{
    
    @ObservedObject var consumeViewModel:ConsumeViewModel
    @Environment(\.modelContext) var context

    var body : some View{
        ZStack{
            HStack{
                TextField("",text:$consumeViewModel.addFood,prompt: Text("Input Your Food")
                    .foregroundColor(.lightGray).fontWeight(.regular)).font(.system(size:20)).fontWeight(.bold).foregroundColor(.white).padding([.leading,.trailing],20)
                
            }
            .frame(width:496,height:52).background(.green)
        }
        .frame(width:496,height:54).background(.white)
        

        ZStack{
            HStack{
                TextField("",text:$consumeViewModel.addGluco,prompt: Text("Input Your Food Glucose")
                    .foregroundColor(.lightGray).fontWeight(.regular)).font(.system(size:20)).fontWeight(.bold).foregroundColor(.white).padding([.leading,.trailing],20)
                
            }
            .frame(width:496,height:52).background(.green)
        }
        .frame(width:496,height:54).background(.white)
        
        ZStack{
            Button(action:{
                withAnimation{
                    if let glucose = Double(consumeViewModel.addGluco) {
                        let newFood = FoodGlucose(name: consumeViewModel.addFood, glucose: glucose)
                        
                        //consumeViewModel.allFood.append(newFood)
                        context.insert(newFood)
                        
                        if consumeViewModel.frameMenuHeight<378{
                            consumeViewModel.frameMenuHeight = consumeViewModel.frameMenuHeight + 54
                            consumeViewModel.offsetY = consumeViewModel.offsetY + 27
                        }
                    }
                }
            },label:{
                HStack{
                    Text("Add").font(.system(size:20)).fontWeight(.bold).foregroundColor(.green)
                    
                }
                .frame(width:496,height:52).background(.white)
            })
        }
        .frame(width:496,height:54).background(.white)
    }
}


struct GlucoseDropDownMenu:View{
    
    @ObservedObject var consumeViewModel:ConsumeViewModel
    @Environment(\.modelContext) var context
    var food:FoodGlucose

    var body : some View{
        HStack{
            Button(action:{
                withAnimation{
                    consumeViewModel.addFoodTags(food:food)
                }
            },label:{
                VStack{
                    Text("\(food.name) -  \(food.glucose,specifier:"%.2f") mg/dL").font(.system(size:20)).fontWeight(.bold).foregroundColor(.white)
                }
            })
            .padding(.leading,20)
            
            Spacer()
            Button(action:{
                withAnimation{
                    context.delete(food)
                    consumeViewModel.decreaseFrameMenu()
                }
            },label:{
                Text("X").foregroundColor(.white)
            })
            .padding(.trailing,20)
        }
        .frame(width:496,height:52).background(.green)
    }
}


struct GlucoseButtonAndTags:View{
    @ObservedObject var consumeViewModel:ConsumeViewModel
    @Environment(\.modelContext) var context
    
    var body : some View{
        VStack(alignment:.leading){
            HStack(spacing:10){
                Button(action:{
                    withAnimation{
                        consumeViewModel.onClickDropdown()
                    }
                },label:{
                    ZStack{
                        ZStack{
                            Image(systemName:"plus").font(.system(size:30)).foregroundColor(consumeViewModel.plusColor).fontWeight(.bold).rotationEffect(.degrees(consumeViewModel.rotation))
                        }.frame(width:45,height:45).background(consumeViewModel.plusBg).cornerRadius(180)
                    }.frame(width:50,height:50).background(.white).cornerRadius(180)
                })
                
                
                ScrollView(.horizontal){
                    HStack(spacing:10){
                        ForEach(consumeViewModel.foodList, id:\.id){food in
                            GlucoseTags(consumeViewModel: consumeViewModel, food: food)
                        }
                    }
                }

                
            }
            .frame(width:500,alignment:.leading)
        }
    }
}


struct GlucoseTags:View{
    @ObservedObject var consumeViewModel:ConsumeViewModel
    var food:FoodGlucose
    
    var body : some View{
        ZStack{
            ZStack{
                HStack{
                    Button(action:{
                        withAnimation{
                            consumeViewModel.deleteTags(food: food)
                        }
                    },label:{
                        Text("X").font(.system(size:18)).foregroundColor(.white).fontWeight(.black)
                    })
                    Text("\(food.name) (\(food.glucose, specifier:"%.2f"))"
                    ).font(.system(size:20)).foregroundColor(.white).fontWeight(.medium)
                    
                }.padding([.leading,.trailing],20)
            }.frame(height:45).background(.green).cornerRadius(180).padding(2.5)
        }.background(.white).cornerRadius(180)
    }
}


#Preview {
    NavigationStack{
        ConsumeView()
    }
}


/*
struct ConsumeView: View {
    @StateObject var consumeViewModel:ConsumeViewModel = ConsumeViewModel()
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack{
            Color.green.ignoresSafeArea()
            
            VStack{
                Text("")                
                Text("")
                Text("")
                Text("")
                GifImage("HealthyFood").frame(width:680,height:450).cornerRadius(30).shadow(radius: 20).padding(.bottom,35)
                
                VStack(alignment:.leading){
                    HStack{
                        Text("Glucose : ").font(.system(size:40)).fontWeight(.medium).foregroundColor(.white)
                        VStack(spacing:5){
                            TextField("",text:$consumeViewModel.glucose).multilineTextAlignment(.center).font(.system(size:40)).foregroundColor(.white).frame(width:100).onChange(of:consumeViewModel.glucose){
                                
                                if consumeViewModel.glucose==""{
                                    if let doubleGlucoseBefore = Double(consumeViewModel.glucoseBefore){
                                        consumeViewModel.totalGlucose = consumeViewModel.totalGlucose - doubleGlucoseBefore
                                        consumeViewModel.glucoseBefore = "0"
                                    }
                                }
                                else{
                                    if let doubleGlucose = Double(consumeViewModel.glucose){
                                        
                                        if let doubleGlucoseBefore = Double(consumeViewModel.glucoseBefore){
                                            consumeViewModel.totalGlucose = consumeViewModel.totalGlucose - doubleGlucoseBefore + doubleGlucose
                                            consumeViewModel.glucoseBefore = String(doubleGlucose)
                                        }
                                    }
                                }
                                
                            }
                            Text("").frame(width:100,height:1).background(.white)
                        }
                        Text("mg/dL").font(.system(size:40)).fontWeight(.medium).foregroundColor(.white)
                    }
                    .frame(width:500).padding(.top,10).padding(.bottom,10)
                    
                    
                }
                .frame(width:600).padding(.bottom,10)
                
                
                VStack(alignment:.leading){
                    HStack(spacing:10){
                        Button(action:{
                            withAnimation{
                                consumeViewModel.dropOpacity = abs(consumeViewModel.dropOpacity-1)
                                consumeViewModel.rotation=abs(consumeViewModel.rotation-45)
                                if consumeViewModel.plusBg==Color.green{
                                    consumeViewModel.plusBg=Color.white
                                    consumeViewModel.plusColor=Color.green
                                }
                                else{
                                    consumeViewModel.plusBg=Color.green
                                    consumeViewModel.plusColor=Color.white
                                }
                                
                                if consumeViewModel.addMoreOption{
                                    consumeViewModel.frameMenuHeight = consumeViewModel.frameMenuHeight - 108
                                    consumeViewModel.offsetY = consumeViewModel.offsetY - 54
                                }
                                
                                consumeViewModel.addMoreOption=false
                            }
                        },label:{
                            ZStack{
                                ZStack{
                                    Image(systemName:"plus").font(.system(size:30)).foregroundColor(consumeViewModel.plusColor).fontWeight(.bold).rotationEffect(.degrees(consumeViewModel.rotation))
                                }.frame(width:45,height:45).background(consumeViewModel.plusBg).cornerRadius(180)
                            }.frame(width:50,height:50).background(.white).cornerRadius(180)
                        })
                        
                        
                        ScrollView(.horizontal){
                            HStack(spacing:10){
                                ForEach(consumeViewModel.foodList, id:\.id){food in
                                    ZStack{
                                        ZStack{
                                            HStack{
                                                Button(action:{
                                                    withAnimation{
                                                        var index = -1
                                                        for selectedFood in consumeViewModel.foodList{
                                                            
                                                            index = index + 1
                                                            
                                                            if selectedFood.name == food.name && selectedFood.glucose == food.glucose{
                                                                consumeViewModel.foodList.remove(at:index)
                                                                consumeViewModel.totalGlucose = consumeViewModel.totalGlucose - food.glucose
                                                                break
                                                            }
                                                        }
                                                    }
                                                },label:{
                                                    Text("X").font(.system(size:18)).foregroundColor(.white).fontWeight(.black)
                                                })
                                                Text("\(food.name) (\(food.glucose, specifier:"%.2f"))"
                                                ).font(.system(size:20)).foregroundColor(.white).fontWeight(.medium)
                                                
                                            }.padding([.leading,.trailing],20)
                                        }.frame(height:45).background(.green).cornerRadius(180).padding(2.5)
                                    }.background(.white).cornerRadius(180)
                                }
                            }
                        }

                        
                    }
                    .frame(width:500,alignment:.leading)
                }
                
                Spacer()
                Spacer()
                
                HStack{
                    Text("Total Glucose : ").font(.system(size:35)).foregroundColor(.white).fontWeight(.bold)
                    
                    Text("\(consumeViewModel.totalGlucose, specifier:"%.2f") mg/dL").font(.system(size:35)).foregroundColor(.white).fontWeight(.black)
                }.padding(.bottom,20)
                
                Spacer()
                Spacer()
                
                Button(action:{
                    withAnimation{
                        consumeViewModel.foodList.removeAll()
                        consumeViewModel.glucose="0"
                        consumeViewModel.totalGlucose=0
                    }
                },label:{
                    VStack{
                        Text("SUBMIT").foregroundColor(.red).font(.system(size:20)).fontWeight(.bold)
                    }.frame(width:120,height:60).background(.white).cornerRadius(120)
                }).shadow(radius: 5)

                Spacer()
            }
            
            ZStack{
                ScrollView{
                    VStack(spacing:0){
                        
                        ForEach(consumeViewModel.allFood,id:\.id){ food in
                            ZStack{
                                HStack{
                                    Button(action:{
                                        withAnimation{
                                            consumeViewModel.foodList.append(food)
                                            consumeViewModel.totalGlucose = consumeViewModel.totalGlucose + food.glucose
                                        }
                                    },label:{
                                        VStack{
                                            Text("\(food.name) -  \(food.glucose,specifier:"%.2f") mg/dL").font(.system(size:20)).fontWeight(.bold).foregroundColor(.white)
                                        }
                                    })
                                    .padding(.leading,20)
                                    
                                    Spacer()
                                    Button(action:{
                                        withAnimation{
                                            var index = -1
                                            for selectedFood in consumeViewModel.allFood{
                                                index = index + 1
                                                if selectedFood.name == food.name && selectedFood.glucose == food.glucose{
                                                    consumeViewModel.allFood.remove(at:index)
                                                    break
                                                }
                                            }
                                            
                                            consumeViewModel.frameMenuHeight = consumeViewModel.frameMenuHeight - 54
                                            consumeViewModel.offsetY = consumeViewModel.offsetY - 27
                                        }
                                    },label:{
                                        Text("X").foregroundColor(.white)
                                    })
                                    .padding(.trailing,20)
                                }
                                .frame(width:496,height:52).background(.green)
                            }
                            .frame(width:496,height:54).background(.white)
                        }
                        
                        
                        if consumeViewModel.addMoreOption{
                            ZStack{
                                HStack{
                                    TextField("Input Your Food",text:$consumeViewModel.addFood).font(.system(size:20)).fontWeight(.bold).foregroundColor(.white).padding([.leading,.trailing],20)
                                    
                                }
                                .frame(width:496,height:52).background(.green)
                            }
                            .frame(width:496,height:54).background(.white)
                            
            
                            ZStack{
                                HStack{
                                    TextField("Input Your Food Glucose",text:$consumeViewModel.addGluco).font(.system(size:20)).fontWeight(.bold).foregroundColor(.white).padding([.leading,.trailing],20)
                                    
                                }
                                .frame(width:496,height:52).background(.green)
                            }
                            .frame(width:496,height:54).background(.white)
                            
                            ZStack{
                                Button(action:{
                                    withAnimation{
                                        if let glucose = Double(consumeViewModel.addGluco) {
                                            let newFood = FoodGlucose(name: consumeViewModel.addFood, glucose: consumeViewModel.glucose)
                                            consumeViewModel.allFood.append(newFood)
                                            
                                            if consumeViewModel.frameMenuHeight<378{
                                                consumeViewModel.frameMenuHeight = consumeViewModel.frameMenuHeight + 54
                                                consumeViewModel.offsetY = consumeViewModel.offsetY + 27
                                            }
                                        }
                                    }
                                },label:{
                                    HStack{
                                        Text("Add").font(.system(size:20)).fontWeight(.bold).foregroundColor(.green)
                                        
                                    }
                                    .frame(width:496,height:52).background(.white)
                                })
                            }
                            .frame(width:496,height:54).background(.white)
                        }
                        else{
                            ZStack{
                                Button(action:{
                                    withAnimation{
                                        consumeViewModel.addMoreOption = true
                                        
                                        consumeViewModel.frameMenuHeight = consumeViewModel.frameMenuHeight + 108
                                        
                                        consumeViewModel.offsetY = consumeViewModel.offsetY + 54
                                    }
                                },label:{
                                    HStack{
                                        Text("Add More Option").font(.system(size:20)).fontWeight(.bold).foregroundColor(.green)
                                    } .frame(width:496,height:52).background(.white)
                                })
                            }
                            .frame(width:496,height:54).background(.white)
                        }

                        
                    }
                }
                .frame(width:496,height:consumeViewModel.frameMenuHeight).background(.green).cornerRadius(20)
            }
            .frame(width:500,height:consumeViewModel.frameMenuHeight+2).background(.white).cornerRadius(20).offset(x:70,y:consumeViewModel.offsetY).shadow(radius:10).opacity(consumeViewModel.dropOpacity)
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
*/

/*
struct ExerView: View {

    @StateObject var exerciseViewModel:ExerciseViewModel = ExerciseViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack{
            Color.green.ignoresSafeArea()
            
            VStack{
                Text("")
                Text("")
                Text("")
                Text("")
                GifImage("HealthyFood").frame(width:680,height:450).cornerRadius(30).shadow(radius: 20).padding(.bottom,35)
                
                VStack(alignment:.leading){
                    HStack{
                        Text("Glucose : ").font(.system(size:40)).fontWeight(.medium).foregroundColor(.white)
                        VStack(spacing:5){
                            TextField("",text:$exerciseViewModel.glucose).multilineTextAlignment(.center).font(.system(size:40)).foregroundColor(.white).frame(width:100).onChange(of:exerciseViewModel.glucose){ _ in
                                
                                if exerciseViewModel.glucose==""{
                                    if let doubleGlucoseBefore = Double(exerciseViewModel.glucoseBefore){
                                        exerciseViewModel.totalGlucose = exerciseViewModel.totalGlucose - doubleGlucoseBefore
                                        exerciseViewModel.glucoseBefore = "0"
                                    }
                                }
                                else{
                                    if let doubleGlucose = Double(exerciseViewModel.glucose){
                                        
                                        if let doubleGlucoseBefore = Double(exerciseViewModel.glucoseBefore){
                                            exerciseViewModel.totalGlucose = exerciseViewModel.totalGlucose - doubleGlucoseBefore + doubleGlucose
                                            exerciseViewModel.glucoseBefore = String(doubleGlucose)
                                        }
                                    }
                                }
                                
                            }
                            Text("").frame(width:100,height:1).background(.white)
                        }
                        Text("mg/dL").font(.system(size:40)).fontWeight(.medium).foregroundColor(.white)
                    }
                    .frame(width:500).padding(.top,10).padding(.bottom,10)
                    
                    
                }
                .frame(width:600).padding(.bottom,10)
                
                
                VStack(alignment:.leading){
                    HStack(spacing:10){
                        Button(action:{
                            withAnimation{
                                exerciseViewModel.dropOpacity = abs(exerciseViewModel.dropOpacity-1)
                                exerciseViewModel.rotation=abs(exerciseViewModel.rotation-45)
                                if exerciseViewModel.plusBg==Color.green{
                                    exerciseViewModel.plusBg=Color.white
                                    exerciseViewModel.plusColor=Color.green
                                }
                                else{
                                    exerciseViewModel.plusBg=Color.green
                                    exerciseViewModel.plusColor=Color.white
                                }
                                
                                if exerciseViewModel.addMoreOption{
                                    exerciseViewModel.frameMenuHeight = exerciseViewModel.frameMenuHeight - 108
                                    exerciseViewModel.offsetY = exerciseViewModel.offsetY - 54
                                }
                                
                                exerciseViewModel.addMoreOption=false
                            }
                        },label:{
                            ZStack{
                                ZStack{
                                    Image(systemName:"plus").font(.system(size:30)).foregroundColor(exerciseViewModel.plusColor).fontWeight(.bold).rotationEffect(.degrees(exerciseViewModel.rotation))
                                }.frame(width:45,height:45).background(exerciseViewModel.plusBg).cornerRadius(180)
                            }.frame(width:50,height:50).background(.white).cornerRadius(180)
                        })
                        
                        
                        ScrollView(.horizontal){
                            HStack(spacing:10){
                                ForEach(exerciseViewModel.foodList, id:\.id){food in
                                    ZStack{
                                        ZStack{
                                            HStack{
                                                Button(action:{
                                                    withAnimation{
                                                        var index = -1
                                                        for selectedFood in exerciseViewModel.foodList{
                                                            
                                                            index = index + 1
                                                            
                                                            if selectedFood.name == food.name && selectedFood.glucose == food.glucose{
                                                                exerciseViewModel.foodList.remove(at:index)
                                                                exerciseViewModel.totalGlucose = exerciseViewModel.totalGlucose - food.glucose
                                                                break
                                                            }
                                                        }
                                                    }
                                                },label:{
                                                    Text("X").font(.system(size:18)).foregroundColor(.white).fontWeight(.black)
                                                })
                                                Text("\(food.name) (\(food.glucose, specifier:"%.2f"))"
                                                ).font(.system(size:20)).foregroundColor(.white).fontWeight(.medium)
                                                
                                            }.padding([.leading,.trailing],20)
                                        }.frame(height:45).background(.green).cornerRadius(180).padding(2.5)
                                    }.background(.white).cornerRadius(180)
                                }
                            }
                        }

                        
                    }
                    .frame(width:500,alignment:.leading)
                }
                
                Spacer()
                Spacer()
                
                HStack{
                    Text("Total Glucose : ").font(.system(size:35)).foregroundColor(.white).fontWeight(.bold)
                    
                    Text("\(exerciseViewModel.totalGlucose, specifier:"%.2f") mg/dL").font(.system(size:35)).foregroundColor(.white).fontWeight(.black)
                }.padding(.bottom,20)
                
                Spacer()
                Spacer()
                
                Button(action:{
                    withAnimation{
                        exerciseViewModel.foodList.removeAll()
                        exerciseViewModel.glucose="0"
                        exerciseViewModel.totalGlucose=0
                    }
                },label:{
                    VStack{
                        Text("SUBMIT").foregroundColor(.red).font(.system(size:20)).fontWeight(.bold)
                    }.frame(width:120,height:60).background(.white).cornerRadius(120)
                }).shadow(radius: 5)

                Spacer()
            }
            
            ZStack{
                ScrollView{
                    VStack(spacing:0){
                        
                        ForEach(exerciseViewModel.allFood,id:\.id){ food in
                            ZStack{
                                HStack{
                                    Button(action:{
                                        withAnimation{
                                            exerciseViewModel.foodList.append(food)
                                            exerciseViewModel.totalGlucose = exerciseViewModel.totalGlucose + food.glucose
                                        }
                                    },label:{
                                        VStack{
                                            Text("\(food.name) -  \(food.glucose,specifier:"%.2f") mg/dL").font(.system(size:20)).fontWeight(.bold).foregroundColor(.white)
                                        }
                                    })
                                    .padding(.leading,20)
                                    
                                    Spacer()
                                    Button(action:{
                                        withAnimation{
                                            var index = -1
                                            for selectedFood in exerciseViewModel.allFood{
                                                index = index + 1
                                                if selectedFood.name == food.name && selectedFood.glucose == food.glucose{
                                                    exerciseViewModel.allFood.remove(at:index)
                                                    break
                                                }
                                            }
                                            
                                            exerciseViewModel.frameMenuHeight = exerciseViewModel.frameMenuHeight - 54
                                            exerciseViewModel.offsetY = exerciseViewModel.offsetY - 27
                                        }
                                    },label:{
                                        Text("X").foregroundColor(.white)
                                    })
                                    .padding(.trailing,20)
                                }
                                .frame(width:496,height:52).background(.green)
                            }
                            .frame(width:496,height:54).background(.white)
                        }
                        
                        
                        if exerciseViewModel.addMoreOption{
                            ZStack{
                                HStack{
                                    TextField("Input Your Food",text:$exerciseViewModel.addFood).font(.system(size:20)).fontWeight(.bold).foregroundColor(.white).padding([.leading,.trailing],20)
                                    
                                }
                                .frame(width:496,height:52).background(.green)
                            }
                            .frame(width:496,height:54).background(.white)
                            
            
                            ZStack{
                                HStack{
                                    TextField("Input Your Food Glucose",text:$exerciseViewModel.addGluco).font(.system(size:20)).fontWeight(.bold).foregroundColor(.white).padding([.leading,.trailing],20)
                                    
                                }
                                .frame(width:496,height:52).background(.green)
                            }
                            .frame(width:496,height:54).background(.white)
                            
                            ZStack{
                                Button(action:{
                                    withAnimation{
                                        if let glucose = Double(exerciseViewModel.addGluco) {
                                            let newFood = ActivityCalor(name: exerciseViewModel.addFood, glucose: exerciseViewModel.glucose)
                                            exerciseViewModel.allFood.append(newFood)
                                            
                                            if exerciseViewModel.frameMenuHeight<378{
                                                exerciseViewModel.frameMenuHeight = exerciseViewModel.frameMenuHeight + 54
                                                exerciseViewModel.offsetY = exerciseViewModel.offsetY + 27
                                            }
                                        }
                                    }
                                },label:{
                                    HStack{
                                        Text("Add").font(.system(size:20)).fontWeight(.bold).foregroundColor(.green)
                                        
                                    }
                                    .frame(width:496,height:52).background(.white)
                                })
                            }
                            .frame(width:496,height:54).background(.white)
                        }
                        else{
                            ZStack{
                                Button(action:{
                                    withAnimation{
                                        exerciseViewModel.addMoreOption = true
                                        
                                        exerciseViewModel.frameMenuHeight = exerciseViewModel.frameMenuHeight + 108
                                        
                                        exerciseViewModel.offsetY = exerciseViewModel.offsetY + 54
                                    }
                                },label:{
                                    HStack{
                                        Text("Add More Option").font(.system(size:20)).fontWeight(.bold).foregroundColor(.green)
                                    } .frame(width:496,height:52).background(.white)
                                })
                            }
                            .frame(width:496,height:54).background(.white)
                        }

                        
                    }
                }
                .frame(width:496,height:exerciseViewModel.frameMenuHeight).background(.green).cornerRadius(20)
            }
            .frame(width:500,height:exerciseViewModel.frameMenuHeight+2).background(.white).cornerRadius(20).offset(x:70,y:exerciseViewModel.offsetY).shadow(radius:10).opacity(exerciseViewModel.dropOpacity)
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
*/
