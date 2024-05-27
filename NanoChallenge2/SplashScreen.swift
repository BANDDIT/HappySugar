//
//  SplashScreen.swift
//  NanoChallenge2
//
//  Created by Arrick Russell Adinoto on 19/05/24.
//

import SwiftUI

struct SplashScreen: View {
    
    @Binding var isSplashScreen:Bool
    @Binding var opacity:Double
    
    
    @State var tapNextColor:Color = Color.purple
    @State var changeColorBool:Bool = false
    
    let timer = Timer.publish(every:1,on:.main, in:.common).autoconnect()
    
    
    var body: some View {
        Button(action:{
            isSplashScreen = false
            opacity = 1
        },label:{
            ZStack{
                Color.purple.ignoresSafeArea()
                VStack{
                    Spacer()
                    Text("Did You Know?").foregroundColor(.white).font(.system(size:50)).fontWeight(.black)
         
                    Text("Sleeping for 8 hours can help you to stabilize your glucose.").foregroundColor(.white).font(.system(size:30)).fontWeight(.bold).frame(width:700,height:200)
                    Text("")
     
                    
                    Image("Lamp")
                    
                    Spacer()
                    
                    Text("TAP TO NEXT").foregroundColor(tapNextColor).font(.system(size:30)).fontWeight(.light).onReceive(timer){ _ in
                        
                        changeColorBool.toggle()
                        
                        
                        if changeColorBool {
                            withAnimation{
                                tapNextColor=Color.white
                            }
                        }
                        else{
                            withAnimation{
                                tapNextColor=Color.purple
                            }
                        }
                    }
                    
                    Spacer()
                }
            }
        })
    }
    
}

/*
#Preview {
    SplashScreen()
}
*/

