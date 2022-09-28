//
//  Storage.swift
//  Astronomy Daily
//
//  Created by Nathan Hoellein on 9/25/22.
//

import Foundation

protocol StorageProtocol {
    func saveData(dailyData: DailyData) -> Bool
    func getSavedData() -> DailyData?
}

class Storage: StorageProtocol {
    func saveData(dailyData: DailyData) -> Bool {
        do {
            let data = try JSONEncoder().encode(dailyData)
            UserDefaults.standard.set(data, forKey: "SAVEDDAILYDATA")
            return true
        } catch {
            print("ERROR saving data to UserDefaullts: \(error.localizedDescription)")
            return false
        }
    }
    
    func getSavedData() -> DailyData? {
        guard let data = UserDefaults.standard.value(forKeyPath: "SAVEDDAILYDATA") as? Data else {
            return nil
        }
        do {
            let dailyData = try JSONDecoder().decode(DailyData.self, from: data)
            return dailyData
        } catch {
            print("ERROR retrieving data from UserDefaullts: \(error.localizedDescription)")
        }
        return nil
    }
}
