//
//  ProfileViewModel.swift
//  FirebaseMessenger
//
//  Created by Tuấn Nguyễn on 22/02/2022.
//

import Foundation

struct ProfileViewModel {
    let viewModelType: ProfileViewModelType
    let title: String
    let handler: (() -> Void)?
}

enum ProfileViewModelType {
    case info, logout
}
