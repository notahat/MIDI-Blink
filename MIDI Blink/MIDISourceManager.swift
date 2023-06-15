import CoreMIDI

@MainActor
class MIDISourceManager: ObservableObject {
    var clientRef: MIDIClientRef = 0
    var portRef: MIDIPortRef = 0
    var messageCounter = 0

    @Published var sources: [MIDISource] = []
    
    init() {
        var status = MIDIClientCreateWithBlock("MIDI Blink" as CFString, &clientRef) { _ in
            Task.detached { await self.updateSources() }
        }
        guard status == noErr else {
            print("MIDIClientCreate failed with ", status)
            return
        }
        
        status = MIDIInputPortCreateWithProtocol(clientRef, "MIDI Blink" as CFString, ._1_0, &portRef) { _, _ in
            Task.detached { await self.processReceivedMessages() }
        }
        guard status == noErr else {
            print("MIDIInputPortCreateWithProtocol failed with ", status)
            return
        }
        
        Task.detached { await self.updateSources() }
    }
    
    func updateSources() {
        let numberOfSources = MIDIGetNumberOfSources()
        sources = (0..<numberOfSources).map { index in
            let endpointRef = MIDIGetSource(index)
            
            var name: Unmanaged<CFString>?
            var status = MIDIObjectGetStringProperty(endpointRef, kMIDIPropertyDisplayName, &name)
            guard status == noErr else {
                print("MIDIObjectGetStringProperty failed with ", status)
                return MIDISource(displayName: "Unknown source")
            }
            
            status = MIDIPortConnectSource(portRef, endpointRef, nil)
            guard status == noErr else {
                print("MIDIPortConnectSource failed with ", status)
                return MIDISource(displayName: "Couldn't connect")
            }
            
            return MIDISource(displayName: name!.takeRetainedValue() as String, endpointRef: endpointRef)
        }
    }
    
    func processReceivedMessages() {
        messageCounter += 1
        print("Message \(messageCounter) received")
    }
}
