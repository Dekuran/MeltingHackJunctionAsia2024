import SwiftUI


struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()

    var body: some View {
        ZStack {
            Color(uiColor: .preimary)
                .ignoresSafeArea()

            contentView

            bottomButton
        }
        .onAppear {
            viewModel.fetchEncouragementMessage()
        }
        .fullScreenCover(isPresented: $viewModel.isPresented, content: ScanView.init)
    }
    
    var contentView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 24.0)
                .foregroundColor(Color(uiColor: .secondary))

            profileView
        }
    }
    
    var profileView: some View {
        VStack {
            Spacer().frame(height: 4)
            // Displaying the user's name
            Text(viewModel.userGreeting)
                .font(.system(size: 27))
                .fontWeight(.heavy)
                .foregroundColor(Color(uiColor: .button))
                .padding(.bottom, 8)

            // Displaying the weeks and days passed since the start
            Text("\(viewModel.weeksSinceStart.weeks) weeks, \(viewModel.weeksSinceStart.days) days")
                .font(.system(size: 27))
                .fontWeight(.semibold)
                .foregroundColor(Color(uiColor: .button))
                .padding(.bottom, 2)

            Text("Due Date in \(viewModel.weeksUntilDue.weeks) weeks")
                .font(.system(size: 16))
                .fontWeight(.semibold)
                .foregroundColor(Color(uiColor: .button))
                .padding(.bottom, 4)


            Image("BabyImage")
                .resizable()
                .scaledToFit()
                .frame(width: 200)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.white, lineWidth: 4))
                .shadow(radius: 7)
            
            messageView
            
            Spacer()
        }
    }
    
    var messageView: some View {
        ZStack {
            VStack {
                Spacer().frame(height: 36.0)

                RoundedRectangle(cornerRadius: 24.0)
                    .foregroundColor(.white)
            }
            
            VStack {
                vegetablebar
                
                Text("Weeks Food Track")
                    .font(.system(size: 24))
                    .fontWeight(.semibold)
                    .foregroundColor(Color(uiColor: .button))
                
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .foregroundColor(.white)
                } else {
                    // Displaying the encouragement and advice
                    Text(viewModel.encouragementMessage)
                        .font(.system(size: 14))
                        .foregroundColor(Color(uiColor: .button))
                        .padding()
                        .multilineTextAlignment(.center)
                }
                
                Image("calendar")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 108)
                
                Spacer()
            }
        }
    }
    
    var vegetablebar: some View {
        ZStack {
            Image("vegetableBar")
                .resizable()
                .scaledToFit()
                .frame(height: 89)
            
            Text("\(viewModel.weeksSinceStart.weeks)")
                .font(.system(size: 55))
                .fontWeight(.heavy)
                .foregroundColor(Color(uiColor: .button))
        }
    }
    
    var bottomButton: some View {
        VStack {
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
    }
}


//#Preview {
//    HomeView()
//}
