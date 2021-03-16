// Referenced from https://stackoverflow.com/a/65046791

import SwiftUI

extension Color {
    struct UI {
        static let background = Color("bg")
        static let foreground = Color("fg")
        static let grey = Color("grey")
        static let red = Color("red")
        static let orange = Color("orange")
        static let green = Color("green")
        static let teal = Color("teal")
        static let yellow = Color("yellow")
        static let blue = Color("blue")
        static let darkBlue = Color("dark-blue")
        static let magenta = Color("magenta")
        static let violet = Color("violet")
        static let cyan = Color("cyan")
        static let darkCyan = Color("dark-cyan")

        // Different shades of the base theme (e.g. light / dark)
        // As number increases, colour becomes less and less like the base theme
        static let base0 = Color("base0")
        static let base1 = Color("base1")
        static let base2 = Color("base2")
        static let base3 = Color("base3")
        static let base4 = Color("base4")
        static let base5 = Color("base5")
    }
}
