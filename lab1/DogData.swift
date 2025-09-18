//
//  DogData.swift
//  lab1
//
//  Created by cisstudent on 9/18/25.
//

import OrderedCollections
import Foundation

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
func loadDogs() throws -> OrderedDictionary<String, String> {

     
    let dogDesc: OrderedDictionary<String, String> = [
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

