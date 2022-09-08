//
//  DynamicTabView.swift
//  DynamicTabBar
//
//  Created by Hamish Allan on 28/04/2022.
//

import SwiftUI

struct DynamicTabItem: Hashable {
    let title: String
    let systemName: String
    
    init(_ title: String, systemName: String) {
        self.title = title
        self.systemName = systemName
    }
}

class SelectionWrapper: ObservableObject {
    @Published var selection: DynamicTabItem? = nil
}

struct DynamicTabItemButton: View {
    @EnvironmentObject var selectionWrapper: SelectionWrapper
    let tab: DynamicTabItem

    var body: some View {
        Button {
            selectionWrapper.selection = tab
        } label: {
            VStack {
                Image(systemName: tab.systemName)
                    .font(.subheadline)
                Text(tab.title)
                    .font(.system(size: 10, weight: .semibold, design: .rounded))
            }
        }
        .foregroundColor(selectionWrapper.selection == tab ? .accentColor : .gray)
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity)
    }
}

struct DynamicTabBar: View {
    let tabs: [DynamicTabItem]

    var body: some View {
        HStack {
            ForEach(tabs, id: \.self) { tab in
                DynamicTabItemButton(tab: tab)
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

struct DynamicTabItemModifer: ViewModifier {
    let tab: DynamicTabItem
    @EnvironmentObject var selectionWrapper: SelectionWrapper
    
    @ViewBuilder func body(content: Content) -> some View {
        if selectionWrapper.selection == tab {
            content.tabPreference(tab).navigationTitle(tab.title)
        } else {
            Color.clear.tabPreference(tab)
        }
    }
}

struct DynamicTabItemsPreferenceKey: PreferenceKey {
    static var defaultValue: [DynamicTabItem] = []
    static func reduce(value: inout [DynamicTabItem], nextValue: () -> [DynamicTabItem]) {
        value += nextValue()
    }
}

extension View {
    func tabPreference(_ tab: DynamicTabItem) -> some View {
        preference(key: DynamicTabItemsPreferenceKey.self, value: [tab])
    }
    func dynamicTabItem(_ tab: DynamicTabItem) -> some View {
        modifier(DynamicTabItemModifer(tab: tab))
    }
}
