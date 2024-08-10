//
//  RootOnboardingView.swift
//  Mommy
//
//  Created by Kyubo Shim on 8/10/24.
//

import SwiftUI

struct RootOnboardingView: View {
    @State private var currentPage: Int = 0
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding: Bool = false
    
    var pages: [AnyView] {
        [
            AnyView(OnboardingWelcomeView(currentPage: $currentPage)),
            AnyView(EnterInfoView(currentPage: $currentPage)),
        ]
    }
    
    var body: some View {
        if hasSeenOnboarding {
            HomeView()
        } else {
            if currentPage < pages.count {
                pages[currentPage]
            } else {
                HomeView()
                    .onAppear {
                        hasSeenOnboarding = true
                    }
            }
        }
    }
}

#Preview {
    RootOnboardingView()
}
