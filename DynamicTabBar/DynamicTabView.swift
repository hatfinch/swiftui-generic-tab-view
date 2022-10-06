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

struct DynamicTabButtonLabel: View {
    let text: String
    let systemName: String

    var body: some View {
        VStack {
            Image(systemName: systemName)
                .font(.subheadline)
            Text(text)
                .font(.system(size: 10, weight: .semibold, design: .rounded))
        }
    }
}

struct DynamicTabItemButton: View {
    @EnvironmentObject var selectionWrapper: SelectionWrapper
    let tab: DynamicTabItem

    var body: some View {
        Button {
            selectionWrapper.selection = tab
        } label: {
            DynamicTabButtonLabel(text: tab.title, systemName: tab.systemName)
        }
        .foregroundColor(selectionWrapper.selection == tab ? .accentColor : .gray)
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity)
    }
}

struct DynamicTabMoreList: View {
    @Binding var tabs: [DynamicTabItem]
    @Binding var showingPopover: Bool
    @EnvironmentObject var selectionWrapper: SelectionWrapper

    var body: some View {
        NavigationStack {
            List {
                ForEach(tabs, id: \.self) { tab in
                    HStack {
                        Image(systemName: tab.systemName)
                        Text(tab.title)
                        Spacer() // to make whole row tappable
                    }
                    .border(.white) // to make whole row tappable
                    .foregroundColor(selectionWrapper.selection == tab ? .accentColor : .gray)
                    .onTapGesture {
                        selectionWrapper.selection = tab
                        showingPopover = false
                    }
                }
                .onMove { from, to in
                    tabs.move(fromOffsets: from, toOffset: to)
                }
            }
            .toolbar {
                EditButton()
            }
        }
    }
}

struct DynamicTabMoreButton: View {
    @Binding var tabs: [DynamicTabItem]
    @State var showingPopover = false

    var body: some View {
        Button {
            showingPopover = true
        } label: {
            DynamicTabButtonLabel(text: "More", systemName: "ellipsis.circle.fill")
                .popover(isPresented: $showingPopover) {
                    DynamicTabMoreList(tabs: $tabs, showingPopover: $showingPopover)
                        .frame(idealWidth: 320, idealHeight: 320)
                }
        }
        .foregroundColor(.gray) // .accentColor
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity)
    }
}

struct DynamicTabBarLayout: Layout {
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        return proposal.replacingUnspecifiedDimensions()
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let maximumNumberOfTabs = Int(bounds.width / 64)

        let numberOfTabs = min(maximumNumberOfTabs, subviews.count) - 1
        if (numberOfTabs < 1) {
            return
        }
        let tabWidth = bounds.width / CGFloat(numberOfTabs)
        let proposal = ProposedViewSize(width: tabWidth, height: bounds.height)

        for (index, subview) in subviews.enumerated() {
            func placeAt(index: Int) {
                subview.place(at: CGPoint(x: bounds.minX + (tabWidth * CGFloat(index)),
                                          y: bounds.minY), proposal: proposal)
            }

            if (index < numberOfTabs - 1) {
                placeAt(index: index)
            } else if (index == subviews.count - 1) { // more button
                placeAt(index: numberOfTabs - 1)
            } else { // excess tabs offscreen
                placeAt(index: numberOfTabs)
            }
        }
    }
}

struct DynamicTabBar: View {
    @Binding var tabs: [DynamicTabItem]

    var body: some View {
        DynamicTabBarLayout {
            ForEach(tabs, id: \.self) { tab in
                DynamicTabItemButton(tab: tab)
            }
            DynamicTabMoreButton(tabs: $tabs)
        }
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
                    DynamicTabBar(tabs: $tabs)
                        .frame(maxHeight: 64)
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
