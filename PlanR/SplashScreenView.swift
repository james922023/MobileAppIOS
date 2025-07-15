//
//  SplashScreenView.swift
//  PlanR
//
//  Created by James Yackanich on 12/8/24.
//

import SwiftUI

struct SplashScreenView: View {
    var body: some View {
        ZStack {
            Color.blue // Background color
                .edgesIgnoringSafeArea(.all)

            VStack {
                Image("DrawingSmall") // Replace with your app's logo
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.white)

                Text("PlanR")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top, 16)
            }
        }
    }
}


