import CoreMIDI

@MainActor
class MIDISourceManager: ObservableObject {
    var clientRef: MIDIClientRef = 0
    var portRef: MIDIPortRef = 0
    var messageCounter = 0

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
        let status = MIDIInputPortCreateWithProtocol(clientRef, "MIDI Blink" as CFString, ._1_0, &portRef) { _, _ in
            Task.detached { await self.processReceivedMessages() }
        }
        guard status == noErr else {
            print("MIDIInputPortCreateWithProtocol failed with ", status)
            return
        }
    }
    
    func updateSources() {
        let numberOfSources = MIDIGetNumberOfSources()
        sources = (0..<numberOfSources).map { index in
            let endpointRef = MIDIGetSource(index)
            listenForMessagesFrom(endpointRef)
            return MIDISource(
                displayName: getMIDIObjectDisplayName(endpointRef),
                endpointRef: endpointRef
            )
        }
    }
    
    func listenForMessagesFrom(_ endpointRef: MIDIEndpointRef) {
        let status = MIDIPortConnectSource(portRef, endpointRef, nil)
        guard status == noErr else {
            print("MIDIPortConnectSource failed with ", status)
            return
        }
    }
    
    func processReceivedMessages() {
        messageCounter += 1
        print("Message \(messageCounter) received")
    }
}
