//
//  ErrorAlertView.swift
//  NanoChallenge2
//
//  Created by Arrick Russell Adinoto on 25/05/24.
//

import SwiftUI

struct ErrorAlertView: View {
    
    var errorMessage:String
    @Binding var isPresented:Bool

    var body: some View {
        ZStack{
            Color.black.opacity(0.5).ignoresSafeArea()
            VStack{
                ZStack{
                    VStack(alignment:.leading){
                        Text("OOPS !").fontWeight(.black).font(.system(size:70)).foregroundColor(.white).padding(.top,20)
                        Spacer()
                        Text("\(errorMessage)").fontWeight(.medium).font(.system(size:40)).foregroundColor(.white).padding(.bottom,20).offset(y:-40)
                        
                    }.frame(width:410,height:300).padding(.leading,70).offset(x:-150)
                    
                    Image("ErrorMessagePicture").resizable().frame(width:360,height:300).offset(x:170).padding(.bottom,30)
                }.frame(width:630,height:360).background(.pink).cornerRadius(30)
            }.frame(width:640,height:370).background(.black).cornerRadius(30)
            
            Button(action:{
                withAnimation{
                    isPresented = false
                }
            },label:{
                Image(systemName:"x.circle.fill").font(.system(size:45)).foregroundColor(.black)
            }).offset(x:287,y:-152)
        }

    }
}
/*
#Preview {
    ErrorAlertView(errorMessage:"You haven't filled email form")
}
*/
