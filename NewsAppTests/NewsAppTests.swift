//
//  NewsAppTests.swift
//  NewsAppTests
//
//  Created by Renê Xavier on 24/01/21.
//

import XCTest
import RxSwift
@testable import NewsApp

class NewsAppTests: XCTestCase {
    let disposeBag = DisposeBag()
    var viewmodel: LoginViewModel?
    var loginInputs: LoginInputs?
    
    override func setUpWithError() throws {
        viewmodel = LoginViewModel(NewsService(stub: true), disposeBag: disposeBag)
//        loginInputs = LoginInputs(username: , password: , tapExecuteLogin: )
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
//        viewmodel?.setUp(with: LoginInputs)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
