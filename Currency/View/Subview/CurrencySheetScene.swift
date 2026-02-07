//
//  CurrencySheetScene.swift
//  Currency
//
//  Created by Ваган Галстян on 03.02.2026.
//

import SwiftUI

struct CurrencySheetScene: View {

    @State var chosenCurrency: CurrencyModel?

    let currencies: [CurrencyModel]
    let action: ((CurrencyModel) -> Void)?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Choose currency")
                .font(.title2)
                .bold()
            
            VStack(spacing: 16) {
                ForEach(currencies) { model in
                    currencyOption(model: model)
                }
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .background(
                Color.white
                    .cornerRadius(16)
            )
        }
        .padding(.horizontal, 16)
        .padding(.top, 30)
    }
}

extension CurrencySheetScene {
    func currencyOption(model: CurrencyModel) -> some View {
        HStack(spacing: 8) {
            Image(model.image)
                .resizable()
                .frame(width: 28, height: 28)
                .padding(6)
                .background(
                    Color.gray
                        .opacity(0.3)
                        .cornerRadius(8)
                )
            
            Text(model.name)
            
            Spacer()
            
            if let id = chosenCurrency?.id,
               id == model.id {
                Image(.mark)
            } else {
                Circle()
                    .stroke(lineWidth: 2)
                    .frame(width: 26, height: 26)
                    .foregroundStyle(Color.gray.opacity(0.4))
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            chosenCurrency = model
            action?(model)
        }
    }
}

let dollar1 = CurrencyModel(name: "USDc", rate: 1, image: .usa)
let euro1 = CurrencyModel(name: "EUR", rate: 0.8, image: .eur)

#Preview {
    CurrencySheetScene(chosenCurrency: dollar1, currencies: [dollar1, euro1]) { _ in
        print("Here")
    }
}
