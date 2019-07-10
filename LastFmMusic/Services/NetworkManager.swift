//
//  NetworkManager.swift
//  LastFmMusic
//
//  Created by Ivan Logvinov on 7/8/19.
//  Copyright © 2019 Ivan Logvinov. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class NetworkManager {
    
    // MARK: - Properties
    
    private var baseURL = ""
    private var apiKey = ""
    private var staticUrlString = ""
    
    // MARK: - Lifecycle
    
    init() {
        if let url = Bundle.main.url(forResource: "config", withExtension: "plist"),
            let configDict = NSDictionary(contentsOf: url) as? [String: Any] {
            guard let baseURL = configDict["baseURL"] as? String, let apiKey = configDict["apiKey"] as? String
                else { assert(false, "There is a problem with Base URL string") }
            self.baseURL = baseURL
            self.apiKey = apiKey
            self.staticUrlString = "&api_key=" + apiKey + "&format=json"
        }
    }
    
    
    // MARK: - Get Data
    
    func getAlbumData(completionHandler: @escaping ([AlbumsListModel]?, String?) -> Void, url: String) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let url = baseURL + url + staticUrlString
        
        AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil)
            .responseJSON { response in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                switch response.result {
                case .success:
                    do {
                        completionHandler(try parseAlbumData(json: JSON(response.result.get())), nil)
                    } catch {
                        completionHandler(nil, "Couldn't get JSON from response data")
                    }
                case .failure(let error):
                    completionHandler(nil, error.localizedDescription)
                }
        }
    }
    
    func getAlbumDetailData(completionHandler: @escaping (AlbumDetailModel?, String?) -> Void, url: String) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let url = baseURL + url + staticUrlString
        
        AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil)
            .responseJSON { response in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                switch response.result {
                case .success:
                    do {
                        completionHandler(try parseDetailsData(json: JSON(response.result.get())), nil)
                    } catch {
                        completionHandler(nil, "Couldn't get JSON from response data")
                    }
                case .failure(let error):
                    completionHandler(nil, error.localizedDescription)
                }
        }
    }
    
    
    func getArtistData(completionHandler: @escaping (ArtistModel?, String?) -> Void, url: String) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let url = baseURL + url + staticUrlString
        
        AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil)
            .responseJSON { response in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                switch response.result {
                case .success:
                    do {
                        completionHandler(try parseArtistData(json: JSON(response.result.get())), nil)
                    } catch {
                        completionHandler(nil, "Couldn't get JSON from response data")
                    }
                case .failure(let error):
                    completionHandler(nil, error.localizedDescription)
                }
        }
    }
    
   
    
    // MARK: - Album Image
    
    func getImage(by url: String, completionHandler: @escaping (UIImage?, String?) -> Void) {
        AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil)
            .responseJSON { response in
                if let imageData = response.data {
                    let image = UIImage.init(data: imageData)
                    completionHandler(image, nil)
                } else {
                    completionHandler(nil, "Couldn't get image")
                }
        }
    }
}
