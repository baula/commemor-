//
//  MyStoryUITests.swift
//  MyStoryUITests
//
//  Created by Jessica Choi on 7/14/16.
//  Copyright © 2016 Jessica Choi. All rights reserved.
//




// Must disable hardware -> keyboard -> connect hardware keyboard (shift-command-k) in simulator

import XCTest
@testable import MyStory

class MyStoryUITests: XCTestCase {
    
    let app = XCUIApplication()

    override func setUp() {
        super.setUp()
        
        
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let createPost = app.navigationBars["MyStory.TimelineView"].buttons["Create Post"]
        sleep(3)
        createPost.tap()                                //taps create
        
        let element = app.childrenMatchingType(.Window).elementBoundByIndex(0).childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element         //accesses elements on this VC
        
        let title = element.childrenMatchingType(.TextField).elementBoundByIndex(0)
        title.tap()                                     // taps title field
        sleep(1)
        title.typeText("this is the title")
        sleep(1)


        let tags = element.childrenMatchingType(.TextField).elementBoundByIndex(1)
        tags.tap()                                      // taps tags field
        sleep(1)
        tags.typeText("these, are, some, tags")
        sleep(1)

        
        let description = element.childrenMatchingType(.TextView).element
        description.tap()
        description.doubleTap()                               // taps description
        sleep(1)
        description.typeText("this is a description")
        sleep(1)
        
        app.childrenMatchingType(.Window).elementBoundByIndex(0).tap()      // dismisses keyboard
        sleep(1)
        
        let photoLibrary = app.buttons["Photo Library"]
        photoLibrary.tap()                              // taps photo library button
        sleep(3)
        
        app.collectionViews.cells.elementBoundByIndex(0).tap()          // taps first element in collectionview
        sleep(1)

        app.collectionViews.cells.elementBoundByIndex(1).tap()          // taps second
        sleep(1)

        app.collectionViews.cells.elementBoundByIndex(2).tap()          // taps third
        sleep(1)

        app.buttons["Done (3)"].tap()                                   // taps "done" button
        sleep(1)

        
        app.buttons["Next"].tap()                                       // taps "next" button
        sleep(1)
        
        app.navigationBars["MyStory.CanvasView"].buttons["Create"].tap()        // taps create
        sleep(10)

        app.tabBars.childrenMatchingType(.Button).matchingIdentifier("Item").elementBoundByIndex(1).tap() //taps second tab
        sleep(2)

        
        app.collectionViews.childrenMatchingType(.Cell).elementBoundByIndex(0).otherElements.childrenMatchingType(.Image).element.tap()                 // accesses elements on VC
        sleep(2)

        
//        app.navigationBars["MyStory.CollectionView"].childrenMatchingType(.Other).element.childrenMatchingType(.SearchField).element.tap()          // accesses
//        sleep(2)
//
//        
//        XCUIApplication().buttons["Titles"].tap()
//        sleep(2)
//
//        
//        app.typeText("this")
//        sleep(2)
//
//        
//        app.collectionViews.cells.elementBoundByIndex(0).tap()
//        sleep(2)

        
        app.buttons["Delete"].tap()
        sleep(3)


   
    }
    
}
//
//extension XCUIElement{
//    /**
//     Removes any current text in the field before typing in the new value
//     - Parameter text: the text to enter into the field
//     */
//    func clearAndEnterText(text: String) -> Void {
//        guard let stringValue = self.value as? String else {
//            XCTFail("Tried to clear and enter text into a non string value")
//            return
//        }
//        
//        self.tap()
//        
//        var deleteString: String = ""
//        for _ in stringValue.characters {
//            deleteString += "\u{8}"
//        }
//        self.typeText(deleteString)
//        
//        self.typeText(text)
//    }
//}
