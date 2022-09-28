//
//  MainViewModel.swift
//  Astronomy Daily
//
//  Created by Nathan Hoellein on 9/24/22.
//

import Foundation
import UIKit


class MainViewModel {
    var title: String
    var date: String
    var image: UIImage?
    var copyright: String
    var author: String
    var description: String
    var network: NetworkProtocol
    var storage: StorageProtocol
    var delegate: UpdatedDataProtocol?
    
    private var imageList: [DailyData] = []
    private var viewingIndex: Int = 0
    var dataSaved = false
    
    init() {
        network = Network()
        storage = Storage()
        
        if let data = storage.getSavedData() {
            title = data.title
            date = data.date
            copyright = data.copyright ?? "---"
            author = data.author ?? "---"
            description = data.explanation
            if let data = data.imageData {
                image = UIImage(data: data)
            } else {
                image = UIImage(named: "PlaceholderSmiley")
            }
        } else {
            title = "September Sunrise Shadows"
            date = "2022-09-24"
            copyright = "© Donato Lioce"
            author = "Donato Lioce"
            description = "The defining astronomical moment for this September's equinox was on Friday, September 23, 2022 at 01:03 UTC, when the Sun crossed the celestial equator moving south in its yearly journey through planet Earth's sky. That marked the beginning of fall for our fair planet in the northern hemisphere and spring in the southern hemisphere, when day and night are nearly equal around the globe.  Of course, if you celebrate the astronomical change of seasons by watching a sunrise you can also look for crepuscular rays. The shadows cast by clouds can have a dramatic appearance in the twilight sky during any sunrise or sunset. Due to perspective, the parallel shadows will seem to point back to the rising Sun and a place due east on your horizon near the equinox date. Taken on September 15, this sunrise sea and skyscape captured crepuscular rays in the sky and watery specular reflections from the Mediterranean coast near the village of Petacciato, Italy."
            image = UIImage(named: "default")
        }
        
        getNewImages()
    }
    
    public func saveToStorage(dailyData: DailyData) {
        self.dataSaved = self.storage.saveData(dailyData: dailyData)
    }
    
    public func nextImage() {
        if imageList.count == 0 {
            return
        }
        
        if viewingIndex == imageList.count - 1 {
            viewingIndex = 0
        }
        let image:DailyData = imageList[viewingIndex]
        self.title = image.title
        self.date = image.date
        self.copyright = image.copyright ?? ""
        self.author = image.author ?? ""
        self.description = image.explanation
        self.delegate?.updatedData(dailyData: image)
        if viewingIndex < imageList.count {
            viewingIndex += 1
        } else {
            viewingIndex = 0
        }
    }
    
    public func previousImage() {
        if imageList.count == 0 {
            return
        }
        if viewingIndex == 0 {
            viewingIndex = imageList.count - 1
        } else {
            viewingIndex -= 1
        }
        let image:DailyData = imageList[viewingIndex]
        self.title = image.title
        self.date = image.date
        self.copyright = image.copyright ?? ""
        self.author = image.author ?? ""
        self.description = image.explanation
        self.delegate?.updatedData(dailyData: image)
        if viewingIndex == 0 {
            viewingIndex = imageList.count - 1
        }
    }
    
    public func getNewImages() {
        let queryObject = QueryObject(count: 5)
        self.network.getData(queryObject: queryObject, handler: {(result) in
            switch result {
            case .success(let dailyDataList):
                self.imageList = dailyDataList
            case .failure(let error):
                print("Error calling API: \(error.localizedDescription)")
            }
        })
    }
    
    func getImage(url: String) async -> Data? {
        let url = URL(string: url)!
        return await self.network.getImage(url: url)
    }
}
