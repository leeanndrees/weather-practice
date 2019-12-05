//
//  WeatherModel.swift
//  Weather Practice
//
//  Created by Leeann Drees on 12/3/19.
//  Copyright © 2019 DetroitLabs. All rights reserved.
//

import Foundation

struct CurrentWeatherResponse: Decodable {
    let weather: [Weather]
    let main: Main
    
    struct Weather: Decodable {
        let description: String
    }
    
    struct Main: Decodable {
        let temp: Decimal
    }
}
