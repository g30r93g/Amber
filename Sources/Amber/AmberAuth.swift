//
//  AmberAuth.swift
//
//
//  Created by George Nick Gorzynski on 30/05/2020.
//

import Foundation
import StoreKit

@available(iOS 11.0, *)
internal struct AmberAuth {
    
    public static func fetchUserToken(developerToken: String, completion: @escaping(Result<String?, AmberError>) -> Void) {
        let controller = SKCloudServiceController()
        
        // Perform authorisation
        let authStatus = SKCloudServiceController.authorizationStatus()
        switch authStatus {
        case .authorized:
            controller.requestCapabilities { (capability, error) in
                if capability.contains(.musicCatalogPlayback) {
                    controller.requestUserToken(forDeveloperToken: developerToken) { (userToken, error) in
                        if error != nil {
                            completion(.failure(.tokenFetchFailure))
                        } else if let token = userToken {
                            completion(.success(token))
                        } else {
                            completion(.failure(.tokenFetchFailure))
                        }
                    }
                } else {
                    completion(.failure(.noSubscription))
                }
            }
        default:
            // Re-request Authorisation
            SKCloudServiceController.requestAuthorization { (status) in
                if status == .authorized {
                    self.fetchUserToken(developerToken: developerToken, completion: completion)
                } else {
                    completion(.failure(.permissionDenied))
                }
            }
        }
    }
    
}
