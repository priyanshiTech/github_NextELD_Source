//
//  DeviceDataDbManager.swift
//  NextEld
//
//  Created by priyanshi  on 08/01/26.
//

import Foundation
import SQLite3
import SQLite
import SwiftUI

struct DeviceDataModel: Identifiable {
    var id: Int64?
    let driverId: Int
    let vehicleId: Int
    let dateTime: Date
    let odometer: Double
    let engineHours: Double
    let model: String
    let serialNo: String
    let macAddress: String
    let version: String
    let vin: String
    let lat: Double
    let long: Double
    let rpm: Int
    let speed: Double
    let utcTime: Int64
    let oilTemp: Double
    let coolantTemp: Double
    let fuelTankTemp: Double
}



 
class DeviceDataDbManager {
    
    static let shared = DeviceDataDbManager()
    private var db: Connection?
    // MARK: - Device Data Table
    let deviceDataTable = Table("Devicedata")
    
    let deviceId = Expression<Int64>("id")
    let deviceDriverId = Expression<Int>("driverId")
    let deviceVehicleId = Expression<Int>("vehicleId")
    let deviceDateTime = Expression<Date>("dateTime")
    let deviceOdometer = Expression<Double>("odometer")
    let deviceEngineHours = Expression<Double>("engineHours")
    let deviceModel = Expression<String>("model")
    let deviceSerialNo = Expression<String>("serialNo")
    let deviceMacAddress = Expression<String>("macAddress")
    let deviceVersion = Expression<String>("version")
    let deviceVIN = Expression<String>("vin")
    let deviceLat = Expression<Double>("lat")
    let deviceLong = Expression<Double>("long")
    let deviceRPM = Expression<Int>("rpm")
    let deviceSpeed = Expression<Double>("speed")
    let deviceUTCTime = Expression<Int64>("utcTime")
    let deviceOilTemp = Expression<Double>("oilTemp")
    let deviceCoolantTemp = Expression<Double>("coolantTemp")
    let deviceFuelTankTemp = Expression<Double>("fuelTankTemp")
    

   

    //MARK: -  create a Table
    func createDeviceDataTable() {
        do {
            try db?.run(deviceDataTable.create(ifNotExists: true) { t in
                t.column(deviceId, primaryKey: .autoincrement)
                t.column(deviceDriverId)
                t.column(deviceVehicleId)
                t.column(deviceDateTime)
                t.column(deviceOdometer)
                t.column(deviceEngineHours)
                t.column(deviceModel)
                t.column(deviceSerialNo)
                t.column(deviceMacAddress)
                t.column(deviceVersion)
                t.column(deviceVIN)
                t.column(deviceLat)
                t.column(deviceLong)
                t.column(deviceRPM)
                t.column(deviceSpeed)
                t.column(deviceUTCTime)
                t.column(deviceOilTemp)
                t.column(deviceCoolantTemp)
                t.column(deviceFuelTankTemp)
            })
        } catch {
            print(" DeviceData table creation error: \(error)")
        }
    }
    
    
    private init() {
        do {
            let documentDirectory = try FileManager.default.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            )

            let dbPath = documentDirectory.appendingPathComponent("NextEld.sqlite3")
            db = try Connection(dbPath.path)

            print(" DeviceData DB path:", dbPath.path)

            createDeviceDataTable()
        } catch {
            print(" DeviceData DB init error:", error)
        }
    }
    
    func insertDeviceData(_ model: DeviceDataModel) {
        do {
            let insert = deviceDataTable.insert(
                deviceDriverId <- model.driverId,
                deviceVehicleId <- model.vehicleId,
                deviceDateTime <- model.dateTime,
                deviceOdometer <- model.odometer,
                deviceEngineHours <- model.engineHours,
                deviceModel <- model.model,
                deviceSerialNo <- model.serialNo,
                deviceMacAddress <- model.macAddress,
                deviceVersion <- model.version,
                deviceVIN <- model.vin,
                deviceLat <- model.lat,
                deviceLong <- model.long,
                deviceRPM <- model.rpm,
                deviceSpeed <- model.speed,
                deviceUTCTime <- model.utcTime,
                deviceOilTemp <- model.oilTemp,
                deviceCoolantTemp <- model.coolantTemp,
                deviceFuelTankTemp <- model.fuelTankTemp
            )
            
            try db?.run(insert)
            print("Device data saved")
            
        } catch {
            print(" Insert DeviceData error: \(error)")
        }
    }
//    func insertLiveDeviceData() {
//
//        let model = DeviceDataModel(
//            id: nil,
//            driverId: AppStorageHandler.shared.driverId ?? 0,
//            vehicleId: AppStorageHandler.shared.vehicleId ?? 0,
//            dateTime: Date(),
//
//            odometer: SharedInfoManager.shared.odometer,
//            engineHours: SharedInfoManager.shared.engineHours,
//
//            model: SharedInfoManager.shared.deviceModel,
//            serialNo: SharedInfoManager.shared.serialNo,
//            macAddress: SharedInfoManager.shared.macAddress,
//            version: SharedInfoManager.shared.firmwareVersion,
//            vin: SharedInfoManager.shared.vin,
//
//            lat: SharedInfoManager.shared.lattitude,
//            long: SharedInfoManager.shared.longitude,
//
//            rpm: SharedInfoManager.shared.rpm,
//            speed: SharedInfoManager.shared.speed,
//
//            utcTime: Int64(Date().timeIntervalSince1970),
//
//            oilTemp: SharedInfoManager.shared.oilTemp,
//            coolantTemp: SharedInfoManager.shared.coolantTemp,
//            fuelTankTemp: SharedInfoManager.shared.fuelTankTemp
//        )
//
//        insertDeviceData(model)
//    }

    
    func fetchAllDeviceData() -> [DeviceDataModel] {
        var records: [DeviceDataModel] = []
        guard let db = db else { return [] }
        
        do {
            for row in try db.prepare(deviceDataTable.order(deviceDateTime.desc)) {
                records.append(
                    DeviceDataModel(
                        id: row[deviceId],
                        driverId: row[deviceDriverId],
                        vehicleId: row[deviceVehicleId],
                        dateTime: row[deviceDateTime],
                        odometer: row[deviceOdometer],
                        engineHours: row[deviceEngineHours],
                        model: row[deviceModel],
                        serialNo: row[deviceSerialNo],
                        macAddress: row[deviceMacAddress],
                        version: row[deviceVersion],
                        vin: row[deviceVIN],
                        lat: row[deviceLat],
                        long: row[deviceLong],
                        rpm: row[deviceRPM],
                        speed: row[deviceSpeed],
                        utcTime: row[deviceUTCTime],
                        oilTemp: row[deviceOilTemp],
                        coolantTemp: row[deviceCoolantTemp],
                        fuelTankTemp: row[deviceFuelTankTemp]
                    )
                )
            }
        } catch {
            print(" Fetch DeviceData error: \(error)")
        }
        
        return records
    }
}


