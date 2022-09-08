//
//  DynamicTabBarApp.swift
//  DynamicTabBar
//
//  Created by Hamish Allan on 28/04/2022.
//

import SwiftUI

extension DynamicTabItem {
    static let home = DynamicTabItem(iconName: "house.fill", title: "Home")
    static let favorites = DynamicTabItem(iconName: "heart.fill", title: "Favorites")
    static let profile = DynamicTabItem(iconName: "person.fill", title: "Profile")
    static let messages = DynamicTabItem(iconName: "message.fill", title: "Messages")
}

@main
struct DynamicTabBarApp: App {
    @State var selection: DynamicTabItem = .home

    var body: some Scene {
        WindowGroup {
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
