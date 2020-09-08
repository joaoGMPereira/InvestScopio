//
//  SimulationCreationView.swift
//  InvestScopio
//
//  Created by Joao Gabriel Pereira on 27/08/20.
//  Copyright © 2020 Joao Medeiros Pereira. All rights reserved.
//

import SwiftUI
import Introspect
import JewFeatures

struct SimulationCreationView: View {
    @ObservedObject var viewModel: SimulationCreationViewModel
    @ObservedObject var stepViewModel: SimulationCreationStepViewModel
    @Environment(\.sizeCategory) internal var defaultSizeCategory: ContentSizeCategory
    @EnvironmentObject var reachability: Reachability
    @EnvironmentObject var settings: AppSettings
    
    var body: some View {
        ZStack {
            defaultView()
            stepView()
        }
    }
}

//MARK: - Default View
extension SimulationCreationView {
    func defaultView() -> some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    firstSteps()
                    middleSteps()
                    finalSteps()
                }
            }
            .padding(.bottom, 22)
            .navigationBarTitle("Simulação", displayMode: .large)
        }
    }
    
    fileprivate func firstSteps() -> some View {
        return ForEach(Range(0...1), id: \.self) { index in
            self.stepTextField(index: index).padding(.horizontal)
        }
    }
    
    fileprivate func middleSteps() -> some View {
        HStack(spacing: 8) {
            stepTextField(index: 2)
            stepTextField(index: 3)
        }.padding(.horizontal)
    }
    
    fileprivate func finalSteps() -> some View {
        return ForEach(4..<viewModel.allSteps.count, id: \.self) { index in
            self.stepTextField(index: index).padding(.horizontal)
        }
    }
    
    fileprivate func stepTextField(index: Int) -> some View {
        ZStack {
            FloatingTextField(toolbarBuilder: JEWFloatingTextFieldToolbarBuilder().setToolbar(leftButtons: [.cancel, .back], rightButtons: [.ok]), formatBuilder: FloatingTextField.defaultFormatBuilder(placeholderColor: .label), placeholder: .constant(self.viewModel.allSteps[index].type.setNextStepPlaceHolder()), text: self.$viewModel.allSteps[index].value, formatType: .constant(self.viewModel.allSteps[index].type.setFormat()), close: self.$viewModel.close, shouldBecomeFirstResponder: .constant(false), tapOnToolbarButton: { textField, type in
                //self.tapOnToolbar(textField: textField, type: type)
            }) { textfield, text, isBackspace in
                var updatedText = text
                if isBackspace && !text.isEmpty {
                    updatedText.removeLast()
                }
                // self.stepViewModel.updateStep(textField: textfield, text: updatedText)
            }
            .frame(height: 50)
            .padding(8)
            GeometryReader { geometry in
                Rectangle().frame(height: 2).foregroundColor(Color(.JEWDefault())).position(x: geometry.size.width/2, y: geometry.size.height - 1)
            }
        }
        .background(Color(.systemGray5))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

struct SimulationCreationView_Previews: PreviewProvider {
    static var previews: some View {
        SimulationCreationView(viewModel: SimulationCreationViewModel(), stepViewModel: SimulationCreationStepViewModel())
    }
}
