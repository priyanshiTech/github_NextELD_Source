//
//  SessionCleanupManager.swift
//  NextEld
//
//  Created by CursorAssistant on 13/11/25.
//

import Foundation

enum SessionCleanupManager {
    
    static func clearAllPersistentData() {
        // Clear authentication artifacts
        
       // KeychainHelper.shared.deleteToken()
        
        // Remove auxiliary UserDefaults flags that might be set outside AppStorage
//        let defaults = UserDefaults.standard
//        defaults.set(false, forKey: "isLoggedIn")
//        defaults.synchronize()
        
        // Purge local databases
        DatabaseManager.shared.deleteAllLogs()
        ContinueDriveDBManager.shared.deleteAllContinueDriveData()
        DvirDatabaseManager.shared.deleteAllRecordsForDvirDataBase()
        CertifyDatabaseManager.shared.deleteAllCertifyRecords()
    }
}

