import UIKit
import XCTest
import dsxs

class Tests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
        let today = Date.today
        XCTAssert(Date(today.toString()) != nil, "Pass")
    }
    func evbag(_ emitter: EventEmitter<String, String>){
        let test = "test"
        let bag = EventListenerBag<String, String>()
        emitter.on(test, listener: EventListener{
            XCTAssert($0 == test, "test bag event received")
        }).addTo(bag)
        emitter.once(test, listener: EventListener{
            XCTAssert($0 == test, "test bag event received")
        }).addTo(bag)
        XCTAssert(emitter.emit(test, object: test))
        
    }
    func testEventEmitter()  {
        let emitter = EventEmitter<String, String>()
        let test = "test"
        let listener = emitter.on(test, listener: EventListener{
            XCTAssert($0 == test, "test event received")
        })
        XCTAssert(emitter.emit(test, object: test))
        emitter.off(listener: listener)
        XCTAssert(emitter.emit(test, object: test) == false, "off 1 listener passed")
        evbag(emitter)
        
        XCTAssert(emitter.emit(test, object: test) == false, "bag disposed")
        emitter.on(test, listener: EventListener{
            XCTAssert($0 == test, "test on event received")
        })
        emitter.on(test, listener: EventListener{
            XCTAssert($0 == test, "test on event received")
        })
        XCTAssert(emitter.emit(test, object: test))
        emitter.off(test)
        XCTAssert(emitter.emit(test, object: test) == false, "off event passed")
        emitter.once(test, listener: EventListener{
            XCTAssert($0 == test, "test once event received")
        })
        emitter.once(test, listener: EventListener{
            XCTAssert($0 == test, "test once event received")
        })
        XCTAssert(emitter.emit(test, object: test), "once event emitted")
        XCTAssert(emitter.emit(test, object: test) == false, "once event passed")



    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure() {
            // Put the code you want to measure the time of here.
        }
    }
    
}
