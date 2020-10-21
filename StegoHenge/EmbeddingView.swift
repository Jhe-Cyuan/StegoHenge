//
//  EmbeddingView.swift
//  StegoHenge
//
//  Created by JCYang on 2020/10/16.
//

import SwiftUI

struct EmbeddingView: View {
    
    @State private var strMessage:String = ""
    
    @State private var bImgSourceSheet:Bool = false
    @State private var bShowImgPkr:Bool = false
    
    @State private var uiipkrctrlerSourceType:UIImagePickerController.SourceType = .photoLibrary
    
    @State private var uiiCarrierImg:UIImage? = UIImage(named: "background")//nil
    @State private var urlCarrierImg:URL? = nil
    
    @State private var uiiHidedImg:UIImage? = nil
    
    @State private var arrRSAKey:[RSAKey] = []
    @State private var iUserNameIndex:Int = 0
    
    var body: some View {
        ZStack {
            Image("background")
                .resizable()
                .scaledToFill()
                .frame(minWidth: 0, maxWidth: .infinity)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("Embedding")
                    .font(.custom("Futura-Meduim", size: 100))
                    .foregroundColor(.white)
                    .padding([.all],25)
                
                if(uiiCarrierImg == nil) {
                    Button (action: {self.bImgSourceSheet = true}) {
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
                }
                
                if(uiiCarrierImg != nil) {
                    Button (action: {self.bImgSourceSheet = true}) {
                        VStack {
                            Image(uiImage: self.uiiCarrierImg!)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 300)
                                .foregroundColor(.white)
                            
                            Text("Click to Change Image")
                                .foregroundColor(Color.white)
                                .font(.custom("Futura-Medium", size: 30))
                        }
                    }
                }
                
                if(uiiCarrierImg != nil) {
                    Spacer()
                    
                    Picker(
                        selection: self.$iUserNameIndex,
                        label: Text("For: \((self.arrRSAKey.count != 0) ? self.arrRSAKey[self.iUserNameIndex].name! : "")")) {
                        ForEach(0..<self.arrRSAKey.count, id: \.self) { value in
                            Text(self.arrRSAKey[value].name ?? "")
                                .tag(value)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .foregroundColor(Color.blue)
                    .font(.custom("Futura-Medium", size: 30))
                    .padding()
                    .frame(width: 50, height: 16)
                    
                    HStack{
                        Image(systemName: "envelope.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50)
                            .foregroundColor(.white)
                        
                        TextField("Input your message here", text: $strMessage)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width:250)
                    }
                    .padding([.top],35)
                }
                
                Spacer()
                
                if(self.strMessage != "") {
                    Button(action: {
                        self.uiiHidedImg = LSB_Hide(image: self.uiiCarrierImg, data: self.strMessage)
                        
                        self.uiiHidedImg = F5_Hide(image: self.uiiCarrierImg, data: self.strMessage)
                        
                        if self.uiiHidedImg != nil {
                            UIImageWriteToSavedPhotosAlbum(
                                UIImage(data: self.uiiHidedImg!.pngData()!)!,
                                nil,
                                nil,
                                nil
                            )
                        }
                    }) {
                        VStack {
                            Image(systemName: "tray.and.arrow.down.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50)
                                .foregroundColor(.white)
                            
                            Text("Embedding")
                                .foregroundColor(Color.white)
                                .font(.custom("Futura-Medium", size: 30))
                        }
                    }
                }
                
                Spacer()
            }
            .actionSheet(isPresented: $bImgSourceSheet){
                ActionSheet(
                    title : Text("Select your carrier image"),
                    message: Text("please select png image."),
                    buttons:[
                        .default(Text("Photo Library")) {
                            self.bShowImgPkr = true
                            self.uiipkrctrlerSourceType = .photoLibrary
                        }
                    ]
                )
            }
            .sheet(isPresented: $bShowImgPkr) {
                ImagePicker(image: self.$uiiCarrierImg,
                            isShown: self.$bShowImgPkr,
                            imageURL: self.$urlCarrierImg,
                            sourceType: self.uiipkrctrlerSourceType)
            }
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        }
        .onAppear() {
            let app = UIApplication.shared.delegate as! AppDelegate
            let context = app.persistentContainer.viewContext
            
            do {
                self.arrRSAKey = try context.fetch(RSAKey.fetchRequest())
            } catch {
                print(error)
            }
        }
    }
}

struct EmbeddingView_Previews: PreviewProvider {
    static var previews: some View {
        EmbeddingView()
    }
}
