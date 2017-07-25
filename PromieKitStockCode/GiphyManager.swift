//
//  GiphyManager.swift
//  PromieKitStockCode
//
//  Created by James Rochabrun on 7/24/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import PromiseKit

struct GiphyManager {
    
    let giphyBaseURL = "https://api.giphy.com/v1/gifs/search"
    let imageLimit: UInt32 = 1
    var apiKey = "dc6zaTOxFJmzC"

    static let sharedInstance = GiphyManager()
    private init() {}
    
    var randomNum: Int {
        return Int(arc4random_uniform(self.imageLimit))
    }
    
    private struct Key {
        static let dataKey = "data"
        static let imagesKey = "images"
        static let downSizedKey = "downsized"
        static let urlKey = "url"
    }

    func fetchRandomGifUrl(forSearchQuery query: String) -> Promise<String> {
//        let params = ["api_key": self.apiKey, "q": query, "limit": "(self.imageLimit)"]

        let params = GiphyParameter.randomGifFrom(query: query).parameter
        // Return a Promise for the caller of this function to use.
        return Promise { fulfill, reject in
            
            // Inside the Promise, make an HTTP request to the Giphy API.
            Alamofire.request(self.giphyBaseURL, parameters: params)
                .responseJSON { response in
                    if let result = response.result.value {
                        let json = JSON(result)
                        
                        print(self.randomNum)
                        if let imageUrlString = json[Key.dataKey][self.randomNum][Key.imagesKey][Key.downSizedKey][Key.urlKey].string {
                            
                            fulfill(imageUrlString)
                        } else {
                            guard let error = response.error else {
                                reject(GiphyError.errorNil)
                                return
                            }
                            reject(error)
                        }
                    }
            }
        }
    }

    func fetchImage(forImageUrl imageUrlString: String) -> Promise<Data> {
        
        // Return a Promise for the caller of this function to use.
        return Promise { fulfill, reject in
            
            // Make an HTTP request to download the image.
            Alamofire.request(imageUrlString).responseData { response in
                
                if let imageData = response.result.value {
                    print("image downloaded")
                    
                    // Pass the image data to the next function.
                    fulfill(imageData)
                } else {
                    //Reject the promise if something went wrong
                    guard let error = response.error else {
                        reject(GiphyError.errorNil)
                        return
                    }
                    reject(error)
                }
            }
        }
    }
}

enum GiphyError: Error {
    case errorNil
}











