import XCTest
@testable import FileManagerPersistence

struct TestStruct:Codable, Equatable {
    var value:Int
}

class TestClass:Codable, Equatable {
    var value:Int
    
    init(value: Int) {
        self.value = value
    }
    
    static func == (lhs: TestClass, rhs: TestClass) -> Bool {
        lhs.value == rhs.value
    }
}

final class FileManagerPersistenceTests: XCTestCase {
    func testPersistenceBuiltInVar() throws {
        let testVar = 42
        let testPath = FileManager.documentsPathWithAppending(path: "TestPath")
        FileManager.trySavingVariable(value: testVar, toPath: testPath)
        let result = FileManager.tryLoadingVariable(fromPath: testPath, defaultValue: -1)
        XCTAssertEqual(testVar, result)
    }
    
    func testPersistenceCustomStruct() throws {
        let testStruct = TestStruct(value: 42)
        let testPath = FileManager.documentsPathWithAppending(path: "TestPath")
        FileManager.trySavingVariable(value: testStruct, toPath: testPath)
        let result = FileManager.tryLoadingVariable(fromPath: testPath, defaultValue: TestStruct(value: -1))
        XCTAssertEqual(testStruct, result)
    }
    
    func testPersistenceCustomClass() throws {
        let testClass = TestClass(value: 42)
        let testPath = FileManager.documentsPathWithAppending(path: "TestPath")
        FileManager.trySavingVariable(value: testClass, toPath: testPath)
        let result = FileManager.tryLoadingVariable(fromPath: testPath, defaultValue: TestClass(value: -1))
        XCTAssertEqual(testClass, result)
    }
    
    func testPersistenceBuiltInVarList() throws {
        let testArr = [42, 43]
        let testPath = FileManager.documentsPathWithAppending(path: "TestPath")
        FileManager.trySavingList(list: testArr, toPath: testPath)
        let result = FileManager.tryLoadingList(fromPath: testPath, defaultValue: [-1])
        XCTAssertEqual(testArr, result)
    }
    
    func testPersistenceCustomStructList() throws {
        let testArr = [TestStruct(value: 42), TestStruct(value: 43)]
        let testPath = FileManager.documentsPathWithAppending(path: "TestPath")
        FileManager.trySavingList(list: testArr, toPath: testPath)
        let result = FileManager.tryLoadingList(fromPath: testPath, defaultValue: [TestStruct(value: -1)])
        XCTAssertEqual(testArr, result)
    }
    
    func testPersistenceCustomClassList() throws {
        let testArr = [TestClass(value: 42), TestClass(value: 43)]
        let testPath = FileManager.documentsPathWithAppending(path: "TestPath")
        FileManager.trySavingList(list: testArr, toPath: testPath)
        let result = FileManager.tryLoadingList(fromPath: testPath, defaultValue: [TestClass(value: -1)])
        XCTAssertEqual(testArr, result)
    }
    
    func testPersistenceTest() throws {
        let testVar = 42
        let testVarFail = -1
        
        XCTAssertEqual(testVar != testVarFail, true)
        
        let testCustomStruct = TestStruct(value: 42)
        let testCustomStructFail = TestStruct(value: -1)
        
        XCTAssertEqual(testCustomStruct != testCustomStructFail, true)
        
        let testCustomClass = TestClass(value: 42)
        let testCustomClassFail = TestClass(value: -1)
        
        XCTAssertEqual(testCustomClass != testCustomClassFail, true)
        
        let testArr = [testVar]
        let testArrFail = [-1]
        
        XCTAssertEqual(testArr != testArrFail, true)
        
        let testCustomStructArr = [testCustomStruct]
        let testCustomStructArrFail = [TestStruct(value: -1)]
        
        XCTAssertEqual(testCustomStructArr != testCustomStructArrFail, true)
        
        let testCustomClassArr = [testCustomClass]
        let testCustomClassArrFail = [TestClass(value: -1)]
        XCTAssertEqual(testCustomClassArr != testCustomClassArrFail, true)
    }
}
