//
//  TalkWithUsView.swift
//  InvestScopio
//
//  Created by Joao Gabriel Pereira on 16/08/20.
//  Copyright © 2020 Joao Medeiros Pereira. All rights reserved.
//

import SwiftUI
import MessageUI
import EnvironmentOverrides
struct TalkWithUsView: View {
    @EnvironmentObject var settings: AppSettings
    @ObservedObject var viewModel: TalkWithUsViewModel
    @State var showCheck = false
    var body: some View {
        NavigationView {
            ZStack {
                Color(.JEWBackground())
                Form {
                    Section(header: Text("Avaliação").font(.subheadline).bold()) {
                        HStack {
                            Spacer()
                            Text("o que você acha do nosso aplicativo?".uppercased()).font(Font.footnote.bold())
                            Spacer()
                        }
                        NPSView(ratings: $viewModel.ratings, selectedRating: $viewModel.selectedRating).disabled(viewModel.npsLoadable.isLoading())
                    }.listRowBackground(Color("cellBackground"))
                    
                    Section(header: Text("Feedback").font(.subheadline).bold()) {
                        informationView
                        Group {
                        feedbackView
                            LoadingButton(isLoading: .constant(false), isEnable: .constant(self.viewModel.selectedFeedback != nil), model: LoadingButtonModel.init(title: "Envie um email", color: Color(.JEWDefault()), isFill: false), action: {
                                viewModel.isShowingMailView = true
                            }).padding(.horizontal, 64)
                            .sheet(isPresented: $viewModel.isShowingMailView) {
                                MailView(result: $viewModel.result, subject: $viewModel.subject, recipients: $viewModel.recipients, messageBody: $viewModel.messageBody)
                            }
                        }
                        
                    }.listRowBackground(Color("cellBackground"))
                    Section(header: Text("Encerrar Sessão").font(.subheadline).bold()) {
                        exitButton
                    }.listRowBackground(Color("cellBackground"))
                }
                .navigationBarTitle("Fale Conosco", displayMode: .large)
                .cornerRadius(8)
                .padding(1)
                .shadow(radius: 8)
            }.onAppear {
                self.viewModel.checkNPS()
                self.viewModel.completion = { popup in
                    settings.popup = popup
                }
            }
        }
    }
    
    var informationView: some View {
        Group {
            HStack {
                Spacer()
                Text("Você pode contar um pouco mais?".uppercased()).font(.footnote).bold()
                Spacer()
            }
            
            Text("Caso tenha alguma dúvida, sugestão ou crítica, nos envie um email.\n\nCaso encontre algum problema, por favor nos envie ele, se possível tente tirar prints.\n\nVamos tentar resolve-los o mais breve possível.")
        }
        .padding(.horizontal)
        .font(.caption)
        .multilineTextAlignment(.center)
    }
    
    var feedbackView: some View {
        HStack {
            Text("Selecione o tipo de feedback").font(Font.system(.footnote, design: .rounded).bold())
            Spacer()
            if let selectedFeedback = viewModel.selectedFeedback {
                Text(selectedFeedback).font(.caption)
            }
            Image(symbol: .pencilCircle).foregroundColor(Color(.JEWDefault()))
        }
        .contextMenu {
            ForEach(0..<Int(viewModel.feedbacks.count), id: \.self) { index in
                Button(action: {
                    self.viewModel.selectedFeedback = self.viewModel.selectedFeedback == viewModel.feedbacks[index] ? nil : viewModel.feedbacks[index]
                }) {
                    Group {
                        Text(viewModel.feedbacks[index])
                        if (self.viewModel.selectedFeedback == viewModel.feedbacks[index]) {
                            Image(symbol: .checkmarkCircleFill)
                        }
                    }
                }
            }
        }
    }
    
    var exitButton: some View {
        Button(action: {
            self.settings.loggingState = .notLogged
            self.settings.popup = AppPopupSettings()
        }) {
            Text("Sair")
                .foregroundColor(Color.init(.label))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .contentShape(Rectangle())
        }
        .frame(height: 50)
        .frame(maxWidth: .infinity)
    }
}


struct TalkWithUsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TalkWithUsView(viewModel: TalkWithUsViewModel(service: TalkWithUsService(repository: TalkWithUsRepository()))).attachEnvironmentOverrides()
            TalkWithUsView(viewModel: TalkWithUsViewModel(service: TalkWithUsService(repository: TalkWithUsRepository()))).previewDevice("iPhone SE (2nd generation)").attachEnvironmentOverrides()
        }
    }
}
