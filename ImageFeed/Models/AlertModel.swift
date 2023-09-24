//
//  AlertModel.swift
//  ImageFeed
//
//  Created by Эмилия on 21.09.2023.
//

import Foundation

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let completion: (() -> Void)?
}
