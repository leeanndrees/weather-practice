//
//  CurrentWeatherViewModel.swift
//  Weather Practice
//
//  Created by Leeann Drees on 12/3/19.
//  Copyright © 2019 DetroitLabs. All rights reserved.
//

import Foundation

protocol CurrentWeatherViewDelegate: AnyObject {
    func didGetWeatherData(temp: String, desc: String)
    func didFailToGetWeatherData(errorDescription: String)
}

final class CurrentWeatherViewModel {
    weak var delegate: CurrentWeatherViewDelegate?
    let networking: WeatherNetworking
    
    init(delegate: CurrentWeatherViewDelegate, networking: WeatherNetworking = WeatherNetworking.shared) {
        self.delegate = delegate
        self.networking = networking
    }
    
    func getWeather(for latitude: Double, longitude: Double) {
        networking.getWeather(for: latitude, longitude: longitude, success: { (response) in
            let temp = String(response.main.temp)
            let desc = response.weather[0].description
            self.delegate?.didGetWeatherData(temp: temp, desc: desc)
        }) { (error) in
            self.delegate?.didFailToGetWeatherData(errorDescription: error.localizedDescription)
        }
    }
}
