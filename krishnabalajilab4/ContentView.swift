//
//  ContentView.swift
//  krishnabalajilab4
//
//  Created by Krishna Balaji on 10/5/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = BookViewModel()
    @State var showAddAlert = false
    @State var showEditAlert = false
    @State var showDeleteAlert = false
    @State var showSearchAlert = false
    @State var showSearchResultAlert = false
    @State var selectedIndex: Int? = 0
    @State var page = 0
    let itemsPerPage = 3
    @State var titleInput = ""
    @State var authorInput = ""
    @State var genreInput = ""
    @State var priceInput = ""
    @State var editTitle = ""
    @State var editGenre = ""
    @State var searchTitle = ""
    @State var searchResult = ""

    var booksOnPage: [Book] {
        let start = page * itemsPerPage
        let end = min(start + itemsPerPage, viewModel.books.count)
        return Array(viewModel.books[start..<end])
    }
    var body: some View {
        NavigationView {
            VStack {
                List(booksOnPage.indices, id: \.self) { i in
                    let book = booksOnPage[i]
                    VStack(alignment: .leading) {
                        Text(book.title)
                            .font(.headline)
                        Text("Author: \(book.author)")
                        Text("Genre: \(book.genre)")
                        Text("Price: $\(String(format: "%.2f", book.price))")
                    }
                    .onTapGesture {
                        selectedIndex = i + page * itemsPerPage
                    }
                }
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        Button(action: {
                            showAddAlert = true
                        }) {
                            Image(systemName: "plus")
                        }
                        .alert("Add Book", isPresented: $showAddAlert) {
                            VStack {
                                TextField("Title", text: $titleInput)
                                TextField("Author", text: $authorInput)
                                TextField("Genre", text: $genreInput)
                                TextField("Price", text: $priceInput)
                                    .keyboardType(.decimalPad)
                            }
                            Button("Add", action: {
                                if let price = Double(priceInput) {
                                    viewModel.addBook(title: titleInput, author: authorInput, genre: genreInput, price: price)
                                }
                                titleInput = ""
                                authorInput = ""
                                genreInput = ""
                                priceInput = ""
                            })
                            Button("Cancel", role: .cancel, action: {})
                        }
                        Button(action: {
                            showSearchAlert = true
                        }) {
                            Image(systemName: "magnifyingglass")
                        }
                        .alert("Search Book", isPresented: $showSearchAlert) {
                            VStack {
                                TextField("Enter Book Title", text: $searchTitle)
                            }
                            Button("Search", action: {
                                if let book = viewModel.books.first(where: { $0.title == searchTitle }) {
                                    searchResult = "Title: \(book.title)\nAuthor: \(book.author)\nGenre: \(book.genre)\nPrice: $\(String(format: "%.2f", book.price))"
                                } else {
                                    searchResult = "Book not found"
                                }
                                showSearchResultAlert = true
                            })
                            Button("Cancel", role: .cancel, action: {})
                        }
                    }
                    ToolbarItemGroup(placement: .navigationBarLeading) {
                        Button(action: {
                            showDeleteAlert = true
                        }) {
                            Image(systemName: "trash")
                        }
                        .alert("Delete Book", isPresented: $showDeleteAlert) {
                            VStack {
                                TextField("Enter Book Title", text: $titleInput)
                            }
                            Button("Delete", action: {
                                if let i = viewModel.books.firstIndex(where: { $0.title == titleInput }) {
                                    viewModel.books.remove(at: i)
                                    titleInput = ""
                                    if page > 0 && booksOnPage.isEmpty {
                                        page -= 1
                                    }
                                }
                            })
                            Button("Cancel", role: .cancel, action: {})
                        }
                    }
                    ToolbarItemGroup(placement: .bottomBar) {
                        Button(action: {
                            if page > 0 {
                                page -= 1
                            }
                        }) {
                            Text("Previous")
                        }
                        .disabled(page == 0)

                        Button(action: {
                            if (page + 1) * itemsPerPage < viewModel.books.count {
                                page += 1
                            }
                        }) {
                            Text("Next")
                        }
                        .disabled((page + 1) * itemsPerPage >= viewModel.books.count)

                        Button(action: {
                            editTitle = ""
                            authorInput = ""
                            priceInput = ""
                            editGenre = ""
                            showEditAlert = true
                        }) {
                            Text("Edit")
                        }
                        .disabled(viewModel.books.isEmpty)
                    }
                }
            }
            .navigationTitle("My Book List")
            .alert("Edit Book", isPresented: $showEditAlert) {
                VStack {
                    TextField("Enter Book Title", text: $editTitle)
                    TextField("New Author", text: $authorInput)
                    TextField("New Genre", text: $editGenre)
                    TextField("New Price", text: $priceInput)
                        .keyboardType(.decimalPad)
                }
                Button("Save", action: {
                    if let i = viewModel.books.firstIndex(where: { $0.title == editTitle }), let price = Double(priceInput) {
                        viewModel.books[i].author = authorInput
                        viewModel.books[i].genre = editGenre
                        viewModel.books[i].price = price
                        editTitle = ""
                        authorInput = ""
                        priceInput = ""
                        editGenre = ""
                    }
                })
                Button("Cancel", role: .cancel, action: {})
            }
            .alert("Search Result", isPresented: $showSearchResultAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(searchResult)
            }
        }
    }
}

#Preview {
    ContentView()
}
