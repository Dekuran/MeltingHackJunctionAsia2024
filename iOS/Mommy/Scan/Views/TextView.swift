import SwiftUI
import Combine
import Lottie

struct TextView: View {
    
    let backgroundColor: Color = .init(red: 25 / 255, green: 27 / 255, blue: 35 / 255)
    let gradientColor: Color = .init(red: 13 / 255, green: 15 / 255, blue: 25 / 255, opacity: 0)
    let themeBlue: Color = .init(red: 1 / 255, green: 150 / 255, blue: 240 / 255)
    let themeGray: Color = .init(red: 46 / 255, green: 48 / 255, blue: 51 / 255)
    let placeholderGray: Color = .init(red: 214 / 255, green: 199 / 255, blue: 199 / 255)
    let secondalyGray: Color = .init(red: 142 / 255, green: 145 / 255, blue: 154 / 255)
    

    @StateObject var speechRecognizer = SpeechRecognizer()
    @State private var isRecording = false
    @FocusState var isEditing: Bool
    @State var inputText: String = ""
    @State private var animateBigCircle = false
    @State private var animateSmallCircle = false

    var body: some View {
        ZStack {
            mainContent
            
            if !isEditing {
                VStack {
                    Spacer()
                    footer
                }
                .ignoresSafeArea()
            }
        }
    }
    
    var mainContent: some View {
        ScrollViewReader { proxy in
            VStack {
                ScrollView {
                    VStack {
                        Spacer()
                        LottieView(animation: .named("SpeechBubble"))
                            .playing(loopMode: .loop)

                        if isRecording {
                            ScrollView {
                                Text(speechRecognizer.transcript)
                                    .font(.system(size: 24))
                                    .foregroundColor(Color(uiColor: .button))
                            }
                            .padding(.horizontal, 36)
                            .frame(maxHeight: 100)
                        } else {
                            textInputView
                        }
                        Spacer().frame(height: 48)
                    }
                }
            }
        }
    }

    var textInputView: some View {
        HStack(spacing: 4) {
            TextField("", text: $inputText, axis: .vertical)
                .font(.system(size: 24))
                .foregroundColor(Color(uiColor: .button))
                .focused($isEditing)
                .onSubmit { isEditing = false }
                .padding(.horizontal, 36)
                .frame(maxHeight: 100)
            if isEditing {
                Button {
                    isEditing = false
                    isRecording = false
                    if !inputText.isEmpty {
                        requestAISuggest()
                    }
                } label: {
                    Image(systemName: "paperplane.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 32, height: 32)
                        .accentColor(Color(uiColor: .button))
                }
                .frame(width: 57, height: 57)
                .padding(.trailing, 24)
            }
        }
    }
    
    var footer: some View {
        ZStack {
            HStack(alignment: .bottom) {
                Button(action: {
                    isEditing = true
                }, label: {
                    Image(systemName: "keyboard")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 32, height: 32)
                        .accentColor(Color(uiColor: .button))
                })
                .frame(width: 57, height: 57)
                Spacer()
                
                Button(action: {
                    if !isRecording {
                        speechRecognizer.transcribe()
                    } else {
                        speechRecognizer.stopTranscribing()
                        inputText = speechRecognizer.transcript
                    }
                    isRecording.toggle()
                }) {
                    if isRecording {
                        ZStack {
                            Circle() // Big circle
                                .stroke()
                                .frame(width: 140, height: 140)
                                .foregroundColor(Color(uiColor: .button))
                                .scaleEffect(animateBigCircle ? 1 : 0.3)
                                .opacity(animateBigCircle ? 0: 1)
                                .animation (Animation.easeInOut (duration:2)
                                    .repeatForever(autoreverses: false))
                                .onAppear() { self.animateBigCircle.toggle() }
                            Circle () //Gray
                                .foregroundColor(Color(uiColor: .secondary).opacity(0.5))
                                .frame(width: 88, height: 88)
                                .scaleEffect(animateSmallCircle ? 0.9 : 1.2)
                                .animation(Animation.easeInOut (duration: 0.4)
                                    .repeatForever(autoreverses: false))
                                .onAppear() { self.animateSmallCircle.toggle() }
                            Image(systemName: "stop.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 56, height: 56)
                                .accentColor(Color(uiColor: .button))
                        }
                    } else {
                        Image(systemName: "mic")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 56, height: 56)
                            .accentColor(Color(uiColor: .button))
                    }
                }
                .frame(width: 88, height: 88)
                Spacer()
                Button {
                    isEditing = false
                    isRecording = false
                    if !inputText.isEmpty {
                        requestAISuggest()
                    }
                } label: {
                    Image(systemName: "paperplane.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 32, height: 32)
                        .accentColor(Color(uiColor: .button))

                }
                .frame(width: 57, height: 57)
            }
//        }
            .padding(.bottom, 48)
            .frame(height: 148)
            .padding(.horizontal, 36)
            .ignoresSafeArea(.keyboard)
        }
    }
}

extension TextView {
    func requestAISuggest() {
        withAnimation {
//            chatHistories.append(.me(message: inputText))
//            isSplash = false
//            chatHistories.append(.loading)
            speechRecognizer.transcript = ""
        }

//        Task {
//            do {
//                guard let url = URL(string: "https://east-meets-north.citroner.blog/cgi/query?question=\(inputText)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") else { return }
//                let urlRequest = URLRequest(url: url)
//                let (data, _) = try await URLSession.shared.data(for: urlRequest)
//                let aiMessage = try JSONDecoder().decode(AIMessage.self, from: data)
//                if case .loading = chatHistories.last {
//                    chatHistories.removeLast()
//                }
//                chatHistories.append(.ai(message: aiMessage))
//                inputText = ""
//            } catch {
//                errorHandling(with: "Network Issue, Please try it later.")
//            }
//        }
    }
}
