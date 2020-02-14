//
//  CreateStudentLocationResponse.swift
//  On the map
//
//  Created by Anderson Rodrigues on 13/02/2020.
//  Copyright © 2020 Anderson Rodrigues. All rights reserved.
//

import Foundation

struct CreateStudentLocationResponse: Codable {
    let objectId: String
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case objectId
        case createdAt
    }
}
