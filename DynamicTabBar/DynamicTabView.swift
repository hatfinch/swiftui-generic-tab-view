//
//  DynamicTabView.swift
//  DynamicTabBar
//
//  Created by Hamish Allan on 28/04/2022.
//

import SwiftUI

struct DynamicTabView<Content:View>: View {

    @Binding var selection: DynamicTabItem
    let content: Content
    @State private var tabs: [DynamicTabItem] = []

    init(selection: Binding<DynamicTabItem>, @ViewBuilder content: () -> Content) {
        self._selection = selection
        self.content = content()
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .safeAreaInset(edge: .bottom, spacing: 0) {
                    DynamicTabBar(tabs: tabs, selection: $selection)
                }
        }
        .onPreferenceChange(DynamicTabItemsPreferenceKey.self, perform: { value in
            self.tabs = value
        })
    }
}

struct DemoTab: View {

    let text: String

    init(text: String) {
        self.text = text
        print("init \(text)")
    }

    var body: some View {
        List(1..<21) { n in
            Text("\(text) \(n)")
        }
        .onAppear {
            print("onAppear \(text)")
        }
    }
}

struct DemoTabView: View {
    @State var selection: DynamicTabItem = .home

    var body: some View {
        DynamicTabView(selection: $selection) {
            DemoTab(text: "First")
                .dynamicTabItem(tab: .home, selection: $selection)
            DemoTab(text: "Second")
                .dynamicTabItem(tab: .messages, selection: $selection)
            DemoTab(text: "Third")
                .dynamicTabItem(tab: .favorites, selection: $selection)
            DemoTab(text: "Fourth")
                .dynamicTabItem(tab: .profile, selection: $selection)
        }
    }
}

struct DynamicTabView_Previews: PreviewProvider {

    static var previews: some View {
        DemoTabView()
    }
}
