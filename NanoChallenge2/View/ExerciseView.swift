//
//  ExerciseView.swift
//  NanoChallenge2
//
//  Created by Arrick Russell Adinoto on 20/05/24.
//

import SwiftUI
import SwiftData

struct ExerciseView: View {
    @StateObject var exerciseViewModel:ExerciseViewModel = ExerciseViewModel()
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack{
            Color.red.ignoresSafeArea()
            
            VStack{
                Text("")
                Text("")
                Text("")
                Text("")
                GifImage("JumpingExercise").frame(width:680,height:450).cornerRadius(30).shadow(radius: 20).padding(.bottom,35)
                

                CaloriesTextField(exerciseViewModel: exerciseViewModel)
                CaloriesButtonAndTags(exerciseViewModel: exerciseViewModel)

                Spacer()
                Spacer()
                
                HStack{
                    Text("Total Calories : ").font(.system(size:35)).foregroundColor(.white).fontWeight(.bold)
                    
                    Text("\(exerciseViewModel.totalCalories, specifier:"%.2f") cal").font(.system(size:35)).foregroundColor(.white).fontWeight(.black)
                }.padding(.bottom,20)
                
                Spacer()
                Spacer()
                
                Button(action:{
                    withAnimation{
                        exerciseViewModel.submit()
                    }
                },label:{
                    VStack{
                        Text("SUBMIT").foregroundColor(.red).font(.system(size:20)).fontWeight(.bold)
                    }.frame(width:120,height:60).background(.white).cornerRadius(120)
                }).shadow(radius: 5)

                Spacer()
            }
            
            CaloriesDropdown(exerciseViewModel: exerciseViewModel)
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

struct CaloriesTextField:View{
    @ObservedObject var exerciseViewModel:ExerciseViewModel
    
    var body : some View{
        VStack(alignment:.leading){
            HStack{
                Text("Calories : ").font(.system(size:40)).fontWeight(.medium).foregroundColor(.white)
                VStack(spacing:5){
                    TextField("",text:$exerciseViewModel.calories).multilineTextAlignment(.center).font(.system(size:40)).foregroundColor(.white).frame(width:100).onChange(of:exerciseViewModel.calories){
                        exerciseViewModel.caloriesTextFieldOnChange()
                    }
                    Text("").frame(width:100,height:1).background(.white)
                }
                Text("cal").font(.system(size:40)).fontWeight(.medium).foregroundColor(.white)
            }
            .frame(width:500).padding(.top,10).padding(.bottom,10)
            
            
        }
        .frame(width:600).padding(.bottom,10)
    }
}



struct CaloriesDropdown:View{
    @ObservedObject var exerciseViewModel:ExerciseViewModel
    
    @Query var allItems:[ActivityCalories]
    @Environment(\.modelContext) var context

    var body : some View{
        ZStack{
            ScrollView{
                VStack(spacing:0){
                    
                    ForEach(allItems,id:\.id){ activity in
                        ZStack{
                            CaloriesDropDownMenu(exerciseViewModel:exerciseViewModel,activity:activity)
                        }
                        .frame(width:496,height:54).background(.white)
                    }
                    
                    
                    if exerciseViewModel.addMoreOption{
                        OpenFormForNewActivity(exerciseViewModel: exerciseViewModel)
                    }
                    else{
                        ZStack{
                            Button(action:{
                                withAnimation{
                                    exerciseViewModel.setAddMoreOptionTrue()
                                }
                            },label:{
                                HStack{
                                    Text("Add More Option").font(.system(size:20)).fontWeight(.bold).foregroundColor(.red)
                                } .frame(width:496,height:52).background(.white)
                            })
                        }
                        .frame(width:496,height:54).background(.white)
                    }

                    
                }
            }
            .frame(width:496,height:exerciseViewModel.frameMenuHeight).background(.red).cornerRadius(20)
        }
        .frame(width:500,height:exerciseViewModel.frameMenuHeight+2).background(.white).cornerRadius(20).offset(x:70,y:exerciseViewModel.offsetY).shadow(radius:10).opacity(exerciseViewModel.dropOpacity)
    }
}

struct CaloriesDropDownMenu:View{
    @ObservedObject var exerciseViewModel:ExerciseViewModel
    @Environment(\.modelContext) var context
    var activity:ActivityCalories
    var body : some View{
        HStack{
            Button(action:{
                withAnimation{
                    exerciseViewModel.addActivityTags(activity:activity)
                }
            },label:{
                VStack{
                    Text("\(activity.name) -  \(activity.calories,specifier:"%.2f") cal").font(.system(size:20)).fontWeight(.bold).foregroundColor(.white)
                }
            })
            .padding(.leading,20)
            
            Spacer()
            Button(action:{
                withAnimation{
                    /*
                    var index = -1
                    for selectedFood in exerciseViewModel.allActivity{
                        index = index + 1
                        if selectedFood.name == food.name && selectedFood.calories == food.calories{
                            exerciseViewModel.allActivity.remove(at:index)
                            break
                        }
                    }
                    */
                    context.delete(activity)
                    
                    exerciseViewModel.frameMenuHeight = exerciseViewModel.frameMenuHeight - 54
                    exerciseViewModel.offsetY = exerciseViewModel.offsetY - 27
                }
            },label:{
                Text("X").foregroundColor(.white)
            })
            .padding(.trailing,20)
        }
        .frame(width:496,height:52).background(.red)
    }
}

struct OpenFormForNewActivity:View{
    
    @ObservedObject var exerciseViewModel:ExerciseViewModel
    @Environment(\.modelContext) var context
    
    var body : some View{
        ZStack{
            HStack{
                TextField("",text:$exerciseViewModel.addActivity,prompt: Text("Input Your Activity")
                    .foregroundColor(.lightGray).fontWeight(.regular)).font(.system(size:20)).fontWeight(.bold).foregroundColor(.white).padding([.leading,.trailing],20)
                
            }
            .frame(width:496,height:52).background(.red)
        }
        .frame(width:496,height:54).background(.white)
        

        ZStack{
            HStack{
                TextField("",text:$exerciseViewModel.addCalories,prompt: Text("Input Your Activity Calories")
                    .foregroundColor(.lightGray).fontWeight(.regular)).font(.system(size:20)).fontWeight(.bold).foregroundColor(.white).padding([.leading,.trailing],20)
                
            }
            .frame(width:496,height:52).background(.red)
        }
        .frame(width:496,height:54).background(.white)
        
        ZStack{
            Button(action:{
                withAnimation{
                    if let glucose = Double(exerciseViewModel.addCalories) {
                        let newFood = ActivityCalories(name: exerciseViewModel.addActivity, calories: glucose)
                        
                        //exerciseViewModel.allActivity.append(newFood)
                        context.insert(newFood)
                        
                        if exerciseViewModel.frameMenuHeight<378{
                            exerciseViewModel.frameMenuHeight = exerciseViewModel.frameMenuHeight + 54
                            exerciseViewModel.offsetY = exerciseViewModel.offsetY + 27
                        }
                    }
                }
            },label:{
                HStack{
                    Text("Add").font(.system(size:20)).fontWeight(.bold).foregroundColor(.red)
                    
                }
                .frame(width:496,height:52).background(.white)
            })
        }
        .frame(width:496,height:54).background(.white)
    }
}

/*
struct MyView2_1:View{
    @ObservedObject var exerciseViewModel:ExerciseViewModel
    
    var body : some View{
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
                        /*
                        ForEach(exerciseViewModel.activityList, id:\.id){food in
                            ZStack{
                                ZStack{
                                    HStack{
                                        Button(action:{
                                            withAnimation{
                                                var index = -1
                                                for selectedFood in exerciseViewModel.activityList{
                                                    
                                                    index = index + 1
                                                    
                                                    
                                                    let check1 = selectedFood.name == food.name
                                                    
                                                    let check2 = Double(selectedFood.calories) == Double(food.calories)
                                                    
                                                    if check1 && check2 {
                                                        exerciseViewModel.activityList.remove(at:index)
                                                        exerciseViewModel.totalCalories = exerciseViewModel.totalCalories - food.glucose
                                                        break
                                                    }
                                                    
                                                }
                                            }
                                        },label:{
                                            Text("X").font(.system(size:18)).foregroundColor(.white).fontWeight(.black)
                                        })
                                        Text("\(food.name) ").font(.system(size:20)).foregroundColor(.white).fontWeight(.medium)
                                        //Text("(\(food.calories, specifier:"%.2f"))" as String).font(.system(size:20)).foregroundColor(.white).fontWeight(.medium)
                                        Text("(\(food.calories))" as String).font(.system(size:20)).foregroundColor(.white).fontWeight(.medium)
                                        
                                        //Text("\(food.name) (\(food.calories, specifier:"%.2f"))").font(.system(size:20)).foregroundColor(.white).fontWeight(.medium)
                                        
                                    }.padding([.leading,.trailing],20)
                                }.frame(height:45).background(.green).cornerRadius(180).padding(2.5)
                            }.background(.white).cornerRadius(180)
                        }
                         */
                        ForEach(0..<exerciseViewModel.activityList.count, id:\.self){ index in
                            ZStack{
                                ZStack{
                                    HStack{
                                        Button(action:{
                                            withAnimation{
                                                exerciseViewModel.activityList.remove(at:index)
                                            }
                                        },label:{
                                            
                                        })
                                        
                                        /*
                                        Button(action:{
                                            withAnimation{
                                                exerciseViewModel.activityList.remove(at:i)
                                                }
                                            }
                                        },label:{
                                            Text("X").font(.system(size:18)).foregroundColor(.white).fontWeight(.black)
                                        })
                                        Text("\(food.name) ").font(.system(size:20)).foregroundColor(.white).fontWeight(.medium)
                                        //Text("(\(food.calories, specifier:"%.2f"))" as String).font(.system(size:20)).foregroundColor(.white).fontWeight(.medium)
                                        Text("(\(food.calories))" as String).font(.system(size:20)).foregroundColor(.white).fontWeight(.medium)
                                        
                                        //Text("\(food.name) (\(food.calories, specifier:"%.2f"))").font(.system(size:20)).foregroundColor(.white).fontWeight(.medium)
                                        */
                                        
                                        
                                        
                                    }.padding([.leading,.trailing],20)
                                }.frame(height:45).background(.green).cornerRadius(180).padding(2.5)
                            }.background(.white).cornerRadius(180)
                        }
                    }
                }

                
            }
            .frame(width:500,alignment:.leading)
        }
    }
}
*/


