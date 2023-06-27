import CoreMIDI
import OSLog

// We want to pass pointers to MIDIEndpointRefs as refCon paramters,
// so we use a StablePointerBuffer to store them and get pointers that
// don't move around.
private var endpointRefs = StablePointerBuffer<MIDIEndpointRef>()

@MainActor
class MIDISourceManager: ObservableObject {
    @Published var sources: [MIDISource] = []
    @Published var errorOccurred = false

    private var clientRef: MIDIClientRef = 0
    private var portRef: MIDIPortRef = 0
    
    private let logger = Logger()
    
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
            logger.error("MIDIClientCreateWithBlock failed with status \(status)")
            errorOccurred = true
            return
        }
    }
    
    private func createMIDIPort() {
        guard clientRef != 0 else { return }
        let status = MIDIInputPortCreateWithProtocol(clientRef, "MIDI Blink" as CFString, ._2_0, &portRef) { _, refCon in
            let endpointRef = refCon!.load(as: MIDIEndpointRef.self)
            Task.detached { await self.processReceivedMessages(endpointRef) }
        }
        guard status == noErr else {
            logger.error("MIDIInputPortCreateWithProtocol failed with status \(status)")
            errorOccurred = true
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
        guard portRef != 0 else { return }
        let refCon = endpointRefs.pointerTo(endpointRef)
        let status = MIDIPortConnectSource(portRef, endpointRef, refCon)
        guard status == noErr else {
            logger.error("MIDIPortConnectSource failed with status \(status)")
            errorOccurred = true
            return
        }
    }
    
    private func processReceivedMessages(_ endpointRef: MIDIEndpointRef) {
        if let index = sources.firstIndex(where: { $0.endpointRef == endpointRef }) {
            sources[index].eventCount += 1
        }
    }
}
