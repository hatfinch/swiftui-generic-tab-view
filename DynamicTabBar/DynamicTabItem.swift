//
//  DynamicTabItem.swift
//  DynamicTabBar
//
//  Created by Hamish Allan on 28/04/2022.
//

import SwiftUI

struct DynamicTabItem: Hashable {
    let iconName: String
    let title: String

    static let home = DynamicTabItem(iconName: "house.fill", title: "Home")
    static let favorites = DynamicTabItem(iconName: "heart.fill", title: "Favorites")
    static let profile = DynamicTabItem(iconName: "person.fill", title: "Profile")
    static let messages = DynamicTabItem(iconName: "message.fill", title: "Messages")
}

struct DynamicTabItemsPreferenceKey: PreferenceKey {
    static var defaultValue: [DynamicTabItem] = []
    static func reduce(value: inout [DynamicTabItem], nextValue: () -> [DynamicTabItem]) {
        value += nextValue()
    }
}