struct CaloriesButtonAndTags:View{
    @ObservedObject var exerciseViewModel:ExerciseViewModel
    
    var body : some View{
        VStack(alignment:.leading){
            HStack(spacing:10){
                Button(action:{
                    withAnimation{
                        exerciseViewModel.onClickDropDown()
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
                        ForEach(0..<exerciseViewModel.activityList.count, id:\.self){ index in
                            ZStack{
                                ZStack{
                                    HStack{
                                        Button(action:{
                                            withAnimation{
                                                exerciseViewModel.totalCalories = exerciseViewModel.totalCalories - exerciseViewModel.activityList[index].calories
                                                exerciseViewModel.activityList.remove(at:index)
                                            }
                                            
                                        },label:{
                                            Text("X").font(.system(size:18)).foregroundColor(.white).fontWeight(.black)
                                        })
                                        Text("\(exerciseViewModel.activityList[index].name) (\(exerciseViewModel.activityList[index].calories, specifier:"%.2f")) ").font(.system(size:20)).foregroundColor(.white).fontWeight(.medium)
                                    }.padding([.leading,.trailing],20)
                                     
                                }.frame(height:45).background(.red).cornerRadius(180).padding(2.5)
                                 
                            }.background(.white).cornerRadius(180)
                        }
                    }
                }
                
                
            }
            .frame(width:500,alignment:.leading)
        }
    }
}
/*
struct CaloriesTags:View{
    @ObservedObject var exerciseViewModel:ExerciseViewModel
    var index:Int
    var body : some View{
        ZStack{
            ZStack{
                HStack{
                    Button(action:{
                        withAnimation{
                            exerciseViewModel.totalCalories = exerciseViewModel.totalCalories - exerciseViewModel.activityList[index].calories
                            exerciseViewModel.activityList.remove(at:index)
                        }
                        
                    },label:{
                        Text("X").font(.system(size:18)).foregroundColor(.white).fontWeight(.black)
                    })
                    Text("\(exerciseViewModel.activityList[index].name) (\(exerciseViewModel.activityList[index].calories, specifier:"%.2f")) ").font(.system(size:20)).foregroundColor(.white).fontWeight(.medium)
                }.padding([.leading,.trailing],20)
                 
            }.frame(height:45).background(.red).cornerRadius(180).padding(2.5)
             
        }.background(.white).cornerRadius(180)
    }
}
*/

#Preview {
    NavigationStack{
        ExerciseView()
    }
}


