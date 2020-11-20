//
//  AmberError.swift
//  
//
//  Created by George Nick Gorzynski on 30/05/2020.
//

import Foundation

public enum AmberError: Error {
    
    /// User has not permitted access to Cloud Music Library.
    case noUserToken
    
    /// User has previously permitted access to Cloud Music Library.
    case userAlreadyAuthed
    
    /// User token fetch failed.
    case tokenFetchFailure
    
    /// User has denied permission to connect their Apple Music account.
    case permissionDenied
    
    /// User does not have an active subscription to Apple Music.
    case noSubscription
    
    /// Please ensure you are observing the maximum number of items that can be fetched in a single request. The limit for this request is {limit}.
    case fetchLimitBoundsNotObserved(limit: Int)
    
    /// Failed to fetch resource {resource.rawValue}
    case fetchFail(resource: Resources)
    
    /// An unknown error occurred.
    case unknownError
    
    /// Failed to decode JSON response.
    case dataDecodingError
    
    /// No data was decoded from the response.
    case noData
    
    /// The request body supplied was badly formatted.
    case invalidRequestBody
    
    /// This endpoint has not been implemented.
    case notImplemented
    
    /// The decoded type is not understood.
    case unknownDecodeType
    
    /// Content may be available at a different URL.
    case movedPermanently
    
    /// Content definitely available at a specific URL.
    case found
    
    /// The request wasn’t accepted as formed.
    case badRequest
    
    /// The request wasn’t accepted because its authorization is missing or invalid due to an issue with the developer token.
    case unauthorized
    
    /// The request wasn’t accepted due to an issue with the music user token or because it’s using incorrect authentication.
    case forbidden
    
    /// The requested resource doesn’t exist.
    case notFound
    
    /// The method can’t be used for the request.
    case methodNotAllowed
    
    /// A modification or creation request couldn’t be processed because there’s a conflict with the current state of the resource.
    case conflict
    
    /// The body of the request is too large.
    case payloadTooLarge
    
    /// The URI of the request is too long and won’t be processed.
    case uriTooLong
    
    /// The user has made too many requests.
    case tooManyRequests
    
    /// There’s an error processing the request.
    case internalServerError
    
    /// The service is currently unavailable to process requests.
    case serviceUnavailable
    
    var localizedDescription: String {
        switch self {
        case .noUserToken:
            return "User has not permitted access to Cloud Music Library."
        case .userAlreadyAuthed:
            return "User has previously permitted access to Cloud Music Library."
        case .tokenFetchFailure:
            return "User token fetch failed."
        case .noSubscription:
            return "User does not have an active subscription to Apple Music."
        case .fetchLimitBoundsNotObserved(let limit):
            return "Please ensure you are observing the maximum number of items that can be fetched in a single request. The limit for this request is \(limit)."
        case .fetchFail(let resource):
            return "Failed to fetch resource '\(resource.rawValue)'"
        case .unknownError:
            return "An unknown error occurred."
        case .dataDecodingError:
            return "Failed to decode JSON response."
        case .noData:
            return "No data was decoded from the response."
        case .invalidRequestBody:
            return "The request body supplied was badly formatted."
        case .notImplemented:
            return "This endpoint has not been implemented."
        case .unknownDecodeType:
            return "The decoded type is not understood."
        case .permissionDenied:
            return "The user has denied permission to connect their Apple Music account."
        case .movedPermanently:
            return "Content may be available at a different URL."
        case .found:
            return "Content definitely available at a specific URL."
        case .badRequest:
            return "The request wasn’t accepted as formed."
        case .unauthorized:
            return "The request wasn’t accepted because its authorization is missing or invalid due to an issue with the developer token. For personal endpoints, authorization issues may occur because the user wasn’t signed in or didn’t have a valid Apple Music subscription. For music user token requests, developer token issues may occur because the token wasn’t received or was invalid. There could also be an error processing the request."
        case .forbidden:
            return "The request wasn’t accepted due to an issue with the music user token or because it’s using incorrect authentication. For personal endpoints, authentication issues may occur if the account hasn’t accepted the Media and Apple Music privacy setting."
        case .notFound:
            return "The requested resource doesn’t exist."
        case .methodNotAllowed:
            return "The method can’t be used for the request."
        case .conflict:
            return "A modification or creation request couldn’t be processed because there’s a conflict with the current state of the resource."
        case .payloadTooLarge:
            return "The body of the request is too large."
        case .uriTooLong:
            return "The URI of the request is too long and won’t be processed."
        case .tooManyRequests:
            return "The user has made too many requests. "
        case .internalServerError:
            return "There’s an error processing the request."
        case .serviceUnavailable:
            return "The service is currently unavailable to process requests."
        }
    }
    
    init(appleMusicError: AMError) {
        switch appleMusicError.code {
        case "301":
            self = .movedPermanently
        case "302":
            self = .found
        case "400":
            self = .badRequest
        case "401":
            self = .unauthorized
        case "403":
            self = .forbidden
        case "404":
            self = .notFound
        case "405":
            self = .methodNotAllowed
        case "409":
            self = .conflict
        case "413":
            self = .payloadTooLarge
        case "414":
            self = .uriTooLong
        case "429":
            self = .tooManyRequests
        case "500":
            self = .internalServerError
        case "501":
            self = .notImplemented
        case "503":
            self = .serviceUnavailable
        default:
            self = .unknownError
        }
    }
    
}
