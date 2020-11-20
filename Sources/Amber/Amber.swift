//
//  Amber.swift
//
//
//  Created by George Nick Gorzynski on 31/05/2020.
//  Copyright © 2020 George Nick Gorzynski. All rights reserved.
//

import Foundation
import Alamofire

@available(iOS 11.0, macOS 13.0, *)
public class Amber {
    
    // MARK: Initialisers
    public init(developerToken: String, userToken: String? = nil, countryCode: String? = nil) {
        self.developerToken = developerToken
        self.userToken = userToken
        self.player = AmberPlayer()
        
        self.updateStorefront(to: countryCode)
    }
    
    // MARK: Properties
    private(set) public var developerToken: String!
    private(set) var userToken: String?
    private(set) var storefront: StorefrontDeterminator.StorefrontDetails?
    
    public var player: AmberPlayer
    
    // MARK: Update Methods
    public func fetchUserToken(completion: @escaping(Result<String, AmberError>) -> Void) {
        AmberAuth.fetchUserToken(developerToken: self.developerToken) { (result) in
            switch result {
            case .success(let userToken):
                guard let userToken = userToken else { completion(.failure(.noUserToken)); break }

                self.updateUserToken(to: userToken)

                completion(.success(userToken))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func updateUserToken(to token: String) {
        self.userToken = token
    }
    
    public func updateStorefront(to countryCode: String? = nil) {
        if let countryCode = countryCode {
            self.storefront = StorefrontDeterminator.storefront(for: countryCode)
//        } else if self.userToken != nil {
//            self.getUserStorefront { (result) in
//                switch result {
//                case .success(let userStorefront):
//                    self.storefront = StorefrontDeterminator.storefront(for: userStorefront.defaultLanguageTag)
//                case .failure(_):
//                    self.storefront = StorefrontDeterminator.deviceStorefront()
//                }
//            }
        } else {
            self.storefront = StorefrontDeterminator.deviceStorefront()
        }
    }
    
    // MARK: Request Fetch Methods
    private func requestHandler<T: Decodable>(_ request: URLRequest, for resource: Resources, completion: @escaping(Result<ResponseRoot<T>?, AmberError>) -> Void) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-DD"
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        AF.request(request)
            .validate()
            .responseDecodable(of: ResponseRoot<T>.self, decoder: decoder) { (response) in
                switch response.result {
                case .success(let responseData):
                    completion(.success(responseData))
                case .failure(_):
                    
                    if let data = response.data {
                        do {
                            let errorDecodable = try decoder.decode(AMError.self, from: data)
                            
                            completion(.failure(AmberError(appleMusicError: errorDecodable)))
                        } catch {
                            completion(.failure(.fetchFail(resource: resource)))
                        }
                    } else {
                        completion(.failure(.fetchFail(resource: resource)))
                    }
                }
            }
    }
    
    // MARK: Storefront
    private func getUserStorefront(completion: @escaping(Result<StorefrontAttributes, AmberError>) -> Void) {
        let request = RequestGenerator(self).individualizedContentRequest(resource: .storefront)
        
        self.requestHandler(request, for: .storefront) { (result: Result<ResponseRoot<Storefront>?, AmberError>) in
            switch result {
            case .success(let response):
                if let data = response?.data?.first,
                   let attributes = data.attributes {
                    completion(.success(attributes))
                } else if let firstError = response?.errors?.first {
                    completion(.failure(AmberError(appleMusicError: firstError)))
                } else {
                    completion(.failure(.noData))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: Albums
    public func getCatalogAlbum(identifier: String, include relationships: [Relationships]? = nil, completion: @escaping(Result<Album, AmberError>) -> Void) {
        let request = RequestGenerator(self).catalogContentRequest(resource: .albums, identifier: identifier, relationships: relationships)
        
        self.requestHandler(request, for: .albums) { (result: Result<ResponseRoot<Album>?, AmberError>) in
            switch result {
            case .success(let response):
                if let data = response?.data?.first {
                    completion(.success(data))
                } else if let firstError = response?.errors?.first {
                    completion(.failure(AmberError(appleMusicError: firstError)))
                } else {
                    completion(.failure(.noData))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func getCatalogAlbumByRelationship<T: Codable>(identifier: String, relationship: Relationships, include relationships: [Relationships]? = nil,  limit: Int? = nil, completion: @escaping(Result<T, AmberError>) -> Void) {
        let request = RequestGenerator(self).catalogContentRequest(resource: .albums, identifier: identifier, relationship: relationship, relationships: relationships, limit: limit)
        
        self.requestHandler(request, for: .albums) { (result: Result<ResponseRoot<T>?, AmberError>) in
            switch result {
            case .success(let response):
                if let data = response?.data?.first {
                    completion(.success(data))
                } else if let firstError = response?.errors?.first {
                    completion(.failure(AmberError(appleMusicError: firstError)))
                } else {
                    completion(.failure(.noData))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func getMultipleCatalogAlbums(identifiers: [String], relationships: [Relationships]? = nil, completion: @escaping(Result<[Album], AmberError>) -> Void) {
        if identifiers.count > 100 {
            completion(.failure(.fetchLimitBoundsNotObserved(limit: 100)))
        }
        
        if identifiers.isEmpty {
            completion(.failure(.noData))
        }
        
        let request = RequestGenerator(self).catalogContentRequest(resource: .albums, identifiers: identifiers, relationships: relationships)
        
        self.requestHandler(request, for: .albums) { (result: Result<ResponseRoot<Album>?, AmberError>) in
            switch result {
            case .success(let response):
                if let data = response?.data {
                    completion(.success(data))
                } else if let firstError = response?.errors?.first {
                    completion(.failure(AmberError(appleMusicError: firstError)))
                } else {
                    completion(.failure(.noData))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func getLibraryAlbum(identifier: String, include relationships: [Relationships]? = nil, completion: @escaping(Result<LibraryAlbum, AmberError>) -> Void) {
        let request = RequestGenerator(self).individualizedContentRequest(resource: .albums, identifier: identifier, relationships: relationships)
        
        self.requestHandler(request, for: .albums) { (result: Result<ResponseRoot<LibraryAlbum>?, AmberError>) in
            switch result {
            case .success(let response):
                if let data = response?.data?.first {
                    completion(.success(data))
                } else if let firstError = response?.errors?.first {
                    completion(.failure(AmberError(appleMusicError: firstError)))
                } else {
                    completion(.failure(.noData))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func getLibraryAlbumByRelationship(identifier: String, relationship: Relationships, limit: Int? = nil, offset: Int? = nil, completion: @escaping(Result<LibraryAlbum, AmberError>) -> Void) {
        let request = RequestGenerator(self).individualizedContentRequest(resource: .albums, identifier: identifier, relationship: relationship, limit: limit, offset: offset)
        
        self.requestHandler(request, for: .albums) { (result: Result<ResponseRoot<LibraryAlbum>?, AmberError>) in
            switch result {
            case .success(let response):
                if let data = response?.data?.first {
                    completion(.success(data))
                } else if let firstError = response?.errors?.first {
                    completion(.failure(AmberError(appleMusicError: firstError)))
                } else {
                    completion(.failure(.noData))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func getLibraryAlbums(identifiers: [String], include relationships: [Relationships]? = nil, completion: @escaping(Result<[LibraryAlbum], AmberError>) -> Void) {
        let request = RequestGenerator(self).individualizedContentRequest(resource: .albums, identifiers: identifiers, relationships: relationships)
        
        self.requestHandler(request, for: .albums) { (result: Result<ResponseRoot<LibraryAlbum>?, AmberError>) in
            switch result {
            case .success(let response):
                if let data = response?.data {
                    completion(.success(data))
                } else if let firstError = response?.errors?.first {
                    completion(.failure(AmberError(appleMusicError: firstError)))
                } else {
                    completion(.failure(.noData))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func getAllLibraryAlbums(include relationships: [Relationships]? = nil, limit: Int? = nil, offset: Int? = nil, completion: @escaping(Result<[LibraryAlbum], AmberError>) -> Void) {
        completion(.failure(.notImplemented))
    }
    
    // MARK: Artists
    public func getCatalogArtist(identifier: String, include relationships: [Relationships]? = nil, completion: @escaping(Result<Artist, AmberError>) -> Void) {
        let request = RequestGenerator(self).catalogContentRequest(resource: .artists, identifier: identifier, relationships: relationships)
        
        self.requestHandler(request, for: .artists) { (result: Result<ResponseRoot<Artist>?, AmberError>) in
            switch result {
            case .success(let response):
                if let data = response?.data?.first {
                    completion(.success(data))
                } else if let firstError = response?.errors?.first {
                    completion(.failure(AmberError(appleMusicError: firstError)))
                } else {
                    completion(.failure(.noData))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func getCatalogArtistByRelationship(identifier: String, relationship: Relationships, limit: Int? = nil, completion: @escaping(Result<Artist, AmberError>) -> Void) {
        let request = RequestGenerator(self).catalogContentRequest(resource: .artists, identifier: identifier, relationship: relationship, limit: limit)
        
        self.requestHandler(request, for: .artists) { (result: Result<ResponseRoot<Artist>?, AmberError>) in
            switch result {
            case .success(let response):
                if let data = response?.data?.first {
                    completion(.success(data))
                } else if let firstError = response?.errors?.first {
                    completion(.failure(AmberError(appleMusicError: firstError)))
                } else {
                    completion(.failure(.noData))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func getMultipleCatalogArtists(identifiers: [String], include relationships: [Relationships]? = nil, completion: @escaping(Result<[Artist], AmberError>) -> Void) {
        let request = RequestGenerator(self).catalogContentRequest(resource: .artists, identifiers: identifiers, relationships: relationships)
        
        self.requestHandler(request, for: .artists) { (result: Result<ResponseRoot<Artist>?, AmberError>) in
            switch result {
            case .success(let response):
                if let data = response?.data {
                    completion(.success(data))
                } else if let firstError = response?.errors?.first {
                    completion(.failure(AmberError(appleMusicError: firstError)))
                } else {
                    completion(.failure(.noData))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func getLibraryArtist(identifier: String, include relationships: [Relationships]? = nil, completion: @escaping(Result<LibraryArtist, AmberError>) -> Void) {
        let request = RequestGenerator(self).individualizedContentRequest(resource: .artists, identifier: identifier, relationships: relationships)
        
        self.requestHandler(request, for: .artists) { (result: Result<ResponseRoot<LibraryArtist>?, AmberError>) in
            switch result {
            case .success(let response):
                if let data = response?.data?.first {
                    completion(.success(data))
                } else if let firstError = response?.errors?.first {
                    completion(.failure(AmberError(appleMusicError: firstError)))
                } else {
                    completion(.failure(.noData))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func getLibraryArtistByRelationship(identifier: String, relationship: Relationships, limit: Int? = nil, completion: @escaping(Result<LibraryArtist, AmberError>) -> Void) {
        let request = RequestGenerator(self).individualizedContentRequest(resource: .artists, identifier: identifier, relationship: relationship, limit: limit)
        
        self.requestHandler(request, for: .artists) { (result: Result<ResponseRoot<LibraryArtist>?, AmberError>) in
            switch result {
            case .success(let response):
                if let data = response?.data?.first {
                    completion(.success(data))
                } else if let firstError = response?.errors?.first {
                    completion(.failure(AmberError(appleMusicError: firstError)))
                } else {
                    completion(.failure(.noData))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func getAllLibraryArtists(include relationships: [Relationships]? = nil, limit: Int? = nil, offset: Int? = nil, completion: @escaping(Result<[LibraryArtist], AmberError>) -> Void) {
        completion(.failure(.notImplemented))
    }
    
    public func getMultipleLibraryArtists(identifiers: [String], include relationships: [Relationships]? = nil, completion: @escaping(Result<[LibraryArtist], AmberError>) -> Void) {
        let request = RequestGenerator(self).individualizedContentRequest(resource: .artists, identifiers: identifiers, relationships: relationships)
        
        self.requestHandler(request, for: .artists) { (result: Result<ResponseRoot<LibraryArtist>?, AmberError>) in
            switch result {
            case .success(let response):
                if let data = response?.data {
                    completion(.success(data))
                } else if let firstError = response?.errors?.first {
                    completion(.failure(AmberError(appleMusicError: firstError)))
                } else {
                    completion(.failure(.noData))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: Songs
    public func getCatalogSong(identifier: String, include relationships: [Relationships]? = nil, completion: @escaping(Result<Song, AmberError>) -> Void) {
        let request = RequestGenerator(self).catalogContentRequest(resource: .songs, identifier: identifier, relationships: relationships)
        
        self.requestHandler(request, for: .songs) { (result: Result<ResponseRoot<Song>?, AmberError>) in
            switch result {
            case .success(let response):
                if let data = response?.data?.first {
                    completion(.success(data))
                } else if let firstError = response?.errors?.first {
                    completion(.failure(AmberError(appleMusicError: firstError)))
                } else {
                    completion(.failure(.noData))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func getCatalogSongByRelationship<T: Codable>(identifier: String, relationship: Relationships, include relationships: [Relationships]? = nil, limit: Int? = nil, completion: @escaping(Result<T, AmberError>) -> Void) {
        let request = RequestGenerator(self).catalogContentRequest(resource: .songs, identifier: identifier, relationship: relationship, relationships: relationships, limit: limit)
        
        self.requestHandler(request, for: .songs) { (result: Result<ResponseRoot<T>?, AmberError>) in
            switch result {
            case .success(let response):
                if let data = response?.data?.first {
                    completion(.success(data))
                } else if let firstError = response?.errors?.first {
                    completion(.failure(AmberError(appleMusicError: firstError)))
                } else {
                    completion(.failure(.noData))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func getMultipleCatalogSongs(identifiers: [String], include relationships: [Relationships]? = nil, completion: @escaping(Result<[Song], AmberError>) -> Void) {
        let request = RequestGenerator(self).catalogContentRequest(resource: .songs, identifiers: identifiers, relationships: relationships)
        
        self.requestHandler(request, for: .songs) { (result: Result<ResponseRoot<Song>?, AmberError>) in
            switch result {
            case .success(let response):
                if let data = response?.data {
                    completion(.success(data))
                } else if let firstError = response?.errors?.first {
                    completion(.failure(AmberError(appleMusicError: firstError)))
                } else {
                    completion(.failure(.noData))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func getLibrarySong(identifier: String, include relationships: [Relationships]? = nil, completion: @escaping(Result<LibrarySong, AmberError>) -> Void) {
        let request = RequestGenerator(self).individualizedContentRequest(resource: .songs, identifier: identifier, relationships: relationships)
        
        self.requestHandler(request, for: .songs) { (result: Result<ResponseRoot<LibrarySong>?, AmberError>) in
            switch result {
            case .success(let response):
                if let data = response?.data?.first {
                    completion(.success(data))
                } else if let firstError = response?.errors?.first {
                    completion(.failure(AmberError(appleMusicError: firstError)))
                } else {
                    completion(.failure(.noData))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func getLibrarySongByRelationship(identifier: String, relationship: Relationships, limit: Int? = nil, completion: @escaping(Result<LibrarySong, AmberError>) -> Void) {
        let request = RequestGenerator(self).individualizedContentRequest(resource: .songs, identifier: identifier, relationship: relationship, limit: limit)
        
        self.requestHandler(request, for: .songs) { (result: Result<ResponseRoot<LibrarySong>?, AmberError>) in
            switch result {
            case .success(let response):
                if let data = response?.data?.first {
                    completion(.success(data))
                } else if let firstError = response?.errors?.first {
                    completion(.failure(AmberError(appleMusicError: firstError)))
                } else {
                    completion(.failure(.noData))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func getAllLibrarySongs(include relationships: [Relationships]? = nil, limit: Int? = nil, offset: Int? = nil, completion: @escaping(Result<[LibrarySong], AmberError>) -> Void) {
        completion(.failure(.notImplemented))
    }
    
    public func getMultipleLibrarySongs(identifiers: [String], include relationships: [Relationships]? = nil, completion: @escaping(Result<[LibrarySong], AmberError>) -> Void) {
        let request = RequestGenerator(self).individualizedContentRequest(resource: .songs, identifiers: identifiers, relationships: relationships)
        
        self.requestHandler(request, for: .songs) { (result: Result<ResponseRoot<LibrarySong>?, AmberError>) in
            switch result {
            case .success(let response):
                if let data = response?.data {
                    completion(.success(data))
                } else if let firstError = response?.errors?.first {
                    completion(.failure(AmberError(appleMusicError: firstError)))
                } else {
                    completion(.failure(.noData))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: Music Videos
    public func getCatalogMusicVideo(identifier: String, include relationships: [Relationships]? = nil, completion: @escaping(Result<MusicVideo, AmberError>) -> Void) {
        let request = RequestGenerator(self).catalogContentRequest(resource: .musicVideos, identifier: identifier, relationships: relationships)
        
        self.requestHandler(request, for: .musicVideos) { (result: Result<ResponseRoot<MusicVideo>?, AmberError>) in
            switch result {
            case .success(let response):
                if let data = response?.data?.first {
                    completion(.success(data))
                } else if let firstError = response?.errors?.first {
                    completion(.failure(AmberError(appleMusicError: firstError)))
                } else {
                    completion(.failure(.noData))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func getCatalogMusicVideoByRelationship(identifier: String, relationship: Relationships, limit: Int? = nil, completion: @escaping(Result<MusicVideo, AmberError>) -> Void) {
        let request = RequestGenerator(self).catalogContentRequest(resource: .musicVideos, identifier: identifier, relationship: relationship, limit: limit)
        
        self.requestHandler(request, for: .musicVideos) { (result: Result<ResponseRoot<MusicVideo>?, AmberError>) in
            switch result {
            case .success(let response):
                if let data = response?.data?.first {
                    completion(.success(data))
                } else if let firstError = response?.errors?.first {
                    completion(.failure(AmberError(appleMusicError: firstError)))
                } else {
                    completion(.failure(.noData))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func getMultipleCatalogMusicVideos(identifiers: [String], include relationships: [Relationships]? = nil, completion: @escaping(Result<[MusicVideo], AmberError>) -> Void) {
        let request = RequestGenerator(self).catalogContentRequest(resource: .musicVideos, identifiers: identifiers, relationships: relationships)
        
        self.requestHandler(request, for: .musicVideos) { (result: Result<ResponseRoot<MusicVideo>?, AmberError>) in
            switch result {
            case .success(let response):
                if let data = response?.data {
                    completion(.success(data))
                } else if let firstError = response?.errors?.first {
                    completion(.failure(AmberError(appleMusicError: firstError)))
                } else {
                    completion(.failure(.noData))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func getLibraryMusicVideo(identifier: String, include relationships: [Relationships]? = nil, completion: @escaping(Result<LibraryMusicVideo, AmberError>) -> Void) {
        let request = RequestGenerator(self).individualizedContentRequest(resource: .libraryMusicVideos, identifier: identifier, relationships: relationships)
        
        self.requestHandler(request, for: .musicVideos) { (result: Result<ResponseRoot<LibraryMusicVideo>?, AmberError>) in
            switch result {
            case .success(let response):
                if let data = response?.data?.first {
                    completion(.success(data))
                } else if let firstError = response?.errors?.first {
                    completion(.failure(AmberError(appleMusicError: firstError)))
                } else {
                    completion(.failure(.noData))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func getLibraryMusicVideoByRelationship(identifier: String, relationship: Relationships, limit: Int? = nil, completion: @escaping(Result<LibraryMusicVideo, AmberError>) -> Void) {
        let request = RequestGenerator(self).individualizedContentRequest(resource: .libraryMusicVideos, identifier: identifier, relationship: relationship, limit: limit)
        
        self.requestHandler(request, for: .musicVideos) { (result: Result<ResponseRoot<LibraryMusicVideo>?, AmberError>) in
            switch result {
            case .success(let response):
                if let data = response?.data?.first {
                    completion(.success(data))
                } else if let firstError = response?.errors?.first {
                    completion(.failure(AmberError(appleMusicError: firstError)))
                } else {
                    completion(.failure(.noData))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func getMultipleLibraryMusicVideos(identifiers: [String], include relationships: [Relationships]? = nil, completion: @escaping(Result<[LibraryMusicVideo], AmberError>) -> Void) {
        let request = RequestGenerator(self).individualizedContentRequest(resource: .libraryMusicVideos, identifiers: identifiers, relationships: relationships)
        
        self.requestHandler(request, for: .musicVideos) { (result: Result<ResponseRoot<LibraryMusicVideo>?, AmberError>) in
            switch result {
            case .success(let response):
                if let data = response?.data {
                    completion(.success(data))
                } else if let firstError = response?.errors?.first {
                    completion(.failure(AmberError(appleMusicError: firstError)))
                } else {
                    completion(.failure(.noData))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func getAllLibraryMusicVideos(include relationships: [Relationships]? = nil, limit: Int? = nil, offset: Int? = nil, completion: @escaping(Result<[LibraryMusicVideo], AmberError>) -> Void) {
        completion(.failure(.notImplemented))
    }
    
    // MARK: Playlists
    public func getCatalogPlaylist(identifier: String, include relationships: [Relationships]? = nil, completion: @escaping(Result<Playlist, AmberError>) -> Void) {
        let request = RequestGenerator(self).catalogContentRequest(resource: .playlists, identifier: identifier, relationships: relationships)
        
        self.requestHandler(request, for: .playlists) { (result: Result<ResponseRoot<Playlist>?, AmberError>) in
            switch result {
            case .success(let response):
                if let data = response?.data?.first {
                    completion(.success(data))
                } else if let firstError = response?.errors?.first {
                    completion(.failure(AmberError(appleMusicError: firstError)))
                } else {
                    completion(.failure(.noData))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func getCatalogPlaylistByRelationship(identifier: String, relationship: Relationships, limit: Int? = nil, completion: @escaping(Result<Playlist, AmberError>) -> Void) {
        let request = RequestGenerator(self).catalogContentRequest(resource: .playlists, identifier: identifier, relationship: relationship, limit: limit)
        
        self.requestHandler(request, for: .playlists) { (result: Result<ResponseRoot<Playlist>?, AmberError>) in
            switch result {
            case .success(let response):
                if let data = response?.data?.first {
                    completion(.success(data))
                } else if let firstError = response?.errors?.first {
                    completion(.failure(AmberError(appleMusicError: firstError)))
                } else {
                    completion(.failure(.noData))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func getMultipleCatalogPlaylist(identifiers: [String], include relationships: [Relationships]? = nil, completion: @escaping(Result<[Playlist], AmberError>) -> Void) {
        let request = RequestGenerator(self).catalogContentRequest(resource: .playlists, identifiers: identifiers, relationships: relationships)
        
        self.requestHandler(request, for: .playlists) { (result: Result<ResponseRoot<Playlist>?, AmberError>) in
            switch result {
            case .success(let response):
                if let data = response?.data {
                    completion(.success(data))
                } else if let firstError = response?.errors?.first {
                    completion(.failure(AmberError(appleMusicError: firstError)))
                } else {
                    completion(.failure(.noData))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func getLibraryPlaylist(identifier: String, include relationships: [Relationships]? = nil, completion: @escaping(Result<LibraryPlaylist, AmberError>) -> Void) {
        let request = RequestGenerator(self).individualizedContentRequest(resource: .playlists, identifier: identifier, relationships: relationships)
        
        self.requestHandler(request, for: .playlists) { (result: Result<ResponseRoot<LibraryPlaylist>?, AmberError>) in
            switch result {
            case .success(let response):
                if let data = response?.data?.first {
                    completion(.success(data))
                } else if let firstError = response?.errors?.first {
                    completion(.failure(AmberError(appleMusicError: firstError)))
                } else {
                    completion(.failure(.noData))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func getLibraryPlaylistByRelationship(identifier: String, relationship: Relationships, limit: Int? = nil, completion: @escaping(Result<LibraryPlaylist, AmberError>) -> Void) {
        let request = RequestGenerator(self).individualizedContentRequest(resource: .playlists, identifier: identifier, relationship: relationship, limit: limit)
        
        self.requestHandler(request, for: .playlists) { (result: Result<ResponseRoot<LibraryPlaylist>?, AmberError>) in
            switch result {
            case .success(let response):
                if let data = response?.data?.first {
                    completion(.success(data))
                } else if let firstError = response?.errors?.first {
                    completion(.failure(AmberError(appleMusicError: firstError)))
                } else {
                    completion(.failure(.noData))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func getMultipleLibraryPlaylists(identifiers: [String], include relationships: [Relationships]? = nil, completion: @escaping(Result<[LibraryPlaylist], AmberError>) -> Void) {
        let request = RequestGenerator(self).individualizedContentRequest(resource: .playlists, identifiers: identifiers, relationships: relationships)
        
        self.requestHandler(request, for: .playlists) { (result: Result<ResponseRoot<LibraryPlaylist>?, AmberError>) in
            switch result {
            case .success(let response):
                if let data = response?.data {
                    completion(.success(data))
                } else if let firstError = response?.errors?.first {
                    completion(.failure(AmberError(appleMusicError: firstError)))
                } else {
                    completion(.failure(.noData))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func getAllLibraryPlaylists(include relationships: [Relationships]? = nil, limit: Int? = nil, offset: Int? = nil, completion: @escaping(Result<[LibraryPlaylist], AmberError>) -> Void) {
        completion(.failure(.notImplemented))
    }
    
    public func createNewLibraryPlaylist(playlistCreationRequest: LibraryPlaylistCreationRequest, include relationships: [Relationships]? = nil, completion: @escaping(Result<LibraryPlaylist, AmberError>) -> Void) {
        guard let data = try? playlistCreationRequest.data() else { completion(.failure(.invalidRequestBody)); return }
        let request = RequestGenerator(self).individualizedContentRequest(resource: .playlists, relationships: relationships, method: .post, body: data)
        
        self.requestHandler(request, for: .playlists) { (result: Result<ResponseRoot<LibraryPlaylist>?, AmberError>) in
            switch result {
            case .success(let response):
                if let data = response?.data?.first {
                    completion(.success(data))
                } else if let firstError = response?.errors?.first {
                    completion(.failure(AmberError(appleMusicError: firstError)))
                } else {
                    completion(.failure(.noData))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func addTracksToLibraryPlaylist(identifier: String, playlistTracksRequest: LibraryPlaylistTracksRequest, completion: @escaping(Result<Void?, AmberError>) -> Void) {
        let _ = RequestGenerator(self).individualizedContentRequest(resource: .playlists, identifier: identifier, relationship: .tracks, method: .put)
        
//        self.requestHandler(request, for: .playlists) { (result: Result<ResponseRoot<EmptyResource>?, AmberError>) in
//            switch result {
//            case .success(_):
//                completion(.success(Void()))
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        }
        completion(.failure(.notImplemented))
    }
    
    public func addResourceToLibrary(identifiers: [(Resources, String)], completion: @escaping(Result<Void, AmberError>) -> Void) {
        let acceptedIdentifiers = self.preprocessIdentifiers(identifiers)
        
        let _ = RequestGenerator(self).individualizedContentRequest(resource: .none, identifiers: acceptedIdentifiers)
        
        completion(.failure(.notImplemented))
    }
    
    private func preprocessIdentifiers(_ identifiers: [(Resources, String)]) -> [String] {
        return []
    }
    
    // MARK: Stations
    public func getCatalogStation(identifier: String, include relationships: [Relationships]? = nil, completion: @escaping(Result<Station, AmberError>) -> Void) {
        let request = RequestGenerator(self).catalogContentRequest(resource: .stations, identifier: identifier, relationships: relationships)
        
        self.requestHandler(request, for: .stations) { (result: Result<ResponseRoot<Station>?, AmberError>) in
            switch result {
            case .success(let response):
                if let data = response?.data?.first {
                    completion(.success(data))
                } else if let firstError = response?.errors?.first {
                    completion(.failure(AmberError(appleMusicError: firstError)))
                } else {
                    completion(.failure(.noData))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func getMultipleStations(identifiers: [String], include relationships: [Relationships]? = nil, completion: @escaping(Result<[Station], AmberError>) -> Void) {
        let request = RequestGenerator(self).individualizedContentRequest(resource: .stations, identifiers: identifiers, relationships: relationships)
        
        self.requestHandler(request, for: .stations) { (result: Result<ResponseRoot<Station>?, AmberError>) in
            switch result {
            case .success(let response):
                if let data = response?.data {
                    completion(.success(data))
                } else if let firstError = response?.errors?.first {
                    completion(.failure(AmberError(appleMusicError: firstError)))
                } else {
                    completion(.failure(.noData))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: Search
    public func searchCatalogResources(searchTerm: String, limit: Int? = nil, offset: Int? = nil, types resources: [Resources]? = nil, completion: @escaping(Result<SearchResults, AmberError>) -> Void) {
        let request = RequestGenerator(self).searchRequest(searchTerm: searchTerm, limit: limit, offset: offset, types: resources)
        
        self.requestHandler(request, for: .search) { (result: Result<ResponseRoot<SearchResults>?, AmberError>) in
            switch result {
            case .success(let response):
                if let data = response?.results {
                    completion(.success(data))
                } else if let firstError = response?.errors?.first {
                    completion(.failure(AmberError(appleMusicError: firstError)))
                } else {
                    completion(.failure(.noData))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func searchCatalogHints(searchTerm: String, limit: Int? = nil, types resources: [Resources]? = nil, completion: @escaping(Result<[String], AmberError>) -> Void) {
        let request = RequestGenerator(self).searchHintRequest(searchTerm: searchTerm, limit: limit, types: resources)
        
        self.requestHandler(request, for: .search) { (result: Result<ResponseRoot<SearchHints>?, AmberError>) in
            switch result {
            case .success(let response):
                if let data = response?.results?.terms {
                    completion(.success(data))
                } else if let firstError = response?.errors?.first {
                    completion(.failure(AmberError(appleMusicError: firstError)))
                } else {
                    completion(.failure(.noData))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func searchLibraryResources(searchTerm: String, types resources: [Resources]? = nil, limit: Int? = nil, offset: Int? = nil, completion: @escaping(Result<LibrarySearchResults, AmberError>) -> Void) {
        let request = RequestGenerator(self).librarySearchRequest(searchTerm: searchTerm, limit: limit, offset: offset, types: resources)
        
        self.requestHandler(request, for: .search) { (result: Result<ResponseRoot<LibrarySearchResults>?, AmberError>) in
            switch result {
            case .success(let response):
                if let data = response?.results {
                    completion(.success(data))
                } else if let firstError = response?.errors?.first {
                    completion(.failure(AmberError(appleMusicError: firstError)))
                } else {
                    completion(.failure(.noData))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: Ratings
    public func getPersonalAlbumRating(identifier: String, include relationships: [Relationships]? = nil, completion: @escaping(Result<Rating, AmberError>) -> Void) {
        let request = RequestGenerator(self).individualizedRatingRequest(resource: .albums, identifier: identifier, relationships: relationships)
        
        self.requestHandler(request, for: .albums) { (result: Result<ResponseRoot<Rating>?, AmberError>) in
            switch result {
            case .success(let response):
                if let data = response?.results {
                    completion(.success(data))
                } else if let firstError = response?.errors?.first {
                    completion(.failure(AmberError(appleMusicError: firstError)))
                } else {
                    completion(.failure(.noData))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func getPersonalMusicVideoRating(identifier: String, include relationships: [Relationships]? = nil, completion: @escaping(Result<Rating, AmberError>) -> Void) {
        let request = RequestGenerator(self).individualizedRatingRequest(resource: .musicVideos, identifier: identifier, relationships: relationships)
        
        self.requestHandler(request, for: .musicVideos) { (result: Result<ResponseRoot<Rating>?, AmberError>) in
            switch result {
            case .success(let response):
                if let data = response?.results {
                    completion(.success(data))
                } else if let firstError = response?.errors?.first {
                    completion(.failure(AmberError(appleMusicError: firstError)))
                } else {
                    completion(.failure(.noData))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func getPersonalPlaylistRating(identifier: String, include relationships: [Relationships]? = nil, completion: @escaping(Result<Rating, AmberError>) -> Void) {
        let request = RequestGenerator(self).individualizedRatingRequest(resource: .playlists, identifier: identifier, relationships: relationships)
        
        self.requestHandler(request, for: .playlists) { (result: Result<ResponseRoot<Rating>?, AmberError>) in
            switch result {
            case .success(let response):
                if let data = response?.results {
                    completion(.success(data))
                } else if let firstError = response?.errors?.first {
                    completion(.failure(AmberError(appleMusicError: firstError)))
                } else {
                    completion(.failure(.noData))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func getPersonalSongRating(identifier: String, include relationships: [Relationships]? = nil, completion: @escaping(Result<Rating, AmberError>) -> Void) {
        let request = RequestGenerator(self).individualizedRatingRequest(resource: .songs, identifier: identifier, relationships: relationships)
        
        self.requestHandler(request, for: .songs) { (result: Result<ResponseRoot<Rating>?, AmberError>) in
            switch result {
            case .success(let response):
                if let data = response?.results {
                    completion(.success(data))
                } else if let firstError = response?.errors?.first {
                    completion(.failure(AmberError(appleMusicError: firstError)))
                } else {
                    completion(.failure(.noData))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func getPersonalStationRating(identifier: String, include relationships: [Relationships]? = nil, completion: @escaping(Result<Rating, AmberError>) -> Void) {
        let request = RequestGenerator(self).individualizedRatingRequest(resource: .stations, identifier: identifier, relationships: relationships)
        
        self.requestHandler(request, for: .stations) { (result: Result<ResponseRoot<Rating>?, AmberError>) in
            switch result {
            case .success(let response):
                if let data = response?.results {
                    completion(.success(data))
                } else if let firstError = response?.errors?.first {
                    completion(.failure(AmberError(appleMusicError: firstError)))
                } else {
                    completion(.failure(.noData))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func getMultiplePersonalAlbumRatings(identifiers: [String], include relationships: [Relationships]? = nil, completion: @escaping(Result<[Rating], AmberError>) -> Void) {
        let request = RequestGenerator(self).individualizedRatingRequest(resource: .albums, identifiers: identifiers, relationships: relationships)
        
        self.requestHandler(request, for: .albums) { (result: Result<ResponseRoot<[Rating]>?, AmberError>) in
            switch result {
            case .success(let response):
                if let data = response?.results {
                    completion(.success(data))
                } else if let firstError = response?.errors?.first {
                    completion(.failure(AmberError(appleMusicError: firstError)))
                } else {
                    completion(.failure(.noData))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func getMultiplePersonalMusicVideoRatings(identifiers: [String], include relationships: [Relationships]? = nil, completion: @escaping(Result<[Rating], AmberError>) -> Void) {
        let request = RequestGenerator(self).individualizedRatingRequest(resource: .musicVideos, identifiers: identifiers, relationships: relationships)
        
        self.requestHandler(request, for: .musicVideos) { (result: Result<ResponseRoot<[Rating]>?, AmberError>) in
            switch result {
            case .success(let response):
                if let data = response?.results {
                    completion(.success(data))
                } else if let firstError = response?.errors?.first {
                    completion(.failure(AmberError(appleMusicError: firstError)))
                } else {
                    completion(.failure(.noData))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func getMultiplePersonalPlaylistRatings(identifiers: [String], include relationships: [Relationships]? = nil, completion: @escaping(Result<[Rating], AmberError>) -> Void) {
        let request = RequestGenerator(self).individualizedRatingRequest(resource: .playlists, identifiers: identifiers, relationships: relationships)
        
        self.requestHandler(request, for: .playlists) { (result: Result<ResponseRoot<[Rating]>?, AmberError>) in
            switch result {
            case .success(let response):
                if let data = response?.results {
                    completion(.success(data))
                } else if let firstError = response?.errors?.first {
                    completion(.failure(AmberError(appleMusicError: firstError)))
                } else {
                    completion(.failure(.noData))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func getMultiplePersonalSongRatings(identifiers: [String], include relationships: [Relationships]? = nil, completion: @escaping(Result<[Rating], AmberError>) -> Void) {
        let request = RequestGenerator(self).individualizedRatingRequest(resource: .songs, identifiers: identifiers, relationships: relationships)
        
        self.requestHandler(request, for: .songs) { (result: Result<ResponseRoot<[Rating]>?, AmberError>) in
            switch result {
            case .success(let response):
                if let data = response?.results {
                    completion(.success(data))
                } else if let firstError = response?.errors?.first {
                    completion(.failure(AmberError(appleMusicError: firstError)))
                } else {
                    completion(.failure(.noData))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func getMultiplePersonalStationRatings(identifiers: [String], include relationships: [Relationships]? = nil, completion: @escaping(Result<[Rating], AmberError>) -> Void) {
        let request = RequestGenerator(self).individualizedRatingRequest(resource: .stations, identifiers: identifiers, relationships: relationships)
        
        self.requestHandler(request, for: .stations) { (result: Result<ResponseRoot<[Rating]>?, AmberError>) in
            switch result {
            case .success(let response):
                if let data = response?.results {
                    completion(.success(data))
                } else if let firstError = response?.errors?.first {
                    completion(.failure(AmberError(appleMusicError: firstError)))
                } else {
                    completion(.failure(.noData))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func addPersonalAlbumRating(identifier: String, rating: Rating, completion: @escaping(Result<Rating, AmberError>) -> Void) {
        let request = RequestGenerator(self).individualizedRatingRequest(resource: .albums, identifier: identifier, method: .put)
        
        self.requestHandler(request, for: .albums) { (result: Result<ResponseRoot<Rating>?, AmberError>) in
            switch result {
            case .success(let response):
                if let data = response?.results {
                    completion(.success(data))
                } else if let firstError = response?.errors?.first {
                    completion(.failure(AmberError(appleMusicError: firstError)))
                } else {
                    completion(.failure(.noData))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func addPersonalMusicVideoRating(identifier: String, rating: Rating, completion: @escaping(Result<Rating, AmberError>) -> Void) {
        let request = RequestGenerator(self).individualizedRatingRequest(resource: .musicVideos, identifier: identifier, method: .put)
        
        self.requestHandler(request, for: .musicVideos) { (result: Result<ResponseRoot<Rating>?, AmberError>) in
            switch result {
            case .success(let response):
                if let data = response?.results {
                    completion(.success(data))
                } else if let firstError = response?.errors?.first {
                    completion(.failure(AmberError(appleMusicError: firstError)))
                } else {
                    completion(.failure(.noData))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func addPersonalPlaylistRating(identifier: String, rating: Rating, completion: @escaping(Result<Rating, AmberError>) -> Void) {
        let request = RequestGenerator(self).individualizedRatingRequest(resource: .playlists, identifier: identifier, method: .put)
        
        self.requestHandler(request, for: .playlists) { (result: Result<ResponseRoot<Rating>?, AmberError>) in
            switch result {
            case .success(let response):
                if let data = response?.results {
                    completion(.success(data))
                } else if let firstError = response?.errors?.first {
                    completion(.failure(AmberError(appleMusicError: firstError)))
                } else {
                    completion(.failure(.noData))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func addPersonalSongRating(identifier: String, rating: Rating, completion: @escaping(Result<Rating, AmberError>) -> Void) {
        let request = RequestGenerator(self).individualizedRatingRequest(resource: .songs, identifier: identifier, method: .put)
        
        self.requestHandler(request, for: .songs) { (result: Result<ResponseRoot<Rating>?, AmberError>) in
            switch result {
            case .success(let response):
                if let data = response?.results {
                    completion(.success(data))
                } else if let firstError = response?.errors?.first {
                    completion(.failure(AmberError(appleMusicError: firstError)))
                } else {
                    completion(.failure(.noData))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func addPersonalStationRating(identifier: String, rating: Rating, completion: @escaping(Result<Rating, AmberError>) -> Void) {
        let request = RequestGenerator(self).individualizedRatingRequest(resource: .stations, identifier: identifier, method: .put)
        
        self.requestHandler(request, for: .stations) { (result: Result<ResponseRoot<Rating>?, AmberError>) in
            switch result {
            case .success(let response):
                if let data = response?.results {
                    completion(.success(data))
                } else if let firstError = response?.errors?.first {
                    completion(.failure(AmberError(appleMusicError: firstError)))
                } else {
                    completion(.failure(.noData))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func deletePersonalAlbumRating(identifier: String, completion: @escaping(Result<Rating, AmberError>) -> Void) {
        let request = RequestGenerator(self).individualizedRatingRequest(resource: .albums, identifier: identifier, method: .delete)
        
        self.requestHandler(request, for: .albums) { (result: Result<ResponseRoot<Rating>?, AmberError>) in
            switch result {
            case .success(let response):
                if let data = response?.results {
                    completion(.success(data))
                } else if let firstError = response?.errors?.first {
                    completion(.failure(AmberError(appleMusicError: firstError)))
                } else {
                    completion(.failure(.noData))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func deletePersonalMusicVideoRating(identifier: String, completion: @escaping(Result<Rating, AmberError>) -> Void) {
        let request = RequestGenerator(self).individualizedRatingRequest(resource: .musicVideos, identifier: identifier, method: .delete)
        
        self.requestHandler(request, for: .musicVideos) { (result: Result<ResponseRoot<Rating>?, AmberError>) in
            switch result {
            case .success(let response):
                if let data = response?.results {
                    completion(.success(data))
                } else if let firstError = response?.errors?.first {
                    completion(.failure(AmberError(appleMusicError: firstError)))
                } else {
                    completion(.failure(.noData))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func deletePersonalPlaylistRating(identifier: String, completion: @escaping(Result<Rating, AmberError>) -> Void) {
        let request = RequestGenerator(self).individualizedRatingRequest(resource: .playlists, identifier: identifier, method: .delete)
        
        self.requestHandler(request, for: .playlists) { (result: Result<ResponseRoot<Rating>?, AmberError>) in
            switch result {
            case .success(let response):
                if let data = response?.results {
                    completion(.success(data))
                } else if let firstError = response?.errors?.first {
                    completion(.failure(AmberError(appleMusicError: firstError)))
                } else {
                    completion(.failure(.noData))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func deletePersonalStationRating(identifier: String, completion: @escaping(Result<Rating, AmberError>) -> Void) {
        let request = RequestGenerator(self).individualizedRatingRequest(resource: .stations, identifier: identifier, method: .delete)
        
        self.requestHandler(request, for: .stations) { (result: Result<ResponseRoot<Rating>?, AmberError>) in
            switch result {
            case .success(let response):
                if let data = response?.results {
                    completion(.success(data))
                } else if let firstError = response?.errors?.first {
                    completion(.failure(AmberError(appleMusicError: firstError)))
                } else {
                    completion(.failure(.noData))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: Library Ratings
    public func getPersonalLibraryMusicVideoRating(identifier: String, include relationships: [Relationships]? = nil, completion: @escaping(Result<Rating, AmberError>) -> Void) {
        let request = RequestGenerator(self).individualizedRatingRequest(resource: .libraryMusicVideos, identifier: identifier, relationships: relationships)
        
        self.requestHandler(request, for: .libraryMusicVideos) { (result: Result<ResponseRoot<Rating>?, AmberError>) in
            switch result {
            case .success(let response):
                if let data = response?.results {
                    completion(.success(data))
                } else if let firstError = response?.errors?.first {
                    completion(.failure(AmberError(appleMusicError: firstError)))
                } else {
                    completion(.failure(.noData))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func getPersonalLibraryPlaylistRating(identifier: String, include relationships: [Relationships]? = nil, completion: @escaping(Result<Rating, AmberError>) -> Void) {
        let request = RequestGenerator(self).individualizedRatingRequest(resource: .libraryPlaylists, identifier: identifier, relationships: relationships)
        
        self.requestHandler(request, for: .libraryPlaylists) { (result: Result<ResponseRoot<Rating>?, AmberError>) in
            switch result {
            case .success(let response):
                if let data = response?.results {
                    completion(.success(data))
                } else if let firstError = response?.errors?.first {
                    completion(.failure(AmberError(appleMusicError: firstError)))
                } else {
                    completion(.failure(.noData))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func getPersonalLibrarySongRating(identifier: String, include relationships: [Relationships]? = nil, completion: @escaping(Result<Rating, AmberError>) -> Void) {
        let request = RequestGenerator(self).individualizedRatingRequest(resource: .librarySongs, identifier: identifier, relationships: relationships)
        
        self.requestHandler(request, for: .librarySongs) { (result: Result<ResponseRoot<Rating>?, AmberError>) in
            switch result {
            case .success(let response):
                if let data = response?.results {
                    completion(.success(data))
                } else if let firstError = response?.errors?.first {
                    completion(.failure(AmberError(appleMusicError: firstError)))
                } else {
                    completion(.failure(.noData))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func getMultiplePersonalLibraryMusicVideoRatings(identifiers: [String], include relationships: [Relationships]? = nil, completion: @escaping(Result<[Rating], AmberError>) -> Void) {
        let request = RequestGenerator(self).individualizedRatingRequest(resource: .libraryMusicVideos, identifiers: identifiers, relationships: relationships)
        
        self.requestHandler(request, for: .libraryMusicVideos) { (result: Result<ResponseRoot<[Rating]>?, AmberError>) in
            switch result {
            case .success(let response):
                if let data = response?.results {
                    completion(.success(data))
                } else if let firstError = response?.errors?.first {
                    completion(.failure(AmberError(appleMusicError: firstError)))
                } else {
                    completion(.failure(.noData))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func getMultiplePersonalLibraryPlaylistRatings(identifiers: [String], include relationships: [Relationships]? = nil, completion: @escaping(Result<[Rating], AmberError>) -> Void) {
        let request = RequestGenerator(self).individualizedRatingRequest(resource: .libraryPlaylists, identifiers: identifiers, relationships: relationships)
        
        self.requestHandler(request, for: .libraryPlaylists) { (result: Result<ResponseRoot<[Rating]>?, AmberError>) in
            switch result {
            case .success(let response):
                if let data = response?.results {
                    completion(.success(data))
                } else if let firstError = response?.errors?.first {
                    completion(.failure(AmberError(appleMusicError: firstError)))
                } else {
                    completion(.failure(.noData))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func getMultiplePersonalLibrarySongRatings(identifiers: [String], include relationships: [Relationships]? = nil, completion: @escaping(Result<[Rating], AmberError>) -> Void) {
        let request = RequestGenerator(self).individualizedRatingRequest(resource: .librarySongs, identifiers: identifiers, relationships: relationships)
        
        self.requestHandler(request, for: .librarySongs) { (result: Result<ResponseRoot<[Rating]>?, AmberError>) in
            switch result {
            case .success(let response):
                if let data = response?.results {
                    completion(.success(data))
                } else if let firstError = response?.errors?.first {
                    completion(.failure(AmberError(appleMusicError: firstError)))
                } else {
                    completion(.failure(.noData))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func addPersonalLibraryMusicVideoRating(identifier: String, rating: Rating, completion: @escaping(Result<Rating, AmberError>) -> Void) {
        let request = RequestGenerator(self).individualizedRatingRequest(resource: .libraryMusicVideos, identifier: identifier, method: .put)
        
        self.requestHandler(request, for: .libraryMusicVideos) { (result: Result<ResponseRoot<Rating>?, AmberError>) in
            switch result {
            case .success(let response):
                if let data = response?.results {
                    completion(.success(data))
                } else if let firstError = response?.errors?.first {
                    completion(.failure(AmberError(appleMusicError: firstError)))
                } else {
                    completion(.failure(.noData))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func addPersonalLibraryPlaylistRating(identifier: String, rating: Rating, completion: @escaping(Result<Rating, AmberError>) -> Void) {
        let request = RequestGenerator(self).individualizedRatingRequest(resource: .libraryPlaylists, identifier: identifier, method: .put)
        
        self.requestHandler(request, for: .libraryPlaylists) { (result: Result<ResponseRoot<Rating>?, AmberError>) in
            switch result {
            case .success(let response):
                if let data = response?.results {
                    completion(.success(data))
                } else if let firstError = response?.errors?.first {
                    completion(.failure(AmberError(appleMusicError: firstError)))
                } else {
                    completion(.failure(.noData))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func addPersonalLibrarySongRating(identifier: String, rating: Rating, completion: @escaping(Result<Rating, AmberError>) -> Void) {
        let request = RequestGenerator(self).individualizedRatingRequest(resource: .librarySongs, identifier: identifier, method: .put)
        
        self.requestHandler(request, for: .librarySongs) { (result: Result<ResponseRoot<Rating>?, AmberError>) in
            switch result {
            case .success(let response):
                if let data = response?.results {
                    completion(.success(data))
                } else if let firstError = response?.errors?.first {
                    completion(.failure(AmberError(appleMusicError: firstError)))
                } else {
                    completion(.failure(.noData))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func deletePersonalLibraryMusicVideoRating(identifier: String, completion: @escaping(Result<Rating, AmberError>) -> Void) {
        let request = RequestGenerator(self).individualizedRatingRequest(resource: .libraryMusicVideos, identifier: identifier, method: .delete)
        
        self.requestHandler(request, for: .libraryMusicVideos) { (result: Result<ResponseRoot<Rating>?, AmberError>) in
            switch result {
            case .success(let response):
                if let data = response?.results {
                    completion(.success(data))
                } else if let firstError = response?.errors?.first {
                    completion(.failure(AmberError(appleMusicError: firstError)))
                } else {
                    completion(.failure(.noData))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func deletePersonalLibraryPlaylistRating(identifier: String, completion: @escaping(Result<Rating, AmberError>) -> Void) {
        let request = RequestGenerator(self).individualizedRatingRequest(resource: .libraryPlaylists, identifier: identifier, method: .delete)
        
        self.requestHandler(request, for: .libraryPlaylists) { (result: Result<ResponseRoot<Rating>?, AmberError>) in
            switch result {
            case .success(let response):
                if let data = response?.results {
                    completion(.success(data))
                } else if let firstError = response?.errors?.first {
                    completion(.failure(AmberError(appleMusicError: firstError)))
                } else {
                    completion(.failure(.noData))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: Charts
    public func getCatalogCharts(types resources: [Resources]? = nil, chart: String? = nil, genre: String? = nil, limit: Int? = nil, offset: Int? = nil, completion: @escaping(Result<Chart, AmberError>) -> Void) {
        let request = RequestGenerator(self).catalogContentRequest(resource: .charts, types: resources, limit: limit, offset: offset, chart: chart, genre: genre)
        
        self.requestHandler(request, for: .charts) { (result: Result<ResponseRoot<Chart>?, AmberError>) in
            switch result {
            case .success(let response):
                if let data = response?.results {
                    completion(.success(data))
                } else if let firstError = response?.errors?.first {
                    completion(.failure(AmberError(appleMusicError: firstError)))
                } else {
                    completion(.failure(.noData))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: Music Genres
    public func getCatalogGenre(identifier: String, completion: @escaping(Result<Genre, AmberError>) -> Void) {
        let request = RequestGenerator(self).catalogContentRequest(resource: .genres, identifier: identifier)
        
        self.requestHandler(request, for: .genres) { (result: Result<ResponseRoot<Genre>?, AmberError>) in
            switch result {
            case .success(let response):
                if let data = response?.data?.first {
                    completion(.success(data))
                } else if let firstError = response?.errors?.first {
                    completion(.failure(AmberError(appleMusicError: firstError)))
                } else {
                    completion(.failure(.noData))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func getCatalogGenreByRelationship(identifier: String, relationship: Relationships, limit: Int? = nil, offset: Int? = nil, completion: @escaping(Result<Genre, AmberError>) -> Void) {
        let request = RequestGenerator(self).catalogContentRequest(resource: .genres, identifier: identifier, relationship: relationship, limit: limit, offset: offset)
        
        self.requestHandler(request, for: .genres) { (result: Result<ResponseRoot<Genre>?, AmberError>) in
            switch result {
            case .success(let response):
                if let data = response?.data?.first {
                    completion(.success(data))
                } else if let firstError = response?.errors?.first {
                    completion(.failure(AmberError(appleMusicError: firstError)))
                } else {
                    completion(.failure(.noData))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func getMultipleCatalogGenres(identifiers: [String], completion: @escaping(Result<[Genre], AmberError>) -> Void) {
        let request = RequestGenerator(self).catalogContentRequest(resource: .genres, identifiers: identifiers)
        
        self.requestHandler(request, for: .genres) { (result: Result<ResponseRoot<Genre>?, AmberError>) in
            switch result {
            case .success(let response):
                if let data = response?.data {
                    completion(.success(data))
                } else if let firstError = response?.errors?.first {
                    completion(.failure(AmberError(appleMusicError: firstError)))
                } else {
                    completion(.failure(.noData))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func getTopChartingGenres(limit: Int? = nil, offset: Int?, completion: @escaping(Result<[Genre], AmberError>) -> Void) {
        let request = RequestGenerator(self).catalogContentRequest(resource: .genres, limit: limit, offset: offset)
        
        self.requestHandler(request, for: .genres) { (result: Result<ResponseRoot<Genre>?, AmberError>) in
            switch result {
            case .success(let response):
                if let data = response?.data {
                    completion(.success(data))
                } else if let firstError = response?.errors?.first {
                    completion(.failure(AmberError(appleMusicError: firstError)))
                } else {
                    completion(.failure(.noData))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: Curators
    public func getCatalogCurator(identifier: String, include relationships: [Relationships]? = nil, completion: @escaping(Result<Curator, AmberError>) -> Void) {
        let request = RequestGenerator(self).catalogContentRequest(resource: .curators, identifier: identifier, relationships: relationships)
        
        self.requestHandler(request, for: .curators) { (result: Result<ResponseRoot<Curator>?, AmberError>) in
            switch result {
            case .success(let response):
                if let data = response?.data?.first {
                    completion(.success(data))
                } else if let firstError = response?.errors?.first {
                    completion(.failure(AmberError(appleMusicError: firstError)))
                } else {
                    completion(.failure(.noData))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func getCatalogCuratorByRelationship(identifier: String, relationship: Relationships, limit: Int? = nil, completion: @escaping(Result<Curator, AmberError>) -> Void) {
        let request = RequestGenerator(self).catalogContentRequest(resource: .curators, identifier: identifier, relationship: relationship, limit: limit)
        
        self.requestHandler(request, for: .curators) { (result: Result<ResponseRoot<Curator>?, AmberError>) in
            switch result {
            case .success(let response):
                if let data = response?.data?.first {
                    completion(.success(data))
                } else if let firstError = response?.errors?.first {
                    completion(.failure(AmberError(appleMusicError: firstError)))
                } else {
                    completion(.failure(.noData))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func getMultipleCatalogCurators(identifiers: [String], include relationships: [Relationships]? = nil, completion: @escaping(Result<[Curator], AmberError>) -> Void) {
        let request = RequestGenerator(self).catalogContentRequest(resource: .curators, identifiers: identifiers, relationships: relationships)
        
        self.requestHandler(request, for: .curators) { (result: Result<ResponseRoot<Curator>?, AmberError>) in
            switch result {
            case .success(let response):
                if let data = response?.data {
                    completion(.success(data))
                } else if let firstError = response?.errors?.first {
                    completion(.failure(AmberError(appleMusicError: firstError)))
                } else {
                    completion(.failure(.noData))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func getCatalogAppleCurator(identifier: String, include relationships: [Relationships]? = nil, completion: @escaping(Result<AppleCurator, AmberError>) -> Void) {
        let request = RequestGenerator(self).catalogContentRequest(resource: .appleCurators, identifier: identifier)
        
        self.requestHandler(request, for: .appleCurators) { (result: Result<ResponseRoot<AppleCurator>?, AmberError>) in
            switch result {
            case .success(let response):
                if let data = response?.data?.first {
                    completion(.success(data))
                } else if let firstError = response?.errors?.first {
                    completion(.failure(AmberError(appleMusicError: firstError)))
                } else {
                    completion(.failure(.noData))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
     
    public func getCatalogAppleCuratorByRelationship(identifier: String, relationship: Relationships, limit: Int? = nil, completion: @escaping(Result<AppleCurator, AmberError>) -> Void) {
        let request = RequestGenerator(self).catalogContentRequest(resource: .appleCurators, identifier: identifier, relationship: relationship, limit: limit)
        
        self.requestHandler(request, for: .appleCurators) { (result: Result<ResponseRoot<AppleCurator>?, AmberError>) in
            switch result {
            case .success(let response):
                if let data = response?.data?.first {
                    completion(.success(data))
                } else if let firstError = response?.errors?.first {
                    completion(.failure(AmberError(appleMusicError: firstError)))
                } else {
                    completion(.failure(.noData))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func getMultipleCatalogAppleCurators(identifiers: [String], include resources: [Resources]? = nil, completion: @escaping(Result<[AppleCurator], AmberError>) -> Void) {
        let request = RequestGenerator(self).catalogContentRequest(resource: .appleCurators, types: resources, identifiers: identifiers)
        
        self.requestHandler(request, for: .appleCurators) { (result: Result<ResponseRoot<AppleCurator>?, AmberError>) in
            switch result {
            case .success(let response):
                if let data = response?.data {
                    completion(.success(data))
                } else if let firstError = response?.errors?.first {
                    completion(.failure(AmberError(appleMusicError: firstError)))
                } else {
                    completion(.failure(.noData))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: Recommendations
    public func getUserRecommendation(identifier: String, limit: Int? = nil, offset: Int? = nil, completion: @escaping(Result<Recommendation, AmberError>) -> Void) {
        let request = RequestGenerator(self).individualizedContentRequest(resource: .libraryRecommendations, identifier: identifier, limit: limit, offset: offset)
        
        self.requestHandler(request, for: .libraryRecommendations) { (result: Result<ResponseRoot<Recommendation>?, AmberError>) in
            switch result {
            case .success(let response):
                if let data = response?.data?.first {
                    completion(.success(data))
                } else if let firstError = response?.errors?.first {
                    completion(.failure(AmberError(appleMusicError: firstError)))
                } else {
                    completion(.failure(.noData))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func getMultipleUserRecommendations(identifiers: [String], limit: Int? = nil, offset: Int? = nil, completion: @escaping(Result<[Recommendation], AmberError>) -> Void) {
        let request = RequestGenerator(self).individualizedContentRequest(resource: .libraryRecommendations, identifiers: identifiers, limit: limit, offset: offset)
        
        self.requestHandler(request, for: .libraryRecommendations) { (result: Result<ResponseRoot<Recommendation>?, AmberError>) in
            switch result {
            case .success(let response):
                if let data = response?.data {
                    completion(.success(data))
                } else if let firstError = response?.errors?.first {
                    completion(.failure(AmberError(appleMusicError: firstError)))
                } else {
                    completion(.failure(.noData))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func getUserRecommendations(limit: Int? = nil, offset: Int? = nil, completion: @escaping(Result<[Recommendation], AmberError>) -> Void) {
        let request = RequestGenerator(self).individualizedContentRequest(resource: .libraryRecommendations, limit: limit, offset: offset)
        
        self.requestHandler(request, for: .libraryRecommendations) { (result: Result<ResponseRoot<Recommendation>?, AmberError>) in
            switch result {
            case .success(let response):
                if let data = response?.data {
                    completion(.success(data))
                } else if let firstError = response?.errors?.first {
                    completion(.failure(AmberError(appleMusicError: firstError)))
                } else {
                    completion(.failure(.noData))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: Activities
    public func getCatalogActivity(identifier: String, include relationships: [Relationships]? = nil, completion: @escaping(Result<Activity, AmberError>) -> Void) {
        let request = RequestGenerator(self).individualizedContentRequest(resource: .activities, identifier: identifier, relationships: relationships)
        
        self.requestHandler(request, for: .activities) { (result: Result<ResponseRoot<Activity>?, AmberError>) in
            switch result {
            case .success(let response):
                if let data = response?.data?.first {
                    completion(.success(data))
                } else if let firstError = response?.errors?.first {
                    completion(.failure(AmberError(appleMusicError: firstError)))
                } else {
                    completion(.failure(.noData))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func getCatalogActivityByRelationship(identifier: String, relationship: Relationships, limit: Int? = nil, completion: @escaping(Result<Activity, AmberError>) -> Void) {
        let request = RequestGenerator(self).individualizedContentRequest(resource: .activities, identifier: identifier, relationship: relationship, limit: limit)
        
        self.requestHandler(request, for: .activities) { (result: Result<ResponseRoot<Activity>?, AmberError>) in
            switch result {
            case .success(let response):
                if let data = response?.data?.first {
                    completion(.success(data))
                } else if let firstError = response?.errors?.first {
                    completion(.failure(AmberError(appleMusicError: firstError)))
                } else {
                    completion(.failure(.noData))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func getMultipleCatalogActivities(identifiers: [String], include resources: [Resources]? = nil, completion: @escaping(Result<[Activity], AmberError>) -> Void) {
        let request = RequestGenerator(self).individualizedContentRequest(resource: .activities, types: resources, identifiers: identifiers)
        
        self.requestHandler(request, for: .activities) { (result: Result<ResponseRoot<Activity>?, AmberError>) in
            switch result {
            case .success(let response):
                if let data = response?.data {
                    completion(.success(data))
                } else if let firstError = response?.errors?.first {
                    completion(.failure(AmberError(appleMusicError: firstError)))
                } else {
                    completion(.failure(.noData))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: History
    public func getHeavyRotationContent(limit: Int? = nil, offset: Int? = nil, completion: @escaping(Result<[HeavyRotation], AmberError>) -> Void) {
        let request = RequestGenerator(self).individualizedContentRequest(resource: .libraryHeavyRotation, limit: limit, offset: offset)
        
        self.requestHandler(request, for: .libraryHeavyRotation) { (result: Result<ResponseRoot<HeavyRotation>?, AmberError>) in
            switch result {
            case .success(let response):
                if let data = response?.data {
                    completion(.success(data))
                } else if let firstError = response?.errors?.first {
                    completion(.failure(AmberError(appleMusicError: firstError)))
                } else {
                    completion(.failure(.noData))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func getRecentlyPlayedResources(limit: Int? = nil, offset: Int? = nil, completion: @escaping(Result<[RecentlyPlayed], AmberError>) -> Void) {
        let request = RequestGenerator(self).individualizedContentRequest(resource: .libraryRecentlyPlayed, limit: limit, offset: offset)
        
        self.requestHandler(request, for: .libraryHeavyRotation) { (result: Result<ResponseRoot<RecentlyPlayed>?, AmberError>) in
            switch result {
            case .success(let response):
                if let data = response?.data {
                    completion(.success(data))
                } else if let firstError = response?.errors?.first {
                    completion(.failure(AmberError(appleMusicError: firstError)))
                } else {
                    completion(.failure(.noData))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func getRecentlyPlayedStations(limit: Int? = nil, offset: Int? = nil, completion: @escaping(Result<[RecentlyPlayed], AmberError>) -> Void) {
        let request = RequestGenerator(self).individualizedContentRequest(resource: .libraryRecentlyPlayedStations, limit: limit, offset: offset)
        
        self.requestHandler(request, for: .libraryHeavyRotation) { (result: Result<ResponseRoot<RecentlyPlayed>?, AmberError>) in
            switch result {
            case .success(let response):
                if let data = response?.data {
                    completion(.success(data))
                } else if let firstError = response?.errors?.first {
                    completion(.failure(AmberError(appleMusicError: firstError)))
                } else {
                    completion(.failure(.noData))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func getRecentlyAddedResources(limit: Int? = nil, offset: Int? = nil, completion: @escaping(Result<[RecentlyAdded], AmberError>) -> Void) {
        let request = RequestGenerator(self).individualizedContentRequest(resource: .libraryRecentlyAdded, limit: limit, offset: offset)
        
        self.requestHandler(request, for: .libraryHeavyRotation) { (result: Result<ResponseRoot<RecentlyAdded>?, AmberError>) in
            switch result {
            case .success(let response):
                if let data = response?.data {
                    completion(.success(data))
                } else if let firstError = response?.errors?.first {
                    completion(.failure(AmberError(appleMusicError: firstError)))
                } else {
                    completion(.failure(.noData))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}
