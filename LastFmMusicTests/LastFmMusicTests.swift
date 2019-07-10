//
//  LastFmMusicTests.swift
//  LastFmMusicTests
//
//  Created by Ivan Logvinov on 7/10/19.
//  Copyright © 2019 Ivan Logvinov. All rights reserved.
//

import XCTest

@testable import LastFmMusic
//@testable import SwiftyJSON

class LastFmMusicTests: XCTestCase {
    
    var dataManager: DataManager!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        dataManager = DataManager()
    }
    
    override func tearDown() {
        dataManager = nil
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testViewCellExtension() {
        XCTAssertEqual(AlbumViewCell.identifier(), "AlbumViewCell")
        XCTAssertNotEqual(AlbumViewCell.identifier(), "AlbumViewViewCell")
    }
    
    func testAlbumURLString() {
        let albumsListUrl =  dataManager.getURLForDataType(type: .albums, object: nil)
        XCTAssertEqual("?method=tag.gettopalbums&tag=hip+hop", albumsListUrl)
    }
    
    func testAlbumDetailURLString() {
        let albumDetailsUrl = dataManager.getURLForDataType(
            type: .albumDetails,
            object: AlbumsListModel.init(name: "Free Wired", artist: ArtistModel.init(
                name: "Far East Movement",
                listeners: 0), imageURL: "https://lastfm-img2.akamaized.net/i/u/174s/8857fe8b4e3149bec9bb7e8f21598819.png") as AnyObject)
        XCTAssertEqual("?method=album.getinfo&artist=Far+East+Movement&album=Free+Wired", albumDetailsUrl)
    }
    
    func testArtistURLString() {
        let artistUrl = dataManager.getURLForDataType(
            type: .artist,
            object: ArtistModel.init(name: "The Roots", listeners: 0) as AnyObject)
        XCTAssertEqual("?method=artist.getinfo&artist=The+Roots", artistUrl)
    }
    
    func testParsingAlbumData() {

        let bundle = Bundle(for: type(of: self))
        guard let url = bundle.url(forResource: "AlbumInfo", withExtension: "json") else {
            XCTFail("JSON file not found")
            return
        }
        guard let data = try? Data(contentsOf: url),
            let jsonDictionary = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                XCTFail("JSON format error")
                return
        }

        guard let albumArray = parseAlbumData(json: JSON(jsonDictionary)) else {
            XCTFail("Couln't get Album data")
            return
        }

        let album = albumArray.first

        XCTAssertEqual(album?.imageURL, "https://lastfm-img2.akamaized.net/i/u/174s/8857fe8b4e3149bec9bb7e8f21598819.png")
        XCTAssertEqual(album?.name, "Free Wired")
        XCTAssertEqual(album?.artist.name, "Far East Movement")
    }
    
    func testArtistModel() {
        let artist = ArtistModel.init(name: "John Doe", listeners: 1000)
        XCTAssertEqual(artist.name, "John Doe")
        XCTAssertEqual(artist.listeners, 1000)
    }
    
    func testAlbumModel() {
        let album = AlbumsListModel.init(name: "Believe", artist: ArtistModel.init(name: "Cher", listeners: 1200),
                                          imageURL:"https://lastfm-img2.akamaized.net/i/u/174s/8857fe8b4e3149bec9bb7e8f21598819.png")

        XCTAssertEqual(album.name, "Believe")
        XCTAssertEqual(album.artist.name, "Cher")
        XCTAssertEqual(album.artist.listeners, 1200)
        XCTAssertEqual(album.imageURL, "https://lastfm-img2.akamaized.net/i/u/174s/8857fe8b4e3149bec9bb7e8f21598819.png")
    }
    
    func testAlbumDetailModel() {
        let albumDetailModel = AlbumDetailModel.init(name: "Believe", trackCount: 10, publishDate: "27 Jul 2008, 15:55", url: "https://lastfm-img2.akamaized.net/i/u/174s/8857fe8b4e3149bec9bb7e8f21598819.png")
        
        XCTAssertEqual(albumDetailModel.name, "Believe")
        XCTAssertEqual(albumDetailModel.trackCount, 10)
        XCTAssertEqual(albumDetailModel.publishDate, "27 Jul 2008, 15:55")
        XCTAssertEqual(albumDetailModel.url, "https://lastfm-img2.akamaized.net/i/u/174s/8857fe8b4e3149bec9bb7e8f21598819.png")
    }
    
    
}
