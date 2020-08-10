//
//  FloatingTextField.swift
//  InvestScopio
//
//  Created by Joao Gabriel Pereira on 18/07/20.
//  Copyright © 2020 Joao Medeiros Pereira. All rights reserved.
//

import SwiftUI
import JewFeatures

struct FloatingTextField_Previews: PreviewProvider {
    static var previews: some View {
        JEWUIColor.default.defaultColor = UIColor(named: "accent")!
        JEWUIColor.default.lightDefaultColor = UIColor(named: "accentLight")!
        JEWUIColor.default.darkDefaultColor = UIColor(named: "accentDark")!
        return VStack {
            FloatingTextField(toolbarBuilder: JEWFloatingTextFieldToolbarBuilder().setToolbar(leftButtons: [], rightButtons: [.ok]), formatBuilder: JEWFloatingTextFieldFormatBuilder().setAll(withPlaceholder: "Testando").setPlaceholderColor(color: .JEWDefault()).setTextFieldTextColor(color: .JEWBlack()).setSelectedColor(color: .JEWDefault()).setTextFieldValueType(type: JEWFloatingTextFieldValueType.percent), text: .constant(""))
                .frame(width: 300, height: 50)
            Spacer()
        }
    }
}


struct FloatingTextField: UIViewRepresentable {
    
    var toolbarBuilder: JEWFloatingTextFieldToolbarBuilder
    var formatBuilder: JEWFloatingTextFieldFormatBuilder
    @Binding var text: String
    var hasInfoButton: Bool = false
    var isSecureTextEntry: Bool = false
    var autocapitalizationType = UITextAutocapitalizationType.none
    var tapOnInfoButton: ((JEWFloatingTextField) -> Void)?
    var tapOnToolbarButton: ((JEWFloatingTextField, _ type: JEWKeyboardToolbarButton) -> Void)?
    var didBeginEditing: ((JEWFloatingTextField) -> Void)?
    var didEndEditing: ((JEWFloatingTextField) -> Void)?
    var onChanged: ((JEWFloatingTextField, _ text: String, _ isBackspace: Bool) -> Void)?
    
    static func defaultFormatBuilder(placeholder: String, valueType: JEWFloatingTextFieldValueType = .none, hideBottomView: Bool = true) -> JEWFloatingTextFieldFormatBuilder {
        JEWFloatingTextFieldFormatBuilder().setAll(withPlaceholder: placeholder).setBigFont(font: UIFont.systemFont(ofSize: UIFont.systemFontSize, weight: .semibold)).setSmallFont(font: UIFont.systemFont(ofSize: UIFont.smallSystemFontSize, weight: .bold)).setPlaceholderColor(color: .JEWDefault()).setTextFieldTextColor(color: .label).setTextFieldValueType(type: valueType).setHideBottomView(isHidden: hideBottomView)
    }
    
    func makeUIView(context: Context) -> JEWFloatingTextField {
        let floatingTextField = JEWFloatingTextField(frame: .zero)
        floatingTextField.textField.isSecureTextEntry = isSecureTextEntry
        floatingTextField.textField.autocapitalizationType = autocapitalizationType

        let streetNameTextFieldFactory = JEWFloatingTextFieldFactory(withFloatingTextField: floatingTextField)
        let streetNameToolbarBuilder = toolbarBuilder.update(textField: floatingTextField)
        let streetNameFormatBuilder = formatBuilder.update(textField: floatingTextField)
        var types: [JEWFloatingTextFieldFactoryTypes] = [.format(builder: streetNameFormatBuilder), .toolbar(builder: streetNameToolbarBuilder)]
        if hasInfoButton {
            types.append(.InfoButton)
        }
        types.append(.CodeView)
        streetNameTextFieldFactory.setup(buildersType: types, delegate: context.coordinator)
        return floatingTextField
    }
    
    func updateUIView(_ uiView: JEWFloatingTextField, context: Context) {
        uiView.textFieldText = self.text
    }
    
    func makeCoordinator() -> Coordinator {
        let coordinator = Coordinator()
        coordinator.tapOnInfoButton = tapOnInfoButton
        coordinator.tapOnToolbarButton = tapOnToolbarButton
        coordinator.didBeginEditing = didBeginEditing
        coordinator.didEndEditing = didEndEditing
        coordinator.onChanged = onChanged
        return coordinator
    }
    
    class Coordinator: NSObject, JEWFloatingTextFieldDelegate {
        
        var tapOnInfoButton: ((JEWFloatingTextField) -> Void)?
        var tapOnToolbarButton: ((JEWFloatingTextField, _ type: JEWKeyboardToolbarButton) -> Void)?
        var didBeginEditing: ((JEWFloatingTextField) -> Void)?
        var didEndEditing: ((JEWFloatingTextField) -> Void)?
        var onChanged: ((JEWFloatingTextField, _ text: String, _ isBackspace: Bool) -> Void)?
        
        func infoButtonAction(_ textField: JEWFloatingTextField) {
            tapOnInfoButton?(textField)
        }
        
        func toolbarAction(_ textField: JEWFloatingTextField, typeOfAction type: JEWKeyboardToolbarButton) {
            textField.endEditing(true)
            tapOnToolbarButton?(textField, type)
        }
        
        func textFieldDidBeginEditing(_ textField: JEWFloatingTextField){
            didBeginEditing?(textField)
        }
        
        func textFieldDidEndEditing(_ textField: JEWFloatingTextField){
            didEndEditing?(textField)
        }
        
        func textFieldShouldChangeCharactersIn(_ textField: JEWFloatingTextField, text: String, isBackSpace: Bool){
            var updatedText = text
            if text.count == 1 && isBackSpace {
                updatedText = String()
            }
            onChanged?(textField, updatedText, isBackSpace)
        }
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
