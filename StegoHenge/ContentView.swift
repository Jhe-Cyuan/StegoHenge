//
//  ContentView.swift
//  StegoHenge
//
//  Created by JCYang on 2020/10/15.
//

import SwiftUI

struct ContentView: View {
    
    @State private var bShowSetting:Bool = false
    
    @State private var strStegoAlgo:String = "LSB Original"
    @State private var strCyptoAlgo:String = "RSA"
    
    var body: some View {
        NavigationView {
            ZStack {
                Image("background")
                    .resizable()
                    .scaledToFill()
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Text("Steganography")
                        .foregroundColor(Color.white)
                        .font(.custom("Futura-Medium", size: 30))
                    
                    Spacer()
                    
                    HStack {
                        NavigationLink(destination: StegoView()) {
                            VStack {
                                Image(systemName: "play.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.white)
                                    .frame(width: 50,alignment: .center)
                                
                                Text("Start")
                                    .foregroundColor(Color.white)
                                    .font(.custom("Futura-Medium", size: 30))
                            }
                        }
                    }
                    
                    Spacer()
                }
                .sheet(isPresented: self.$bShowSetting, content: {
                    Spacer()
                    
                    Image(systemName: "gearshape")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.black)
                        .frame(width: 50,alignment: .center)
                    
                    Form {
                        VStack {
                            Text("Cryptography Algorithm")
                                .font(.custom("Futura-Medium", size: 20))
                            
                            Picker(selection: self.$strCyptoAlgo, label: Text(self.strCyptoAlgo)) {
                                Text("None").tag("None")
                                Text("RSA").tag("RSA")
                            }
                            .pickerStyle(SegmentedPickerStyle())
                        }
                        
                        VStack {
                            Text("Steganography Algorithm")
                                .font(.custom("Futura-Medium", size: 20))
                            
                            Picker(selection: self.$strStegoAlgo, label: Text(self.strStegoAlgo)) {
                                Text("LSB Original")
                                    .tag("LSB Original")
                                /*Text("LSB Match")
                                    .tag("LSB Match")*/
                                Text("F5 Algorithm")
                                    .tag("F5 Algorithm")
                            }
                            .pickerStyle(SegmentedPickerStyle())
                        }
                        
                        HStack {
                            Spacer()
                            
                            VStack {
                                Group {
                                    Text("Leader")
                                    Text("06360293 楊哲銓")
                                    Text("Member")
                                    Text("06360870 曾志敏")
                                    Text("06361155 馬叡竣")
                                    Text("Teacher")
                                    Text("MCU CSIE 李遠坤副教授")
                                }
                                Text("")
                                Group {
                                    Text("Copyright © 2020")
                                    Text("MCU Graduation Project By Team 4.")
                                    Text("All rights reserved.")
                                }
                            }
                            .font(.custom("Futura-Medium", size: 16))
                            
                            Spacer()
                        }
                    }
                    
                    Button(action: {self.bShowSetting = false}) {
                        Text("OK")
                    }
                    .padding(.all, 20)
                })
            }
            .navigationBarItems(
                trailing:
                    Button(action: {self.bShowSetting = true}) {
                        Image(systemName: "ellipsis")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.white)
                            .frame(width: 25, alignment: .topTrailing)
                    }
                    .frame(width: 100, height: 100, alignment: .trailing)
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
