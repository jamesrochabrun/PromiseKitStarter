//
//  GiphyParameter.swift
//  PromieKitStockCode
//
//  Created by James Rochabrun on 7/24/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation

enum GiphyParameter {
    case randomGifFrom(query: String)
}

extension GiphyParameter {
    
    private struct Key {
        static let apiKey = "api_key"
        static let queryKey = "q"
        static let limitKey = "limit"
    }
    
    var parameter: [String: Any] {
        var paramDict: [String: Any] = [:]
        switch self {
        case .randomGifFrom(let query):
            paramDict[Key.apiKey] = GiphyManager.sharedInstance.apiKey
            paramDict[Key.queryKey] = query
            paramDict[Key.limitKey] = "(self.imageLimit)"
        }
        return paramDict
    }
}

