//
//  book.swift
//  krishnabalajilab4
//
//  Created by Krishna Balaji on 10/5/24.
//

import Foundation

struct Book: Identifiable {
    var id = UUID()
    var title: String
    var author: String
    var genre: String
    var price: Double
}
