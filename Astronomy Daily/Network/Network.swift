//
//  Network.swift
//  Astronomy Daily
//
//  Created by Nathan Hoellein on 9/24/22.
//

import Foundation

struct QueryObject {
    var count: Int
}

protocol NetworkProtocol {
    func getData(queryObject: QueryObject, handler: @escaping (Result<[DailyData], Error>) -> Void)
    func getImage(url: URL) async -> Data?
}

class Network: NetworkProtocol {
    
    func getData(queryObject: QueryObject, handler: @escaping (Result<[DailyData], Error>) -> Void) {
        let session = URLSession(configuration: .default)
        
        var url = URL(string: "https://api.nasa.gov/planetary/apod")
        if #available(iOS 16.0, *) {
            url?.append(queryItems: [URLQueryItem(name: "api_key", value: "kQbJgkKlyPg9RVatIX46EnkLVmdhJ8PneH5iukGV")])
            url?.append(queryItems: [URLQueryItem(name: "count", value: String(queryObject.count))])
        } else {
            let queryItems = [URLQueryItem(name: "api_key", value: "kQbJgkKlyPg9RVatIX46EnkLVmdhJ8PneH5iukGV"),
                              URLQueryItem(name: "count", value: String(queryObject.count))]
            var components = URLComponents(string: "https://api.nasa.gov/planetary/apod")
            components?.queryItems = queryItems
            url = components?.url
        }
        let task = session.dataTask(with: URLRequest(url: url!)) { data, response, error in
            if let error = error {
                handler(Result<[DailyData], Error>.failure(error))
            }
            if let data = data {
                do {
                    let dailyData: [DailyData] = try JSONDecoder().decode([DailyData].self, from: data)
                    handler(Result<[DailyData], Error>.success(dailyData))
                } catch {
                    handler(Result<[DailyData], Error>.failure(error))
                }
            }
        }
        task.resume()
    }
    
    func getImage(url: URL) async -> Data? {
        let session = URLSession(configuration: .default)
        
        do {
            let (data,_) = try await session.data(for: URLRequest(url: url))
            return data
        } catch {
            print("Error downloading image data \(error.localizedDescription)")
            return nil
        }
    }
}
