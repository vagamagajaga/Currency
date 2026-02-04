//
//  CurrencyScene.swift
//  Currency
//
//  Created by Ваган Галстян on 02.02.2026.
//

import SwiftUI
import FitSheet

private enum Fields {
    case first
    case second
}

struct CurrencyScene: View {
    
    @FocusState private var focusedField: Fields?
    
    @ObservedObject var viewModel: CurrencyViewModel
    
    @State private var isSheetVisible: Bool = false
    
    var body: some View {
        ZStack {
            Color.gray.ignoresSafeArea().opacity(0.3)
                .onTapGesture {
                    focusedField = nil
                }
            
            content()
        }
        .sheet(isPresented: $isSheetVisible) {
            CurrencySheetScene(
                chosenCurrency: viewModel.actualCurrency,
                currencies: viewModel.currencies
            ) { model in
                viewModel.changeCurrency(to: model)
                isSheetVisible = false
            }
            .fitSheet()
        }
        .onAppear {
            Task {
                await viewModel.fetchData()
            }
        }
    }
}

extension CurrencyScene {
    func content() -> some View {
        VStack(
            alignment: .leading,
            spacing: 24
        ) {
            headerView()
            
            fieldsBlock()
                .overlay {
                    switchButton()
                }
            
            Spacer()
        }
        .padding(.horizontal)
        .padding(.top, 40)
    }
}

extension CurrencyScene {
    func headerView() -> some View {
        VStack(
            alignment: .leading,
            spacing: 8
        ) {
            title()
            currencyCourse()
        }
    }
    
    func title() -> some View {
        Text("Exchange Calculator")
            .font(.title)
            .bold()
    }
    
    func currencyCourse() -> some View {
        Text(provideCourseText())
            .foregroundStyle(.green)
            .bold()
    }
}

extension CurrencyScene {
    func fieldsBlock() -> some View {
        VStack(spacing: 16) {
            CurrencyField(
                model: $viewModel.mainModel
            ) {
                isSheetVisible = true
            }
            .onChange(of: viewModel.mainModel.amount) { _, _ in
                guard let focusedField, focusedField == .first else { return }
                
                viewModel.updateModel(for: viewModel.mainModel.isMain)
            }
            .focused($focusedField, equals: Fields.first)
            
            CurrencyField(
                model: $viewModel.secondModel,
            ) {
                isSheetVisible = true
            }
            .onChange(of: viewModel.secondModel.amount) { _, _ in
                guard let focusedField, focusedField == .second else { return }
                
                viewModel.updateModel(for: viewModel.secondModel.isMain)
            }
            .focused($focusedField, equals: Fields.second)
        }
    }
    
    func switchButton() -> some View {
        Button {
            viewModel.switchModels()
        } label: {
            Image(.switch)
        }
    }
}

extension CurrencyScene {
    func provideCourseText() -> String {
        "1 USDc = \(viewModel.actualCurrency.formattedCourse) \(viewModel.actualCurrency.name)"
    }
}

#Preview {
    CurrencyScene(
        viewModel: CurrencyViewModel()
    )
}
