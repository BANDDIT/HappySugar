//
//  SettingsView.swift
//  NanoChallenge2
//
//  Created by Arrick Russell Adinoto on 19/05/24.
//

import SwiftUI

struct SettingsView: View {
    
    @State var choosenMenu:String="Widget"
    @StateObject var settings:Settings=Settings()
    
    var body: some View {
        
        HStack{
            VStack{
                Text("Settings").foregroundColor(.blue).fontWeight(.black).font(.system(size:40))
                Text("")
                
                VStack(spacing:1){
                    Button(action:{
                        choosenMenu = "Widget"
                    },label:{
                        MenuOption(text: "Widget", bgColor: choosenMenu == "Widget" ? Color.mediumGray : Color.lightGray)
                    })

                    Button(action:{
                        choosenMenu = "App Sounds"
                    },label:{
                        MenuOption(text: "App Sounds", bgColor: choosenMenu == "App Sounds" ? Color.mediumGray : Color.lightGray)
                    })
                    
                    Button(action:{
                        choosenMenu = "Notification Reminder"
                    },label:{
                        MenuOption(text: "Notification Reminder", bgColor: choosenMenu == "Notification Reminder" ? Color.mediumGray : Color.lightGray)
                    })
 
                    Button(action:{
                        choosenMenu = "Connect to Apple Watch"
                    },label:{
                        MenuOption(text: "Connect to Apple Watch", bgColor: choosenMenu == "Connect to Apple Watch" ? Color.mediumGray : Color.lightGray)
                    })
                   
                }
                .background(.gray)
                .cornerRadius(20)
       
                
                Spacer()
            }.padding(.top,10).padding([.leading,.trailing],10)
  
            GeometryReader{ geometry in
                VStack{
                    Text("")
                }.frame(width:1,height:geometry.size.height).background(.gray)
            }.frame(width:1).background(.gray)
            .background(.green)
            
            
            VStack(alignment:.leading){
                
                if choosenMenu == "Widget"{
                    Text("Widget")
                   
                    GeometryReader{ geo in
                        VStack(spacing:1){
                            
                            Button(action:{
                                settings.widget = "WidgetAllow"
                            },label:{
                                SubMenuOption(text:"Allow",stringName:"WidgetAllow",settings:settings.widget)
                            })
  
                            Button(action:{
                                settings.widget = "WidgetDontAllow"
                            },label:{
                                SubMenuOption(text:"Don't Allow",stringName:"WidgetDontAllow",settings:settings.widget)

                            })
                        }
                        .background(.gray)     .cornerRadius(20)
                    }.padding(.trailing,10)
  
                }
                else if choosenMenu == "App Sounds"{
                    Text("App Sounds")
                    GeometryReader{ geo in
                        VStack(spacing:1){
                            
                            Button(action:{
                                settings.appSounds = "appSoundsABCD"
                            },label:{
                                SubMenuOption(text:"ABCD",stringName:"appSoundsABCD",settings:settings.appSounds)

                            })
  
                            Button(action:{
                                settings.appSounds = "appSoundsEFGH"
                            },label:{
                                SubMenuOption(text:"EFGH",stringName:"appSoundsEFGH",settings:settings.appSounds)

                            })
                        }
                        .background(.gray)     .cornerRadius(20)
                    }.padding(.trailing,10)
                }
                else if choosenMenu == "Notification Reminder"{
                    Text("Notification Reminder")

                    GeometryReader{ geo in
                        VStack(spacing:1){
                            
                            Button(action:{
                                settings.notifReminder = "NotifReminderAllow"
                            },label:{
                                SubMenuOption(text:"Allow",stringName:"NotifReminderAllow",settings:settings.notifReminder)
                            })
  
                            Button(action:{
                                settings.notifReminder = "NotifReminderDontAllow"
                            },label:{
                                SubMenuOption(text:"Don't Allow",stringName:"NotifReminderDontAllow",settings:settings.notifReminder)

                            })
                        }
                        .background(.gray)     .cornerRadius(20)
                    }.padding(.trailing,10)
                }
                else{
                    Text("Connect to Apple Watch")
                    
                    GeometryReader{ geo in
                        VStack(spacing:1){
                            
                            Button(action:{
                                settings.connectWatch = "ConnectWatchAllow"
                            },label:{
                                SubMenuOption(text:"Allow",stringName:"ConnectWatchAllow",settings:settings.connectWatch)
                            })
  
                            Button(action:{
                                settings.connectWatch = "ConnectWatchDontAllow"
                            },label:{
                                SubMenuOption(text:"Don't Allow",stringName:"ConnectWatchDontAllow",settings:settings.connectWatch)

                            })
                        }
                        .background(.gray)     .cornerRadius(20)
                    }.padding(.trailing,10)
                }
                
            }
            
            
        }
        
    }
}


class Settings : ObservableObject{
    @Published var widget:String = "WidgetAllow"
    @Published var appSounds:String = "appSoundsABCD"
    @Published var notifReminder:String = "NotifReminderAllow"
    @Published var connectWatch:String = "ConnectWatchAllow"
}


struct MenuOption:View{
    
    var text:String
    var bgColor:Color

    
    var body : some View{
        
        GeometryReader{ geo in
            VStack(alignment:.leading){
                HStack{
                    Image(systemName:"cloud.fill")
                    Text("\(text)").foregroundColor(.blue).font(.system(size:25)).fontWeight(.medium)
                }.padding(.leading,15)
            }.frame(width:geo.size.width,height:65,alignment:.leading)
        }.frame(height:65).background(bgColor)
        
    }
}


struct SubMenuOption:View{
    var text:String
    var checkmark:Bool = true
    var stringName:String
    
    var settings:String
    
    var body : some View{
        
        GeometryReader{ geo in
            VStack(alignment:.leading){
                HStack{
                    Text("\(text)").foregroundColor(.blue).font(.system(size:25)).fontWeight(.medium)
                    
                    Spacer()
                    
                    
                    if stringName == settings {
                        Image(systemName:"checkmark")
                    }
                }.padding([.leading,.trailing],15)
            }.frame(width:geo.size.width,height:65,alignment:.leading)
        }.frame(height:65).background(Color.lightGray)
        
    }
}

#Preview {
    SettingsView()
    //MenuOption(text:"sadasda")
}
