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
    let pathAppending = "TestPath"
    let testValue1 = 42
    let testValue2 = 43
    let testFailedValue = -1
    let testKey1 = "test1"
    let testKey2 = "test2"
    let testFailedKey = "test0"
    
    func testPersistenceBuiltInVar() throws {
        let testVar = testValue1
        let testPath = FileManager.documentsPathWithAppending(path: pathAppending)
        FileManager.trySavingVariable(value: testVar, toPath: testPath)
        let result = FileManager.tryLoadingVariable(fromPath: testPath, defaultValue: testFailedValue)
        XCTAssertEqual(testVar, result)
        
        testVar.trySavingToDocumentsWithAppending(appending: pathAppending)
        let result2 = FileManager.tryLoadingVariable(fromPath: testPath, defaultValue: testFailedValue)
        XCTAssertEqual(testVar, result2)
    }
    
    func testPersistenceCustomStruct() throws {
        let testStruct = TestStruct(value: testValue1)
        let testPath = FileManager.documentsPathWithAppending(path: pathAppending)
        FileManager.trySavingVariable(value: testStruct, toPath: testPath)
        let result = FileManager.tryLoadingVariable(fromPath: testPath, defaultValue: TestStruct(value: testFailedValue))
        XCTAssertEqual(testStruct, result)
        
        testStruct.trySavingToDocumentsWithAppending(appending: pathAppending)
        let result2 = FileManager.tryLoadingVariable(fromPath: testPath, defaultValue: TestStruct(value: testFailedValue))
        XCTAssertEqual(testStruct, result2)
    }
    
    func testPersistenceCustomClass() throws {
        let testClass = TestClass(value: testValue1)
        let testPath = FileManager.documentsPathWithAppending(path: pathAppending)
        FileManager.trySavingVariable(value: testClass, toPath: testPath)
        let result = FileManager.tryLoadingVariable(fromPath: testPath, defaultValue: TestClass(value: testFailedValue))
        XCTAssertEqual(testClass, result)
        
        testClass.trySavingToDocumentsWithAppending(appending: pathAppending)
        let result2 = FileManager.tryLoadingVariable(fromPath: testPath, defaultValue: TestClass(value: testFailedValue))
        XCTAssertEqual(testClass, result2)
    }
    
    func testPersistenceBuiltInVarList() throws {
        let testArr = [testValue1, testValue2]
        let testPath = FileManager.documentsPathWithAppending(path: pathAppending)
        FileManager.trySavingList(list: testArr, toPath: testPath)
        let result = FileManager.tryLoadingList(fromPath: testPath, defaultValue: [testFailedValue])
        XCTAssertEqual(testArr, result)
        
        testArr.trySavingToDocumentsWithAppending(appending: pathAppending)
        let result2 = FileManager.tryLoadingList(fromPath: testPath, defaultValue: [testFailedValue])
        XCTAssertEqual(testArr, result2)
    }
    
    func testPersistenceCustomStructList() throws {
        let testArr = [TestStruct(value: testValue1), TestStruct(value: testValue2)]
        let testPath = FileManager.documentsPathWithAppending(path: pathAppending)
        FileManager.trySavingList(list: testArr, toPath: testPath)
        let result = FileManager.tryLoadingList(fromPath: testPath, defaultValue: [TestStruct(value: testFailedValue)])
        XCTAssertEqual(testArr, result)
        
        testArr.trySavingToDocumentsWithAppending(appending: pathAppending)
        let result2 = FileManager.tryLoadingList(fromPath: testPath, defaultValue: [TestStruct(value: testFailedValue)])
        XCTAssertEqual(testArr, result2)
    }
    
    func testPersistenceCustomClassList() throws {
        let testArr = [TestClass(value: testValue1), TestClass(value: testValue2)]
        let testPath = FileManager.documentsPathWithAppending(path: pathAppending)
        FileManager.trySavingList(list: testArr, toPath: testPath)
        let result = FileManager.tryLoadingList(fromPath: testPath, defaultValue: [TestClass(value: testFailedValue)])
        XCTAssertEqual(testArr, result)
        
        testArr.trySavingToDocumentsWithAppending(appending: pathAppending)
        let result2 = FileManager.tryLoadingList(fromPath: testPath, defaultValue: [TestClass(value: testFailedValue)])
        XCTAssertEqual(testArr, result2)
    }
    
    func testPersistenceBuiltInVarDict() throws {
        let testDict = [
            testKey1 : testValue1,
            testKey2 : testValue2
        ]
        let testPath = FileManager.documentsPathWithAppending(path: pathAppending)
        FileManager.trySavingDictionary(dict: testDict, toPath: testPath)
        let result = FileManager.tryLoadingDictionary(fromPath: testPath, defaultValue: [testFailedKey : testFailedValue])
        XCTAssertEqual(testDict, result)
        
        testDict.trySavingToDocumentsWithAppending(appending: pathAppending)
        let result2 = FileManager.tryLoadingDictionary(fromPath: testPath, defaultValue: [testFailedKey : testFailedValue])
        XCTAssertEqual(testDict, result2)
    }
    
    func testPersistenceCustomStructDict() throws {
        let testDict = [
            testKey1 : TestStruct(value: testValue1),
            testKey2 : TestStruct(value: testValue2)
        ]
        let testPath = FileManager.documentsPathWithAppending(path: pathAppending)
        FileManager.trySavingDictionary(dict: testDict, toPath: testPath)
        let result = FileManager.tryLoadingDictionary(fromPath: testPath, defaultValue: [testFailedKey : TestStruct(value: testFailedValue)])
        XCTAssertEqual(testDict, result)
        
        testDict.trySavingToDocumentsWithAppending(appending: pathAppending)
        let result2 = FileManager.tryLoadingDictionary(fromPath: testPath, defaultValue: [testFailedKey : TestStruct(value: testFailedValue)])
        XCTAssertEqual(testDict, result2)
    }
    
    func testPersistenceCustomClassDict() throws {
        let testDict = [
            testKey1 : TestClass(value: testValue1),
            testKey2 : TestClass(value: testValue2)
        ]
        let testPath = FileManager.documentsPathWithAppending(path: pathAppending)
        FileManager.trySavingDictionary(dict: testDict, toPath: testPath)
        let result = FileManager.tryLoadingDictionary(fromPath: testPath, defaultValue: [testFailedKey : TestClass(value: testFailedValue)])
        XCTAssertEqual(testDict, result)
        
        testDict.trySavingToDocumentsWithAppending(appending: pathAppending)
        let result2 = FileManager.tryLoadingDictionary(fromPath: testPath, defaultValue: [testFailedKey : TestClass(value: testFailedValue)])
        XCTAssertEqual(testDict, result2)
    }
    
    func testPersistenceTest() throws {
        let testVar = testValue1
        let testVarFail = testFailedValue
        
        XCTAssertEqual(testVar != testVarFail, true)
        
        let testCustomStruct = TestStruct(value: testValue1)
        let testCustomStructFail = TestStruct(value: testFailedValue)
        
        XCTAssertEqual(testCustomStruct != testCustomStructFail, true)
        
        let testCustomClass = TestClass(value: testValue1)
        let testCustomClassFail = TestClass(value: testFailedValue)
        
        XCTAssertEqual(testCustomClass != testCustomClassFail, true)
        
        let testArr = [testVar]
        let testArrFail = [testFailedValue]
        
        XCTAssertEqual(testArr != testArrFail, true)
        
        let testCustomStructArr = [testCustomStruct]
        let testCustomStructArrFail = [TestStruct(value: testFailedValue)]
        
        XCTAssertEqual(testCustomStructArr != testCustomStructArrFail, true)
        
        let testCustomClassArr = [testCustomClass]
        let testCustomClassArrFail = [TestClass(value: testFailedValue)]
        XCTAssertEqual(testCustomClassArr != testCustomClassArrFail, true)
    }
}
