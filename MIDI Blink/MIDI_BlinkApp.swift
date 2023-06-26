import SwiftUI

@main
struct MIDI_BlinkApp: App {
    @Environment(\.openURL) var openURL

    @StateObject private var sourceManager = MIDISourceManager()

    var body: some Scene {
        Window("MIDI Blink", id: "main") {
            ContentView(
                sources: sourceManager.sources,
                showError: sourceManager.errorOccurred
            )
        }
        .commands {
            CommandGroup(replacing: .help) {
                Button("MIDI Blink Help") { openHelp() }
            }
        }
    }
    
    private func openHelp() {
        if let url = URL(string: "https://notahat.com/midi-blink/support/") {
            openURL(url)
        }
    }
}
