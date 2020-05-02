//
//  ContentView.swift
//  Bookworm
//
//  Created by Ahad Islam on 5/1/20.
//  Copyright © 2020 Ahad Islam. All rights reserved.
//

import SwiftUI

struct PushButton: View {
    let title: String
    @Binding var isOn: Bool
    // Property wrapper that allows a two-way data flow. when isOn is triggered, it sends that data to the "binded" object as well.
    
    var onColors = [Color.red, Color.yellow]
    var offColors = [Color(white: 0.6), Color(white: 0.4)]
    
    
    var body: some View {
        Button(title) {
            self.isOn.toggle()
        }
        .padding()
        .background(LinearGradient(gradient: Gradient(colors: isOn ? onColors: offColors), startPoint: .top, endPoint: .bottom))
        .foregroundColor(.white)
        .clipShape(Capsule())
        .shadow(radius: isOn ? 0 : 5)
    }
}

struct BindingContentView: View {
    @State private var rememberMe = false
    
    var body: some View {
        VStack {
            PushButton(title: "Remember Me", isOn: $rememberMe)
            Text(rememberMe ? "On" : "Off")
        }
    }
}

struct AnyViewContentView: View {
    /// AnyView allows us to use type-erasure so SwiftUI believes we're just returning a simple view.  Howevers with it comes a performance impact.  Since SwiftUI doesn't know what exists afterwards.
    
    @Environment(\.horizontalSizeClass) var sizeClass
    
    var body: some View {
        if sizeClass == .compact {
            return AnyView(VStack {
                Text("Active size class:")
                Text("Compact")
            }
            .font(.largeTitle))
        } else {
            return AnyView(HStack {
                Text("Active size class:")
                Text("REGULAR")
            }
            .font(.largeTitle))
        }
    }
}

struct CoreDataContentView: View {
    @FetchRequest(entity: Student.entity(), sortDescriptors: []) var students: FetchedResults<Student>
    
    @Environment(\.managedObjectContext) var moc
    
    /// Integrating CoreData in swiftUI is dumb easy and makes me sad we've never done it before.
    
    var body: some View {
        VStack {
            List {
                ForEach(students, id: \.id) {
                    Text($0.name ?? "Unknown")
                }
            }
            Button("Add") {
                let firstNames = ["Ginny", "Harry", "Hermione", "Luna", "Ron"]
                let lastNames = ["Granger", "Lovegood", "Potter", "Weasley"]
                
                let chosenFirstName = firstNames.randomElement()!
                let chosenLastName = lastNames.randomElement()!
                
                let student = Student(context: self.moc)
                student.id = UUID()
                student.name = "\(chosenFirstName) \(chosenLastName)"
                
                try? self.moc.save()
            }
        }
    }
}

struct AddBookView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    
    @State private var title = ""
    @State private var author = ""
    @State private var rating = 3
    @State private var genre = ""
    @State private var review = ""
    
    let genres = ["Fantasy", "Horror", "Kids", "Mystery", "Poetry", "Romance", "Thriller"]
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Name of book", text: $title)
                    TextField("Author's name", text: $author)
                    
                    Picker("Genre", selection: $genre) {
                        ForEach(genres, id: \.self) {
                            Text($0)
                        }
                    }
                }
                
                Section {
                    Picker("Rating", selection: $rating) {
                        ForEach(0..<6) {
                            Text("\($0)")
                        }
                    }
                    
                    TextField("Write a review", text: $review)
                }
                
                Section {
                    Button("Save") {
                        let newBook = Book(context: self.moc)
                        newBook.title = self.title
                        newBook.author = self.author
                        newBook.rating = Int16(self.rating)
                        newBook.genre = self.genre
                        newBook.review = self.review
                        
                        try? self.moc.save()
                        self.presentationMode.wrappedValue.dismiss()
                        
                    }
                }
            }
            .navigationBarTitle("Add Book")
        }
    }
}

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Book.entity(), sortDescriptors: []) var books: FetchedResults<Book>
    
    @State private var showingAddScreen = false
    
    var body: some View {
        NavigationView {
            Text("Count: \(books.count)")
                .navigationBarTitle("Bookworm")
                .navigationBarItems(trailing: Button(action: {
                    self.showingAddScreen.toggle()
                }) {
                    Image(systemName: "plus")
                })
                .sheet(isPresented: $showingAddScreen) {
                    AddBookView()
                        .environment(\.managedObjectContext, self.moc)
                }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
