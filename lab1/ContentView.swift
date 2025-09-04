//
//  ContentView.swift
//  lab1
//
//  Created by cisstudent on 9/3/25.
//

import SwiftUI

/* define a runtime error we can throw if we can't load our stuff */
struct RuntimeError: LocalizedError {
    let description: String

    init(_ description: String) {
        self.description = description
    }

    var errorDescription: String? {
        description
    }
}

/* load the dog names and descriptions. Return a dictionary  */

func loadTapped(_ dictionary: [String: String]) -> [String: Bool] {
    var booleanDictionary: [String: Bool] = [:]

    // Iterate over the keys of the string dictionary
    for key in dictionary.keys {
        // Add each key to the new dictionary with a default Boolean value (e.g., false)
        booleanDictionary[key] = false
    }
    return booleanDictionary
}
func loadDogs() throws -> [String: String] {

    /* it would be nice to iterate over the images programatically but swift doesn't seem to want to make that easy. Instead we make an array of dog names.
     */
    let dogs: [String] = [
        "Airedale Terrier",
        "American Foxhound",
        "Dutch Shepherd",
        "Havanese",
        "Leonberger",
        "Mudi",
        "Norwegian Lundehund",
        "Pharaoh Hound",
        "Scottish Terrier",
        "Tosa",
    ]

    /* grab the embedded file with the list of dog descriptions */

    if let data = NSDataAsset(name: "dog_data")?.data {
        var fileContents = String(data: data, encoding: .utf8) ?? ""

        /* remove the escaped quotes. I have a feeling the idea was to add a bunch of these strings directly in the program
         but we are just going to load a a file */

        fileContents = fileContents.replacingOccurrences(
            of: "\\\"",
            with: "\""
        )

        /* parse the file into an array of strings, remove empties */
        let separators = CharacterSet(charactersIn: "\r\n")
        let arrayOfStrings = fileContents.components(
            separatedBy: separators
        )
        var filtered = arrayOfStrings.filter { !$0.isEmpty }

        /* there is a leading a trailing quote on each - nuke that */
        for (index, dog) in filtered.enumerated() {
            filtered[index] = String(dog.dropFirst().dropLast())
        }

        /* ok we've got our dictionary now - return it*/
        let dogInfo = Dictionary(uniqueKeysWithValues: zip(dogs, filtered))
        return dogInfo

    } else {
        throw RuntimeError("Could not find 'dog_data.txt' in the main bundle.")
    }

}

struct ContentView: View {

    let dogs = try! loadDogs()

    @State var dog: String? = "Tosa"

    let columns = [
        GridItem(.adaptive(minimum: 200))
    ]

    var body: some View {
        ScrollView {
            VStack {
                Text("Pick a dog..any dog")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 10)  // Add some spacing below the header

                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(Array(dogs.keys), id: \.self) { key in
                        Image(key)
                            .resizable()
                            .scaledToFit()
                            .onTapGesture {
                                dog = key
                            }
                    }
                }
                .padding(.horizontal)
                Text(dogs[dog!]!)
            }
        }
        .frame(maxHeight: 1000)
    }
}

#Preview {
    ContentView()
}
