//
//  WorkerHelper.swift
//  GroceryList
//
//  Created by Bassel Ezzeddine on 24/06/2018.
//  Copyright © 2018 Bassel Ezzeddine. All rights reserved.
//

import Foundation

class WorkerHelper {
    
    enum Result<T> {
        case success(T)
        case failure(ErrorType)
    }
    
    enum ErrorType: Error {
        case invalidUrl
        case invalidResponse
    }
}
