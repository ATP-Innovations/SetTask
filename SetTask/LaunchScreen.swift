//
//  SetTask
//
//  Created by Egor Poimanov on 2024-04-06.
//
//  and Igor Tsyupko, Nizar Atassi, Bulat Khungureev
//
//  LaunchScreen.swift



import SwiftUI

struct LaunchScreen: View {
    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                
                Text("SetTask")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                
                Spacer()
                
                Text("Made By\nNizar Atassi 101297716\nIgor Tsyupko 101379825\nEgor Poimanov 101249541\nBulat Khungureev 101370740\n\nGroup 38")
                    .multilineTextAlignment(.center)
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .padding()
            }
        }
    }
}

struct LaunchScreen_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreen()
    }
}
