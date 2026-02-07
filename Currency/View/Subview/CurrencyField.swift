//
//  CurrencyField.swift
//  Currency
//
//  Created by Ваган Галстян on 03.02.2026.
//

import SwiftUI

struct CurrencyField: View {
    
    @Binding var model: CurrencyFieldModel
        
    private let action: (() -> Void)?
    
    init(
        model: Binding<CurrencyFieldModel>,
        action: (() -> Void)? = nil
    ) {
        _model = model
        self.action = action
    }
    
    var body: some View {
        HStack(spacing: 8) {
            Image(model.currency.image)
                .resizable()
                .frame(width: 16, height: 16)
            
            Text(model.currency.name)
                .bold()
            
            if !model.isMain {
                courseChangeButton()
            }
            
            Spacer()
                .frame(maxWidth: .infinity)
            
            TextField(
                "$",
                value: $model.amount,
                format: .number,
            )
            .bold()
            .keyboardType(.decimalPad)
        }
        .padding(.vertical, 23)
        .padding(.horizontal, 16)
        .background(
            Rectangle()
                .foregroundStyle(.white)
                .cornerRadius(16)
        )
    }
}

extension CurrencyField {
    func courseChangeButton() -> some View {
        Button {
            action?()
        } label: {
            Image(systemName: "chevron.down")
                .foregroundStyle(.black)
                .bold()
        }
    }
}

let dollar = CurrencyModel(name: "USDc", rate: 1, image: .usa)
let dollarModel = CurrencyFieldModel(currency: dollar, amount: 0)

#Preview {
    ZStack {
        Color.yellow
        
        VStack {
            CurrencyField(model: .constant(dollarModel))
            CurrencyField(model: .constant(dollarModel))
        }
        .padding(16)
    }
}
