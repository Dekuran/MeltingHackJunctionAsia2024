import SwiftUI


struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()

    var body: some View {
        ZStack {
            Color(uiColor: .preimary)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                
                // MARK: Circle Image Of baby
                Image("BabyImage")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 4))
                    .shadow(radius: 7)
                
                // Displaying the user's name
                Text(viewModel.userGreeting)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                // Displaying the weeks and days passed since the start
                Text("It's been..")
                    .font(.headline)
                    .foregroundColor(.white)
                Text("\(viewModel.weeksSinceStart.weeks) weeks and \(viewModel.weeksSinceStart.days) days!")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                
                // Displaying the weeks and days until the due date
                Text("Until the baby arrives..")
                    .font(.headline)
                    .foregroundColor(.white)
                Text("\(viewModel.weeksUntilDue.weeks) weeks and \(viewModel.weeksUntilDue.days) days left!")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                
                // 로딩 중일 때 로딩 인디케이터 표시
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .foregroundColor(.white)
                } else {
                    // Displaying the encouragement and advice
                    Text(viewModel.encouragementMessage)
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .multilineTextAlignment(.center)
                }
                
                Spacer()
                
                Button(
                    action: {
                        viewModel.isPresented.toggle()
                    },
                    label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 16.0)
                                .frame(height: 44.0)
                                .foregroundColor(.init(uiColor: .button))
                            Text("Scan for Nutrients")
                                .foregroundColor(.white)
                                .fontWeight(.semibold)
                        }
                    }
                )
                .padding(.horizontal, 24)
            }
            .padding()
        }
        .onAppear {
            viewModel.fetchEncouragementMessage()
        }
        .fullScreenCover(isPresented: $viewModel.isPresented, content: ScanView.init)
    }
}


#Preview {
    HomeView()
}
