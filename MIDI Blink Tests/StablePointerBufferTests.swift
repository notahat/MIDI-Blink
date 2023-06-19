import XCTest

final class StablePointerBufferTests: XCTestCase {
    func testGivesAPointerToAValue() throws {
        let buffer = StablePointerBuffer<Int>()
        let result = buffer.pointerTo(27)
        XCTAssertEqual(result.pointee, 27)
    }

    func testGivesDifferentPointersForDifferentValues() throws {
        let buffer = StablePointerBuffer<Int>()
        let resultA = buffer.pointerTo(27)
        let resultB = buffer.pointerTo(42)
        XCTAssertNotEqual(resultA, resultB)
    }
    
    func testGivesTheSamePointerForTheSameValue() throws {
        let buffer = StablePointerBuffer<Int>()
        let resultA = buffer.pointerTo(27)
        let resultB = buffer.pointerTo(27)
        XCTAssertEqual(resultA, resultB)
    }
}
