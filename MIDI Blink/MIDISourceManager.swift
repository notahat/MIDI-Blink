import CoreMIDI

@MainActor
class MIDISourceManager: ObservableObject {
    var clientRef: MIDIClientRef = 0
    var portRef: MIDIPortRef = 0
    
    @Published var sources: [MIDISource] = []
    
    init() {
        createMIDIClient()
        createMIDIPort()
        updateSources()
    }
    
    func createMIDIClient() {
        let status = MIDIClientCreateWithBlock("MIDI Blink" as CFString, &clientRef) { _ in
            Task.detached { await self.updateSources() }
        }
        guard status == noErr else {
            print("MIDIClientCreate failed with ", status)
            return
        }
    }
    
    func createMIDIPort() {
        let status = MIDIInputPortCreateWithProtocol(clientRef, "MIDI Blink" as CFString, ._1_0, &portRef) { _, refCon in
            let endpointRef = refCon!.load(as: MIDIEndpointRef.self)
            Task.detached { await self.processReceivedMessages(endpointRef) }
        }
        guard status == noErr else {
            print("MIDIInputPortCreateWithProtocol failed with ", status)
            return
        }
    }
    
    func updateSources() {
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
    
    func listenForMessagesFrom(_ endpointRef: MIDIEndpointRef) {
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
    
    func processReceivedMessages(_ endpointRef: MIDIEndpointRef) {
        if let index = sources.firstIndex(where: { $0.endpointRef == endpointRef }) {
            sources[index].hasReceivedMessages = true
        }
    }
}
