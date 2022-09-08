//
//  DynamicTabBarApp.swift
//  DynamicTabBar
//
//  Created by Hamish Allan on 28/04/2022.
//

import SwiftUI

@main
struct DynamicTabBarApp: App {

    static let home = DynamicTabItem(iconName: "house.fill", title: "Home")
    static let messages = DynamicTabItem(iconName: "message.fill", title: "Messages")
    static let favorites = DynamicTabItem(iconName: "heart.fill", title: "Favorites")
    static let profile = DynamicTabItem(iconName: "person.fill", title: "Profile")

    @State var selection: DynamicTabItem = home

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                DynamicTabView(selection: $selection) {
                    DemoTab(text: "First")
                        .dynamicTabItem(DynamicTabBarApp.home)
                    DemoTab(text: "Second")
                        .dynamicTabItem(DynamicTabBarApp.messages)
                    DemoTab(text: "Third")
                        .dynamicTabItem(DynamicTabBarApp.favorites)
                    DemoTab(text: "Fourth")
                        .dynamicTabItem(DynamicTabBarApp.profile)
                }
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
//        .navigationTitle(text)
//        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            print("onAppear \(text)")
        }
        .onDisappear {
            print("onDisappear \(text)")
        }
    }
}
