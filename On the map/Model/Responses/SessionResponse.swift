//
//  SessionResponse.swift
//  On the map
//
//  Created by Anderson Rodrigues on 12/02/2020.
//  Copyright © 2020 Anderson Rodrigues. All rights reserved.
//

import Foundation

struct SessionResponse: Codable {
    let account: Account
    let session: Session
}

internal struct Account: Codable {
    let registered: Bool
    let key: String
}

internal struct Session: Codable {
    let id: String
    let expiration: String
}
