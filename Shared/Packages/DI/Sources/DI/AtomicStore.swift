import Foundation

final class AtomicStore<Key: Hashable, Value> {
    private var store: [Key: Value] = [:]
    private let accessQueue: DispatchQueue
    private let key = DispatchSpecificKey<Void>()

    init(identifier: String) {
        accessQueue = DispatchQueue(label: "com.wiheads.paste.\(identifier)", qos: .userInteractive)
        accessQueue.setSpecific(key: key, value: ())
    }

    subscript(key: Key) -> Value? {
        get {
            accessQueue.sync {
                store[key]
            }
        }

        set {
            accessQueue.sync {
                store[key] = newValue
            }
        }
    }

    func sync<T>(_ handler: (AtomicStoreSyncAccessor<Key, Value>) -> T) -> T {
        func perform() -> T {
            let accessor = AtomicStoreSyncAccessor(
                get: { self.store[$0] },
                set: { self.store[$0] = $1 }
            )
            return handler(accessor)
        }

        if DispatchQueue.getSpecific(key: key) != nil {
            return perform()
        }
        return accessQueue.sync(execute: perform)
    }

    func removeAll() {
        accessQueue.sync {
            store.removeAll()
        }
    }
}

struct AtomicStoreSyncAccessor<Key, Value> {
    fileprivate let get: (Key) -> Value?
    fileprivate let set: (Key, Value?) -> Void

    subscript(key: Key) -> Value? {
        get { get(key) }
        nonmutating set { set(key, newValue) }
    }
}
