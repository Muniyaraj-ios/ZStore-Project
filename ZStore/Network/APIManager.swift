//
//  APIManager.swift
//  ZStore
//
//  Created by Apple on 30/05/24.
//

import Foundation

final class APIManger{
    private let baseURL = "https://raw.githubusercontent.com/princesolomon/zstore/main/data.json"
    
    typealias CompletionHandler<T> = (Results<T,Error>) -> Void
    
    let session = URLSession.shared
    
    func getURLRequest(method: HTTPMethod = .get) -> URLRequest?{
        guard let url = URL(string: baseURL) else{return nil}
        print("base URL : \(url.absoluteString)")
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        return request
    }
    func getAllData<T: Codable>(_ req: URLRequest,closure: @escaping CompletionHandler<T>){
        session.dataTask(with: req) { data, response, error in
            if let error{
                closure(.failure(error))
                return
            }
            if let response = response as? HTTPURLResponse{
                print("Status Code : ",response.statusCode)
            }
            if let data{
                do{
                    let codable = try JSONDecoder().decode(T.self, from: data)
                    closure(.success(codable))
                }catch let error{
                    closure(.failure(error))
                }
                
                
            }
        }.resume()
    }
}
internal enum Results<T,F>{
    case success(T)
    case failure(F)
}

public struct HTTPMethod{
    public static let get = HTTPMethod(rawValue: "GET")
    public let rawValue: String
    init(rawValue: String) {
        self.rawValue = rawValue
    }
}
