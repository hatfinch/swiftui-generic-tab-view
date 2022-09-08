//
//  DynamicTabView.swift
//  DynamicTabBar
//
//  Created by Hamish Allan on 28/04/2022.
//

import SwiftUI

struct DynamicTabItem: Hashable {
    let iconName: String
    let title: String
}

class SelectionWrapper: ObservableObject {
    @Published var selection: DynamicTabItem? = nil
}

struct DynamicTabItemView: View {
    @EnvironmentObject var selectionWrapper: SelectionWrapper
    let tab: DynamicTabItem

    var body: some View {
        VStack {
            Button {
                selectionWrapper.selection = tab
            } label: {
                VStack {
                    Image(systemName: tab.iconName)
                        .font(.subheadline)
                    Text(tab.title)
                        .font(.system(size: 10, weight: .semibold, design: .rounded))
                }
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

struct DynamicTabItemViewModifer: ViewModifier {
    let tab: DynamicTabItem
    @EnvironmentObject var selectionWrapper: SelectionWrapper
    
    @ViewBuilder func body(content: Content) -> some View {
//        approach1(content: content)
        approach2(content: content)
    }

    @ViewBuilder func approach1(content: Content) -> some View {
        content
            .opacity(selectionWrapper.selection == tab ? 1.0 : 0.0)
            .tabPreference(tab)
    }

    @ViewBuilder func approach2(content: Content) -> some View {
        if selectionWrapper.selection == tab {
            content.tabPreference(tab)
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
    func dynamicTabItem(tab: DynamicTabItem) -> some View {
        modifier(DynamicTabItemViewModifer(tab: tab))
    }
}
