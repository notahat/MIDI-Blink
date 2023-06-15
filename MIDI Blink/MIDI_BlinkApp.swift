import SwiftUI
import CoreMIDI

struct Source: Identifiable {
    var label: String
    var endpointRef: MIDIEndpointRef = 0
    let id = UUID()
}

class SourceManager: ObservableObject {
    var clientRef: MIDIClientRef = 0

    @Published var sources: [Source] = []
    
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
                return Source(label: "Unknown source")
            }
            return Source(label: name!.takeRetainedValue() as String, endpointRef: endpointRef)
        }
    }
}

@main
struct MIDI_BlinkApp: App {
    @StateObject private var sourceManager = SourceManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView(sources: sourceManager.sources)
        }
    }
}
