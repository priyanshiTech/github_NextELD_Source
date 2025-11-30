import CoreBluetooth

class SharedInfoManager {
    private static var instance: SharedInfoManager?
    private static let lock = NSLock()

    static var shared: SharedInfoManager {
        lock.lock()
        defer { lock.unlock() }

        if instance == nil {
            instance = SharedInfoManager()
        }
        return instance!
    }
    
    var lattitude = 0.0
    var longitude = 0.0
    var odometer = 0.0
    var engineHours = 0.0
    var isDeviceConnected: Bool = false
    
    var centralManager: CBCentralManager?
    private init() {
        
    }
}
