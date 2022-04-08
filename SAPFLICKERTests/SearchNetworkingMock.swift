//
//  SearchNetworkingMock.swift
//  SAPFLICKERTests
//
//  Created by Abhijithkrishnan on 23/01/22.
//


import XCTest
@testable import SAPFLICKER
class SearchNetworkingMock: SFNetworkingProtocol {
    func call(endPoint: SFAPICall, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        calledMethods.append(.call)
        do{
            guard let url = try endPoint.buildUrlString() else {
                return
            }
            print(url)
            let request = try endPoint.urlRequest(baseURL: url)
            let _ = endPoint.configuration()
            let mockData = SFUtilities().getDataFromBundle(WithName: "Mock", ext: "json")
            let mockResponse = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)
            completion(mockData,mockResponse,nil)
        }catch{
            completion(nil,nil,error)
        }
    }
    //MARK:- Test Helpers
    enum CalledMethods:Equatable {
        case call
        static func == (lhs:SearchNetworkingMock.CalledMethods, rhs:SearchNetworkingMock.CalledMethods) -> Bool {
            switch (lhs,rhs) {
            case (.call, .call):
            return true
            }
        }
    }
    var calledMethods = [CalledMethods]()
}
extension SearchNetworkingMock {
    func calledMethod(_ method: CalledMethods) -> Bool {
        return calledMethods.first(where: {$0 == method}) != nil
    }
    func numberOfTimesCalled(_ method: CalledMethods) -> Int {
        return calledMethods.filter({$0 == method }).count
    }
}
