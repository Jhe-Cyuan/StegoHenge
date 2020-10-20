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
    
    var body: some View {
        ZStack {
            Image("background")
                .resizable()
                .scaledToFill()
                .frame(minWidth: 0, maxWidth: .infinity)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("Extracting")
                    .font(.custom("Futura-Meduim", size: 30))
                    .foregroundColor(.white)
                    .padding([.all],25)
                
                Spacer()
                
                if(uiiHidedImg == nil) {
                    Button (action: {self.bImgSourceSheet = true}) {
                        VStack {
                            Image(systemName: "photo.on.rectangle.angled")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 65)
                                .foregroundColor(.white)
                            
                            Text("Click to Select Image")
                                .foregroundColor(Color.white)
                                .font(.custom("Futura-Medium", size: 14))
                        }
                    }
                }
                
                if(uiiHidedImg != nil) {
                    Button (action: {self.bImgSourceSheet = true}) {
                        VStack {
                            Image(uiImage: self.uiiHidedImg!)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 400)
                                .foregroundColor(.white)
                            
                            Text("Click to Change Image")
                                .foregroundColor(Color.white)
                                .font(.custom("Futura-Medium", size: 14))
                        }
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        //print(LSB_Take(image: self.uiiHidedImg) ?? "nil")
                        print(F5_Take(image: self.uiiHidedImg) ?? "nil")
                    }) {
                        VStack {
                            Image(systemName: "tray.and.arrow.up.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50)
                                .foregroundColor(.white)
                            
                            Text("Extracting")
                                .foregroundColor(Color.white)
                                .font(.custom("Futura-Medium", size: 14))
                        }
                    }
                }
                
                Spacer()
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
            .sheet(isPresented: $bShowImgPkr) {
                ImagePicker(image: self.$uiiHidedImg,
                            isShown: self.$bShowImgPkr,
                            imageURL: self.$urlHidedImg,
                            sourceType: self.uiipkrctrlerSourceType)
            }
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        }
    }
}

struct ExtractingView_Previews: PreviewProvider {
    static var previews: some View {
        ExtractingView()
    }
}
