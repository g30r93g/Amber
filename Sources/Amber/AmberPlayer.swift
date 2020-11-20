//
//  AmberPlayer.swift
//  
//
//  Created by George Nick Gorzynski on 07/06/2020.
//

import Foundation
import StoreKit
import MediaPlayer

public class AmberPlayer {
    
    // MARK: Initializer
    public init() {
        self.controller = .applicationQueuePlayer
        self.controller.shuffleMode = .off
        self.controller.repeatMode = .none
        self.controller.currentPlaybackRate = 1
        
        self.observeNotifications()
        self.controller.beginGeneratingPlaybackNotifications()
    }
    
    // MARK: Media Player Properties
    public var playbackUpdateDelegate: AmberPlayerUpdateDelegate? = nil
    private(set) public var controller: MPMusicPlayerController!
    
    private(set) public var trackList: [String] = [] {
        didSet {
            self.updateControllerQueue()
        }
    }
    
    public var currentlyPlaying: String? {
        get {
            guard !self.trackList.isEmpty else { return nil }
            
            let nowPlayingIndex = self.controller.indexOfNowPlayingItem
            guard nowPlayingIndex >= 0 && nowPlayingIndex < self.trackList.endIndex else { return nil }
            
            return self.trackList[nowPlayingIndex]
        }
    }
    
    public var playedTracks: [String]? {
        get {
            guard !self.trackList.isEmpty else { return nil }
            
            let nowPlayingIndex = self.controller.indexOfNowPlayingItem
            
            if nowPlayingIndex == 0 {
                return []
            } else {
                return Array(self.trackList[0..<nowPlayingIndex])
            }
        }
    }
    
    public var upcomingTracks: [String]? {
        get {
            guard !self.trackList.isEmpty else { return nil }
            
            let nowPlayingIndex = self.controller.indexOfNowPlayingItem
            let lowerBound = nowPlayingIndex + 1
            let upperBound = self.trackList.count
            
            guard lowerBound < upperBound else { return nil }
            
            return Array(self.trackList[lowerBound..<upperBound])
        }
    }
    
    
    // MARK: Enums
    public enum PlaybackCommand: Equatable {
        case play, pause, stop
        case previous, restart, next
        case seek(time: Int)
    }
    
    // MARK: Notification Observation
    func observeNotifications() {
        NotificationCenter.default.addObserver(forName: NSNotification.Name.MPMusicPlayerControllerNowPlayingItemDidChange,
                                               object: nil,
                                               queue: nil) { (_) in self.playbackUpdateDelegate?.nowPlayingItemChanged() }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.MPMusicPlayerControllerPlaybackStateDidChange,
                                               object: nil,
                                               queue: nil) { (_) in self.playbackUpdateDelegate?.playbackStateChanged() }
    }
    
    // MARK: Queue Modifier Methods
    private func updateControllerQueue() {
        guard let upcomingTracks = self.upcomingTracks,
              let currentlyPlaying = self.currentlyPlaying
        else { return }
        let trackIdentifiers = [currentlyPlaying] + upcomingTracks
        
        let queue = MPMusicPlayerStoreQueueDescriptor(storeIDs: trackIdentifiers)
        self.controller.setQueue(with: queue)
    }
    
    public func updateQueue(_ tracks: [String]) {
        self.trackList = tracks
    }
    
    public func appendToQueue(track: String) {
        self.trackList.append(track)
    }
    
    public func prependToQueue(track: String) {
        self.trackList.prepend(track)
    }
    
    // MARK: Playback Control Methods
    public func play(completion: @escaping(Error?) -> Void) {
        self.controller.prepareToPlay { (error) in
            if let error = error {
                completion(error)
            } else {
                self.controller.play()
            }
        }
    }
    
    public func pause() {
        self.controller.pause()
    }
    
    public func stop() {
        self.controller.stop()
        self.updateQueue([])
    }
    
    public func restart() {
        self.controller.skipToBeginning()
    }
    
    public func previous() {
        self.controller.skipToPreviousItem()
    }
    
    public func next() {
        self.controller.skipToNextItem()
    }
    
    public func skip(by amount: Int) {
        self.controller.currentPlaybackTime += TimeInterval(amount)
    }
    
    public func seek(to time: Int) {
        self.controller.currentPlaybackTime = TimeInterval(time)
    }
    
}

public protocol AmberPlayerUpdateDelegate {
    
    func nowPlayingItemChanged()
    func playbackStateChanged()
    
}
