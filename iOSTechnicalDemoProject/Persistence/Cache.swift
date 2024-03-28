//
//  Cache.swift
//  iOSTechnicalDemoProject
//
//  Created by Ade Adegoke on 21/03/2024.
//

import Foundation

final class Cache<Key: Hashable & Sendable, Value: Sendable> {
    private let wrapped = NSCache<WrappedKey, Entry>()
    private let lock = NSLock()
    
    func insert(_ value: Value, forKey key: Key) {
        lock.lock()
        defer { lock.unlock() }
        let entry = Entry(value: value)
        wrapped.setObject(entry, forKey: WrappedKey(key))
    }

    func value(forKey key: Key) -> Value? {
        lock.lock()
        defer { lock.unlock() }
        let entry = wrapped.object(forKey: WrappedKey(key))
        return entry?.value
    }

    func removeValue(forKey key: Key) {
        lock.lock()
        defer { lock.unlock() }
        wrapped.removeObject(forKey: WrappedKey(key))
    }
}

private extension Cache {
    final class WrappedKey: NSObject {
        let key: Key

        init(_ key: Key) { self.key = key }

        override var hash: Int { return key.hashValue }

        override func isEqual(_ object: Any?) -> Bool {
            guard let value = object as? WrappedKey else {
                return false
            }

            return value.key == key
        }
    }
}

private extension Cache {
    final class Entry {
        let value: Value

        init(value: Value) {
            self.value = value
        }
    }
}

extension Cache {
    subscript(key: Key) -> Value? {
        get { return value(forKey: key) }
        set {
            guard let value = newValue else {
                removeValue(forKey: key)
                return
            }

            insert(value, forKey: key)
        }
    }
}
