import SwiftUI

struct ContentView: View {
    var sources: [MIDISource] = []

    var body: some View {
        List(sources) { source in
            Toggle(source.displayName, isOn: .constant(source.hasReceivedMessages))
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
