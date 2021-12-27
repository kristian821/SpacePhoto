//
//  PhotoInfoController.swift
//  SpacePhoto
//
//  Created by Kristian Mitchell on 12/17/21.
//

import Foundation
import UIKit
@MainActor
struct PhotoInfoController {
    func fetchPhotoInfo(completion: @escaping (Result<PhotoInfo, Error>) -> Void) {
        var urlComponents = URLComponents(string: "https://api.nasa.gov/planetary/apod")!
        urlComponents.queryItems = [
            "api_key": "DEMO_KEY"
        ].map { URLQueryItem(name: $0.key, value: $0.value) }

        let task = URLSession.shared.dataTask(with: urlComponents.url!) {
            (data, response, error) in
            let jsonDecoder = JSONDecoder()
            if let data = data {
               do {
                   let photoInfo = try jsonDecoder.decode(PhotoInfo.self, from: data)
                        completion(.success(photoInfo))
                    } catch {
                        completion(.failure(error))
                    }
                    } else if let error = error {
                        completion(.failure(error))
                    }
            }
    
        task.resume()
    }
    
    enum PhotoInfoError: Error, LocalizedError {
        case imageDataMissing
//        Adding an "invalidServerResponse" error type
        case invalidServerResponse
    }
    
    func fetchImage(from url: URL, completion: @escaping (Result<UIImage, Error>) -> Void) {
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        urlComponents?.scheme = "https"
        let task = URLSession.shared.dataTask(with: urlComponents!.url!) { data, response, error in
            if let data = data, let image = UIImage(data: data) {
                completion(.success(image))
            } else if let error = error {
                completion(.failure(error))
            } else {
                completion(.failure(PhotoInfoError.imageDataMissing))
            }
        }
        task.resume()
    }
    
//    new fetchPhoto() will use async and await to return the image from the api instead of using a completion handler
    func asyncFetchPhotoInfo() async throws -> PhotoInfo {
        var urlComponents = URLComponents(string: "https://api.nasa.gov/planetary/apod")!
        urlComponents.queryItems = [
            "api_key": "DEMO_KEY"
        ].map { URLQueryItem(name: $0.key, value: $0.value) }
        do {
            let (data, _) = try await URLSession.shared.data(from: urlComponents.url!)
                let photoInfo = try JSONDecoder().decode(PhotoInfo.self, from: data)
            print(photoInfo)
            return photoInfo
        } catch {
            throw PhotoInfoError.imageDataMissing
        }
    }
    
}

