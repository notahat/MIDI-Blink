import SwiftUI

struct ContentView: View {
    var sources: [MIDISource] = []

    var body: some View {
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
        .frame(minWidth: 350, minHeight: 165)
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
            .frame(width: 350)
            .previewDisplayName("No sources, narrow")
    }
}
