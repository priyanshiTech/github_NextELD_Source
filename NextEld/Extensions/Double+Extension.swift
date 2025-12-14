

extension Double {
    func getHours() -> Int {
        return Int(self / 3600)
    }
    
    func getMin() -> Int {
        return Int(self / 60)
    }
    
}
