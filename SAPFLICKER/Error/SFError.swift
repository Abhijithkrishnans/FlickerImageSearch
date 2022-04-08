//
//  SFError.swift
//  SAPFLICKER
//
//  Created by Abhijithkrishnan on 22/01/22.
//

import Foundation
enum SFError:Error {
    enum authenticationFailure:Int,Error {
        case serverAuthenticationError = 1001
    }
    enum apiFailure:Int,Error {
        case noData = 2001
        case badRequest = 2002
        case outDated = 2003
        case netWorkError = 2004
        case noResponse = 2005
        case connectivityError = 2006
        
    }
    enum requestBuildFailure:Int,Error {
        case missingURL = 3001
        case urlCreationFailed = 3002
        case undefinedInput = 3003
    }
    enum jsonEncodingFailure:Int,Error {
        case encodingFailed = 4001
        case decodeFailed = 4002
    }
    enum selectionFailure:Int,Error {
        case forbidden = 5001
    }
}
extension SFError.authenticationFailure:LocalizedError {
    var errorDescription: String? {
        switch self {
        case .serverAuthenticationError:
            return SFConstants.errorMessage.endPointFailed
        }
    }
    var debugDescription: String {
        return "\(String(describing: type(of: self))).\(String(describing: self)) (\(SFConstants.fieldNames.code) \((self as NSError).code))"
    }
    
}
extension SFError.apiFailure:LocalizedError {
     var errorDescription: String? {
        switch self {
        case .noData:
            return SFConstants.errorMessage.noData
        case .badRequest:
            return SFConstants.errorMessage.badRequest
        case .outDated:
            return SFConstants.errorMessage.outdated
        case .netWorkError:
            return SFConstants.errorMessage.networkRequestFailed
        case .noResponse:
            return SFConstants.errorMessage.parseError
        case .connectivityError:
            return SFConstants.errorMessage.connectivityError
        }
    }
    var debugDescription: String {
        return "\(String(describing: type(of: self))).\(String(describing: self)) (\(SFConstants.fieldNames.code) \((self as NSError).code))"
    }
}
extension SFError.requestBuildFailure:LocalizedError {
    var errorDescription: String? {
        switch self {
        case .missingURL:
            return SFConstants.errorMessage.nilParam
        case .urlCreationFailed:
            return SFConstants.errorMessage.urlRequestFailed
        case .undefinedInput:
            return SFConstants.errorMessage.undefinedInput
        }
    }
    var debugDescription: String {
        return "\(String(describing: type(of: self))).\(String(describing: self)) (\(SFConstants.fieldNames.code) \((self as NSError).code))"
    }
}
extension SFError.jsonEncodingFailure:LocalizedError {
    var errorDescription: String? {
        switch self {
        case .encodingFailed:
            return SFConstants.errorMessage.jsonEncodingFailed
        case .decodeFailed:
            return SFConstants.errorMessage.jsonDecodingFailed
        }
    }
    var debugDescription: String {
        return "\(String(describing: type(of: self))).\(String(describing: self)) (\(SFConstants.fieldNames.code) \((self as NSError).code))"
    }
}
extension SFError.selectionFailure:LocalizedError {
    var errorDescription: String? {
        switch self {
        case .forbidden:
            return SFConstants.errorMessage.forbidden
        }
    }
    var debugDescription: String {
        return "\(String(describing: type(of: self))).\(String(describing: self)) (\(SFConstants.fieldNames.code) \((self as NSError).code))"
    }
}
// MARK: Image Result
enum SFImageResult{
    case Success([SFImageEssentialDataModelProtocol])
    case Failure(Error)
}
// MARK: URL Result
extension SFImageResult {
    enum URLResult {
        case Success(URL)
        case Failure(Error)
    }
    enum HistoryResult {
        case Success([SearchHistoryResultProtocol])
        case Failure(Error)
    }
}

