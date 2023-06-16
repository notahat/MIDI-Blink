import SwiftUI

struct SourceView: View {
    var source: MIDISource

    @State var lastSeenEventCount = 0

    let timer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()

    var body: some View {
        HStack {
            LightView(isOn: source.eventCount != lastSeenEventCount)
                .onReceive(timer) { _ in
                    withAnimation { lastSeenEventCount = source.eventCount }
                }
            Text(source.displayName)
                .font(.title3)
        }
    }
}

struct SourceView_Previews: PreviewProvider {
    @State static var source = MIDISource(displayName: "Example Source")
    @State static var sourceWithMessages = MIDISource(displayName: "Example Source", eventCount: 5)

    static var previews: some View {
        SourceView(source: source)
        SourceView(source: sourceWithMessages)
            .previewDisplayName("When eventCount changes")
    }
}