/*
struct ExerciseView: View{
    @Environment(\.dismiss) var dismiss
    @State var numberCal:String = "0"
    @State var selectedMenu:String = "Manual Input"
    
    var body : some View{
        ZStack{
            Color.red.ignoresSafeArea()
            VStack{
                Picker("Choose Input Method",selection:$selectedMenu){
                    Text("Manual Input").tag("Manual Input")
                    Text("Apple Watch").tag("Apple Watch")
                }
                .pickerStyle(.segmented)
                .frame(width:500,height:90).scaleEffect(1.5)
                
                if selectedMenu == "Manual Input"{
                    //AddExercise()
                    //ExerciseView2()
                }
                else{
                    AppleWatch()
                }
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

struct AppleWatch:View{
    var body : some View{
        VStack{
            Spacer()
            
            GifImage("AppleWatch").frame(width:700,height:530).cornerRadius(30).shadow(radius: 20)
            Spacer()
            
            Button(action:{
                
            },label:{
                VStack{
                    Text("Sync to Watch OS").foregroundColor(.red).font(.system(size:20)).fontWeight(.bold)
                }.frame(width:220,height:60).background(.white).cornerRadius(90)
            }).offset(y:-80).shadow(radius: 5)
            
            Spacer()
        }
    }
}
/*
struct AddExercise: View {
    @State var calories:String="0"
    @State var caloriesBefore:String="0"
    
    @State var addActivity:String=""
    @State var addCalories:String=""
    
    @State var dropOpacity:Double=0
    
    @State var activityList:[ActivityCalories]=[]//[FoodGlucose(name:"Nasi Goreng",glucose:112),FoodGlucose(name:"Ayam Bakar",glucose:112),FoodGlucose(name:"Ice Lemon Tea",glucose:112)]

    @State var allActivity:[ActivityCalories]=[ActivityCalories(name:"Nasi Goreng",calories:112),ActivityCalories(name:"Ayam Bakar",calories:112),ActivityCalories(name:"Ice Lemon Tea",calories:112)]

    
    @State var rotation:Double=0
    @State var plusBg:Color=Color.red
    @State var plusColor:Color=Color.white
    
    @State var addMoreOption:Bool=false
    
    @State var totalCalories:Double=0
    
    @State var frameMenuHeight:Double=216
    @State var offsetY:CGFloat=245
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack{
            Color.red.ignoresSafeArea()
            
            VStack{
                Text("")
                Text("")
                Text("")
                Text("")
                GifImage("JumpingExercise").frame(width:680,height:450).cornerRadius(30).shadow(radius: 20).padding(.bottom,35)
                
                CaloriesTextField(calories: $calories, caloriesBefore: $caloriesBefore, totalCalories: $totalCalories)
                
                //Plus and Scroll
                
                Spacer()
                Spacer()
                
                HStack{
                    Text("Total Calories : ").font(.system(size:35)).foregroundColor(.white).fontWeight(.bold)
                    
                    Text("\(totalCalories, specifier:"%.2f") cal").font(.system(size:35)).foregroundColor(.white).fontWeight(.black)
                }.padding(.bottom,20)
                
                Spacer()
                Spacer()
                
                Button(action:{
                    withAnimation{
                        activityList.removeAll()
                        calories="0"
                        totalCalories=0
                    }
                },label:{
                    VStack{
                        Text("SUBMIT").foregroundColor(.red).font(.system(size:20)).fontWeight(.bold)
                    }.frame(width:120,height:60).background(.white).cornerRadius(120)
                }).shadow(radius: 5)

                Spacer()
            }
            /*
            ZStack{
                ScrollView{
                    VStack(spacing:0){
                        
                        ForEach(allActivity,id:\.id){activity in
                            ZStack{
                                HStack{
                                    Button(action:{
                                        withAnimation{
                                            activityList.append(activity)
                                            totalCalories = totalCalories + activity.glucose
                                        }
                                    },label:{
                                        VStack{
                                            Text("\(activity.name) -  \(activity.calories,specifier:"%.2f") cal").font(.system(size:20)).fontWeight(.bold).foregroundColor(.white)
                                        }
                                    })
                                    .padding(.leading,20)
                                    
                                    Spacer()
                                    Button(action:{
                                        withAnimation{
                                            var index = -1
                                            for selectedFood in allActivity{
                                                index = index + 1
                                                if selectedFood.name == activity.name && selectedFood.glucose == activity.glucose{
                                                    allActivity.remove(at:index)
                                                    break
                                                }
                                            }
                                            
                                            frameMenuHeight = frameMenuHeight - 54
                                            offsetY = offsetY - 27
                                        }
                                    },label:{
                                        Text("X").foregroundColor(.white)
                                    })
                                    .padding(.trailing,20)
                                }
                                .frame(width:496,height:52).background(.red)
                            }
                            .frame(width:496,height:54).background(.white)
                        }
                        
                        
                        if addMoreOption{
                            ZStack{
                                HStack{
                                    TextField("Input Your Food",text:$addActivity).font(.system(size:20)).fontWeight(.bold).foregroundColor(.white).padding([.leading,.trailing],20)
                                    
                                }
                                .frame(width:496,height:52).background(.red)
                            }
                            .frame(width:496,height:54).background(.white)
                            
            
                            ZStack{
                                HStack{
                                    TextField("Input Your Food Glucose",text:$addCalories).font(.system(size:20)).fontWeight(.bold).foregroundColor(.white).padding([.leading,.trailing],20)
                                    
                                }
                                .frame(width:496,height:52).background(.red)
                            }
                            .frame(width:496,height:54).background(.white)
                            
                            ZStack{
                                Button(action:{
                                    withAnimation{
                                        if let calories = Double(addCalories) {
                                            let newFood = FoodGlucose(name: addActivity, glucose: calories)
                                            allActivity.append(newFood)
                                            
                                            if frameMenuHeight<270{
                                                frameMenuHeight = frameMenuHeight + 54
                                                offsetY = offsetY + 27
                                            }
                                        }
                                    }
                                },label:{
                                    HStack{
                                        Text("Add").font(.system(size:20)).fontWeight(.bold).foregroundColor(.red)
                                        
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
                                        addMoreOption = true
                                        
                                        frameMenuHeight = frameMenuHeight + 108
                                        
                                        offsetY = offsetY + 54
                                    }
                                },label:{
                                    HStack{
                                        Text("Add More Option").font(.system(size:20)).fontWeight(.bold).foregroundColor(.red)
                                    } .frame(width:496,height:52).background(.white)
                                })
                            }
                            .frame(width:496,height:54).background(.white)
                        }

                        
                    }
                }
                .frame(width:496,height:frameMenuHeight).background(.red).cornerRadius(20)
            }
            .frame(width:500,height:frameMenuHeight+2).background(.white).cornerRadius(20).offset(x:70,y:offsetY).shadow(radius:10).opacity(dropOpacity)
            
            */
        }
    }
}

