//
//  lab1UITests.swift
//  lab1UITests
//
//  Created by cisstudent on 9/18/25.
//

import XCTest
@testable import lab1

final class lab1UITests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // Launch the app before each test method.
              app = XCUIApplication()
              app.launch()
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    @MainActor
    func testInitialUIState() throws {
          // 1. Assert that the title "Pick a dog...any dog" exists.
          // `staticTexts` is used to query labels and other static text elements.
          let titleText = app.staticTexts["Pick a dog...any dog"]
          XCTAssertTrue(titleText.exists, "The title 'Pick a dog...any dog' should exist on launch.")
          
          // 2. Assert that the initial description text is empty.
          // We use the accessibility identifier to find the element.
          let descriptionText = app.staticTexts["descriptionText"]
          XCTAssertTrue(descriptionText.exists, "The description text element should be present.")
          XCTAssertEqual(descriptionText.label, "", "The initial description text should be empty.")
          
          // 3. Assert that images for all 10 dogs are visible.
          // The loadDogs() function returns a fixed set of 10 dogs.
          let dogs = try! loadDogs() // Assuming this function is available for the test bundle
          
          for dogName in dogs.keys {
              let dogImage = app.images["image-\(dogName)"]
              XCTAssertTrue(dogImage.exists, "The image for \(dogName) should exist.")
          }
      }

  @MainActor
    func testScrollingAndSelection() throws {
           // The name of the last dog in the list, which will initially be off-screen.
           let lastDogName = "Tosa"
           let lastDogImageIdentifier = "image-\(lastDogName)"

           // 1. Find the last dog's image.
           // XCTest is smart enough to know it's in a scrollable view and will perform
           // the scrolling for you when you interact with an off-screen element.
           let lastDogImage = app.images[lastDogImageIdentifier]

           // 2. Assert that the image for the last dog exists.
           // It should exist in the app's hierarchy, even if not yet visible.
           XCTAssertTrue(lastDogImage.exists, "The image for \(lastDogName) should exist in the view hierarchy.")

           // 3. Tap the off-screen image.
           // This will automatically trigger a scroll until the element is hittable (visible),
           // and then perform the tap.
           lastDogImage.tap()

           // 4. Assert that the description text is updated with the Tosa's description.
           let descriptionText = app.staticTexts["descriptionText"]
           let expectedDescription = try loadDogs()[lastDogName] ?? "" // Use the loaded data for the assertion
           
           // Assert that the description text element exists and contains the correct text.
           XCTAssertTrue(descriptionText.exists, "The description text element should be present.")
           XCTAssertEqual(descriptionText.label, expectedDescription, "The description text should match the description for \(lastDogName).")
       }

    @MainActor
    func testLaunchPerformance() throws {
        
        try XCTSkipIf(true, "This test is temporarily disabled.")
        // This measures how long it takes to launch your application.
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
}
