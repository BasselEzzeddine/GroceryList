//
//  ServicesHelper.swift
//  GroceryList
//
//  Created by Bassel Ezzeddine on 24/06/2018.
//  Copyright © 2018 Bassel Ezzeddine. All rights reserved.
//

import Foundation

enum ServiceResult<T> {
    case Success(T)
    case Failure(ServiceErrorType)
}

enum ServiceErrorType: Error {
    case invalidUrl
    case invalidResponse
}
