//
//  StegoView.swift
//  StegoHenge
//
//  Created by JCYang on 2020/10/15.
//

import SwiftUI

struct StegoView: View {
    var body: some View {
        TabView {
            EmbeddingView()
                .tabItem {
                    Image(systemName: "tray.and.arrow.down.fill")
                    Text("Embedding")
                }
            
            ExtractingView()
                .tabItem {
                    Image(systemName: "tray.and.arrow.up.fill")
                    Text("Extracting")
                }
        }
        .onAppear() {
            UITabBar.appearance().unselectedItemTintColor = UIColor.white
            UITabBar.appearance().backgroundImage = UIImage()
            UITabBar.appearance().shadowImage = UIImage()
        }
    }
}

struct StegoView_Previews: PreviewProvider {
    static var previews: some View {
        StegoView()
    }
}
