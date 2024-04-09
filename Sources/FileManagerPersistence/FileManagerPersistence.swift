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
    
    static func saveSet<T: Encodable>(set: Set<T>, toPath path: URL) throws {
        let data = try JSONEncoder().encode(set)
        try data.write(to: path, options: [.atomic, .completeFileProtection])
    }
    
    static func trySavingSet<T: Encodable>(set: Set<T>, toPath path: URL) {
        do {
            try saveSet(set: set, toPath: path)
        } catch let error {
            print("Unable to save set to path: \(path.absoluteString)")
            print(error.localizedDescription)
        }
    }
    
    static func loadSet<T: Decodable>(fromPath path: URL) throws -> Set<T> {
        let data = try Data(contentsOf: path)
        return try JSONDecoder().decode(Set<T>.self, from: data)
    }
    
    static func tryLoadingSet<T: Decodable>(fromPath path: URL, defaultValue: Set<T>) -> Set<T> {
        do {
            return try loadSet(fromPath: path)
        } catch let error {
            print("Unable to load set from path: \(path.absoluteString)")
            print(error.localizedDescription)
            return defaultValue
        }
    }
    
    static func saveList<T: Encodable>(list: [T], toPath path: URL) throws {
        let data = try JSONEncoder().encode(list)
        try data.write(to: path, options: [.atomic, .completeFileProtection])
    }
    
    static func trySavingList<T: Encodable>(list: [T], toPath path: URL) {
        do {
            try saveList(list: list, toPath: path)
        } catch let error {
            print("Unable to save list to path: \(path.absoluteString)")
            print(error.localizedDescription)
        }
    }
    
    static func loadList<T: Decodable>(fromPath path: URL) throws -> [T] {
        let data = try Data(contentsOf: path)
        return try JSONDecoder().decode([T].self, from: data)
    }
    
    static func tryLoadingList<T: Decodable>(fromPath path: URL, defaultValue: [T]) -> [T] {
        do {
            return try loadList(fromPath: path)
        } catch let error {
            print("Unable to load list from path: \(path.absoluteString)")
            print(error.localizedDescription)
            return defaultValue
        }
    }
    
    static func saveDictionary<T: Encodable, U: Hashable & Encodable>(dict: [U : T], toPath path: URL) throws {
        let data = try JSONEncoder().encode(dict)
        try data.write(to: path, options: [.atomic, .completeFileProtection])
    }
    
    static func trySavingDictionary<T: Encodable, U: Hashable & Encodable>(dict: [U : T], toPath path: URL) {
        do {
            try saveDictionary(dict: dict, toPath: path)
        } catch let error {
            print("Unable to save dictionary to path: \(path.absoluteString)")
            print(error.localizedDescription)
        }
    }
    
    static func loadDictionary<T: Decodable, U: Hashable & Decodable>(fromPath path: URL) throws -> [U : T] {
        let data = try Data(contentsOf: path)
        return try JSONDecoder().decode([U : T].self, from: data)
    }
    
    static func tryLoadingDictionary<T: Decodable, U: Hashable & Decodable>(fromPath path: URL, defaultValue: [U : T]) -> [U : T] {
        do {
            return try loadDictionary(fromPath: path)
        } catch let error {
            print("Unable to load dictionary from path: \(path.absoluteString)")
            print(error.localizedDescription)
            return defaultValue
        }
    }
    
    static func saveVariable<T: Encodable>(value: T, toPath path: URL) throws {
        let data = try JSONEncoder().encode(value)
        try data.write(to: path, options: [.atomic, .completeFileProtection])
    }
    
    static func trySavingVariable<T: Encodable>(value: T, toPath path: URL) {
        do {
            try saveVariable(value: value, toPath: path)
        } catch let error {
            print("Unable to save variable to path: \(path.absoluteString)")
            print(error.localizedDescription)
        }
    }
    
    static func loadVariable<T: Decodable>(fromPath path: URL) throws -> T {
        let data = try Data(contentsOf: path)
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    static func tryLoadingVariable<T: Decodable>(fromPath path: URL, defaultValue: T) -> T {
        do {
            return try loadVariable(fromPath: path)
        } catch let error {
            print("Unable to load variable from path: \(path.absoluteString)")
            print(error.localizedDescription)
            return defaultValue
        }
    }
}

public extension Encodable {
    func trySavingToDocumentsWithAppending(appending: String) {
        let path = FileManager.documentsPathWithAppending(path: appending)
        trySavingToPath(path: path)
    }
    
    func trySavingToPath(path: String) {
        guard let pathURL = URL(string: path) else {
            print("Failed to create URL from path string: \(path)")
            return
        }
        trySavingToPath(path: pathURL)
    }
    
    func trySavingToPath(path: URL) {
        FileManager.trySavingVariable(value: self, toPath: path)
    }
    
    func trySavingWithFilename(filename: String) {
        trySavingToDocumentsWithAppending(appending: filename)
    }
    
    func saveToDocumentsWithAppending(appending: String) throws {
        let path = FileManager.documentsPathWithAppending(path: appending)
        try saveToPath(path: path)
    }
    
    func saveToPath(path: String) throws {
        guard let pathURL = URL(string: path) else {
            throw URLGenerationError.runtimeError("Failed to create URL from path string: \(path)")
        }
        try saveToPath(path: pathURL)
    }
    
    func saveToPath(path: URL) throws {
        try FileManager.saveVariable(value: self, toPath: path)
    }
    
