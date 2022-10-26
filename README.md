# swiftui-generic-tab-view

## WORK IN PROGRESS

### Issues

1. `DynamicTabBar` uses a custom `Layout` to determine how many tabs will comfortably fit into the bar, and hides the remainder offscreen. If the `More` button is pressed, all tabs are shown in a popover.
   - The popover has a fixed height. Ideally it should be the size that fits the number of items in the table view, but I couldn't work out how to achieve this. Is it possible?
   - The table in the popover is greyed out as if inactive. Why does this not have an active appearance, and how can I make it do so?
   - When one of the tabs is selected, it shows in the accent color (in both the tab bar and the popover). If the selected tab is one of the ones that does not fit into the tab bar, I want to highlight the `More` button; but I cannot work out how to make this contingent on the `Layout`. How can I achieve this?

Any feedback and/or advice gratefully appreciated.
