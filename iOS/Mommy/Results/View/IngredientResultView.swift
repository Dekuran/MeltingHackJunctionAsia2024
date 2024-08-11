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
    
    // DI를 위한 초기화 함수. 실제 데이터 기반으로 구성
    init(viewModel: IngredientRiskViewModel, captureCameraViewModel: CaptureCameraViewModel) {
        self.viewModel = viewModel
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
                            riskSection(title: "Danger Factors", risks: viewModel.ingredientRisks.filter { $0.riskScore ?? 0 < 0 }, titleColor: .red)
                            
                            riskSection(title: "Neutral Factors", risks: viewModel.ingredientRisks.filter { $0.riskScore == 0 }, titleColor: .gray)
                            
                            riskSection(title: "Good Factors", risks: viewModel.ingredientRisks.filter { $0.riskScore ?? 0 > 0 }, titleColor: .green)
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
                    
                Spacer()
                if let riskScore = risk.riskScore {
                    Text("\(riskScore, specifier: "%.1f")")
                        .font(.headline)
                        .foregroundColor(.red)
                } else {
                    Text("N/A")
                        .font(.headline)
                        .foregroundColor(.gray)
                }
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

// #Preview 설정은 기본적으로 Dummy 데이터를 통해 설정하고 있으므로, 변경이 필요 없습니다.
// 실제 데이터는 .result에서 전달된 데이터가 표시됩니다.
#Preview {
    IngredientResultView(viewModel: IngredientRiskViewModel(ingredientRisks: IngredientDummyData.ingredientRisks), captureCameraViewModel: CaptureCameraViewModel())
}
