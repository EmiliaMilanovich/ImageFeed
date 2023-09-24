//
//  Date+Extensions.swift
//  ImageFeed
//
//  Created by Эмилия on 24.09.2023.
//

import Foundation

var dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .long
    formatter.timeStyle = .none
    return formatter
}()

extension Date {
    var dateString: String {
        dateFormatter.string(from: self)
    }
}
