import SwiftUI

struct HomeView: View {
    
    @State private var isPresented = false

    var body: some View {
        ZStack {
            Color(uiColor: .preimary)
            bottomButton
        }
        .ignoresSafeArea()
        .fullScreenCover(isPresented: $isPresented, content: ScanView.init)
    }

    var bottomButton: some View {
        VStack {
            Spacer()
           
            Button(
                action: {
                    isPresented.toggle()
                },
                label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 16.0)
                            .frame(height: 44.0)
                            .foregroundColor(.init(uiColor: .button))
                        Text("Scan for Nutrients")
                            .foregroundColor(.white)
                    }
                }
            )
            .padding([.horizontal, .bottom], 24)
        }
    }
}
