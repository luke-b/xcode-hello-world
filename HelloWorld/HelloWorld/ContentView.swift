import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "ipad.landscape")
                .font(.system(size: 80))
                .foregroundStyle(.blue)

            Text("Hello, World!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .accessibilityIdentifier("helloWorldLabel")

            Text("A native iPad app built with SwiftUI")
                .font(.title3)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(40)
    }
}

#Preview {
    ContentView()
}
