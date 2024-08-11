//
//  IngredientResultView.swift
//  Mommy
//
//  Created by Kyubo Shim on 8/10/24.
//


import SwiftUI

struct IngredientResultView: View {
    @ObservedObject private var viewModel: IngredientRiskViewModel
    @ObservedObject private var captureCameraViewModel: CaptureCameraViewModel
    
    init(viewModel: IngredientRiskViewModel, captureCameraViewModel: CaptureCameraViewModel) {
        self.viewModel = viewModel
        self.captureCameraViewModel = captureCameraViewModel
        print("count \(viewModel.ingredientRisks.count)")
    }
    
    @State private var offsetY: CGFloat = 0
    
    var body: some View {
        VStack {
            ScrollView {
                GeometryReader { geometry in
                    let offset = geometry.frame(in: .global).minY
                    
                    ZStack {
                        if let image = captureCameraViewModel.imageData {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .clipped()
                                .frame(width: geometry.size.width, height: 250 + (offset > 0 ? offset : 0))
                                .offset(y: (offset > 0 ? -offset : 0))
                        } else {
                            Color.gray
                                .frame(width: geometry.size.width, height: 250)
                        }
                        
                        Text(viewModel.ingredientRisks.first?.product ?? "Unknown")
                            .foregroundColor(.white)
                            .font(.title)
                            .fontWeight(.bold)
                            .offset(y: (offset > 0 ? -offset : 0))
                    }
                }
                .frame(height: 250)
                
                LazyVStack(pinnedViews: [.sectionHeaders]) {
                    Section {
                        VStack(alignment: .leading, spacing: 16) {
                            Group {
                                riskSection(title: "Danger Factors", risks: viewModel.ingredientRisks.filter { $0.riskScore ?? 0 > 0 }, titleColor: .red)
                                
                                riskSection(title: "Neutral Factors", risks: viewModel.ingredientRisks.filter { $0.riskScore == 0 }, titleColor: .gray)
                                
                                riskSection(title: "Good Factors", risks: viewModel.ingredientRisks.filter { $0.riskScore ?? 0 < 0 }, titleColor: .green)
                            }
                        }
                        .padding()
                    }
                }
            }
            .overlay(
                Rectangle()
                    .foregroundColor(.white)
                    .frame(height: UIApplication.shared.windows.first?.safeAreaInsets.top)
                    .edgesIgnoringSafeArea(.all)
                    .opacity(offsetY > -250 ? 0 : 1)
                , alignment: .top
            )
            
            
            Button(action: {
                
            }) {
                Text("Share with the loved ones")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            .padding(.top, 10)
        }
    }

    @ViewBuilder
    private func stickyHeader() -> some View {
        Text("Food Name blah blah")
            .font(.headline)
            .padding()
            .background(Color.white)
            .cornerRadius(8)
            .shadow(radius: 4)
    }
    
    @ViewBuilder
    private func riskSection(title: String, risks: [IngredientRisk], titleColor: Color) -> some View {
        if !risks.isEmpty {
            Section(header: Text(title)
                        .font(.headline)
                        .foregroundColor(titleColor)) {
                ForEach(risks.sorted(by: { $0.riskSortOrder < $1.riskSortOrder })) { risk in
                    IngredientRiskView(risk: risk)
                }
            }
        }
    }
}


struct IngredientRiskView: View {
    let risk: IngredientRisk
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(risk.ingredient)
                    .font(.title2)
                    .fontWeight(.bold)
                    
                Spacer()
//                if let riskScore = risk.riskScore {
//                    Text("\(riskScore, specifier: "%.1f")")
//                        .font(.headline)
//                        .foregroundColor(.red)
//                } else {
//                    Text("N/A")
//                        .font(.headline)
//                        .foregroundColor(.gray)
//                }
            }
            
            if let riskCategory = risk.riskCategory {
                Text(riskCategory)
                    .font(.subheadline)
                    .foregroundColor(.red)
            } else {
                Text("No Category")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Text(risk.riskDescription ?? "No description available")
                .font(.body)
            
            
            Divider()
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(8)
        .shadow(radius: 4)
    }
}


#Preview {
    IngredientResultView(viewModel: IngredientRiskViewModel(ingredientRisks: IngredientDummyData.ingredientRisks), captureCameraViewModel: CaptureCameraViewModel())
}
