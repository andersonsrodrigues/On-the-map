//
//  StudentProfile.swift
//  On the map
//
//  Created by Anderson Rodrigues on 13/02/2020.
//  Copyright © 2020 Anderson Rodrigues. All rights reserved.
//

import Foundation

struct Guard: Codable {
    let allowedBehaviors: [String]?
    
    enum CodingKeys: String, CodingKey {
        case allowedBehaviors = "allowed_behaviors"
    }
}

struct Email: Codable {
    let address: String
    let verified: Bool
    let verificationCodeSent: Bool
    
    enum CodingKeys: String, CodingKey {
        case address
        case verified = "_verified"
        case verificationCodeSent = "_verification_code_sent"
    }
}

struct StudentProfile: Codable {
    let firstName: String
    let lastName: String
    let socialAccounts: [String]?
    let mailingAddress: String?
    let bio: String?
    let registered: Bool
    let linkedinUrl: String?
    let image: String?
    let `guard`: Guard
    let location: String?
    let key: String
    let timezone: String?
    let imageUrl: String
    let nickname: String
    let websiteUrl: String?
    let occupation: String?
    let cohortKeys: [String]?
    let signature: String?
    let stripeCustomerId: Int?
    let facebookId: Int?
    let sitePreferences: String?
    let jabberId: Int?
    let languages: String?
    let badges: [String]?
    let externalServicePassword: String?
    let principals: [String]?
    let enrollments: [String]?
    let email: Email
    let externalAccounts: [String]?
    let coachingData: String?
    let tags: [String]?
    let affiliateProfiles: [String]?
    let hasPassword: Bool
    let emailPreferences: String?
    let resume: String?
    let employerSharing: Bool
    let memberships: [String]?
    let zendeskId: String?
    let googleId: String?
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case socialAccounts = "social_accounts"
        case mailingAddress = "mailing_address"
        case bio
        case registered = "_registered"
        case linkedinUrl = "linkedin_url"
        case image = "_image"
        case `guard`
        case location
        case key
        case timezone
        case imageUrl = "_image_url"
        case nickname
        case websiteUrl = "website_url"
        case occupation
        case cohortKeys = "_cohort_keys"
        case signature
        case stripeCustomerId = "_stripe_customer_id"
        case facebookId = "_facebook_id"
        case sitePreferences = "site_preferences"
        case jabberId = "jabber_id"
        case languages
        case badges = "_badges"
        case externalServicePassword = "external_service_password"
        case principals = "_principals"
        case enrollments = "_enrollments"
        case email
        case externalAccounts = "external_accounts"
        case coachingData = "coaching_data"
        case tags
        case affiliateProfiles = "_affiliate_profiles"
        case hasPassword = "_has_password"
        case emailPreferences = "email_preferences"
        case resume = "_resume"
        case employerSharing = "employer_sharing"
        case memberships = "_memberships"
        case zendeskId = "zendesk_id"
        case googleId = "_google_id"
    }
}
