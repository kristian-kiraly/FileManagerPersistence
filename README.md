# FileManagerPersistence

Some simple convenience functions to extend FileManager to allow for persistent variables and lists when provided a path and a default value. It works with custom classes and structs so long as they conform to the Codable protocol

Usage:

```swift
struct SavedContent {
    let varPath = FileManager.documentsPathWithAppending(path: "VarPath")
    let savedVar = FileManager.tryLoadingVariable(fromPath: varPath, defaultValue: -1)
    let listPath = FileManager.documentsPathWithAppending(path: "ListPath")
    let savedList = FileManager.tryLoadingList(fromPath: listPath, defaultValue: [-1])
    
    ...
    
    func save() {
        FileManager.trySavingVariable(value: savedVar, toPath: varPath)
        FileManager.trySavingList(list: testArr, toPath: testPath)
    }
}
```
