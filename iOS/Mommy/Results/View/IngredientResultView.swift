//
//  IngredientResultView.swift
//  Mommy
//
//  Created by Kyubo Shim on 8/10/24.
//

import SwiftUI

struct IngredientResultView: View {
    @StateObject private var viewModel: IngredientRiskViewModel
    @ObservedObject private var captureCameraViewModel: CaptureCameraViewModel
    
    // DI를 위한 초기화 함수. 기본적으로 더미 데이터를 사용.
    init(viewModel: IngredientRiskViewModel = IngredientRiskViewModel(ingredientRisks: IngredientDummyData.ingredientRisks), captureCameraViewModel: CaptureCameraViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.captureCameraViewModel = captureCameraViewModel
    }
    
    @State private var offsetY: CGFloat = 0
    
    var body: some View {
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
                    
                    Text("Captured Image here")
                        .foregroundColor(.white)
                        .font(.title)
                        .fontWeight(.bold)
                        .offset(y: (offset > 0 ? -offset : 0))
                }
            }
            .frame(height: 250)
            
            LazyVStack(pinnedViews: [.sectionHeaders]) {
                Section(header: stickyHeader()) {
                    VStack(alignment: .leading, spacing: 16) {
                        Group {
                            riskSection(title: "Danger Factors", risks: viewModel.ingredientRisks.filter { $0.riskScore < 0 }, titleColor: .red)
                            
                            riskSection(title: "Neutral Factors", risks: viewModel.ingredientRisks.filter { $0.riskScore == 0 }, titleColor: .gray)
                            
                            riskSection(title: "Good Factors", risks: viewModel.ingredientRisks.filter { $0.riskScore > 0 }, titleColor: .green)
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
    }
    
    // Sticky Header를 위한 함수
    @ViewBuilder
    private func stickyHeader() -> some View {
        Text("Food Name blah blah")
            .font(.headline)
            .padding()
            .background(Color.white)
            .cornerRadius(8)
            .shadow(radius: 4)
    }
    
    // 위험 요소 섹션을 생성하는 함수
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


// 개별 성분에 대한 정보를 표시하는 하위 뷰
struct IngredientRiskView: View {
    let risk: IngredientRisk
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(risk.ingredient)
                    .font(.title2)
                    .foregroundColor(Color(hex: risk.hexColor))
                Spacer()
                Text("\(risk.riskScore)")
                    .font(.headline)
                    .foregroundColor(.red)
            }
            
            Text(risk.riskCategory)
                .font(.subheadline)
                .foregroundColor(.red)
            
            Text(risk.riskDescription)
                .font(.body)
            
            Text("Pregnancy Status: \(risk.pregnancyStatus)")
                .font(.footnote)
                .foregroundColor(.secondary)
            
            Text("Weeks: \(risk.pregnancyOrPostBirthWeeks)")
                .font(.footnote)
                .foregroundColor(.secondary)
            
            Divider()
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(8)
        .shadow(radius: 4)
    }
}

// Hex 코드를 기반으로 Color를 생성하는 확장 함수
extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.currentIndex = hex.startIndex
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        let r = Double((rgbValue & 0xFF0000) >> 16) / 255.0
        let g = Double((rgbValue & 0x00FF00) >> 8) / 255.0
        let b = Double(rgbValue & 0x0000FF) / 255.0
        self.init(red: r, green: g, blue: b)
    }
}

#Preview {
    IngredientResultView(captureCameraViewModel: CaptureCameraViewModel())
}
