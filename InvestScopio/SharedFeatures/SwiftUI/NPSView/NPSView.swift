//
//  NPSView.swift
//  InvestScopio
//
//  Created by Joao Gabriel Pereira on 28/09/20.
//  Copyright © 2020 Joao Medeiros Pereira. All rights reserved.
//

import SwiftUI

struct NPSView: View {
    @Binding var ratings: [String]
    @Binding var selectedRating: Int?
    var body: some View {
        HStack {
            ForEach(0..<Int(ratings.count), id: \.self) { index in
                NPSItem(title: ratings[index], showCheck: shouldSelectUntil(index: index)).onTapGesture {
                    withAnimation {
                        selectedRating = selectedRating == index ? nil : index
                    }
                }
            }
        }.background(Color.clear)
    }
    
    private func shouldSelectUntil(index: Int) -> Binding<Bool> {
        if let selectedIndex = selectedRating, index <= selectedIndex {
            return .constant(true)
        }
        return .constant(false)
    }
}

struct NPSItem: View {
    var title: String
    @Binding var showCheck: Bool
    var body: some View {
        VStack {
            Star(corners: 5, smoothness: 0.4)
                .stroke(Color(.JEWDefault()), lineWidth: 2).background(Star(corners: 5, smoothness: 0.4).foregroundColor(showCheck ? Color(.JEWDefault()) : .clear))
                .frame(height: 30)
                .scaleEffect(CGSize(width: 0.5, height: 1.0))
            Text(title).font(.caption)
        }
    }
}


struct NPSView_Previews: PreviewProvider {
    static var previews: some View {
        NPSView(ratings: .constant(["Péssimo", "Ruim", "OK", "Bom", "Ótimo"]), selectedRating: .constant(2))
    }
}
