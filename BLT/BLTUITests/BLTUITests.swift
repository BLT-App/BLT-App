//
//  BLTUITests.swift
//  BLTUITests
//
//  Created by LorentzenN on 11/9/19.
//  Copyright © 2019 BLT App. All rights reserved.
//

import XCTest

class BLTUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func createANewTask() {
        
        let app = XCUIApplication()
        
        XCUIApplication()/*@START_MENU_TOKEN@*/.buttons["Add New Task Button"]/*[[".buttons[\"plus large\"]",".buttons[\"Add New Task Button\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        XCTAssert(app.textFields["Class Name"].label == "")
        
        app.textFields["Class Name"].tap()
        app/*@START_MENU_TOKEN@*/.otherElements["drop_down"].tables/*[[".otherElements[\"drop_down\"].tables",".tables"],[[[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/.cells.containing(.staticText, identifier:"Computer Science").element.tap()
        app.textFields["Assignment"].tap()
        app.textFields["Description"].tap()
        
        let datePickersQuery = app.datePickers
        let pickerWheel = datePickersQuery.pickerWheels["15"]
        pickerWheel/*@START_MENU_TOKEN@*/.tap()/*[[".tap()",".press(forDuration: 0.6);"],[[[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/
        pickerWheel.swipeUp()
        datePickersQuery.pickerWheels["2020"]/*@START_MENU_TOKEN@*/.tap()/*[[".tap()",".press(forDuration: 2.8);"],[[[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/
        app.buttons["Add"].tap()
    }

}
