// This stores values in a pre-allocated buffer, so that we can get stable
// pointers to those values.
//
// This is useful for passing data through the UnsafeMutableRawPointer refCon
// parameters of CoreMIDI calls.
class StablePointerBuffer<T: Equatable> {
    let endpointRefs: UnsafeMutableBufferPointer<T>
    var count = 0

    init(capacity: Int = 1024) {
        endpointRefs = UnsafeMutableBufferPointer<T>.allocate(capacity: capacity)
    }

    deinit {
        endpointRefs.deinitialize()
        endpointRefs.deallocate()
    }

    func pointerTo(_ value: T) -> UnsafeMutablePointer<T> {
        if let index = endpointRefs[0 ..< count].firstIndex(of: value) {
            return endpointRefs.baseAddress! + index
        } else {
            precondition(count < endpointRefs.count)
            endpointRefs[count] = value
            let result = endpointRefs.baseAddress! + count
            count += 1
            return result
        }
    }
}
