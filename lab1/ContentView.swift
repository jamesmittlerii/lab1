/**

 * Lab 1
 * Jim Mittler
 * 4 September 2025

 This program loads dog descriptions and images.
 We display a grid of the dog images and show a description when the image is clicked.
 
 _Italic text_
 __Bold text__
 ~~Strikethrough text~~

 */

import SwiftUI
import OrderedCollections

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
func loadDogs() throws -> OrderedDictionary<String,String> {

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
        let dogInfo = OrderedDictionary(uniqueKeysWithValues: zip(dogs, filtered))
        return dogInfo

    } else {
        throw RuntimeError("Could not find 'dog_data.txt' in the main bundle.")
    }

}

/* have a structure that can highlight the selected image */
struct HoverableImageView: View {
    let dog: String
    let parentView: ContentView
    
     var body: some View {
        Image(dog)
            .resizable()
            .scaledToFit()
            .background(Color.gray.opacity(0.2))
            .cornerRadius(10)
            .opacity(dog == parentView.dog ? 0.7 : 1.0) // Example: reduce opacity when highlighted
                    .scaleEffect(dog == parentView.dog  ? 1.1 : 1.0) // Example: slightly enlarge when highlighted
                    .animation(.easeInOut, value: dog == parentView.dog ) // Add animation for a smoother effect
            .onTapGesture {
                parentView.dog = dog
            }
            
            // Display an overlay based on the individual image's state
            .overlay(
                Group {
                    if  parentView.dog == dog {
                        Text(dog)
                            .padding(8)
                            .background(Color.black.opacity(0.8))
                            .foregroundColor(.white)
                            .cornerRadius(5)
                            //.offset(y: -60)
                            .transition(.opacity)
                    }
                }
            )
    }
}

struct ContentView: View {

    let dogs = try! loadDogs()

    // state variable for which dog is picked
    @State var dog: String?
    
    
    
    // grid for the pictures
    let columns = [
        GridItem(.adaptive(minimum: 200))
    ]

    var body: some View {
       
            VStack {
                Text("Pick a dog...any dog")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 10)  // Add some spacing below the header

                ScrollView {
                    // we use a lazy vgrid to show the images
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(Array(dogs.keys), id: \.self) { key in
                            HoverableImageView(dog: key, parentView: self)
                        }
                    }
                    .padding(.horizontal)
                }
                // show the picked dog if any
                Text(dog != nil ? dogs[dog!]! : "")
                    .padding()
            }
        
        .frame(maxHeight: 1000)
    }
}

#Preview {
    ContentView()
}
