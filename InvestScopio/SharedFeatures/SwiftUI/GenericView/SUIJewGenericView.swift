//
//  SUIJewGenericView.swift
//  DailyRewards
//
//  Created by Joao Gabriel Pereira on 19/01/20.
//  Copyright © 2020 Joao Gabriel Medeiros Perei. All rights reserved.
//

import SwiftUI


struct SUIJewGenericView<Content: View>: View {
    let content: () -> Content
    let viewState: ViewState
    init(viewState: ViewState, @ViewBuilder content: @escaping () -> Content) {
        self.content = content
        self.viewState = viewState
    }
    
    public var body: some View {
        switch viewState {
        case .loaded:
            return AnyView(content().clipped())
        case .loading:
            return AnyView(content().overlay(SUIJEWLoadingView()).clipped())
        }
    }
}

struct SUIJewGenericView_Previews: PreviewProvider {
    static var previews: some View {
        SUIJewGenericView(viewState: .loaded) {
            Text("Text")
        }
    }
}

enum ViewState {
    case loading
    case loaded
}
