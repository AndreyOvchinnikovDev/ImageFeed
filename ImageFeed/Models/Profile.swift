//
//  Profile.swift
//  ImageFeed
//
//  Created by Andrey Ovchinnikov on 11.04.2023.
//

import Foundation

struct Profile {
    let userName: String
    let name: String
    let loginName: String
    let bio: String
    
    static func createProfile(profile: ProfileResult) -> Profile {
        Profile(
            userName: profile.userName,
            name: profile.firstName + " " + profile.lastName,
            loginName: "@" + profile.userName,
            bio: profile.bio
        )
    }
}
