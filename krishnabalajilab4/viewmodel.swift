//
//  viewmodel.swift
//  krishnabalajilab4
//
//  Created by Krishna Balaji on 10/5/24.
//

import Foundation

class BookViewModel: ObservableObject {
    @Published var books: [Book] = []
    @Published var currentIndex = 0

    func addBook(title: String, author: String, genre: String, price: Double) {
        let newBook = Book(title: title, author: author, genre: genre, price: price)
        books.append(newBook)
    }
    func deleteBook(title: String) {
        books.removeAll { $0.title == title }
    }
    func searchBook(byQuery query: String) -> Book? {
        return books.first { $0.title.lowercased() == query.lowercased() || $0.genre.lowercased() == query.lowercased() }
    }
    func nextBook() {
        if currentIndex < books.count - 1 {
            currentIndex += 1
        }
    }
    func previousBook() {
        if currentIndex > 0 {
            currentIndex -= 1
        }
    }
}
