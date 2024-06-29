//
//  WeatherManager.swift
//  TripLogger
//
//  Created by 김민석 on 6/29/24.
//

import Foundation

import WeatherKit
import CoreLocation

final class WeatherManager {
    
    static let shared: WeatherManager = .init()
    
    private init() { }
    
    func fetchCurrentWeather(location: CLLocation) async throws -> CurrentWeather {
        let weather = try await WeatherService.shared.weather(for: location)
        
        return weather.currentWeather
    }
    
    func fetchWeatherInHour(location: CLLocation) async throws -> (date: Date, condition: WeatherCondition)? {
        let weather = try await WeatherService.shared.weather(for: location)
        
        let currentWeather = weather.currentWeather
        let info = weather.hourlyForecast.forecast.map { ($0.date, TripWeatherCondition(condition: $0.condition)) }
        return checkNextCondition(
            currentWeather: currentWeather,
            info: info
        )
    }
    
    func checkNextCondition(currentWeather: CurrentWeather, info: [(date: Date, condition: TripWeatherCondition)]) -> (date: Date, condition: WeatherCondition)? {
        
        for i in 0..<info.count {
            if currentWeather.date > info[i].date {
                continue
            }
            if TripWeatherCondition(condition: currentWeather.condition).group != info[i].condition.group {
                return (info[i].date, info[i].condition.condition)
            }
        }
        return nil
    }
}

enum TripWeatherCondition: String {
    enum TripWeatherGroup {
        case clear
        case cloudy
        case precipitation
    }
    
    case blizzard
    case blowingDust
    case blowingSnow
    case breezy
    case clear
    case cloudy
    case drizzle
    case flurries
    case foggy
    case freezingDrizzle
    case freezingRain
    case frigid
    case hail
    case haze
    case heavyRain
    case heavySnow
    case hot
    case hurricane
    case isolatedThunderstorms
    case mostlyClear
    case mostlyCloudy
    case partlyCloudy
    case rain
    case scatteredThunderstorms
    case sleet
    case smoky
    case snow
    case strongStorms
    case sunFlurries
    case sunShowers
    case thunderstorms
    case tropicalStorm
    case windy
    case wintryMix
    
    init(condition: WeatherCondition) {
        self = TripWeatherCondition(rawValue: condition.rawValue) ?? .clear
    }
    
    var condition: WeatherCondition {
        return WeatherCondition(rawValue: self.rawValue) ?? .clear
        
    }

    var group: TripWeatherGroup {
        switch self {
        case .clear, .mostlyClear, .sunShowers: return .clear
        case .partlyCloudy, .cloudy, .mostlyCloudy, .foggy, .haze, .smoky: return .cloudy
        case .drizzle, .freezingDrizzle, .rain, .freezingRain, .sleet, .snow, .flurries, .thunderstorms, .isolatedThunderstorms, .scatteredThunderstorms, .strongStorms, .hail, .hurricane, .tropicalStorm, .blizzard, .blowingDust, .blowingSnow, .frigid, .hot, .windy, .wintryMix: return .precipitation
        default: return .cloudy
        }
    }
}

