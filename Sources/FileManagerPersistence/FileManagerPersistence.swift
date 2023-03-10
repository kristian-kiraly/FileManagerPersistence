import Foundation

public extension FileManager {
    static var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    static func documentsPathWithAppending(path:String) -> URL {
        if #available(iOS 16.0, *) {
            return FileManager.documentsDirectory.appending(path: path)
        } else {
            return FileManager.documentsDirectory.appendingPathComponent(path)
        }
    }
    
    static func trySavingList<T:Encodable>(list:[T], toPath path:URL) {
        do {
            let data = try JSONEncoder().encode(list)
            try data.write(to: path, options: [.atomic, .completeFileProtection])
        } catch let error {
            print("Unable to save list to path: \(path.absoluteString)")
            print(error.localizedDescription)
        }
    }
    
    static func tryLoadingList<T:Decodable>(fromPath path:URL, defaultValue:[T]) -> [T] {
        var result:[T]
        do {
            let data = try Data(contentsOf: path)
            result = try JSONDecoder().decode([T].self, from: data)
            return result
        } catch let error {
            print("Unable to load list from path: \(path.absoluteString)")
            print(error.localizedDescription)
            return defaultValue
        }
    }
    
    static func trySavingDictionary<T:Encodable, U:Hashable & Encodable>(dict:[U : T], toPath path:URL) {
        do {
            let data = try JSONEncoder().encode(dict)
            try data.write(to: path, options: [.atomic, .completeFileProtection])
        } catch let error {
            print("Unable to save dictionary to path: \(path.absoluteString)")
            print(error.localizedDescription)
        }
    }
    
    static func tryLoadingDictionary<T:Decodable, U:Hashable & Decodable>(fromPath path:URL, defaultValue:[U : T]) -> [U : T] {
        var result:[U : T]
        do {
            let data = try Data(contentsOf: path)
            result = try JSONDecoder().decode([U : T].self, from: data)
            return result
        } catch let error {
            print("Unable to load dictionary from path: \(path.absoluteString)")
            print(error.localizedDescription)
            return defaultValue
        }
    }
    
    static func trySavingVariable<T:Encodable>(value:T, toPath path:URL) {
        do {
            let data = try JSONEncoder().encode(value)
            try data.write(to: path, options: [.atomic, .completeFileProtection])
        } catch let error {
            print("Unable to save variable to path: \(path.absoluteString)")
            print(error.localizedDescription)
        }
    }
    
    static func tryLoadingVariable<T:Decodable>(fromPath path:URL, defaultValue:T) -> T {
        var result:T
        do {
            let data = try Data(contentsOf: path)
            result = try JSONDecoder().decode(T.self, from: data)
            return result
        } catch let error {
            print("Unable to load variable from path: \(path.absoluteString)")
            print(error.localizedDescription)
            return defaultValue
        }
    }
}

public extension Encodable {
    func trySavingToDocumentsWithAppending(appending:String) {
        let path = FileManager.documentsPathWithAppending(path: appending)
        trySavingToPath(path: path)
    }
    
    func trySavingToPath(path:String) {
        guard let pathURL = URL(string: path) else {
            print("Failed to create URL from path string: \(path)")
            return
        }
        trySavingToPath(path: pathURL)
    }
    
    func trySavingToPath(path:URL) {
        FileManager.trySavingVariable(value: self, toPath: path)
    }
}

public extension Array where Element: Encodable {
    func trySavingToDocumentsWithAppending(appending:String) {
        let path = FileManager.documentsPathWithAppending(path: appending)
        trySavingToPath(path: path)
    }
    
    func trySavingToPath(path:String) {
        guard let pathURL = URL(string: path) else {
            print("Failed to create URL from path string: \(path)")
            return
        }
        trySavingToPath(path: pathURL)
    }
    
    func trySavingToPath(path:URL) {
        FileManager.trySavingList(list: self, toPath: path)
    }
}

public extension Dictionary where Key: Hashable & Encodable, Value: Encodable {
    func trySavingToDocumentsWithAppending(appending:String) {
        let path = FileManager.documentsPathWithAppending(path: appending)
        trySavingToPath(path: path)
    }
    
    func trySavingToPath(path:String) {
        guard let pathURL = URL(string: path) else {
            print("Failed to create URL from path string: \(path)")
            return
        }
        trySavingToPath(path: pathURL)
    }
    
    func trySavingToPath(path:URL) {
        FileManager.trySavingDictionary(dict: self, toPath: path)
    }
}
