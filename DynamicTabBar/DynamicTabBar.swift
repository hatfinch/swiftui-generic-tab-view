//
//  DynamicTabBar.swift
//  DynamicTabBar
//
//  Created by Hamish Allan on 28/04/2022.
//

import SwiftUI

struct DynamicTabBar: View {

    let tabs: [DynamicTabItem]
    @Binding var selection: DynamicTabItem

    var body: some View {
        HStack {
            ForEach(tabs, id: \.self) { tab in
                DynamicTabItemView(selection: $selection, tab: tab)
            }
        }
        .padding(6)
        .background(Color.white.ignoresSafeArea(edges: .bottom))
    }
}

struct DemoTabBar: View {
    @State var selection: DynamicTabItem = .home
    let tabs: [DynamicTabItem] = [
        .home, .messages, .favorites, .profile
    ]

    var body: some View {
        VStack {
            DynamicTabBar(tabs: tabs, selection: $selection)
        }
    }
}

struct DynamicTabBar_Previews: PreviewProvider {

    static var previews: some View {
        DemoTabBar()
    }
}
