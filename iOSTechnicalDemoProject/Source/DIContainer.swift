//
//  DIContainer.swift
//  iOSTechnicalDemoProject
//
//  Created by Ade Adegoke on 20/03/2024.
//

import Foundation

protocol DIContainerProtocol {
    func register<Service>(type: Service.Type, component: Any)
    func resolve<Service>(type: Service.Type) -> Service
}

final class DIContainer: DIContainerProtocol {
    static let shared = DIContainer()
    var components: [String: Any] = [:]
    
    init() {}
    
    func register<Service>(type: Service.Type, component: Any) {
        components["\(type)"] = component
    }
    
    func resolve<Service>(type: Service.Type) -> Service {
        components["\(type)"] as! Service
    }

}
