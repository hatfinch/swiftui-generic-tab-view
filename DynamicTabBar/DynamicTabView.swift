//
//  DynamicTabView.swift
//  DynamicTabBar
//
//  Created by Hamish Allan on 28/04/2022.
//

import SwiftUI

class SelectionWrapper: ObservableObject {
    @Published var selection: DynamicTabItem? = nil
}

struct DynamicTabBar: View {

    let tabs: [DynamicTabItem]

    var body: some View {
        HStack {
            ForEach(tabs, id: \.self) { tab in
                DynamicTabItemView(tab: tab)
            }
        }
        .padding(6)
        .background(Color.white.ignoresSafeArea(edges: .bottom))
    }
}

struct DynamicTabView<Content: View>: View {

    @Binding var selection: DynamicTabItem
    let content: Content
    @State private var tabs: [DynamicTabItem] = []

    @StateObject var selectionWrapper = SelectionWrapper()

    init(selection: Binding<DynamicTabItem>, @ViewBuilder content: () -> Content) {
        self._selection = selection
        self.content = content()
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .safeAreaInset(edge: .bottom, spacing: 0) {
                    DynamicTabBar(tabs: tabs)
                }
        }
        .onPreferenceChange(DynamicTabItemsPreferenceKey.self, perform: { value in
            self.tabs = value
        })
        .environmentObject(selectionWrapper)
        .onChange(of: selection) { newValue in
            selectionWrapper.selection = newValue
        }
        .onChange(of: selectionWrapper.selection) { newValue in 
            if let newValue = newValue {
                selection = newValue
            }
        }
        .onAppear {
            selectionWrapper.selection = selection
        }
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
                .dynamicTabItem(tab: .home)
            DemoTab(text: "Second")
                .dynamicTabItem(tab: .messages)
            DemoTab(text: "Third")
                .dynamicTabItem(tab: .favorites)
            DemoTab(text: "Fourth")
                .dynamicTabItem(tab: .profile)
        }
    }
}

struct DynamicTabView_Previews: PreviewProvider {

    static var previews: some View {
        DemoTabView()
    }
}
