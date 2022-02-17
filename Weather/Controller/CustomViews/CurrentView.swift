//
//  CurrentView.swift
//  Weather
//
//  Created by Hassan Javed on 16/02/2022.
//  Copyright © 2022 Hassan Javed. All rights reserved.
//

import UIKit

class CurrentView: UIView {

    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var temp: UILabel!
    
    func clear() {
        weatherLabel.text = ""
        temp.text = ""
        weatherImage.image = nil
    }
    
    func updateView(currentWeather: Current, city: String) {
        weatherLabel.text = currentWeather.weather[0].description.capitalized
        weatherImage.image = UIImage(named: currentWeather.weather[0].icon)
        temp.text = "\(Int(currentWeather.temp))°F"
    }

}
