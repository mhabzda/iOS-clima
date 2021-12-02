//
//  Localized.swift
//  Clima
//
//  Created by Marcin Habzda on 02/12/2021.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation
enum Localized {}

extension Localized {
    
    enum Weather {
        
        static let searchPlaceholder = "SearchPlaceholder".localize()
        static let errorTitle = "ErrorTitle".localize()
        static let defaultCity = "DefaultCity".localize()
        static let okTitle = "OkTitle".localize()
        static let defaultTemperature = "DefaultTemperature".localize()
        static let temperatureUnit = "TemperatureUnit".localize()
    }
}
