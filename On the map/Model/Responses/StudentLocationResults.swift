//
//  StudentLocationResults.swift
//  On the map
//
//  Created by Anderson Rodrigues on 12/02/2020.
//  Copyright © 2020 Anderson Rodrigues. All rights reserved.
//

import Foundation

struct StudentLocationResults: Codable {
    let results: [StudentInformation]
    
    enum CodingKeys: String, CodingKey {
        case results
    }
}
