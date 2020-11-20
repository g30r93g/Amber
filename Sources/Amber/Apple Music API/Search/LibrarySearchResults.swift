//
//  LibrarySearchResults.swift
//  
//
//  Created by George Nick Gorzynski on 30/05/2020.
//

import Foundation

public struct LibrarySearchResults: Codable {
    public let albums: ResponseRoot<LibraryAlbum>?
    public let artists: ResponseRoot<LibraryArtist>?
    public let musicVideos: ResponseRoot<LibraryMusicVideo>?
    public let playlists: ResponseRoot<LibraryPlaylist>?
    public let songs: ResponseRoot<LibrarySong>?
    
    internal enum CodingKeys: String, CodingKey {
        case albums = "library-albums"
        case artists = "library-artists"
        case musicVideos = "library-music-videos"
        case playlists = "library-playlists"
        case songs = "library-songs"
    }
}
