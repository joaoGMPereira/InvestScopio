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
    @ObservedObject var detailViewModel: SimulationDetailViewModel
    @ObservedObject var stepViewModel: SimulationCreationStepViewModel
    @Environment(\.sizeCategory) internal var defaultSizeCategory: ContentSizeCategory
    @EnvironmentObject var reachability: Reachability
    @EnvironmentObject var settings: AppSettings
    
    var body: some View {
        ZStack {
            defaultView()
            stepView().opacity(self.viewModel.shouldSimulate ? 0 : 1)
        }
    }
}

//MARK: - Default View
extension SimulationCreationView {
    func defaultView() -> some View {
        NavigationView {
            ScrollView {
                KeyboardHost {
                    VStack(spacing: 16) {
                        NavigationLink(destination: NavigationLazyView(SimulationDetailView(viewModel: self.detailViewModel)), isActive: self.$viewModel.shouldSimulate) {
                            EmptyView()
                        }
                        firstSteps()
                        middleSteps()
                        finalSteps()
                        DoubleButtons(firstIsLoading: .constant(false), secondIsLoading: .constant(false), firstIsEnable: .constant(true), secondIsEnable: .constant(true), firstModel: .init(title: "Simular", color: Color(.JEWDefault()), isFill: true), secondModel: .init(title: "Nova Simulação", color: Color(.JEWDefault()), isFill: false), background: Color(.JEWBackground()), firstCompletion: {
                            self.viewModel.selectFirstButton(completion: { (simulation) in
                                self.settings.popup = AppPopupSettings()
                                self.detailViewModel.simulation = simulation
                            }, failure: { (settings) in
                                self.settings.popup = settings
                            })
                        }) {
                            self.viewModel.cleanTextFields() {
                                self.settings.popup = AppPopupSettings()
                            }
                        }
                    }
                }
            }
            .padding(.top, 16)
            .padding(.bottom, 22)
            .navigationBarTitle("Simulação", displayMode: .inline)
            
            .introspectViewController(customize: { (view) in
                view.background = .JEWBackground()
            })
            .introspectScrollView(customize: { (scrollView) in
                if self.viewModel.shouldScrollBottom {
                    scrollView.scrollTo(edge: .bottom, animated: true)
                } else {
                    scrollView.scrollTo(edge: .top, animated: true)
                }
            })
        }.onDisappear {
            self.viewModel.shouldSimulate = false
            self.viewModel.cleanTextFields() {
                self.settings.popup = AppPopupSettings()
            }
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
            FloatingTextField(toolbarBuilder: JEWToolbarBuilder().setToolbar(leftButtons: [.cancel, .back], rightButtons: [.ok]), formatBuilder: FloatingTextField.defaultFormatBuilder(placeholderColor: .label), placeholder: .constant(self.viewModel.allSteps[index].type.setNextStepPlaceHolder()), text: self.$viewModel.allSteps[index].value, formatType: .constant(self.viewModel.allSteps[index].type.setFormat()), keyboardType: .constant(.numberPad), close: self.$viewModel.close, shouldBecomeFirstResponder: $viewModel.allSteps[index].shouldBecomeFirstResponder, tapOnToolbarButton: { textField, type in
                self.tapOnToolbar(textField: textField, type: type, index: index)
            }, didBeginEditing: { textField in
                self.viewModel.didBeginEditing(index: index)
            }) { textfield, text, isBackspace in
                var updatedText = text
                if isBackspace && !text.isEmpty {
                    updatedText.removeLast()
                }
                self.viewModel.updateStep(textField: textfield, text: updatedText, index: index)
            }
            .frame(height: 50)
            .padding(8)
            GeometryReader { geometry in
                Rectangle().frame(height: 2).foregroundColor(self.viewModel.allSteps[index].hasError ? Color(.JEWRed()) : Color(.JEWDefault())).position(x: geometry.size.width/2, y: geometry.size.height - 1)
            }
        }
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
    
    func tapOnToolbar(textField: JEWFloatingTextField, type: JEWKeyboardToolbarButton, index: Int) {
        switch type {
        case .cancel:
            self.viewModel.cancel(index: index)
        case .back:
            self.viewModel.backStep(index: index) {
                self.settings.popup = AppPopupSettings()
            }
        case .ok:
            self.viewModel.nextStep(index: index, completion: {
                self.settings.popup = AppPopupSettings()
            }){ popupSetting in
                self.settings.popup = popupSetting
            }
        default:
            break
        }
    }
}

struct SimulationCreationView_Previews: PreviewProvider {
    static var previews: some View {
        SimulationCreationView(viewModel: SimulationCreationViewModel(), detailViewModel: SimulationDetailViewModel(service: SimulationDetailService(repository: SimulationDetailRepository())), stepViewModel: SimulationCreationStepViewModel())
    }
}
