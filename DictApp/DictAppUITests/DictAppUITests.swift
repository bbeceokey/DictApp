//
//  DictAppUITests.swift
//  DictAppUITests
//
//  Created by Ece Ok, Vodafone on 17.05.2024.
//

import XCTest

final class DictAppUITests: XCTestCase {
    private var app : XCUIApplication!
    
    override func setUp(){
        super.setUp()
        
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append("***UITest***")
    }
    
    func test_pages(){
        
        let app = XCUIApplication()
        app.launch()
        
        let tablesQuery = app.tables
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["People"]/*[[".cells.staticTexts[\"People\"]",".staticTexts[\"People\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.images["waveform"].tap()
    
        let collectionViewsQuery = app.collectionViews
        collectionViewsQuery.children(matching: .cell).element(boundBy: 0).buttons["noun"].tap()
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Persons forming or belonging to a particular group, such as a nation, class, ethnic group, country, family, etc."]/*[[".cells.staticTexts[\"Persons forming or belonging to a particular group, such as a nation, class, ethnic group, country, family, etc.\"]",".staticTexts[\"Persons forming or belonging to a particular group, such as a nation, class, ethnic group, country, family, etc.\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.swipeUp()
 
    }
}
