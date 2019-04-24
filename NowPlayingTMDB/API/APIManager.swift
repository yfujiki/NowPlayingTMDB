//
//  APIManager.swift
//  NowPlayingTMDB
//
//  Created by Yuichi Fujiki on 4/24/19.
//  Copyright © 2019 Yfujiki. All rights reserved.
//

import Foundation

let API_KEY = "caf895c3e8d7b13a7a9b70ca2a9cfd6e" // ToDo : Read from external file

enum NetworkError: Error {
    case badURL
    case badParams
    case badData
}

enum TMDB_API_URL {
    case nowPlaying
    case similar(referenceMovieId: Int)

    var path: String {
        switch self {
        case .nowPlaying:
            return "https://api.themoviedb.org/3/movie/now_playing"
        case .similar(let referenceMovieId):
            return "https://api.themoviedb.org/3/movie/\(referenceMovieId)/similar"
        }
    }
}

protocol APIManagerProtocol {
    func nowPlaying(page: Int, completionBlock: @escaping (Result<MoviesPage, Error>) -> Void)
    func similar(referenceMovieId: Int, page: Int, completionBlock: @escaping (Result<MoviesPage, Error>) -> Void)
}

class APIManager: APIManagerProtocol {

    private func GET(path: String, params: [String: CustomStringConvertible], completionBlock: @escaping (Result<Data, Error>) -> Void) {
        guard let components = NSURLComponents(string: path) else {
            let error = NetworkError.badURL as Error
            let result = Result<Data, Error>.failure(error)
            DispatchQueue.main.async {
                completionBlock(result)
            }
            return
        }

        let queryItems = params.map { (arg) -> URLQueryItem in
            let (key, value) = arg
            return URLQueryItem(name: key, value: value.description)
        }
        components.queryItems = queryItems

        guard let url = components.url else {
            let error = NetworkError.badParams as Error
            let result = Result<Data, Error>.failure(error)
            DispatchQueue.main.async {
                completionBlock(result)
            }
            return
        }

        let request = URLRequest(url: url)
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                let result = Result<Data, Error>.failure(error)
                DispatchQueue.main.async {
                    completionBlock(result)
                }
                return
            }

            guard let data = data else {
                let error = NetworkError.badData as Error
                let result = Result<Data, Error>.failure(error)
                DispatchQueue.main.async {
                    completionBlock(result)
                }
                return
            }

            let result = Result<Data, Error>.success(data)// No error means there should be data
            DispatchQueue.main.async {
                completionBlock(result)
            }
        }

        task.resume()
    }

    func nowPlaying(page: Int, completionBlock: @escaping (Result<MoviesPage, Error>) -> Void) {
        let params = [
            "api_key": API_KEY,
            "page": page
        ] as [String: CustomStringConvertible]

        GET(path: TMDB_API_URL.nowPlaying.path, params: params) { result in
            switch(result) {
            case .success(let data):
                do {
                    let moviesPage = try MoviesPage(from: data)
                    let result = Result<MoviesPage, Error>.success(moviesPage)
                    completionBlock(result)
                } catch(let error) {
                    let result = Result<MoviesPage, Error>.failure(error)
                    completionBlock(result)
                }
            case .failure(let error):
                let e = error as Error
                let r = Result<MoviesPage, Error>.failure(e)
                completionBlock(r)
            }
        }
    }

    func similar(referenceMovieId: Int, page: Int, completionBlock: @escaping (Result<MoviesPage, Error>) -> Void) {
        let params = [
            "api_key": API_KEY,
            "page": page
            ] as [String: CustomStringConvertible]

        GET(path: TMDB_API_URL.similar(referenceMovieId: referenceMovieId).path, params: params) { result in
            switch(result) {
            case .success(let data):
                do {
                    let moviesPage = try MoviesPage(from: data)
                    let result = Result<MoviesPage, Error>.success(moviesPage)
                    completionBlock(result)
                } catch(let error) {
                    let result = Result<MoviesPage, Error>.failure(error)
                    completionBlock(result)
                }
            case .failure(let error):
                let e = error as Error
                let r = Result<MoviesPage, Error>.failure(e)
                completionBlock(r)
            }
        }
    }
}
