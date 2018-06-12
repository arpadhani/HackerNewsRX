//
//  Service.swift
//  HackerNewsApp
//
//  Created by Raza Padhani on 6/8/18.
//  Copyright © 2018 Raza Padhani. All rights reserved.
//

import Alamofire
import Foundation
import SwiftyJSON

class Service {
    func request(url: URL, completion: @escaping (JSON?) -> Void) {
        Alamofire.request(url.absoluteString)
            .validate(statusCode: 200..<300)
            .responseData { response in
                switch response.result {
                case .success:
                    guard let value = response.result.value else {
                        completion(nil)
                        return
                    }

                    completion(JSON(value))
                case .failure(let error):
                    print(error)
                    completion(nil)
                }
        }
    }
}
