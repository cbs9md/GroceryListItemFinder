//
//  Models.swift
//  GroceryListItemFinder
//
//  Created by Chethan Shivaram on 7/17/23.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let krogerData = try? JSONDecoder().decode(KrogerData.self, from: jsonData)

import Foundation

// MARK: - KrogerData
struct KrogerData: Codable {
    let meta: Meta
    let data: [Datum]
}

// MARK: - Datum
struct Datum: Codable {
    let images: [KrogImage]
    let temperature: Temperature
    let itemInformation: ItemInformation
    let productID: String
    let categories: [Category]
    let aisleLocations: [AisleLocation]
    let brand, description: String
    let countryOrigin: CountryOrigin
    let upc: String
    let items: [Item]

    enum CodingKeys: String, CodingKey {
        case images, temperature, itemInformation
        case productID = "productId"
        case categories, aisleLocations, brand, description, countryOrigin, upc, items
    }
}

// MARK: - AisleLocation
struct AisleLocation: Codable {
    let number, shelfPositionInBay, bayNumber, shelfNumber: String
    let description, numberOfFacings, side: String
}

enum Category: String, Codable {
    case breakfast = "Breakfast"
    case dairy = "Dairy"
}

enum CountryOrigin: String, Codable {
    case unitedStates = "UNITED STATES"
}

// MARK: - KrogImage
struct KrogImage: Codable {
    let perspective: Perspective
    let sizes: [SizeElement]
    let featured: Bool?
}

enum Perspective: String, Codable {
    case back = "back"
    case bottom = "bottom"
    case front = "front"
    case perspectiveLeft = "left"
    case perspectiveRight = "right"
    case top = "top"
}

// MARK: - SizeElement
struct SizeElement: Codable {
    let url: String
    let size: SizeEnum
}

enum SizeEnum: String, Codable {
    case large = "large"
    case medium = "medium"
    case small = "small"
    case thumbnail = "thumbnail"
    case xlarge = "xlarge"
}

// MARK: - ItemInformation
struct ItemInformation: Codable {
    let depth, width, height: String?
}

// MARK: - Item
struct Item: Codable {
    let itemID: String
    let soldBy: SoldBy
    let price: Price
    let favorite: Bool
    let size: String
    let fulfillment: Fulfillment
    let inventory: Inventory

    enum CodingKeys: String, CodingKey {
        case itemID = "itemId"
        case soldBy, price, favorite, size, fulfillment, inventory
    }
}

// MARK: - Fulfillment
struct Fulfillment: Codable {
    let curbside, delivery, shipToHome, inStore: Bool
}

// MARK: - Inventory
struct Inventory: Codable {
    let stockLevel: StockLevel
}

enum StockLevel: String, Codable {
    case high = "HIGH"
    case low = "LOW"
    case temporarilyOutOfStock = "TEMPORARILY_OUT_OF_STOCK"
}

// MARK: - Price
struct Price: Codable {
    let regular, promo: Double
}

enum SoldBy: String, Codable {
    case unit = "UNIT"
}

// MARK: - Temperature
struct Temperature: Codable {
    let heatSensitive: Bool
    let indicator: Indicator
}

enum Indicator: String, Codable {
    case refrigerated = "Refrigerated"
}

// MARK: - Meta
struct Meta: Codable {
    let pagination: Pagination
}

// MARK: - Pagination
struct Pagination: Codable {
    let start, limit, total: Int
}
