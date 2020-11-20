//
//  SearchResponse.swift
//  
//
//  Created by George Nick Gorzynski on 30/05/2020.
//

import Foundation

public struct SearchResults: Codable {
    public let albums: ResponseRoot<Album>?
    public let artists: ResponseRoot<Artist>?
    public let musicVideos: ResponseRoot<MusicVideo>?
    public let playlists: ResponseRoot<Playlist>?
    public let songs: ResponseRoot<Song>?
    
    internal enum CodingKeys: String, CodingKey {
        case albums, artists, playlists, songs
        case musicVideos = "music-videos"
    }
}
