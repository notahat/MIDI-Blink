import CoreMIDI

func getMIDIObjectDisplayName(_ objectRef: MIDIObjectRef) -> String {
    var name: Unmanaged<CFString>?
    let status = MIDIObjectGetStringProperty(objectRef, kMIDIPropertyDisplayName, &name)
    guard status == noErr else {
        print("MIDIObjectGetStringProperty failed with ", status)
        return "Unknown source"
    }

    return name!.takeRetainedValue() as String
}
