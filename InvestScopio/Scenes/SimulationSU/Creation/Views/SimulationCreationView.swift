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
    @Environment(\.sizeCategory) private var defaultSizeCategory: ContentSizeCategory
    @EnvironmentObject var reachability: Reachability
    @EnvironmentObject var settings: AppSettings
    @State var teste = CreateSimulationSegments.completed
    @State var rects = Array<CGRect>(repeating: CGRect(), count: 6)
    @State var titles : [String] = CreateSimulationSegments.allLocalizedText
    var body: some View {
        
        return SplitView(isOpened: $viewModel.isOpened, minHeight: 22) {
            VStack {
                Color("secondary").cornerRadius(2).frame(width: 40, height: 4).padding(.top, 8)
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 16) {
                        self.header()
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
        }
    }
    
    func header() -> some View {
        VStack {
            if viewModel.showHeader {
                JewSegmentedControl(selectedIndex: $viewModel.selectedIndex, rects: $rects, titles: $titles, selectedColor: Color("selectedSegment"), unselectedColor: Color("background4"), coordinateSpaceName: "SimulationCreationSegmentedControl").padding(.horizontal)
                Step(passed: self.$viewModel.passed, progress: self.$viewModel.progress, quantity: self.$viewModel.quantity, progressedColor: Color(.JEWDefault()), unprogressedColor: Color("background4")).padding(.horizontal)
                Spacer()
            }
        }
    }
    
    func form() -> some View {
        VStack {
            Spacer()
            AnimatedText(message: self.viewModel.isOpened ? self.viewModel.step.setNextStep(size:self.defaultSizeCategory) : NSMutableAttributedString(string: String())) { size in
                DispatchQueue.main.async {
                    self.viewModel.textHeight = size.height
                }
            }
            .frame(height: self.viewModel.textHeight)
            if viewModel.showTextField {
                FloatingTextField(toolbarBuilder: JEWFloatingTextFieldToolbarBuilder().setToolbar(leftButtons: [], rightButtons: [.ok]), formatBuilder: FloatingTextField.defaultFormatBuilder(placeholder: viewModel.step.setNextStepPlaceHolder()), text: self.$viewModel.text, close: self.$viewModel.close) { textfield, text, isBackspace in
                    self.viewModel.text = text
                }
                .frame(height: 50)
                .padding(8)
                .background(Color(.systemBackground))
                .cornerRadius(8)
                .padding()
            }
        }.background(Color(UIColor.systemGray5))
            .cornerRadius(16)
            .padding()
    }
    
    func bottomButtons() -> some View {
        Group {
            if self.viewModel.isOpened && self.viewModel.showBottomButtons {
                DoubleButtons(firstIsLoading: .constant(false), secondIsLoading: .constant(false), firstModel: .init(title: "Simplificada", color: Color(.JEWLightDefault()), isFill: true), secondModel: .init(title: "Completa", color: Color(.JEWDefault()), isFill: true), firstCompletion: {
                    self.viewModel.selectedIndex = 0
                    
                }) {
                    self.viewModel.selectedIndex = 1
                }
            }
        }
    }
}

struct SimulationCreationView_Previews: PreviewProvider {
    static var previews: some View {
        SimulationCreationView(viewModel: SimulationCreationViewModel())
    }
}


public protocol SegmentedPickerViewElementTraits: Hashable {
    var localizedText: String { get }
}

enum CreateSimulationSegments: Int, CaseIterable {
    case simply
    case completed
    case teste
    case teste2
    case teste3
    case teste4
    
    static var allLocalizedText: [String] {
        return allCases.map { $0.localizedText }
    }
}

extension CreateSimulationSegments: SegmentedPickerViewElementTraits {
    var localizedText: String {
        switch self {
        case .simply:
            return "test"
        case .completed:
            return "test1"
        case .teste:
            return "test2"
        case .teste2:
            return "test3"
        case .teste3:
            return "test4"
        case .teste4:
            return "test5"
        }
    }
}
