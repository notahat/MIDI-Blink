import SwiftUI

struct ContentView: View {
    var sources: [Source] = []

    var body: some View {
        List(sources) {
            Text($0.label)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(sources: [
            Source(label: "Foo"),
            Source(label: "Bar"),
            Source(label: "Baz"),
        ])
    }
}
