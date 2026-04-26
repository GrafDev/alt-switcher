import Foundation

struct RingBuffer {
    private var buffer: [String]
    
    init() {
        self.buffer = []
    }
    
    mutating func append(_ element: String) {
        // Ограничим буфер, скажем, 50 символами
        buffer.append(element)
        if buffer.count > 50 {
            buffer.removeFirst()
        }
    }
    
    mutating func removeLast() {
        if !buffer.isEmpty {
            buffer.removeLast()
        }
    }
    
    mutating func clear() {
        buffer.removeAll()
    }
    
    var joinedString: String {
        return buffer.joined()
    }
    
    var count: Int {
        return buffer.count
    }
}
