import SwiftUI

struct ContentView: View {
    var sources: [MIDISource] = []

    var body: some View {
        List(sources) {
            SourceView(source: $0)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(sources: [
            MIDISource(displayName: "Foo"),
            MIDISource(displayName: "Bar"),
            MIDISource(displayName: "Baz"),
        ])
    }
}
