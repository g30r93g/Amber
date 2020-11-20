//
//  Chart.swift
//  
//
//  Created by George Nick Gorzynski on 30/05/2020.
//

import Foundation

public struct Chart: Codable {
    public let albums: ResponseRoot<LibraryAlbum>?
    public let artists: ResponseRoot<LibraryArtist>?
    public let musicVideos: ResponseRoot<LibraryMusicVideo>?
    public let playlists: ResponseRoot<LibraryPlaylist>?
    public let songs: ResponseRoot<LibrarySong>?
}
