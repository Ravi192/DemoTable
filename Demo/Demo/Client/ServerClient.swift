//
//  ServerClient.swift
//  Demo
//
//  Created by RAVIKANT KUMAR on 18/07/20.
//  Copyright © 2020 Societe Generale. All rights reserved.
//

import Foundation

class ServerClient {

 func getCountaryData(completionHandler: ((CountaryModel, Int, Error?) -> Void)? = nil) {
    guard let urlPath = URL(string: UrlPath.path) else { return }
    guard NSURLComponents(url: urlPath, resolvingAgainstBaseURL: false) != nil else {
                   return
        }
    var request = URLRequest(url: urlPath)
    request.httpMethod = "GET"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
             guard
                 let data = data,
                let utf8Data = String(decoding: data, as: UTF8.self).data(using: .utf8),
                 let httpCode = (response as? HTTPURLResponse)?.statusCode,
                let jsonResult = try? JSONDecoder().decode(CountaryModel.self, from: utf8Data)
                     else {
                        let httpCode = (response as? HTTPURLResponse)?.statusCode
                        completionHandler!("" as Any as! CountaryModel, httpCode ?? 403, error)
                         return
                 }
             completionHandler!(jsonResult, httpCode, error)
         }
         task.resume()
  }
}

