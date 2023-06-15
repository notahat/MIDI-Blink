import CoreMIDI

@MainActor
class MIDISourceManager: ObservableObject {
    @Published var sources: [MIDISource] = []

    private var clientRef: MIDIClientRef = 0
    private var portRef: MIDIPortRef = 0
    
    init() {
        createMIDIClient()
        createMIDIPort()
        updateSources()
    }
    
    private func createMIDIClient() {
        let status = MIDIClientCreateWithBlock("MIDI Blink" as CFString, &clientRef) { _ in
            Task.detached { await self.updateSources() }
        }
        guard status == noErr else {
            print("MIDIClientCreate failed with ", status)
            return
        }
    }
    
    private func createMIDIPort() {
        let status = MIDIInputPortCreateWithProtocol(clientRef, "MIDI Blink" as CFString, ._2_0, &portRef) { _, refCon in
            let endpointRef = refCon!.load(as: MIDIEndpointRef.self)
            Task.detached { await self.processReceivedMessages(endpointRef) }
        }
        guard status == noErr else {
            print("MIDIInputPortCreateWithProtocol failed with ", status)
            return
        }
    }
    
    private func updateSources() {
        let numberOfSources = MIDIGetNumberOfSources()
        sources = (0 ..< numberOfSources).map { index in
            let endpointRef = MIDIGetSource(index)
            listenForMessagesFrom(endpointRef)
            return MIDISource(
                displayName: getMIDIObjectDisplayName(endpointRef),
                endpointRef: endpointRef
            )
        }
    }
    
    private func listenForMessagesFrom(_ endpointRef: MIDIEndpointRef) {
        // TODO: Fix this memory leak!
        // Just to get things working, I'm deliberately allocating memory that's never deallocated.
        // This is obviously not ok, so I need to come up with a better approach.
        let refCon = UnsafeMutablePointer<MIDIEndpointRef>.allocate(capacity: 1)
        refCon.initialize(to: endpointRef)

        let status = MIDIPortConnectSource(portRef, endpointRef, refCon)
        guard status == noErr else {
            print("MIDIPortConnectSource failed with ", status)
            return
        }
    }
    
    private func processReceivedMessages(_ endpointRef: MIDIEndpointRef) {
        if let index = sources.firstIndex(where: { $0.endpointRef == endpointRef }) {
            sources[index].eventCount += 1
        }
    }
}
