//
//  WeatherData.swift
//  Clima
//


import Foundation

// This File is constructed based on JSON data from the API Servers

struct WeatherData: Codable  // Decodable Protocol to decode JSON data into String, Codalbe type alias has both protocols.
{
    let name: String // name Data from API
    let main: Main // Initialize Main struct with temp value
    let weather: [Weather] // Using array since API data has array
}

struct Main: Codable // Creating struct to assign value to main constant(14)
{
    let temp: Double // Constant name should match API servers exactly
}

struct Weather: Codable // Creating struct to assign value to weather constant(15)
{
    let main: String // calling array value named main.
    let id: Int
    let description: String
}
