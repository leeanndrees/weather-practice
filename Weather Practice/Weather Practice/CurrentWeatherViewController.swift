//
//  ViewController.swift
//  Weather Practice
//
//  Created by Leeann Drees on 12/3/19.
//  Copyright © 2019 DetroitLabs. All rights reserved.
//

import CoreLocation
import UIKit

class CurrentWeatherViewController: UIViewController {

    @IBOutlet var tempLabel: UILabel!
    @IBOutlet var descLabel: UILabel!
    
    var location: CLLocation?
    lazy var viewModel = CurrentWeatherViewModel(delegate: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocationManager()
    }

    private func setupLocationManager() {
        let locationManager = LocationManager.shared
        locationManager.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
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

extension CurrentWeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        viewModel.getWeather(for: location.coordinate.latitude, longitude: location.coordinate.longitude)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        let alert = UIAlertController(title: "Failed to get Location", message: error.localizedDescription, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        present(alert, animated: true)
    }
}