struct PlusAndTags:View{
    
    @Binding var dropOpacity:Double
    @Binding var rotation:Double
    @Binding var plusBg:Color
    @Binding var plusColor:Color
    @Binding var addMoreOption:Bool
    @Binding var frameMenuHeight:Double
    @Binding var offsetY:CGFloat
    @Binding var activityList:[ActivityCalories]
    @Binding var totalCalories:Double
    
    var body : some View{
        VStack(alignment:.leading){
            HStack(spacing:10){
                Button(action:{
                    withAnimation{
                        dropOpacity = abs(dropOpacity-1)
                        rotation=abs(rotation-45)
                        if plusBg==Color.red{
                            plusBg=Color.white
                            plusColor=Color.red
                        }
                        else{
                            plusBg=Color.red
                            plusColor=Color.white
                        }
                        
                        if addMoreOption{
                            frameMenuHeight = frameMenuHeight - 108
                            offsetY = offsetY - 54
                        }
                        
                        addMoreOption=false
                    }
                },label:{
                    ZStack{
                        ZStack{
                            Image(systemName:"plus").font(.system(size:30)).foregroundColor(plusColor).fontWeight(.bold).rotationEffect(.degrees(rotation))
                        }.frame(width:45,height:45).background(plusBg).cornerRadius(180)
                    }.frame(width:50,height:50).background(.white).cornerRadius(180)
                })
                
                
                ExerciseScrollView(activityList:$activityList, totalCalories:$totalCalories)

                
            }
            .frame(width:500,alignment:.leading)
        }
    }
}


struct ExerciseScrollView:View{
    
    @Binding var activityList:[ActivityCalories]
    @Binding var totalCalories:Double
    
    var body : some View{
        ScrollView(.horizontal){
            HStack(spacing:10){
                ForEach($activityList, id:\.id){food in
                    ZStack{
                        ZStack{
                            HStack{
                                
                                Button(action:{
                                    withAnimation{
                                        var index = -1
                                        for selectedFood in activityList{
                                            
                                            index = index + 1
                                            /*
                                            let stringSelectedFood = String(selectedFood.name)
                                            //let food_check:Bool = (stringSelectedFood == food.name)
                                            
                                            if let stringSelectedFood = selectedFood.name{
                                                
                                            }
                                            */
                                            
                                            //if stringSelectedFood
                                            
                                            
                                            /*
                                            if  && Double(selectedFood.calories) == food.calories{
                                                activityList.remove(at:index)
                                                totalCalories = totalCalories - food.calories
                                                break
                                            }
                                             */
                                        }
                                    }
                                },label:{
                                    Text("X").font(.system(size:18)).foregroundColor(.white).fontWeight(.black)
                                })
                                
                                //Text("\(food.name) (\(food.calories, specifier:"%.2f"))").font(.system(size:20)).foregroundColor(.white).fontWeight(.medium)
                                
                            }.padding([.leading,.trailing],20)
                        }.frame(height:45).background(.green).cornerRadius(180).padding(2.5)
                    }.background(.white).cornerRadius(180)
                }
            }
        }
    }
}

struct CaloriesTextField:View{
    
    @Binding var calories:String
    @Binding var caloriesBefore:String
    @Binding var totalCalories:Double
    
    var body : some View{
        VStack(alignment:.leading){
            HStack{
                Text("Calories : ").font(.system(size:40)).fontWeight(.medium).foregroundColor(.white)
                VStack(spacing:5){
                    TextField("",text:$calories).multilineTextAlignment(.center).font(.system(size:40)).foregroundColor(.white).frame(width:100).onChange(of:calories){
                        
                        if calories==""{
                            if let doubleCaloriesBefore = Double(caloriesBefore){
                                totalCalories = totalCalories - doubleCaloriesBefore
                                caloriesBefore = "0"
                            }
                        }
                        else{
                            
                            if let doubleCalories = Double(calories){
                                
                                if let doubleCaloriesBefore = Double(caloriesBefore){
                                    totalCalories = totalCalories - doubleCaloriesBefore + doubleCalories
                                    caloriesBefore = String(doubleCalories)
                                }
                            }
                             
                        }
                        
                    }
                    Text("").frame(width:100,height:1).background(.white)
                }
                Text("cal").font(.system(size:40)).fontWeight(.medium).foregroundColor(.white)
            }
            .frame(width:500).padding(.top,10).padding(.bottom,10)
            
            
        }
        .frame(width:600).padding(.bottom,10)
    }
}
*/



#Preview {
    NavigationStack{
        //AddExercise()
    }
}


