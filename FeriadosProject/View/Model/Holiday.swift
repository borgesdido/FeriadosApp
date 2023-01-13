//
//  Holyday.swift
//  FeriadosProject
//
//  Created by Diego Araújo Borges on 12/01/23.
//
//
import Foundation

struct HolidayResponse: Codable {
    let response: Holidays
}

struct Holidays: Codable {
    let holidays: [HolidayDetail]
}
struct HolidayDetail:Codable {
    let name: String
    let date: HolidayDate
}
struct HolidayDate: Codable {
    let iso : String
}