    func saveWithFilename(filename: String) throws {
        try saveToDocumentsWithAppending(appending: filename)
    }
}

public extension Decodable {
    init(filename: String, defaultValue: Self) {
        self = FileManager.tryLoadingVariable(fromPath: FileManager.documentsPathWithAppending(path: filename), defaultValue: defaultValue)
    }
    
    init(filename: String) throws {
        self = try FileManager.loadVariable(fromPath: FileManager.documentsPathWithAppending(path: filename))
    }
}

public extension Array where Element: Codable {
    init(filename: String, defaultValue: Self) {
        self = FileManager.tryLoadingList(fromPath: FileManager.documentsPathWithAppending(path: filename), defaultValue: defaultValue)
    }
    
    init(filename: String) throws {
        self = try FileManager.loadList(fromPath: FileManager.documentsPathWithAppending(path: filename))
    }
    
    func trySavingToDocumentsWithAppending(appending: String) {
        let path = FileManager.documentsPathWithAppending(path: appending)
        trySavingToPath(path: path)
    }
    
    func trySavingToPath(path: String) {
        guard let pathURL = URL(string: path) else {
            print("Failed to create URL from path string: \(path)")
            return
        }
        trySavingToPath(path: pathURL)
    }
    
    func trySavingToPath(path: URL) {
        FileManager.trySavingList(list: self, toPath: path)
    }
    
    func trySavingWithFilename(filename: String) {
        trySavingToDocumentsWithAppending(appending: filename)
    }
    
    func saveToDocumentsWithAppending(appending: String) throws {
        let path = FileManager.documentsPathWithAppending(path: appending)
        try saveToPath(path: path)
    }
    
    func saveToPath(path: String) throws {
        guard let pathURL = URL(string: path) else {
            throw URLGenerationError.runtimeError("Failed to create URL from path string: \(path)")
        }
        try saveToPath(path: pathURL)
    }
    
    func saveToPath(path: URL) throws {
        try FileManager.saveList(list: self, toPath: path)
    }
    
    func saveWithFilename(filename: String) throws {
        try saveToDocumentsWithAppending(appending: filename)
    }
}

public extension Dictionary where Key: Hashable & Codable, Value: Codable {
    init(filename: String, defaultValue: Self) {
        self = FileManager.tryLoadingDictionary(fromPath: FileManager.documentsPathWithAppending(path: filename), defaultValue: defaultValue)
    }
    
    init(filename: String) throws {
        self = try FileManager.loadDictionary(fromPath: FileManager.documentsPathWithAppending(path: filename))
    }
    
    func trySavingToDocumentsWithAppending(appending: String) {
        let path = FileManager.documentsPathWithAppending(path: appending)
        trySavingToPath(path: path)
    }
    
    func trySavingToPath(path: String) {
        guard let pathURL = URL(string: path) else {
            print("Failed to create URL from path string: \(path)")
            return
        }
        trySavingToPath(path: pathURL)
    }
    
    func trySavingToPath(path: URL) {
        FileManager.trySavingDictionary(dict: self, toPath: path)
    }
    
    func trySavingWithFilename(filename: String) {
        trySavingToDocumentsWithAppending(appending: filename)
    }
    
    func saveToDocumentsWithAppending(appending: String) throws {
        let path = FileManager.documentsPathWithAppending(path: appending)
        try saveToPath(path: path)
    }
    
    func saveToPath(path: String) throws {
        guard let pathURL = URL(string: path) else {
            throw URLGenerationError.runtimeError("Failed to create URL from path string: \(path)")
        }
        try saveToPath(path: pathURL)
    }
    
    func saveToPath(path: URL) throws {
        try FileManager.saveDictionary(dict: self, toPath: path)
    }
    
    func saveWithFilename(filename: String) throws {
        try saveToDocumentsWithAppending(appending: filename)
    }
}

public extension Set where Element: Codable {
    init(filename: String, defaultValue: Self) {
        self = FileManager.tryLoadingSet(fromPath: FileManager.documentsPathWithAppending(path: filename), defaultValue: defaultValue)
    }
    
    init(filename: String) throws {
        self = try FileManager.loadSet(fromPath: FileManager.documentsPathWithAppending(path: filename))
    }
    
    func trySavingToDocumentsWithAppending(appending: String) {
        let path = FileManager.documentsPathWithAppending(path: appending)
        trySavingToPath(path: path)
    }
    
    func trySavingToPath(path: String) {
        guard let pathURL = URL(string: path) else {
            print("Failed to create URL from path string: \(path)")
            return
        }
        trySavingToPath(path: pathURL)
    }
    
    func trySavingToPath(path: URL) {
        FileManager.trySavingSet(set: self, toPath: path)
    }
    
    func trySavingWithFilename(filename: String) {
        trySavingToDocumentsWithAppending(appending: filename)
    }
    
    func saveToDocumentsWithAppending(appending: String) throws {
        let path = FileManager.documentsPathWithAppending(path: appending)
        try saveToPath(path: path)
    }
    
    func saveToPath(path: String) throws {
        guard let pathURL = URL(string: path) else {
            throw URLGenerationError.runtimeError("Failed to create URL from path string: \(path)")
        }
        try saveToPath(path: pathURL)
    }
    
    func saveToPath(path: URL) throws {
        try FileManager.saveSet(set: self, toPath: path)
    }
    
    func saveWithFilename(filename: String) throws {
        try saveToDocumentsWithAppending(appending: filename)
    }
}

enum URLGenerationError: LocalizedError {
    case runtimeError(String)
}
