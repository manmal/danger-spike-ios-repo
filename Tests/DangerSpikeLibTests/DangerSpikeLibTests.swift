import Testing
@testable import DangerSpikeLib

@Test func testGreet() {
    let lib = DangerSpikeLib()
    #expect(lib.greet() == "Hello from DangerSpikeLib!")
}
