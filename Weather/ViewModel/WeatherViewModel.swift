//
//  WeatherViewModel.swift
//  Weather
//
//  Created by Hassan Javed on 16/02/2022.
//  Copyright © 2022 Hassan Javed. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherDataUpdate: AnyObject {
    func updateWeather(weatherResult: WeatherData?)
    func cityUpdated(city: String)
}

class WeatherViewModel {
    
    var weatherResult: WeatherData?
    weak var delegate: WeatherDataUpdate?
    
    func getWeather() {
        APIClient.shared.getWeather(of: WeatherData.self) { result in
            self.weatherResult = result
            
            self.weatherResult?.sortDailyArray()
            self.weatherResult?.sortHourlyArray()
            
            self.delegate?.updateWeather(weatherResult: self.weatherResult)
            
        } onError: { (errorMessage) in
            debugPrint(errorMessage)
        }

    }
    
    func locationUpdated(locations: [CLLocation]) {
        if let location = locations.last {
            let currentlocation = location
            
            let latitude: Double = currentlocation.coordinate.latitude
            let longitude: Double = currentlocation.coordinate.longitude
            
            APIClient.shared.setLatitude(latitude)
            APIClient.shared.setLongitude(longitude)
            
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
                if let error = error {
                    debugPrint(error.localizedDescription)
                }
                if let placemarks = placemarks {
                    if placemarks.count > 0 {
                        let placemark = placemarks[0]
                        if let city = placemark.locality {
                            self.delegate?.cityUpdated(city: city)
                        }
                    }
                }
            }
            
            getWeather()
        }

    }
    
    func segmentChanged() {
        self.delegate?.updateWeather(weatherResult: weatherResult)
    }
    
}
