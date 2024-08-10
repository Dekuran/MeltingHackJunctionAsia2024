//
//  IngredientResultView.swift
//  Mommy
//
//  Created by Kyubo Shim on 8/10/24.
//

import SwiftUI

struct IngredientResultView: View {
    @StateObject private var viewModel: IngredientRiskViewModel
    
    // DI를 위한 초기화 함수. 기본적으로 더미 데이터를 사용.
    init(viewModel: IngredientRiskViewModel = IngredientRiskViewModel(ingredientRisks: IngredientDummyData.ingredientRisks)) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Result")
                    .font(.largeTitle)
                    .padding(.bottom, 10)
                
                Group {
                    riskSection(title: "Danger Factors", risks: viewModel.ingredientRisks.filter { $0.riskScore < 0 }, titleColor: .red)
                    
                    riskSection(title: "Neutral Factors", risks: viewModel.ingredientRisks.filter { $0.riskScore == 0 }, titleColor: .gray)
                    
                    riskSection(title: "Good Factors", risks: viewModel.ingredientRisks.filter { $0.riskScore > 0 }, titleColor: .green)
                }
            }
            .padding()
        }
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
    IngredientResultView()
}
