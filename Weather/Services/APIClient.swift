//
//  NetworkService.swift
//  Weather
//
//  Created by Hassan Javed on 16/02/2022.
//  Copyright © 2020 Hassan Javed. All rights reserved.
//

import Foundation

class APIClient {
    static let shared = APIClient()
    
    let URL_BASE = "https://api.openweathermap.org/data/2.5"
    let URL_API_KEY = "779f11e8f6b50313f1ff0c063fdfb347"
    var URL_LATITUDE = ""
    var URL_LONGITUDE = ""
    var URL_GET_ONE_CALL = ""
    
    let session = URLSession(configuration: .default)
    
    func buildURL() -> String {
        URL_GET_ONE_CALL = "/onecall?lat=" + URL_LATITUDE + "&lon=" + URL_LONGITUDE + "&units=imperial" + "&appid=" + URL_API_KEY
        return URL_BASE + URL_GET_ONE_CALL
    }
    
    func setLatitude(_ latitude: String) {
        URL_LATITUDE = latitude
    }
    
    func setLatitude(_ latitude: Double) {
        setLatitude(String(latitude))
    }
    
    func setLongitude(_ longitude: String) {
        URL_LONGITUDE = longitude
    }
    
    func setLongitude(_ longitude: Double) {
        setLongitude(String(longitude))
    }
    
    func getWeather<T: Decodable>(of type: T.Type = T.self, onSuccess: @escaping (_ result: T) -> Void, onError: @escaping (String) -> Void) {
        guard let url = URL(string: buildURL()) else {
            onError("Error building URL")
            return
        }
        
        let task = session.dataTask(with: url) { (data, response, error) in
            
            DispatchQueue.main.async {
                if let error = error {
                    onError(error.localizedDescription)
                    return
                }
                
                guard let data = data, let response = response as? HTTPURLResponse else {
                    onError("Invalid data or response")
                    return
                }
                
                if response.statusCode == 200 {
                    let result: T = self.load(data: data)
                    onSuccess(result)
                } else {
                    onError("Response wasn't 200. It was: " + "\n\(response.statusCode)")
                }
            }
            
        }
        task.resume()
    }
    
    func load<T: Decodable>(data: Data) -> T {
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        }
        catch {
            fatalError("Couldn't parse as \(T.self) \(error)")
        }
    }
}
