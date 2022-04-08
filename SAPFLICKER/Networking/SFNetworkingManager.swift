//
//  SFNetworkingManager.swift
//  SAPFLICKER
//
//  Created by Abhijithkrishnan on 22/01/22.
//

import Foundation
protocol SFNetworkingProtocol {
    func call(endPoint:SFAPICall, completion:@escaping(_ data:Data?, _ response:URLResponse?, _ error:Error?)->())
}
class SFNetworking:SFNetworkingProtocol{
    func call(endPoint:SFAPICall, completion:@escaping(_ data:Data?, _ response:URLResponse?, _ error:Error?)->()){
        if Reachability.isConnectedToNetwork() {
            do{
                guard let url = try endPoint.buildUrlString() else {
                    return
                }
                print(url)
                let request = try endPoint.urlRequest(baseURL: url)
                let session = endPoint.configuration()
                let task = session.dataTask(with: request) { (data, response, error) in
                    completion(data,response,error)
                }
                task.resume()
            }catch{
                completion(nil,nil,error)
            }
        }else {
            completion(nil,nil,SFError.apiFailure.connectivityError)
        }
    }
}
