//
//  ViewController.swift
//  Weather Practice
//
//  Created by Leeann Drees on 12/3/19.
//  Copyright © 2019 DetroitLabs. All rights reserved.
//

import UIKit

class CurrentWeatherViewController: UIViewController {

    @IBOutlet var tempLabel: UILabel!
    @IBOutlet var descLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let viewModel = CurrentWeatherViewModel(delegate: self)
        viewModel.getWeather(for: 42.0, longitude: 16.0)
    }

}

extension CurrentWeatherViewController: CurrentWeatherViewDelegate {
    func didGetWeatherData(temp: String, desc: String) {
        DispatchQueue.main.async {
            self.tempLabel.text = temp
            self.descLabel.text = desc
        }
    }
    
    func didFailToGetWeatherData(errorDescription: String) {
        let alert = UIAlertController(title: "Failed to get Weather", message: errorDescription, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
}

