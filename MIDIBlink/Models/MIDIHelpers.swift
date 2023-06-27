import CoreMIDI
import OSLog

func getMIDIObjectDisplayName(_ objectRef: MIDIObjectRef) -> String {
    var name: Unmanaged<CFString>?
    let status = MIDIObjectGetStringProperty(objectRef, kMIDIPropertyDisplayName, &name)
    guard status == noErr else {
        Logger().error("MIDIObjectGetStringProperty failed with status \(status)")
        return "Untitled source"
    }

    return name!.takeRetainedValue() as String
}
