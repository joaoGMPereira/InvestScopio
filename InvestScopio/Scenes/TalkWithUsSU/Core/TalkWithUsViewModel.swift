//
//  TalkWithUsViewModel.swift
//  InvestScopio
//
//  Created by Joao Gabriel Pereira on 28/09/20.
//  Copyright © 2020 Joao Medeiros Pereira. All rights reserved.
//

import Foundation
import SwiftUI
import JewFeatures

class TalkWithUsViewModel: ObservableObject {
    @Published var ratings = ["Péssimo", "Ruim", "OK", "Bom", "Ótimo"]
    @Published var feedbacks = ["Sugestão", "Reclamação", "Elogio", "Feedback"]
    @Published var selectedRating: Int? {
        didSet {
            print("funcionou")
        }
    }
    @Published var sendingRating: Bool = false
    @Published var selectedFeedback: String?
}
