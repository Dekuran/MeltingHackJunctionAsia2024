//
//  EnterInfoView.swift
//  Mommy
//
//  Created by Kyubo Shim on 8/10/24.
//

import SwiftUI

struct EnterInfoView: View {
    @Environment(\.colorScheme) private var scheme
    @State private var userName = ""
    @State private var currentStage: String?
    @State private var weekOfPregnancy = ""
    @State private var dueDate = Date()
    @State private var allergies = ""
    @Binding var currentPage: Int
    
    var body: some View {
    
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
                    .background(Color(uiColor: .preimary))
                    .cornerRadius(10)
                    .padding(.horizontal, 20)
            })
            
            Spacer()
        }
    }
}

#Preview {
    EnterInfoView(currentPage: .constant(1))
}
