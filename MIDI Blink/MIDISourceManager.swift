import CoreMIDI

class MIDISourceManager: ObservableObject {
    var clientRef: MIDIClientRef = 0

    @Published var sources: [MIDISource] = []
    
    init() {
        let status = MIDIClientCreateWithBlock("MIDI Blink" as CFString, &clientRef) { _ in
            Task.detached { await self.updateSources() }
        }
        guard status == noErr else {
            print("MIDIClientCreate failed with ", status)
            return
        }
        
        Task.detached { await self.updateSources() }
    }
    
    @MainActor
    func updateSources() {
        let numberOfSources = MIDIGetNumberOfSources()
        sources = (0..<numberOfSources).map { index in
            let endpointRef = MIDIGetSource(index)
            var name: Unmanaged<CFString>?
            let status = MIDIObjectGetStringProperty(endpointRef, kMIDIPropertyDisplayName, &name)
            guard status == noErr else {
                print("MIDIObjectGetStringProperty failed with ", status)
                return MIDISource(displayName: "Unknown source")
            }
            return MIDISource(displayName: name!.takeRetainedValue() as String, endpointRef: endpointRef)
        }
    }
}
