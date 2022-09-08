//
//  DynamicTabItemView.swift
//  DynamicTabBar
//
//  Created by Hamish Allan on 29/04/2022.
//

import SwiftUI

struct DynamicTabItemView: View {
    @EnvironmentObject var selectionWrapper: SelectionWrapper
    let tab: DynamicTabItem

    var body: some View {
        VStack {
            Image(systemName: tab.iconName)
                .font(.subheadline)
            Text(tab.title)
                .font(.system(size: 10, weight: .semibold, design: .rounded))
        }
        .foregroundColor(selectionWrapper.selection == tab ? .accentColor : .gray)
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity)
        .onTapGesture {
            selectionWrapper.selection = tab
        }
    }
}

struct DynamicTabItemViewModifer: ViewModifier {
    let tab: DynamicTabItem
    @EnvironmentObject var selectionWrapper: SelectionWrapper
    
    @State var loaded: Bool = false

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

extension View {
    func tabPreference(_ tab: DynamicTabItem) -> some View {
        preference(key: DynamicTabItemsPreferenceKey.self, value: [tab])
    }
    func dynamicTabItem(tab: DynamicTabItem) -> some View {
        modifier(DynamicTabItemViewModifer(tab: tab))
    }
}
