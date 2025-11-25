import CoreBluetooth

class SharedInfoManager {
    static let shared = SharedInfoManager()
    var centralManager: CBCentralManager?    
    private init() {
        
    }
}
