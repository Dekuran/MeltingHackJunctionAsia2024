//
//  OnboardingWelcomeView.swift
//  Mommy
//
//  Created by Kyubo Shim on 8/10/24.
//

import SwiftUI
import Lottie

struct OnboardingWelcomeView: View {
    @Binding var currentPage: Int
    var body: some View {
        VStack {
            HStack{
                VStack(alignment: .leading) {
                    Text("Your")
                    Text("Safest Pregnant")
                    Text("Guide")
                }
                .font(.largeTitle)
                .fontWeight(.semibold)
                
                Spacer()
            }
            .padding(.top, 50)
            
            Spacer()
            
            LottieView(animation: .named("BabyLottie"))
                .playing(loopMode: .loop)
                
            
            Spacer()
            
            Button(action: {
                withAnimation{
                    currentPage += 1
                }
            }, label: {
                Text("Hello!")
                    .font(.body)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(10)
            })
            Spacer()
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    OnboardingWelcomeView(currentPage: .constant(0))
}
