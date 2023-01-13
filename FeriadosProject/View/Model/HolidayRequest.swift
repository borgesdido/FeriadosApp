//
//  HolydayRequest.swift
//  FeriadosProject
//
//  Created by Diego Araújo Borges on 12/01/23.
//

import Foundation



enum HolidayError: Error {
    case noDataAvailable
    case canNotProcessData
}

struct HolidayRequest {
    let resourceURL: URL
    let API_KEY = "999452c9f4ba2fb1bd4cae84740f30bcddc97aeb"
    
    init(countryCode:String) {
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy"
        let currentYear = format.string(from: date)
        let resourceString = "https://calendarific.com/api/v2/holidays?api_key=\(API_KEY)&country=\(countryCode)&year=\(currentYear)"
        
        guard let resourceURL = URL(string: resourceString) else {
            fatalError()
        }
        
        self.resourceURL = resourceURL
    }
    
    func getHolidays(completion: @escaping(Result<[HolidayDetail],HolidayError>) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: resourceURL) { (data, _, _) in
            guard let jsonData = data else {
                completion(.failure(.noDataAvailable))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let holidayResponse = try decoder.decode(HolidayResponse.self, from: jsonData)
                print("Holiday Res: \(holidayResponse)")
                let holidayDetails = holidayResponse.response.holidays
                completion(.success(holidayDetails))
            }
            catch {
                completion(.failure(.canNotProcessData))
            }
        }
        func urlSession(_ session: URLSession, dataTask: URLSessionDataTask,
                        willCacheResponse proposedResponse: CachedURLResponse,
                        completionHandler: @escaping (CachedURLResponse?) -> Void) {
            if proposedResponse.response.url?.scheme == "https" {
                let updatedResponse = CachedURLResponse(response: proposedResponse.response,
                                                        data: proposedResponse.data,
                                                        userInfo: proposedResponse.userInfo,
                                                        storagePolicy: .allowedInMemoryOnly)
                completionHandler(updatedResponse)
            } else {
                completionHandler(proposedResponse)
            }
        }
        dataTask.resume()
    }
}



