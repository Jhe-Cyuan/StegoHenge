//
//  ContentView.swift
//  StegoHenge
//
//  Created by JCYang on 2020/10/15.
//

import SwiftUI

struct ContentView: View {
    
    @State private var bShowSetting:Bool = false
    
    @State private var strStegoAlgo:String = ""
    @State private var strCyptoAlgo:String = ""
    
    @State private var textsRSAKey:[Text] = [Text]()
    
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
                            Spacer()
                            
                            Text("Cryptography Algorithm")
                                .font(.custom("Futura-Medium", size: 20))
                            
                            Picker(selection: self.$strCyptoAlgo, label: Text(self.strCyptoAlgo)) {
                                Text("None").tag("None")
                                Text("RSA").tag("RSA")
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            
                            Spacer()
                        }
                        
                        VStack {
                            Spacer()
                            
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
                            
                            Spacer()
                        }
                        
                        VStack {
                            Spacer()
                            
                            HStack {
                                Spacer()
                                
                                Text("RSA Key")
                                
                                Button(action: {print("press")}) {
                                    Image(systemName: "person.crop.circle.badge.plus")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 40)
                                }
                                .buttonStyle(BorderlessButtonStyle())
                                
                                Spacer()
                            }
                            
                            Form {
                                ForEach(0..<self.textsRSAKey.count) {
                                    self.textsRSAKey[$0]
                                        .contextMenu{
                                            Button(action:{}) {
                                                Text("Edit")
                                                Image(systemName: "pencil")
                                            }
                                            Button(action:{}) {
                                                Text("Delete")
                                                    .foregroundColor(.red)
                                                Image(systemName: "trash")
                                                    .foregroundColor(.red)
                                            }
                                        }
                                }
                            }
                            .frame(height: 200)
                            
                            Spacer()
                        }
                        .font(.custom("Futura-Medium", size: 20))
                        
                        VStack {
                            Spacer()
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
                            Spacer()
                        }
                    }
                    .onAppear() {
                        let app = UIApplication.shared.delegate as! AppDelegate
                        let context = app.persistentContainer.viewContext
                        var config:[Configure]
                        
                        do {
                            config = try context.fetch(Configure.fetchRequest())
                            
                            self.strCyptoAlgo = config[0].strCyptoAlgo!
                            self.strStegoAlgo = config[0].strStegoAlgo!
                        } catch {
                            print(error)
                        }
                    }
                    
                    Button(action: {
                        self.bShowSetting = false
                        
                        let app = UIApplication.shared.delegate as! AppDelegate
                        let context = app.persistentContainer.viewContext
                        var config:[Configure]
                        
                        do {
                            config = try context.fetch(Configure.fetchRequest())
                            config[0].strCyptoAlgo = self.strCyptoAlgo
                            config[0].strStegoAlgo = self.strStegoAlgo
                        } catch {
                            print(error)
                        }
                        app.saveContext()
                    }) {
                        Text("OK")
                            .frame(width: UIScreen.main.bounds.width)
                    }
                    .padding(.all, 20)
                })
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
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
            .onAppear() {
                let app = UIApplication.shared.delegate as! AppDelegate
                let context = app.persistentContainer.viewContext
                var config:[Configure]
                
                do {
                    config = try context.fetch(Configure.fetchRequest())
                    
                    switch config.count {
                    case 0:
                        let newConfig = Configure(context: context)
                        newConfig.strCyptoAlgo = "RSA"
                        newConfig.strStegoAlgo = "LSB Original"
                        self.strCyptoAlgo = "RSA"
                        self.strStegoAlgo = "LSB Original"
                        app.saveContext()
                    default:
                        self.strCyptoAlgo = config[0].strCyptoAlgo!
                        self.strStegoAlgo = config[0].strStegoAlgo!
                    }
                } catch {
                    print(error)
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
