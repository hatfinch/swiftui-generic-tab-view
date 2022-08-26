//
//  DynamicTabItemView.swift
//  DynamicTabBar
//
//  Created by Hamish Allan on 29/04/2022.
//

import SwiftUI

struct DynamicTabItemView: View {
    @Binding var selection: DynamicTabItem
    let tab: DynamicTabItem

    var body: some View {
        VStack {
            Image(systemName: tab.iconName)
                .font(.subheadline)
            Text(tab.title)
                .font(.system(size: 10, weight: .semibold, design: .rounded))
        }
        .foregroundColor(selection == tab ? .accentColor : .gray)
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity)
        .onTapGesture {
            self.selection = tab
        }
    }
}

struct DynamicTabItemViewModifer: ViewModifier {
    let tab: DynamicTabItem
    @Binding var selection: DynamicTabItem

    @ViewBuilder func body(content: Content) -> some View {
//        approach1(content: content)
        approach2(content: content)
    }

    @ViewBuilder func approach1(content: Content) -> some View {
        content
            .opacity(selection == tab ? 1.0 : 0.0)
            .tabPreference(tab)
    }

    @ViewBuilder func approach2(content: Content) -> some View {
        if selection == tab {
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
    func dynamicTabItem(tab: DynamicTabItem, selection: Binding<DynamicTabItem>) -> some View {
        modifier(DynamicTabItemViewModifer(tab: tab, selection: selection))
    }
}

struct DemoTabItemView: View {
    @State var selection: DynamicTabItem = .home

    var body: some View {
        DynamicTabItemView(selection: $selection, tab: .home)
        DynamicTabItemView(selection: $selection, tab: .messages)
    }
}

struct DynamicTabItemView_Previews: PreviewProvider {
    static var previews: some View {
        DemoTabItemView()
    }
}
