//
//  EnterInfoView.swift
//  Mommy
//
//  Created by Kyubo Shim on 8/10/24.
//

import SwiftUI

struct EnterInfoView: View {
    @Environment(\.colorScheme) private var scheme
    @AppStorage("userName") private var userName = ""
    @AppStorage("currentStage") private var currentStage: String?
    @AppStorage("weekOfPregnancy") private var weekOfPregnancy = ""
    @AppStorage("dueDate") private var dueDateString = ""
    @AppStorage("allergies") private var allergies = ""
    @Binding var currentPage: Int
    
    @State private var dueDate: Date = Date()

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }

    private func updateDueDateString() {
        dueDateString = dateFormatter.string(from: dueDate)
    }

    private var isFormComplete: Bool {
        !userName.isEmpty && currentStage != nil && !weekOfPregnancy.isEmpty && !allergies.isEmpty
    }
    
    var body: some View {
        ZStack {
            Color(uiColor: .preimary)
                .ignoresSafeArea()
            ScrollView {
                VStack(spacing: 20) {
                    Spacer()
                    
                    Text("Tell us who you are!")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .padding(.bottom, 30)
                    
                    VStack(alignment: .leading, spacing: 15) {
                        Group {
                            Text("Enter your full name")
                            TextField("Name", text: $userName)
                                .frame(height: 40)
                                .padding(.horizontal, 15)
                                .padding(.vertical, 5)
                                .background(Color.white)
                                .cornerRadius(15)
                                .shadow(color: .black.opacity(0.2), radius: 3)
                                .frame(maxWidth: 350)
                        }
                        
                        Group {
                            Text("Select your current stage")
                            DropDownView(
                                hint: "Select",
                                options: [
                                    "Pre-Pregnant",
                                    "Currently Pregnant",
                                    "Post-Pregnant"
                                ],
                                anchor: .bottom,
                                selection: $currentStage
                            )
                        }
                        
                        Group {
                            Text("Week of pregnancy")
                            TextField("Week of Pregnancy", text: $weekOfPregnancy)
                                .frame(height: 40)
                                .padding(.horizontal, 15)
                                .padding(.vertical, 5)
                                .background(Color.white)
                                .cornerRadius(15)
                                .shadow(color: .black.opacity(0.2), radius: 3)
                                .frame(maxWidth: 350)
                                .keyboardType(.numberPad)
                        }
                        
                        Group {
                            Text("Due Date")
                            DatePicker("Select due date", selection: $dueDate, displayedComponents: .date)
                                .datePickerStyle(CompactDatePickerStyle())
                                .frame(height: 40)
                                .padding(.horizontal, 15)
                                .padding(.vertical, 5)
                                .background(Color.white)
                                .cornerRadius(15)
                                .shadow(color: .black.opacity(0.2), radius: 3)
                                .frame(maxWidth: 350)
                                .onChange(of: dueDate) { newValue in
                                    updateDueDateString()  // 날짜가 변경될 때마다 문자열 업데이트
                                }
                        }
                        
                        Group {
                            Text("Known Allergies")
                            TextField("Allergies", text: $allergies)
                                .frame(height: 40)
                                .padding(.horizontal, 15)
                                .padding(.vertical, 5)
                                .background(Color.white)
                                .cornerRadius(15)
                                .shadow(color: .black.opacity(0.2), radius: 3)
                                .frame(maxWidth: 350)
                        }
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        currentPage += 1
                    }, label: {
                        Text("Let's Go!")
                            .font(.body)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .foregroundColor(.white)
                            .background(isFormComplete ? Color(uiColor: .preimary) : Color.gray)
                            .cornerRadius(10)
                    })
                    
                    Spacer()
                }
                .padding()
                .background(
                    Color.clear.contentShape(Rectangle())
                        .onTapGesture {
                            hideKeyboard()
                        }
                )
            }
            .onAppear {
                if let date = dateFormatter.date(from: dueDateString) {
                    dueDate = date
                }
            }
        }
    }
}


#Preview {
    EnterInfoView(currentPage: .constant(1))
}
