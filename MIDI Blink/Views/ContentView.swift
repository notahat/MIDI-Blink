import SwiftUI

struct ContentView: View {
    var sources: [MIDISource] = []

    var body: some View {
        List(sources) {
            SourceView(source: $0)
        }
        .overlay {
            if sources.isEmpty {
                Text("No MIDI sources connected.")
                    .font(.largeTitle)
                    .multilineTextAlignment(.center)
                    .padding()
            }
        }
        .frame(minWidth: 300, minHeight: 165)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(sources: [
            MIDISource(displayName: "Foo"),
            MIDISource(displayName: "Bar"),
            MIDISource(displayName: "Baz"),
        ])
        ContentView(sources: [])
            .previewDisplayName("No sources")
        ContentView(sources: [])
            .frame(width: 300)
            .previewDisplayName("No sources, narrow")
    }
}
