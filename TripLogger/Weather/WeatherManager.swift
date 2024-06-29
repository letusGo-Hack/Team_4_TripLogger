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
    
    func fetchWeatherInHour(location: CLLocation) async throws -> (date: Date, condition: TripWeatherCondition)? {
        let weather = try await WeatherService.shared.weather(for: location)
        
        let currentWeather = weather.currentWeather
        let info = weather.hourlyForecast.forecast.map { ($0.date, TripWeatherCondition(condition: $0.condition)) }
        return checkNextCondition(
            currentWeather: currentWeather,
            info: info
        )
    }
    
    func checkNextCondition(currentWeather: CurrentWeather, info: [(date: Date, condition: TripWeatherCondition)]) -> (date: Date, condition: TripWeatherCondition)? {
        
        for i in 0..<info.count {
            if currentWeather.date > info[i].date {
                continue
            }
            if TripWeatherCondition(condition: currentWeather.condition).group != info[i].condition.group {
                return (info[i].date, info[i].condition)
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
    
    var sfsymbol: String {
        switch self {
        case .blizzard:
            return "wind.snow"
        case .blowingDust:
            return "wind"
        case .blowingSnow:
            return "snow"
        case .breezy:
            return "wind"
        case .clear:
            return "sun.max"
        case .cloudy:
            return "cloud"
        case .drizzle:
            return "cloud.drizzle"
        case .flurries:
            return "snow"
        case .foggy:
            return "cloud.fog"
        case .freezingDrizzle:
            return "cloud.sleet"
        case .freezingRain:
            return "cloud.sleet"
        case .frigid:
            return "thermometer.snowflake"
        case .hail:
            return "cloud.hail"
        case .haze:
            return "sun.haze"
        case .heavyRain:
            return "cloud.heavyrain"
        case .heavySnow:
            return "snow"
        case .hot:
            return "thermometer.sun"
        case .hurricane:
            return "hurricane"
        case .isolatedThunderstorms:
            return "cloud.bolt.rain"
        case .mostlyClear:
            return "sun.max"
        case .mostlyCloudy:
            return "cloud.sun"
        case .partlyCloudy:
            return "cloud.sun"
        case .rain:
            return "cloud.rain"
        case .scatteredThunderstorms:
            return "cloud.bolt"
        case .sleet:
            return "cloud.sleet"
        case .smoky:
            return "smoke"
        case .snow:
            return "snow"
        case .strongStorms:
            return "tornado"
        case .sunFlurries:
            return "sun.dust"
        case .sunShowers:
            return "cloud.sun.rain"
        case .thunderstorms:
            return "cloud.bolt"
        case .tropicalStorm:
            return "tropicalstorm"
        case .windy:
            return "wind"
        case .wintryMix:
            return "cloud.snow"
        }
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

