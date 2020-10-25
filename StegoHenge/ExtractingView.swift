//
//  ExtractingView.swift
//  StegoHenge
//
//  Created by JCYang on 2020/10/16.
//

import SwiftUI

struct ExtractingView: View {
    
    @State private var bImgSourceSheet:Bool = false
    @State private var bShowImgPkr:Bool = false
    
    @State private var uiipkrctrlerSourceType:UIImagePickerController.SourceType = .photoLibrary
    
    @State private var uiiHidedImg:UIImage? = nil
    @State private var urlHidedImg:URL? = nil
    
    @State private var strMessage:String? = nil
    
    @State private var arrConfigure:[Configure] = []
    @State private var arrRSAKey:[RSAKey] = []
    
    var body: some View {
        ZStack {
            Image("background")
                .resizable()
                .scaledToFill()
                .frame(minWidth: 0, maxWidth: .infinity)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("Extracting")
                    .font(.custom("Futura-Meduim", size: 100))
                    .foregroundColor(.white)
                    .padding([.all],25)
                
                if(uiiHidedImg == nil) {
                    Button (action: {
                        self.bImgSourceSheet = true
                        self.strMessage = nil
                    }) {
                        VStack {
                            Image(systemName: "photo.on.rectangle.angled")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 65)
                                .foregroundColor(.white)
                            
                            Text("Click to Select Image")
                                .foregroundColor(Color.white)
                                .font(.custom("Futura-Medium", size: 30))
                        }
                    }
                    .actionSheet(isPresented: $bImgSourceSheet){
                        ActionSheet(
                            title :
                                Text("Select your carrier image"),
                            message:
                                Text("please select png image."),
                            buttons:[
                                .default(Text("Photo Library")) {
                                    self.bShowImgPkr = true
                                    self.uiipkrctrlerSourceType = .photoLibrary
                                }
                            ]
                        )
                    }
                }
                
                if(self.strMessage != nil) {
                    ScrollView {
                        Text("Message:")
                            .font(.custom("Futura-Meduim", size: 100))
                            .foregroundColor(.white)
                            .padding([.all],25)
                        Text(self.strMessage!)
                            .font(.custom("Futura-Meduim", size: 100))
                            .foregroundColor(.white)
                            .padding([.all],25)
                    }
                }
                
                if(uiiHidedImg != nil) {
                    Button (action: {
                        self.bImgSourceSheet = true
                    }) {
                        VStack {
                            Image(uiImage: self.uiiHidedImg!)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 300)
                                .foregroundColor(.white)
                            
                            Text("Click to Change Image")
                                .foregroundColor(Color.white)
                                .font(.custom("Futura-Medium", size: 30))
                        }
                    }
                    .actionSheet(isPresented: $bImgSourceSheet){
                        ActionSheet(
                            title :
                                Text("Select your carrier image"),
                            message:
                                Text("please select png image."),
                            buttons:[
                                .default(Text("Photo Library")) {
                                    self.bShowImgPkr = true
                                    self.uiipkrctrlerSourceType = .photoLibrary
                                }
                            ]
                        )
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        if self.arrConfigure[0].strCyptoAlgo == "None" {
                            if self.arrConfigure[0].strStegoAlgo == "LSB Original" {
                                self.strMessage = LSB_Take(image: self.uiiHidedImg)
                            }
                            else {
                                self.strMessage = F5_Take(image: self.uiiHidedImg)
                            }
                        }
                        else {
                            if self.arrConfigure[0].strStegoAlgo == "LSB Original" {
                                self.strMessage = LSB_RSA_Take(
                                    image: self.uiiHidedImg,
                                    key: self.arrRSAKey[0].privateKey
                                )
                            }
                            else {
                                self.strMessage = F5_RSA_Take(
                                    image: self.uiiHidedImg,
                                    key: self.arrRSAKey[0].privateKey
                                )
                            }
                        }
                        
                        self.uiiHidedImg = nil
                    }) {
                        VStack {
                            Image(systemName: "tray.and.arrow.up.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50)
                                .foregroundColor(.white)
                            
                            Text("Extracting")
                                .foregroundColor(Color.white)
                                .font(.custom("Futura-Medium", size: 30))
                        }
                    }
                }
                
                Spacer()
            }
            .sheet(isPresented: $bShowImgPkr) {
                ImagePicker(image: self.$uiiHidedImg,
                            isShown: self.$bShowImgPkr,
                            imageURL: self.$urlHidedImg,
                            sourceType: self.uiipkrctrlerSourceType)
            }
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        }
        .onAppear() {
            let app = UIApplication.shared.delegate as! AppDelegate
            let context = app.persistentContainer.viewContext
            
            do {
                self.arrConfigure = try context.fetch(Configure.fetchRequest())
            } catch {
                print(error)
            }
            
            do {
                self.arrRSAKey = try context.fetch(RSAKey.fetchRequest())
            } catch {
                print(error)
            }
        }
    }
}

struct ExtractingView_Previews: PreviewProvider {
    static var previews: some View {
        ExtractingView()
    }
}
