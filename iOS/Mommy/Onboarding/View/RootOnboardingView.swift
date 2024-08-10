//
//  RootOnboardingView.swift
//  Mommy
//
//  Created by Kyubo Shim on 8/10/24.
//

import SwiftUI

struct RootOnboardingView: View {
    @State private var currentPage: Int = 0
    @State private var showEgg = false
    @State private var showView = true
    
    var pages: [AnyView] {
        [
            AnyView(OnboardingWelcomeView(currentPage: $currentPage)),
            AnyView(EnterInfoView(currentPage: $currentPage)),
        ]
    }
    
    var body: some View {
        if currentPage < pages.count {
            pages[currentPage]
        } else {
            HomeView()
        }
        
    }
}

#Preview {
    RootOnboardingView()
}
