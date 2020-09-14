//
//  SimulationCreationView+StepView.swift
//  InvestScopio
//
//  Created by Joao Gabriel Pereira on 08/09/20.
//  Copyright © 2020 Joao Medeiros Pereira. All rights reserved.
//

import SwiftUI
import JewFeatures

//MARK: - Step View
extension SimulationCreationView {
    func stepView() -> some View {
        SplitView(isOpened: $stepViewModel.isOpened, minHeight: 22, forceCloseWhenDisappear: true) {
            VStack {
                Color("contrastBackground").cornerRadius(2).frame(width: 40, height: 4).padding(.top, 8)
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 16) {
                        self.header()
                        if self.stepViewModel.showHeader {
                            Spacer()
                        }
                        self.form()
                        self.bottomButtons()
                        Spacer()
                    }
                }.introspectScrollView { (scrollView) in
                    switch self.defaultSizeCategory {
                    case .accessibilityLarge:
                        scrollView.isScrollEnabled = true
                    case .accessibilityExtraLarge:
                        scrollView.isScrollEnabled = true
                    case .accessibilityExtraExtraLarge:
                        scrollView.isScrollEnabled = true
                    case .accessibilityExtraExtraExtraLarge:
                        scrollView.isScrollEnabled = true
                    default:
                        scrollView.isScrollEnabled = false
                    }
                }
                Spacer()
            }
        }.onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.stepViewModel.isOpened = false
            }
        }
    }
    
    func header() -> some View {
        VStack {
            if stepViewModel.showHeader {
                JewSegmentedControl(selectedIndex: $stepViewModel.selectedIndex, rects: $stepViewModel.rects, titles: $stepViewModel.titles, selectedColor: Color("accessoryBackgroundSelected"), unselectedColor: Color("accessoryBackground"), coordinateSpaceName: "SimulationCreationSegmentedControl").padding(.horizontal)
                Step(passed: self.$stepViewModel.passed, progress: self.$stepViewModel.progress, quantity: self.$stepViewModel.quantity, progressedColor: Color(.JEWDefault()), unprogressedColor: Color("accessoryBackground")).padding(.horizontal)
            }
        }
    }
    
    func form() -> some View {
        VStack {
            Spacer()
            AnimatedText(message: self.stepViewModel.isOpened ? self.stepViewModel.step.setNextStep(size:self.defaultSizeCategory) : NSMutableAttributedString(string: String())) { size in
                DispatchQueue.main.async {
                    self.stepViewModel.textHeight = size.height
                }
            }
            .frame(height: self.stepViewModel.textHeight)
            if stepViewModel.showTextField {
                
                ZStack {
                    FloatingTextField(toolbarBuilder: JEWFloatingTextFieldToolbarBuilder().setToolbar(leftButtons: [.cancel, .back], rightButtons: [.ok]), formatBuilder: FloatingTextField.defaultFormatBuilder(placeholderColor: .label), placeholder: .constant(self.stepViewModel.step.setNextStepPlaceHolder()), text: self.$stepViewModel.allSteps[self.stepViewModel.step.rawValue].value, formatType: .constant(self.stepViewModel.step.setFormat()), keyboardType: .constant(.numberPad), close: self.$stepViewModel.close, shouldBecomeFirstResponder: .constant(true), tapOnToolbarButton: { textField, type in
                        self.tapOnToolbarStep(textField: textField, type: type)
                    }) { textfield, text, isBackspace in
                        var updatedText = text
                        if isBackspace && !text.isEmpty {
                            updatedText.removeLast()
                        }
                        self.stepViewModel.updateStep(textField: textfield, text: updatedText)
                    }
                    .frame(height: 50)
                    .padding(8)
                    GeometryReader { geometry in
                        Rectangle().frame(height: 2).foregroundColor(Color(.JEWDefault())).position(x: geometry.size.width/2, y: geometry.size.height - 1)
                    }
                }
                .background(Color(.JEWBackground()))
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .padding()
            }
        }
        .background(Color("cellBackground"))
        .cornerRadius(16)
        .padding()
        .shadow(color: Color("accessoryBackground").opacity(0.8), radius: 8)
    }
    
    func bottomButtons() -> some View {
        Group {
            if self.stepViewModel.isOpened && self.stepViewModel.showBottomButtons {
                DoubleButtons(firstIsLoading: .constant(false), secondIsLoading: .constant(false), firstIsEnable: .constant(true), secondIsEnable: .constant(true), firstModel: .init(title: stepViewModel.firstButtonTitle, color: Color(.JEWDefault()), isFill: true), secondModel: .init(title: stepViewModel.secondButtonTitle, color: Color(.JEWDefault()), isFill: false), background: Color("secondaryBackground"), firstCompletion: {
                    self.stepViewModel.selectFirstButton { (steps) in
                        self.viewModel.updateSteps(steps: steps)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                            self.viewModel.selectFirstButton(completion: { (simulation) in
                                self.settings.popup = AppPopupSettings()
                                self.detailViewModel.simulation = simulation
                            }, failure: { (settings) in
                                self.settings.popup = settings
                            })
                        }
                    }
                    
                }) {
                    self.stepViewModel.selectSecondButton { (steps) in
                        self.viewModel.updateSteps(steps: steps)
                    }
                }
            }
        }
    }
    
    func tapOnToolbarStep(textField: JEWFloatingTextField, type: JEWKeyboardToolbarButton) {
        switch type {
        case .cancel:
            UIApplication.shared.endEditing()
            break
        case .back:
            self.stepViewModel.backStep() {
                self.settings.popup = AppPopupSettings()
            }
        case .ok:
            self.stepViewModel.nextStep(textField: textField, completion: {
                self.settings.popup = AppPopupSettings()
            }){ popupSetting in
                self.settings.popup = popupSetting
            }
        default:
            break
        }
    }
}
