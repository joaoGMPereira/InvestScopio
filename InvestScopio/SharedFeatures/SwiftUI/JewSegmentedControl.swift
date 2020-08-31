//
//  JewSegmentedControl.swift
//  InvestScopio
//
//  Created by Joao Gabriel Pereira on 31/08/20.
//  Copyright © 2020 Joao Medeiros Pereira. All rights reserved.
//

import SwiftUI

struct MyTextPreferenceKey: PreferenceKey {
    typealias Value = [MyTextPreferenceData]
    
    static var defaultValue: [MyTextPreferenceData] = []
    
    static func reduce(value: inout [MyTextPreferenceData], nextValue: () -> [MyTextPreferenceData]) {
        value.append(contentsOf: nextValue())
    }
}

struct MyTextPreferenceData: Equatable {
    let viewIndex: Int
    let rect: CGRect
}

struct JewSegmentedControl : View {
    
    @Binding var selectedIndex: Int
    @Binding var rects: [CGRect]
    @Binding var titles: [String]
    var selectedColor: Color
    var unselectedColor: Color
    var coordinateSpaceName: String
    @State var height: CGFloat = 36
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            ExDivider(color: selectedColor)
                .frame(width: rects[selectedIndex].size.width - 4, height: height - 4)
                .offset(x: rects[selectedIndex].minX + 2, y: 2)
                .animation(.easeInOut(duration: 0.5))
            
            VStack {
                self.addTitles()
                
            }.frame(height: height).onPreferenceChange(MyTextPreferenceKey.self) { preferences in
                for p in preferences {
                    self.rects[p.viewIndex] = p.rect
                }
            }
        }.background(unselectedColor).clipShape(Capsule()).coordinateSpace(name: coordinateSpaceName)
    }
    
    func totalSize() -> CGSize {
        var totalSize: CGSize = .zero
        for rect in rects {
            totalSize.width += rect.width
            totalSize.height = rect.height
        }
        return totalSize
    }
    
    func addTitles() -> some View {
        GeometryReader { geometry in
            HStack(alignment: .center, spacing: 8, content: {
                ForEach(0..<self.titles.count) { index in
                    return SegmentView(selectedIndex: self.$selectedIndex, label: self.titles[index], index: index, isSelected: self.segmentIsSelected(selectedIndex: self.selectedIndex, segmentIndex: index), coordinateSpaceName: self.coordinateSpaceName, size: .constant(CGSize.init(width: ((geometry.size
                        .width - CGFloat(8*(self.titles.count - 1)))/CGFloat(self.titles.count)), height: self.height)))
                }
            })
        }
    }
    
    func segmentIsSelected(selectedIndex: Int, segmentIndex: Int) -> Binding<Bool> {
        return Binding(get: {
            return selectedIndex == segmentIndex
        }) { (value) in }
    }
}

struct SegmentView: View {
    @Binding var selectedIndex: Int
    let label: String
    let index: Int
    @Binding var isSelected: Bool
    var coordinateSpaceName: String
    @Binding var size: CGSize
    
    var body: some View {
        Text(label)
            .frame(maxWidth:.infinity)
            .padding(.horizontal, 4)
            .frame(width: size.width, height: size.height)
            .foregroundColor(Color(.label))
            
            .background(MyPreferenceViewSetter(index: index, coordinateSpaceName: coordinateSpaceName)).onTapGesture {
                self.selectedIndex = self.index
        }
    }
}

struct MyPreferenceViewSetter: View {
    let index: Int
    var coordinateSpaceName: String
    var body: some View {
        GeometryReader { geometry in
            Rectangle()
                .fill(Color.clear)
                .preference(key: MyTextPreferenceKey.self,
                            value: [MyTextPreferenceData(viewIndex: self.index, rect: geometry.frame(in: .named(self.coordinateSpaceName)))])
        }
    }
}


struct ExDivider: View {
    var color: Color
    var body: some View {
        Capsule()
            .fill(color)
            .edgesIgnoringSafeArea(.horizontal)
    }
}
