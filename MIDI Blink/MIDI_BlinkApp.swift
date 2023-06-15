import SwiftUI

@main
struct MIDI_BlinkApp: App {
    @StateObject private var sourceManager = MIDISourceManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView(sources: sourceManager.sources)
        }
    }
}
