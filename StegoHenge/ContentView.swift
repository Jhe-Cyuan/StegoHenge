//
//  ContentView.swift
//  StegoHenge
//
//  Created by JCYang on 2020/10/15.
//

import SwiftUI

struct ContentView: View {
    
    @State private var bShowSetting:Bool = false
    @State private var bShowRSAUser:Bool = false
    @State private var bShowNewRSAUser:Bool = false
    
    @State private var strStegoAlgo:String = ""
    @State private var strCyptoAlgo:String = ""
    
    @State private var strNewRSAUserName:String = ""
    @State private var strNewRSAUserKey:String = ""
    
    @State private var textsRSAKey:[Text] = []
    
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
                        .font(.custom("Futura-Medium", size: 100))
                    
                    Spacer()
                    
                    HStack {
                        NavigationLink(destination: StegoView()) {
                            VStack {
                                Image(systemName: "play.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.white)
                                    .frame(width: 100,alignment: .center)
                                
                                Text("Start")
                                    .foregroundColor(Color.white)
                                    .font(.custom("Futura-Medium", size: 60))
                            }
                        }
                    }
                    
                    Spacer()
                }
                .onAppear() {
                    let app = UIApplication.shared.delegate as! AppDelegate
                    let context = app.persistentContainer.viewContext
                    var arrConfig:[Configure]
                    var arrRSAKey:[RSAKey]
                    
                    do {
                        arrConfig = try context.fetch(Configure.fetchRequest())
                        
                        switch arrConfig.count {
                        case 0:
                            let newConfig = Configure(context: context)
                            newConfig.strCyptoAlgo = "RSA"
                            newConfig.strStegoAlgo = "LSB Original"
                            self.strCyptoAlgo = "RSA"
                            self.strStegoAlgo = "LSB Original"
                            app.saveContext()
                        default:
                            self.strCyptoAlgo = arrConfig[0].strCyptoAlgo!
                            self.strStegoAlgo = arrConfig[0].strStegoAlgo!
                        }
                    } catch {
                        print(error)
                    }
                    
                    do {
                        arrRSAKey = try context.fetch(RSAKey.fetchRequest())
                        
                        switch arrRSAKey.count {
                        case 0:
                            let newRSAKey = RSAKey(context: context)
                            let key = buildRSAKey()
                            
                            var data:Data
                            var b64PublicKey:String = ""
                            var b64PrivateKey:String = ""
                            
                            if let cfdata = SecKeyCopyExternalRepresentation(key.publicKey!, nil) {
                                data = cfdata as Data
                                b64PublicKey = data.base64EncodedString()
                            }
                            
                            if let cfdata = SecKeyCopyExternalRepresentation(key.privateKey!, nil) {
                                data = cfdata as Data
                                b64PrivateKey = data.base64EncodedString()
                            }
                            
                            newRSAKey.name = "MySelf"
                            newRSAKey.publicKey = b64PublicKey
                            newRSAKey.privateKey = b64PrivateKey
                            
                            app.saveContext()
                        default:
                            for i in 0..<arrRSAKey.count {
                                self.textsRSAKey.append(Text(arrRSAKey[i].name ?? "Name Error"))
                            }
                        }
                    } catch {
                        print(error)
                    }
                }
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            }
            .navigationBarItems(
                trailing:
                    VStack {
                        Spacer()
                        
                        Button(action: {
                            self.bShowSetting = true
                            self.bShowNewRSAUser = false
                            self.bShowRSAUser = false
                        }) {
                            Image(systemName: "ellipsis")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.white)
                                .frame(width: 50, height: 50, alignment: .trailing)
                        }
                        .frame(width: 200, height: 200, alignment: .trailing)
                        .padding()
                        
                        Spacer()
                    }
            )
        }
        .navigationViewStyle(StackNavigationViewStyle())
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
                    
                    Picker(selection: self.$strCyptoAlgo, label: Text(self.strCyptoAlgo)) {
                        Text("None")
                            .tag("None")
                        Text("RSA")
                            .tag("RSA")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    Spacer()
                }
                .font(.custom("Futura-Medium", size: 30))
                
                VStack {
                    Spacer()
                    
                    Text("Steganography Algorithm")
                    
                    Picker(selection: self.$strStegoAlgo, label: Text(self.strStegoAlgo)) {
                        Text("LSB Original")
                            .tag("LSB Original")
                        Text("LSB Match")
                            .tag("LSB Match")
                        Text("F5 Algorithm")
                            .tag("F5 Algorithm")
                        Text("LSB Match + F5")
                            .tag("LSB Match + F5")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    Spacer()
                }
                .font(.custom("Futura-Medium", size: 30))
                
                VStack {
                    Spacer()
                    
                    HStack {
                        Spacer()
                        
                        Text("RSA Key Manager")
                        
                        Button(action: {
                            self.bShowRSAUser = false
                            self.bShowNewRSAUser = true
                        }) {
                            Image(systemName: "person.crop.circle.badge.plus")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 40)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            self.bShowRSAUser = !self.bShowRSAUser
                            self.bShowNewRSAUser = false
                        }) {
                            Image(systemName: self.bShowRSAUser ? "eye.slash.fill" : "eye.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                        }
                    }
                    
                    if self.bShowNewRSAUser {
                        VStack {
                            TextField("Input user name here.", text: self.$strNewRSAUserName)
                                .padding()
                                .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.gray, lineWidth: 2))
                            TextField("Input user key here.", text: self.$strNewRSAUserKey)
                                .padding()
                                .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.gray, lineWidth: 2))
                            Button(action: {
                                self.bShowNewRSAUser = false
                                
                                let app = UIApplication.shared.delegate as! AppDelegate
                                let context = app.persistentContainer.viewContext
                                
                                if self.strNewRSAUserName != "" && self.strNewRSAUserKey != "" {
                                    let newRSAKey = RSAKey(context: context)
                                    newRSAKey.name = self.strNewRSAUserName
                                    newRSAKey.publicKey = self.strNewRSAUserKey
                                }
                                
                                app.saveContext()
                                
                                self.strNewRSAUserName = ""
                                self.strNewRSAUserKey = ""
                                
                                var arrRSAKey:[RSAKey]
                                
                                do {
                                    self.textsRSAKey.removeAll()
                                    
                                    arrRSAKey = try context.fetch(RSAKey.fetchRequest())
                                    
                                    for i in 0..<arrRSAKey.count {
                                        self.textsRSAKey.append(Text(arrRSAKey[i].name ?? "Name Error"))
                                    }
                                } catch {
                                    print(error)
                                }
                            }) {
                                Image(systemName: "plus.circle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                            }
                        }
                        .padding()
                        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.black, lineWidth: 2))
                    }
                    
                    if self.bShowRSAUser {
                        Form {
                            self.textsRSAKey[0]
                                .contextMenu{
                                    Button(action:{
                                        let app = UIApplication.shared.delegate as! AppDelegate
                                        let context = app.persistentContainer.viewContext
                                        var arrRSAKey:[RSAKey]
                                        
                                        do {
                                            arrRSAKey = try context.fetch(RSAKey.fetchRequest())
                                            
                                            UIPasteboard.general.string = arrRSAKey[0].publicKey
                                        } catch {
                                            print(error)
                                        }
                                    }) {
                                        Text("Copy My RSA Public Key")
                                        Image(systemName: "doc.on.doc")
                                    }
                                }
                            ForEach(1..<self.textsRSAKey.count) {i in
                                self.textsRSAKey[i]
                            }
                        }
                        .frame(height: 400)
                    }
                    
                    Spacer()
                }
                .buttonStyle(BorderlessButtonStyle())
                .font(.custom("Futura-Medium", size: 30))
                
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
                                Text("MCU Graduation Project By Team 4.")
                            }
                        }
                        
                        Spacer()
                    }
                    Spacer()
                }
                .font(.custom("Futura-Medium", size: 20))
            }
            .onAppear() {
                let app = UIApplication.shared.delegate as! AppDelegate
                let context = app.persistentContainer.viewContext
                var config:[Configure]
                var arrRSAKey:[RSAKey]
                
                do {
                    config = try context.fetch(Configure.fetchRequest())
                    
                    self.strCyptoAlgo = config[0].strCyptoAlgo!
                    self.strStegoAlgo = config[0].strStegoAlgo!
                } catch {
                    print(error)
                }
                
                do {
                    self.textsRSAKey.removeAll()
                    
                    arrRSAKey = try context.fetch(RSAKey.fetchRequest())
                    
                    for i in 0..<arrRSAKey.count {
                        self.textsRSAKey.append(Text(arrRSAKey[i].name ?? "Name Error"))
                    }
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
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