/*
import SwiftUI

struct ActivityCalories: Identifiable {
    var id = UUID()
    var name: String
    var calories: Double
}

struct ConsumeView2: View {
    @State var calories: String = "0"
    @State var caloriesBefore: String = "0"
    
    @State var addActivity: String = ""
    @State var addCalories: String = ""
    
    @State var dropOpacity: Double = 0
    
    @State var activityList: [ActivityCalories] = []
    @State var allActivities: [ActivityCalories] = [ActivityCalories(name: "Jalan Pagi", calories: 112)]
    
    @State var rotation: Double = 0
    @State var plusBg: Color = Color.green
    @State var plusColor: Color = Color.white
    
    @State var addMoreOption: Bool = false
    
    @State var totalCalories: Double = 0
    
    @State var frameMenuHeight: Double = 216
    @State var offsetY: CGFloat = 200
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color.red.ignoresSafeArea()
            
            VStack {
                Spacer(minLength: 40)
                GifImage("JumpingExercise").frame(width: 680, height: 450).cornerRadius(30).shadow(radius: 20).padding(.bottom, 35)
                
                GlucoseInputView(calories: $calories, caloriesBefore: $caloriesBefore, totalCalories: $totalCalories)
                
                ActivityListView(activityList: $activityList, totalCalories: $totalCalories)
                
                Spacer()
                TotalGlucoseView(totalGlucose: $totalCalories)
                Spacer()
                SubmitButton(action: {
                    withAnimation {
                        activityList.removeAll()
                        calories = "0"
                        totalCalories = 0
                    }
                })
                Spacer()
            }
            
            DropDownMenu(
                allActivities: $allActivities,
                addFood: $addActivity,
                addGluco: $addCalories,
                frameMenuHeight: $frameMenuHeight,
                offsetY: $offsetY,
                dropOpacity: $dropOpacity,
                addMoreOption: $addMoreOption,
                totalGlucose: $totalCalories,
                activityList: $activityList
            )
            .frame(width: 500, height: frameMenuHeight + 2)
            .background(Color.white)
            .cornerRadius(20)
            .offset(x: 70, y: offsetY)
            .shadow(radius: 10)
            .opacity(0)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    dismiss()
                }, label: {
                    Image(systemName: "chevron.backward").foregroundColor(.white)
                    Text("Back").foregroundColor(.white)
                })
            }
        }
    }
}

struct GlucoseInputView: View {
    @Binding var calories: String
    @Binding var caloriesBefore: String
    @Binding var totalCalories: Double
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Glucose : ").font(.system(size: 40)).fontWeight(.medium).foregroundColor(.white)
                VStack(spacing: 5) {
                    TextField("", text: $calories)
                        .multilineTextAlignment(.center)
                        .font(.system(size: 40))
                        .foregroundColor(.white)
                        .frame(width: 100)
                        .onChange(of: calories) { newValue in
                            updateCalories(newValue: newValue)
                        }
                    Text("").frame(width: 100, height: 1).background(Color.white)
                }
                Text("mg/dL").font(.system(size: 40)).fontWeight(.medium).foregroundColor(.white)
            }
            .frame(width: 500)
            .padding(.vertical, 10)
        }
        .frame(width: 600)
        .padding(.bottom, 10)
    }
    
    private func updateCalories(newValue: String) {
        if newValue.isEmpty {
            if let doubleCaloriesBefore = Double(caloriesBefore) {
                totalCalories -= doubleCaloriesBefore
                caloriesBefore = "0"
            }
        } else {
            if let doubleCalories = Double(newValue) {
                if let doubleCaloriesBefore = Double(caloriesBefore) {
                    totalCalories = totalCalories - doubleCaloriesBefore + doubleCalories
                    caloriesBefore = String(doubleCalories)
                }
            }
        }
    }
}

struct ActivityListView: View {
    @Binding var activityList: [ActivityCalories]
    @Binding var totalCalories: Double
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 10) {
                ScrollView(.horizontal) {
                    HStack(spacing: 10) {
                        ForEach(activityList) { activity in
                            ActivityItemView(activity:activity, activityList: $activityList, totalCalories: $totalCalories)
                        }
                    }
                }
            }
            .frame(width: 500, alignment: .leading)
        }
    }
}

struct ActivityItemView: View {
    var activity: ActivityCalories
    @Binding var activityList: [ActivityCalories]
    @Binding var totalCalories: Double
    
    var body: some View {
        ZStack {
            HStack {
                Button(action: {
                    withAnimation {
                        if let index = activityList.firstIndex(where: { $0.id == activity.id }) {
                            activityList.remove(at: index)
                            totalCalories -= activity.calories
                        }
                    }
                }, label: {
                    Text("X").font(.system(size: 18)).foregroundColor(.white).fontWeight(.black)
                })
                Text("\(activity.name) (\(activity.calories, specifier: "%.2f"))")
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                    .fontWeight(.medium)
                    .padding([.leading, .trailing], 20)
            }
            .frame(height: 45)
            .background(Color.green)
            .cornerRadius(180)
            .padding(2.5)
        }
        .background(Color.white)
        .cornerRadius(180)
    }
}

struct TotalGlucoseView: View {
    @Binding var totalGlucose: Double
    
    var body: some View {
        HStack {
            Text("Total Glucose : ").font(.system(size: 35)).foregroundColor(.white).fontWeight(.bold)
            Text("\(totalGlucose, specifier: "%.2f") mg/dL").font(.system(size: 35)).foregroundColor(.white).fontWeight(.black)
        }
        .padding(.bottom, 20)
    }
}

struct SubmitButton: View {
    var action: () -> Void
    
    var body: some View {
        Button(action: {
            action()
        }, label: {
            VStack {
                Text("SUBMIT").foregroundColor(.red).font(.system(size: 20)).fontWeight(.bold)
            }
            .frame(width: 120, height: 60)
            .background(Color.white)
            .cornerRadius(120)
        })
        .shadow(radius: 5)
    }
}

struct DropDownMenu: View {
    @Binding var allActivities: [ActivityCalories]
    @Binding var addFood: String
    @Binding var addGluco: String
    @Binding var frameMenuHeight: Double
    @Binding var offsetY: CGFloat
    @Binding var dropOpacity: Double
    @Binding var addMoreOption: Bool
    @Binding var totalGlucose: Double
    @Binding var activityList: [ActivityCalories]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                ForEach(allActivities) { food in
                    ActivityRowView(food: food, allActivities: $allActivities, frameMenuHeight: $frameMenuHeight, offsetY: $offsetY, totalGlucose: $totalGlucose, activityList: $activityList)
                }
                
                if addMoreOption {
                    AddFoodFields(addFood: $addFood, addGluco: $addGluco)
                    
                    AddButton(action: {
                        withAnimation {
                            if let glucose = Double(addGluco) {
                                let newFood = ActivityCalories(name: addFood, calories: glucose)
                                allActivities.append(newFood)
                                if frameMenuHeight < 378 {
                                    frameMenuHeight += 54
                                    offsetY += 27
                                }
                            }
                        }
                    })
                } else {
                    AddMoreOptionButton(action: {
                        withAnimation {
                            addMoreOption = true
                            frameMenuHeight += 108
                            offsetY += 54
                        }
                    })
                }
            }
        }
        .frame(width: 496, height: frameMenuHeight)
        .background(Color.green)
        .cornerRadius(20)
    }
}

struct ActivityRowView: View {
    var food: ActivityCalories
    @Binding var allActivities: [ActivityCalories]
    @Binding var frameMenuHeight: Double
    @Binding var offsetY: CGFloat
    @Binding var totalGlucose: Double
    @Binding var activityList: [ActivityCalories]
    
    var body: some View {
        ZStack {
            HStack {
                Button(action: {
                    withAnimation {
                        activityList.append(food)
                        totalGlucose += food.calories
                    }
                }, label: {
                    VStack {
                        Text("\(food.name) -  \(food.calories, specifier: "%.2f") mg/dL")
                            .font(.system(size: 20))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                })
                .padding(.leading, 20)
                
                Spacer()
                Button(action: {
                    withAnimation {
                        if let index = allActivities.firstIndex(where: { $0.id == food.id }) {
                            allActivities.remove(at: index)
                            frameMenuHeight -= 54
                            offsetY -= 27
                        }
                    }
                }, label: {
                    Text("X").foregroundColor(.white)
                })
                .padding(.trailing, 20)
            }
            .frame(width: 496, height: 52)
            .background(Color.green)
        }
        .frame(width: 496, height: 54)
        .background(Color.white)
    }
}

struct AddFoodFields: View {
    @Binding var addFood: String
    @Binding var addGluco: String
    
    var body: some View {
        ZStack {
            HStack {
                TextField("Input Your Food", text: $addFood)
                    .font(.system(size: 20))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding([.leading, .trailing], 20)
            }
            .frame(width: 496, height: 52)
            .background(Color.green)
        }
        .frame(width: 496, height: 54)
        .background(Color.white)
        
        ZStack {
            HStack {
                TextField("Input Your Food Glucose", text: $addGluco)
                    .font(.system(size: 20))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding([.leading, .trailing], 20)
            }
            .frame(width: 496, height: 52)
            .background(Color.green)
        }
        .frame(width: 496, height: 54)
        .background(Color.white)
    }
}

struct AddButton: View {
    var action: () -> Void
    
    var body: some View {
        ZStack {
            Button(action: {
                action()
            }, label: {
                HStack {
                    Text("Add")
                        .font(.system(size: 20))
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                }
                .frame(width: 496, height: 52)
                .background(Color.white)
            })
        }
        .frame(width: 496, height: 54)
        .background(Color.white)
    }
}

struct AddMoreOptionButton: View {
    var action: () -> Void
    
    var body: some View {
        ZStack {
            Button(action: {
                action()
            }, label: {
                HStack {
                    Text("Add More Option")
                        .font(.system(size: 20))
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                }
                .frame(width: 496, height: 52)
                .background(Color.white)
            })
        }
        .frame(width: 496, height: 54)
        .background(Color.white)
    }
}
*/

