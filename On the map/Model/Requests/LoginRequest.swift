//
//  LoginRequest.swift
//  On the map
//
//  Created by Anderson Rodrigues on 12/02/2020.
//  Copyright © 2020 Anderson Rodrigues. All rights reserved.
//

import Foundation

struct LoginRequest: Codable {
    let udacity: User
}

internal struct User: Codable {
    let username: String
    let password: String
}
