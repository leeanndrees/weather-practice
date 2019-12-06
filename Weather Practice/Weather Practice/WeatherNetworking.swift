//
//  WeatherNetworking.swift
//  Weather Practice
//
//  Created by Leeann Drees on 12/3/19.
//  Copyright © 2019 DetroitLabs. All rights reserved.
//

import Foundation

final class WeatherNetworking {
    let weatherSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?
    let baseURL = "https://api.openweathermap.org/data/2.5/weather"
    let key =  <#String #>
    
    static let shared = WeatherNetworking()
    
    public func getWeather(for latitude: Double,
                           longitude: Double,
                           success: @escaping (CurrentWeatherResponse) -> Void,
                           failure: @escaping (Error) -> Void) {
//        dataTask?.cancel()
        
        let urlString = "\(baseURL)?lat=\(latitude)&lon=\(longitude)&units=imperial&appid=\(key)"
        guard let url = URLComponents(string: urlString)?.url else { print("invalid URL"); return}
        
        dataTask = weatherSession.dataTask(with: url) { data, response, error in
//            defer { self.dataTask = nil }
            
            if let error = error {
                failure(error)
            } else if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                
                switch self.converted(from: data) {
                case .success(let response):
                    success(response)
                case .failure(let error):
                    failure(error)
                case .none:
                    print("oh no")
                }
            }
        }
        
        dataTask?.resume()
    }
    
    private func converted(from data: Data) -> Result<CurrentWeatherResponse, Error>? {
        let decoder = JSONDecoder()
        
        do {
            let response = try decoder.decode(CurrentWeatherResponse.self, from: data)
            return .success(response)
        } catch {
            return .failure(error)
        }
    }
}
