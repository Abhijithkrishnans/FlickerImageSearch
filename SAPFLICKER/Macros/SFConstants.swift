//
//  SFConstants.swift
//  SAPFLICKER
//
//  Created by Abhijithkrishnan on 22/01/22.
//

import Foundation
import UIKit

enum SFConstants {
    enum networking {
        static let baseURL = "api.flickr.com"
        static let singleImagebaseURL = "static.flickr.com"
        static let GET = "GET"
        static let POST = "POST"
        static let json = "json"
        static let XML = "XML"
        static let apiKey = "d5fdb39d99649658162def02d09be32c"
    }
    
    enum microServices {
        static let imageService = "services"
        static let imageServiceRest = "rest"
        static let method = "flickr.photos.search"
        
    }
    enum commonSize {
        static let cellHeight = UIScreen.main.bounds.width/3-1
        static let cellWidth = UIScreen.main.bounds.width/3-1
    }
    enum fieldNames {
        static let JSON = ".json"
        static let JPG = ".jpg"
        static let DurationSuff = "Min"
        static let NA = "NA"
        static let code = "code"
        static let Ok = "Ok"
        static let empty = ""
        static let space = " "
        static let format = "format"
        static let method = "method"
        static let apiKey = "api_key"
        static let nojsoncallback = "nojsoncallback"
        static let safe_search = "safe_search"
        static let text = "text"
        static let farm = "farm"
        static let server = "server"
        static let id = "id"
        static let secret = "secret"
    }
    enum screenTitle {
        static let HomeTitle = "Find Images"
        static let searchBarPlaceHolder = "Search here for your favourite image"
        static let resetButtonTitle = "Reset Search"
    }
    enum errorMessage {
        static let endPointFailed = "End point authentication failed."
        static let noData = "Response returned with no data to decode."
        static let badRequest = "Bad request."
        static let outdated = "The url you requested is outdated."
        static let networkRequestFailed = "Network request failed."
        static let parseError = "Unable to parse response."
        static let nilParam = "Parameters were nil."
        static let urlRequestFailed = "Unable to create request URL"
        static let jsonEncodingFailed = "Json encoding failed."
        static let jsonDecodingFailed = "We could not decode the response."
        static let forbidden = "Dear user, recipe selection limited upto 5. Please deselect any previous recipes and try again!"
        static let connectivityError = "No Internet Connection. Please connect to internet and press Ok to try again."
        static let undefinedInput = "Input model can't be null"
    }
}
