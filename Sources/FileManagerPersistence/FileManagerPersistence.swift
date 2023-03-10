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
    
    static func trySavingList<T:Codable>(list:[T], toPath path:URL) {
        do {
            let data = try JSONEncoder().encode(list)
            try data.write(to: path, options: [.atomic, .completeFileProtection])
        } catch let error {
            print("Unable to save list to path: \(path.absoluteString)")
            print(error.localizedDescription)
        }
    }
    
    static func tryLoadingList<T:Codable>(fromPath path:URL, defaultValue:[T]) -> [T] {
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
    
    static func trySavingDictionary<T:Codable, U:Hashable & Codable>(dict:[U : T], toPath path:URL) {
        do {
            let data = try JSONEncoder().encode(dict)
            try data.write(to: path, options: [.atomic, .completeFileProtection])
        } catch let error {
            print("Unable to save dictionary to path: \(path.absoluteString)")
            print(error.localizedDescription)
        }
    }
    
    static func tryLoadingDictionary<T:Codable, U:Hashable & Codable>(fromPath path:URL, defaultValue:[U : T]) -> [U : T] {
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
    
    static func trySavingVariable<T:Codable>(value:T, toPath path:URL) {
        do {
            let data = try JSONEncoder().encode(value)
            try data.write(to: path, options: [.atomic, .completeFileProtection])
        } catch let error {
            print("Unable to save variable to path: \(path.absoluteString)")
            print(error.localizedDescription)
        }
    }
    
    static func tryLoadingVariable<T:Codable>(fromPath path:URL, defaultValue:T) -> T {
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
