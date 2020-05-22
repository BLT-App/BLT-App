//
//  bltscreenshots.swift
//  bltscreenshots
//
//  Created by LorentzenN on 5/21/20.
//  Copyright © 2020 BLT App. All rights reserved.
//

import XCTest

class bltscreenshots: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
        snapshot("ListView")
        print("Screenshotted List View")
        
        app.buttons["Add New Task Button"].tap()
        app.textFields["Class Name"].tap()
        app/*@START_MENU_TOKEN@*/.otherElements["drop_down"].tables/*[[".otherElements[\"drop_down\"].tables",".tables"],[[[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/.cells.containing(.staticText, identifier:"English").element.tap()
        app.textFields["Assignment"].tap()
        app.typeText("Read Gatsby")
        app.textViews["DescriptionField"].tap()
        app.typeText("Read pages 123-156. Pay attention to changes in character.")
        snapshot("NewItem")
        print("Screenshotted New Item")
        
        app.buttons["Add"].tap()
        app.tabBars.buttons["Focus"].tap()
        app.datePickers.pickerWheels.firstMatch.adjust(toPickerWheelValue: "0")
        app.datePickers.pickerWheels.element(boundBy: 1).adjust(toPickerWheelValue: "3")
        app.buttons["BeginTimer"].tap()
        app.collectionViews.cells.staticTexts.firstMatch.swipeRight()
        snapshot("FocusMode")
        print("Screenshotted Focus Mode")
        
        app.navigationBars["BLT.FocusView"].buttons["End Focus Mode"].tap()
        app.tabBars.buttons["Profile"].tap()
        snapshot("UserProfile")
        print("Screenshotted User Profile")
        
        app.tabBars.buttons["History"].tap()
        snapshot("HistoryView")
        print("Screenshotted History View")
    }
}
