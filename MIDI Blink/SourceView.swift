import SwiftUI

struct SourceView: View {
    var source: MIDISource

    @State var lastSeenEventCount = 0

    let timer = Timer.publish(every: 0.03, on: .main, in: .common).autoconnect()

    var body: some View {
        HStack {
            Circle()
                .frame(width: 30)
                .foregroundColor(source.eventCount != lastSeenEventCount ? .green : .white)
                .onReceive(timer) { _ in
                    withAnimation { lastSeenEventCount = source.eventCount }
                }
            Text(source.displayName)
                .font(.largeTitle)
        }
    }
}

struct SourceView_Previews: PreviewProvider {
    @State static var source = MIDISource(displayName: "Example Source")
    @State static var sourceWithMessages = MIDISource(displayName: "Example Source", eventCount: 5)

    static var previews: some View {
        SourceView(source: source)
        SourceView(source: sourceWithMessages)
            .previewDisplayName("With messages")
    }
}
