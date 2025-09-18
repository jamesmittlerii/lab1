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

import OrderedCollections
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

/* load the dog names and descriptions. Return an ordered dictionary

Ordered dictionary will keep the dog list alphabetized.

 */
func loadDogs() throws -> [String: String] {

     
    let dogDesc: [String: String] = [
            "Airedale Terrier": "The Airedale Terrier stands among the world's most versatile dog breeds and has distinguished himself as hunter, athlete, and companion.",
            "American Foxhound": "American Foxhounds are good-natured, low-maintenance hounds who get on well with kids, dogs, even cats, but come with special considerations for prospective owners.",
            "Dutch Shepherd": "The Dutch Shepherd is a lively, athletic, alert and intelligent breed, and has retained its herding instinct for which it was originally developed.",
            "Havanese": "The Havanese, the only dog breed native to Cuba, are vivacious and sociable companions and are especially popular with American city dwellers.",
            "Leonberger": "The Leonberger is a lush-coated giant of German origin. They have a gentle nature and serene patience and they relish the companionship of the whole family.",
            "Mudi": "The Mudi is an extremely versatile, intelligent, alert, agile, all-purpose Hungarian farm dog. The breed is a loyal protector of property and family members without being overly aggressive.",
            "Norwegian Lundehund": "From Norway’s rocky island of Vaeroy, the uniquely constructed Norwegian Lundehund is the only dog breed created for the job of puffin hunting. With puffins now a protected species, today’s Lundehund is a friendly, athletic companion.",
            "Pharaoh Hound": "The Pharaoh Hound, ancient \"Blushing Dog\" of Malta, is an elegant but rugged sprinting hound bred to course small game over punishing terrain. Quick and tenacious on scent, these friendly, affectionate hounds settle down nicely at home.",
            "Scottish Terrier": "A solidly compact dog of vivid personality, the Scottish Terrier is an independent, confident companion of high spirits. Scotties have a dignified, almost-human character.",
            "Tosa": "The Tosa's temperament is marked by patience, composure, boldness and courage. He is normally a tranquil, quiet, and obedient dog, with a calm but vigilant demeanor."
        ]
   

   return dogDesc
}

/* have a structure that can highlight the selected image

 we need to build this structure to handle the overall, and talking to the parent when it's clicked to change the dog text

 */
struct ClickableImageView: View {
    let dog: String  // my dog
    let parentView: ContentView  // link back to parent

    /* we do some tests to see if the current dog is me or not
    we want to highlight the selected image, and de-highlight when another gets clicked.
     */
    var body: some View {
        Image(dog)
            .resizable()
            .scaledToFit()
            .background(Color.gray.opacity(0.2))
            .cornerRadius(10)
            .opacity(dog == parentView.dog ? 0.7 : 1.0)  // Example: reduce opacity when highlighted
            .scaleEffect(dog == parentView.dog ? 1.1 : 1.0)  // Example: slightly enlarge when highlighted
            .animation(.easeInOut, value: dog == parentView.dog)  // Add animation for a smoother effect
            .onTapGesture {
                // set the current dog
                parentView.dog = dog
                // do a little buzz
                let impactMed = UIImpactFeedbackGenerator(style: .medium)
                impactMed.impactOccurred()
            }

            // Display an overlay based on the individual image's state
            .overlay(
                Group {
                    if parentView.dog == dog {
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

    // load our dog list
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
                // we use a lazy (scrolling) vgrid to show the images
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(Array(dogs.keys), id: \.self) { key in
                        ClickableImageView(dog: key, parentView: self)
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
