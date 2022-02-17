//
//  WeatherViewController.swift
//  Weather
//
//  Created by Hassan Javed on 16/02/2022.
//  Copyright © 2022 Hassan Javed. All rights reserved.
//

import UIKit
import MapKit

class WeatherViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var cityLbl: UILabel!
    @IBOutlet weak var currentView: CurrentView!
    @IBOutlet weak var weatherDetailView: WeatherDetailView!
    
    var city = "" {
        didSet {
            self.cityLbl.text = city.capitalized
        }
    }
    
    var viewModel: WeatherViewModel?
    var locationManger: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = WeatherViewModel()
        viewModel?.delegate = self
        
        clearAll()
        getLocation()
    }
    
    func clearAll() {
        currentView.clear()
        weatherDetailView.clear()
    }
    
    func updateTopView(weatherResult: WeatherData?) {
        guard let weatherResult = weatherResult else {
            return
        }
        
        currentView.updateView(currentWeather: weatherResult.current, city: city)
    }
    
    func updateBottomView(weatherResult: WeatherData?) {
        guard let weatherResult = weatherResult else {
            return
        }
        
        let title = weatherDetailView.getSelectedTitle()
        
        if title == "Today" {
            weatherDetailView.updateViewForToday(weatherResult.hourly)
        } else if title == "Weekly" {
            weatherDetailView.updateViewForWeekly(weatherResult.daily)
        }
    }
    
    func getLocation() {
       
        if (CLLocationManager.locationServicesEnabled()) {
            locationManger = CLLocationManager()
            locationManger.delegate = self
            locationManger.desiredAccuracy = kCLLocationAccuracyBest
            locationManger.requestWhenInUseAuthorization()
            locationManger.requestLocation()
        }
        
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        viewModel?.locationUpdated(locations: locations)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        debugPrint(error.localizedDescription)
    }
    
    @IBAction func getWeatherTapped(_ sender: UIButton) {
        clearAll()
        getLocation()
    }
    
    @IBAction func todayWeeklyValueChanged(_ sender: UISegmentedControl) {
        clearAll()
        viewModel?.segmentChanged()
    }
}

extension WeatherViewController: WeatherDataUpdate {
    
    func updateWeather(weatherResult: WeatherData?) {
        self.updateTopView(weatherResult: weatherResult)
        self.updateBottomView(weatherResult: weatherResult)
    }
    
    func cityUpdated(city: String) {
        self.city = city
    }
    
}
