//
//  DynamicTabBarApp.swift
//  DynamicTabBar
//
//  Created by Hamish Allan on 28/04/2022.
//

import SwiftUI

@main
struct DynamicTabBarApp: App {

    static let home = DynamicTabItem("Home", systemName: "house.fill")
    static let messages = DynamicTabItem("Messages", systemName: "message.fill")
    static let favorites = DynamicTabItem("Favorites", systemName: "heart.fill")
    static let profile = DynamicTabItem("Profile", systemName: "person.fill")

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
