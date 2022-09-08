# swiftui-generic-tab-view
## WORK IN PROGRESS

### Issues

1. `DynamicTabView` follows the `TabView` approach of taking `View`s directly for its `ViewBuilder` children, and modifying them to attach properties for the tab bar buttons. However, the `.dynamicTabItem()` modifier differs from the `.tabItem()` modifier in several suboptimal ways:

    - It requires the Binding `$selection` to be passed to each `.dynamicTabItem()`, so that each item can be compared with the selected item and its visual state set accordingly. I would like to avoid passing `$selection` to each item.

    - It uses a custom `DynamicTabItem` as the identifier, whereas `TabView` uses `.tag()`, which can take any `Hashable` value, to identify its tabs. I would like to make this code similarly generic.

    - `TabView`'s `.tabItem` provides a `ViewBuilder` for `Content`, whereas `DynamicTabBar` only supports a fixed tab bar button layout. I tried to implement a `ViewBuilder` approach, but couldn't work out how to handle the generics.

2. In `DynamicTabItemViewModifier`, I've tried two approaches to only showing one tab at a time, but each has its own problems:

    - With `approach1` (changing the opacity), the `onAppear()` for each tab is only called once, but I want it to be called each time a tab is newly-selected.

    - With `approach2` (adding and removing the view) the above is fixed, but the view's state is lost, e.g. if you're scrolled down the `List`, switch away from and back again to a tab, the `List` is scrolled to the top again.

Any feedback and/or advice gratefully appreciated.
