import SwiftUI

struct ContentView: View {
    var sources: [MIDISource] = []
    var showError = false

    var body: some View {
        VStack(spacing: 0) {
            if showError { ErrorView() }
            List(sources) {
                SourceView(source: $0)
            }
            .overlay {
                if sources.isEmpty {
                    VStack {
                        Text("No MIDI sources are connected.")
                        Text("Plug in a MIDI device to get started.")
                    }
                    .font(.title2)
                    .multilineTextAlignment(.center)
                    .padding()
                }
            }
        }
        .frame(minWidth: 350, minHeight: 165)
    }
}

struct ContentView_Previews: PreviewProvider {
    static let sources = [
        MIDISource(displayName: "Foo"),
        MIDISource(displayName: "Bar"),
        MIDISource(displayName: "Baz"),
    ]
    static var previews: some View {
        ContentView(sources: sources)
        ContentView(sources: sources, showError: true)
            .previewDisplayName("Showing error")
        ContentView(sources: [])
            .previewDisplayName("No sources")
        ContentView(sources: [])
            .frame(width: 350)
            .previewDisplayName("No sources, narrow")
    }
}
