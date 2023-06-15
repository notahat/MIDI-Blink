import SwiftUI

@main
struct MIDI_BlinkApp: App {
    @StateObject private var sourceManager = MIDISourceManager()
    
    var body: some Scene {
        Window("MIDI Blink", id: "main") {
            ContentView(sources: sourceManager.sources)
        }
    }
}
