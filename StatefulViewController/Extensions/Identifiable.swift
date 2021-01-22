import Foundation

protocol Identifiable: class {
    static var identifier: String { get }
}

extension Identifiable {
    static var identifier: String { return String(describing: self) }
}

extension NSObject: Identifiable {
    
}
