//
//  API.swift
//  L-Tech
//
//  Created by emil kurbanov on 16.05.2025.
//

import Alamofire
import UIKit

enum API {
    static let baseURL = "http://dev-exam.l-tech.ru/api/v1"
    
    static func fetchPhoneMask(completion: @escaping (Result<String, Error>) -> Void) {
        let url = baseURL + "/phone_masks"
        AF.request(url).validate().responseDecodable(of: PhoneMaskResponse.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data.phoneMask))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    static func signIn(phone: String, password: String, completion: @escaping (Result<AuthResponse, Error>) -> Void) {
        let url = baseURL + "/auth"
        let params = ["phone": phone, "password": password]
        
        AF.request(url,
                   method: .post,
                   parameters: params,
                   encoder: URLEncodedFormParameterEncoder.default)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: AuthResponse.self) { response in
                switch response.result {
                case .success(let authResponse):
                    if authResponse.success {
                        completion(.success(authResponse))
                    } else {
                        let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Неверный логин или пароль"])
                        completion(.failure(error))
                    }
                case .failure(let error):
                    if let statusCode = response.response?.statusCode {
                        let message: String
                        switch statusCode {
                        case 400:
                            message = "Некорректный запрос (400)"
                        case 401:
                            message = "Неавторизован (401): неверный логин или пароль"
                        case 403:
                            message = "Доступ запрещён (403)"
                        default:
                            message = "Ошибка сервера: \(statusCode)"
                        }
                        let serverError = NSError(domain: "", code: statusCode, userInfo: [NSLocalizedDescriptionKey: message])
                        completion(.failure(serverError))
                    } else {
                        completion(.failure(error))
                    }
                }
            }
    }
    
    static func fetchPosts(completion: @escaping (Result<[Post], Error>) -> Void) {
        let url = baseURL + "/posts"
        AF.request(url)
            .validate()
            .responseDecodable(of: [Post].self) { response in
                switch response.result {
                case .success(let posts):
                    completion(.success(posts))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}

struct PhoneMaskResponse: Codable {
    let phoneMask: String
}

struct AuthResponse: Codable {
    let success: Bool
}
