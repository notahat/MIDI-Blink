import CoreMIDI

struct MIDISource: Identifiable {
    let id = UUID()
    var displayName: String
    var endpointRef: MIDIEndpointRef = 0
}