/*
struct AddExercise: View {
    @State var calories:String="0"
    @State var caloriesBefore:String="0"
    
    @State var addActivity:String=""
    @State var addCalories:String=""
    
    @State var dropOpacity:Double=0
    
    @State var activityList:[ActivityCalories]=[]//[FoodGlucose(name:"Nasi Goreng",glucose:112),FoodGlucose(name:"Ayam Bakar",glucose:112),FoodGlucose(name:"Ice Lemon Tea",glucose:112)]
    
    @State var foodList:[FoodGlucose]=[]
    
    @State var allActivity:[ActivityCalories]=[ActivityCalories(name:"Nasi Goreng",calories:112),ActivityCalories(name:"Ayam Bakar",calories:112),ActivityCalories(name:"Ice Lemon Tea",calories:112)]
    
    @State var allFood:[FoodGlucose]=[FoodGlucose(name:"Nasi Goreng",glucose:112),FoodGlucose(name:"Ayam Bakar",glucose:112),FoodGlucose(name:"Ice Lemon Tea",glucose:112)]
    
    @State var rotation:Double=0
    @State var plusBg:Color=Color.red
    @State var plusColor:Color=Color.white
    
    @State var addMoreOption:Bool=false
    
    @State var totalCalories:Double=0
    
    @State var frameMenuHeight:Double=216
    @State var offsetY:CGFloat=245
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack{
            Color.red.ignoresSafeArea()
            
            VStack{
                Text("")
                Text("")
                Text("")
                Text("")
                GifImage("JumpingExercise").frame(width:680,height:450).cornerRadius(30).shadow(radius: 20).padding(.bottom,35)
                
                VStack(alignment:.leading){
                    HStack{
                        Text("Calories : ").font(.system(size:40)).fontWeight(.medium).foregroundColor(.white)
                        VStack(spacing:5){
                            TextField("",text:$calories).multilineTextAlignment(.center).font(.system(size:40)).foregroundColor(.white).frame(width:100).onChange(of:calories){
                                
                                if calories==""{
                                    if let doubleCaloriesBefore = Double(caloriesBefore){
                                        totalCalories = totalCalories - doubleCaloriesBefore
                                        caloriesBefore = "0"
                                    }
                                }
                                else{
                                    
                                    if let doubleCalories = Double(calories){
                                        
                                        if let doubleCaloriesBefore = Double(caloriesBefore){
                                            totalCalories = totalCalories - doubleCaloriesBefore + doubleCalories
                                            caloriesBefore = String(doubleCalories)
                                        }
                                    }
                                     
                                }
                                
                            }
                            Text("").frame(width:100,height:1).background(.white)
                        }
                        Text("cal").font(.system(size:40)).fontWeight(.medium).foregroundColor(.white)
                    }
                    .frame(width:500).padding(.top,10).padding(.bottom,10)
                    
                    
                }
                .frame(width:600).padding(.bottom,10)
                
                VStack(alignment:.leading){
                    HStack(spacing:10){
                        Button(action:{
                            withAnimation{
                                dropOpacity = abs(dropOpacity-1)
                                rotation=abs(rotation-45)
                                if plusBg==Color.red{
                                    plusBg=Color.white
                                    plusColor=Color.red
                                }
                                else{
                                    plusBg=Color.red
                                    plusColor=Color.white
                                }
                                
                                if addMoreOption{
                                    frameMenuHeight = frameMenuHeight - 108
                                    offsetY = offsetY - 54
                                }
                                
                                addMoreOption=false
                            }
                        },label:{
                            ZStack{
                                ZStack{
                                    Image(systemName:"plus").font(.system(size:30)).foregroundColor(plusColor).fontWeight(.bold).rotationEffect(.degrees(rotation))
                                }.frame(width:45,height:45).background(plusBg).cornerRadius(180)
                            }.frame(width:50,height:50).background(.white).cornerRadius(180)
                        })
                        
                        
                        ScrollView(.horizontal){
                            HStack(spacing:10){
                                ForEach($activityList, id:\.id){food in
                                    ZStack{
                                        ZStack{
                                            HStack{
                                                Button(action:{
                                                    withAnimation{
                                                        var index = -1
                                                        for selectedFood in activityList{
                                                            
                                                            index = index + 1
                                                            
                                                            
                                           
                                                            
                                                            if String(selectedFood.name) == food.name && Double(selectedFood.calories) == food.calories{
                                                                activityList.remove(at:index)
                                                                totalCalories = totalCalories - food.glucose
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
                    Text("Total Calories : ").font(.system(size:35)).foregroundColor(.white).fontWeight(.bold)
                    
                    Text("\(totalCalories, specifier:"%.2f") cal").font(.system(size:35)).foregroundColor(.white).fontWeight(.black)
                }.padding(.bottom,20)
                
                Spacer()
                Spacer()
                
                Button(action:{
                    withAnimation{
                        activityList.removeAll()
                        calories="0"
                        totalCalories=0
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
                        
                        ForEach($allActivity,id:\.id){activity in
                            ZStack{
                                HStack{
                                    Button(action:{
                                        withAnimation{
                                            activityList.append(activity)
                                            totalCalories = totalCalories + activity.glucose
                                        }
                                    },label:{
                                        VStack{
                                            Text("\(activity.name) -  \(activity.calories,specifier:"%.2f") cal").font(.system(size:20)).fontWeight(.bold).foregroundColor(.white)
                                        }
                                    })
                                    .padding(.leading,20)
                                    
                                    Spacer()
                                    Button(action:{
                                        withAnimation{
                                            var index = -1
                                            for selectedFood in allActivity{
                                                index = index + 1
                                                if selectedFood.name == activity.name && selectedFood.glucose == activity.glucose{
                                                    allActivity.remove(at:index)
                                                    break
                                                }
                                            }
                                            
                                            frameMenuHeight = frameMenuHeight - 54
                                            offsetY = offsetY - 27
                                        }
                                    },label:{
                                        Text("X").foregroundColor(.white)
                                    })
                                    .padding(.trailing,20)
                                }
                                .frame(width:496,height:52).background(.red)
                            }
                            .frame(width:496,height:54).background(.white)
                        }
                        
                        
                        if addMoreOption{
                            ZStack{
                                HStack{
                                    TextField("Input Your Food",text:$addActivity).font(.system(size:20)).fontWeight(.bold).foregroundColor(.white).padding([.leading,.trailing],20)
                                    
                                }
                                .frame(width:496,height:52).background(.red)
                            }
                            .frame(width:496,height:54).background(.white)
                            
            
                            ZStack{
                                HStack{
                                    TextField("Input Your Food Glucose",text:$addCalories).font(.system(size:20)).fontWeight(.bold).foregroundColor(.white).padding([.leading,.trailing],20)
                                    
                                }
                                .frame(width:496,height:52).background(.red)
                            }
                            .frame(width:496,height:54).background(.white)
                            
                            ZStack{
                                Button(action:{
                                    withAnimation{
                                        if let calories = Double(addCalories) {
                                            let newFood = FoodGlucose(name: addActivity, glucose: calories)
                                            allActivity.append(newFood)
                                            
                                            if frameMenuHeight<270{
                                                frameMenuHeight = frameMenuHeight + 54
                                                offsetY = offsetY + 27
                                            }
                                        }
                                    }
                                },label:{
                                    HStack{
                                        Text("Add").font(.system(size:20)).fontWeight(.bold).foregroundColor(.red)
                                        
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
                                        addMoreOption = true
                                        
                                        frameMenuHeight = frameMenuHeight + 108
                                        
                                        offsetY = offsetY + 54
                                    }
                                },label:{
                                    HStack{
                                        Text("Add More Option").font(.system(size:20)).fontWeight(.bold).foregroundColor(.red)
                                    } .frame(width:496,height:52).background(.white)
                                })
                            }
                            .frame(width:496,height:54).background(.white)
                        }

                        
                    }
                }
                .frame(width:496,height:frameMenuHeight).background(.red).cornerRadius(20)
            }
            .frame(width:500,height:frameMenuHeight+2).background(.white).cornerRadius(20).offset(x:70,y:offsetY).shadow(radius:10).opacity(dropOpacity)
        }
    }
}
*/
/*
struct ExerciseView2: View {
    @State var glucose:String="0"
    @State var glucoseBefore:String="0"
    
    @State var addFood:String=""
    @State var addGluco:String=""
    
    @State var dropOpacity:Double=0
    
    @State var foodList:[ActivityCalories]=[]//[FoodGlucose(name:"Nasi Goreng",glucose:112),FoodGlucose(name:"Ayam Bakar",glucose:112),FoodGlucose(name:"Ice Lemon Tea",glucose:112)]
    
    @State var allFood:[ActivityCalories]=[ActivityCalories(name:"Nasi Goreng",calories:112),ActivityCalories(name:"Ayam Bakar",calories:112),ActivityCalories(name:"Ice Lemon Tea",calories:112)]
    
    @State var rotation:Double=0
    @State var plusBg:Color=Color.green
    @State var plusColor:Color=Color.white
    
    @State var addMoreOption:Bool=false
    
    @State var totalGlucose:Double=0
    
    @State var frameMenuHeight:Double=216
    @State var offsetY:CGFloat=200
    
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
                            TextField("",text:$glucose).multilineTextAlignment(.center).font(.system(size:40)).foregroundColor(.white).frame(width:100).onChange(of:glucose){
                                
                                if glucose==""{
                                    if let doubleGlucoseBefore = Double(glucoseBefore){
                                        totalGlucose = totalGlucose - doubleGlucoseBefore
                                        glucoseBefore = "0"
                                    }
                                }
                                else{
                                    if let doubleGlucose = Double(glucose){
                                        
                                        if let doubleGlucoseBefore = Double(glucoseBefore){
                                            totalGlucose = totalGlucose - doubleGlucoseBefore + doubleGlucose
                                            glucoseBefore = String(doubleGlucose)
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
                                dropOpacity = abs(dropOpacity-1)
                                rotation=abs(rotation-45)
                                if plusBg==Color.green{
                                    plusBg=Color.white
                                    plusColor=Color.green
                                }
                                else{
                                    plusBg=Color.green
                                    plusColor=Color.white
                                }
                                
                                if addMoreOption{
                                    frameMenuHeight = frameMenuHeight - 108
                                    offsetY = offsetY - 54
                                }
                                
                                addMoreOption=false
                            }
                        },label:{
                            ZStack{
                                ZStack{
                                    Image(systemName:"plus").font(.system(size:30)).foregroundColor(plusColor).fontWeight(.bold).rotationEffect(.degrees(rotation))
                                }.frame(width:45,height:45).background(plusBg).cornerRadius(180)
                            }.frame(width:50,height:50).background(.white).cornerRadius(180)
                        })
                        
                        
                        ScrollView(.horizontal){
                            HStack(spacing:10){
                                ForEach(foodList, id:\.id){food in
                                    ZStack{
                                        ZStack{
                                            HStack{
                                                Button(action:{
                                                    withAnimation{
                                                        var index = -1
                                                        for selectedFood in foodList{
                                                            
                                                            index = index + 1
                                                            
                                                            if selectedFood.name == food.name && selectedFood.calories == food.calories{
                                                                foodList.remove(at:index)
                                                                totalGlucose = totalGlucose - food.glucose
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
                    
                    Text("\(totalGlucose, specifier:"%.2f") mg/dL").font(.system(size:35)).foregroundColor(.white).fontWeight(.black)
                }.padding(.bottom,20)
                
                Spacer()
                Spacer()
                
                Button(action:{
                    withAnimation{
                        foodList.removeAll()
                        glucose="0"
                        totalGlucose=0
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
                        
                        ForEach(allFood,id:\.id){ food in
                            ZStack{
                                HStack{
                                    Button(action:{
                                        withAnimation{
                                            foodList.append(food)
                                            totalGlucose = totalGlucose + food.glucose
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
                                            for selectedFood in allFood{
                                                index = index + 1
                                                if selectedFood.name == food.name && selectedFood.glucose == food.glucose{
                                                    allFood.remove(at:index)
                                                    break
                                                }
                                            }
                                            
                                            frameMenuHeight = frameMenuHeight - 54
                                            offsetY = offsetY - 27
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
                        
                        
                        if addMoreOption{
                            ZStack{
                                HStack{
                                    TextField("Input Your Food",text:$addFood).font(.system(size:20)).fontWeight(.bold).foregroundColor(.white).padding([.leading,.trailing],20)
                                    
                                }
                                .frame(width:496,height:52).background(.green)
                            }
                            .frame(width:496,height:54).background(.white)
                            
            
                            ZStack{
                                HStack{
                                    TextField("Input Your Food Glucose",text:$addGluco).font(.system(size:20)).fontWeight(.bold).foregroundColor(.white).padding([.leading,.trailing],20)
                                    
                                }
                                .frame(width:496,height:52).background(.green)
                            }
                            .frame(width:496,height:54).background(.white)
                            
                            ZStack{
                                Button(action:{
                                    withAnimation{
                                        if let glucose = Double(addGluco) {
                                            let newFood = FoodGlucose(name: addFood, glucose: glucose)
                                            allFood.append(newFood)
                                            
                                            if frameMenuHeight<378{
                                                frameMenuHeight = frameMenuHeight + 54
                                                offsetY = offsetY + 27
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
                                        addMoreOption = true
                                        
                                        frameMenuHeight = frameMenuHeight + 108
                                        
                                        offsetY = offsetY + 54
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
                .frame(width:496,height:frameMenuHeight).background(.green).cornerRadius(20)
            }
            .frame(width:500,height:frameMenuHeight+2).background(.white).cornerRadius(20).offset(x:70,y:offsetY).shadow(radius:10).opacity(dropOpacity)
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
struct ExerciseView: View {
    
    @Environment(\.dismiss) var dismiss
    @State var numberCal:String = "0"
    @State var selectedMenu:String = "Manual Input"
    @State var isPresented:Bool = false
    
    var body: some View {
        ZStack{
            Color.red.ignoresSafeArea()
            VStack{
                Picker("Choose Input Method",selection:$selectedMenu){
                    Text("Select Exercise").tag("Select Exercise")
                    Text("Manual Input").tag("Manual Input")
                    Text("Apple Watch").tag("Apple Watch")
                }
                .pickerStyle(.segmented)
                .frame(width:500,height:90).scaleEffect(1.5)
                
                if selectedMenu == "Select Exercise"{
                    Button(action:{
                        isPresented.toggle()
                    },label:{
                        VStack{
                            Text("Select").foregroundColor(.red).font(.system(size:20)).fontWeight(.bold)
                        }.frame(width:220,height:60).background(.white).cornerRadius(90)
                    })
                }
                else if selectedMenu == "Manual Input"{
                    Spacer()
                    Spacer()

                    GifImage("JumpingExercise").frame(width:700,height:530).cornerRadius(30)      .shadow(radius: 20).padding(.bottom,35)

                    
                    VStack{
                        HStack{
                            VStack(spacing:5){
                                TextField("",text:$numberCal).multilineTextAlignment(.center).font(.system(size:40)).foregroundColor(.white)
                                
                                Text("").frame(width:100,height:1).background(.white)
                            }
                            Text("cal").font(.system(size:40)).fontWeight(.bold).foregroundColor(.white)
                        }
                        .frame(width:210,height:200).background(.red)
                        
                        Button(action:{
                            
                        },label:{
                            VStack{
                                Text("SUBMIT").foregroundColor(.red).font(.system(size:20)).fontWeight(.bold)
                            }.frame(width:120,height:60).background(.white).cornerRadius(120)
                        }).shadow(radius: 5)
                    }
                     
                    
                    Spacer()
                }
                else{
                 
                    Spacer()
                    
                    GifImage("AppleWatch").frame(width:700,height:530).cornerRadius(30).shadow(radius: 20)
                    Spacer()
                    
                    Button(action:{
                        
                    },label:{
                        VStack{
                            Text("Sync to Watch OS").foregroundColor(.red).font(.system(size:20)).fontWeight(.bold)
                        }.frame(width:220,height:60).background(.white).cornerRadius(90)
                    }).offset(y:-80).shadow(radius: 5)
                }
                
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
        .sheet(isPresented:$isPresented){
            VStack{
                Text("Hello ")
            }
        }
    }
}

#Preview {
    NavigationStack{
        ExerciseView()
    }
}
*/
 /*ttps://www.circufiber.com/blogs/diabetes-resources/how-much-does-blood-sugar-drop-after-exercise*/*/
