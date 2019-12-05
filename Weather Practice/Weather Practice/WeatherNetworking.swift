//
//  WeatherNetworking.swift
//  Weather Practice
//
//  Created by Leeann Drees on 12/3/19.
//  Copyright © 2019 DetroitLabs. All rights reserved.
//

import Foundation

final class WeatherNetworking {
    static let weatherSession = URLSession(configuration: .default)
    static var dataTask: URLSessionDataTask?
    static let baseURL = "https://api.openweathermap.org/data/2.5/weather"
    static let key = <#String#>
    
    static public func getWeather(for latitude: Double = 35,
                           longitude: Double = 139,
                           success: @escaping (CurrentWeatherResponse) -> Void,
                           failure: @escaping (Error) -> Void) {
//        dataTask?.cancel()
        
        let urlString = "\(baseURL)?lat=\(latitude)&lon=\(longitude)&units=imperial&appid=\(key)"
        guard let url = URLComponents(string: urlString)?.url else { print("invalid URL"); return}
        
        dataTask = weatherSession.dataTask(with: url) { data, response, error in
//            defer { self.dataTask = nil }
            
            if let error = error {
                print(error.localizedDescription)
                failure(error)
            } else if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                guard let convertedData = self.converted(from: data) else { return }
                success(convertedData)
            }
        }
        
        dataTask?.resume()
    }
    
    static private func converted(from data: Data) -> CurrentWeatherResponse? {
        let decoder = JSONDecoder()
        
        do {
            let response = try decoder.decode(CurrentWeatherResponse.self, from: data)
            return response
        } catch {
            print("decoding failed")
            return nil
        }
    }
}
