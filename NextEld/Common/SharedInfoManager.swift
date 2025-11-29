import CoreBluetooth

class SharedInfoManager {
    static let shared = SharedInfoManager()
    var lattitude = 0.0
    var longitude = 0.0
    var odometer = 0.0
    var engineHours = 0.0
    var customLocation: String  = ""
    var isDeviceConnected: Bool = false
    
    var centralManager: CBCentralManager?
    private init() {
        
    }
}
