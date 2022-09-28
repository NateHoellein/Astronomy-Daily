//
//  DependencyManager.swift
//  Astronomy Daily
//
//  Created by Nathan Hoellein on 9/28/22.
//

import Foundation
import Swinject

class DependencyManager {
    static let shared = DependencyManager()
    
    var container: Container!
    private init() { }
    
    func resolve<T>(_ serviceType:T.Type) -> T {
        return container.resolve(serviceType)!
    }
}
