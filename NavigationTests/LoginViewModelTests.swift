//
//  LoginViewModelTests.swift
//  Navigation
//
//  Created by Sasha Soldatov on 13.08.2026.
//

import XCTest
import FirebaseAuth
@testable import Navigation

final class LoginViewModelTests: XCTestCase {
    
    var delegateMock: LoginViewControllerDelegateMock!
    var viewModel: LoginViewModel!
    
    override func setUp() {
        super.setUp()
        delegateMock = LoginViewControllerDelegateMock()
        viewModel = LoginViewModel(loginDelegate: delegateMock)
    }
    
    override  func tearDown() {
        delegateMock = nil
        viewModel = nil
        super.tearDown()
    }
    
    func testLogin_emptyEmail_setsFailureStateAndDoesNotCallDelegate() {
        //when
        viewModel.login(email: "", password: "123456")
        
        //then
        XCTAssertEqual(viewModel.state, .failure(message: "Введите email"))
        XCTAssertEqual(delegateMock.checkCredentialsCallCount, 0)
    }
    
    func testLogin_emptyPassword_setsFailureStateAndDoesNotCallDelegate() {
        //when
        viewModel.login(email: "test@test.com", password: "")
        
        //then
        XCTAssertEqual(viewModel.state, .failure(message: "Введите пароль"))
        XCTAssertEqual(delegateMock.checkCredentialsCallCount, 0)
    }
    
    func testLogin_success_setsSuccessState() {
        // given
        delegateMock.checkCredentialsResult = .success(())
        
        //when
        viewModel.login(email: "test@test.com", password: "123456")
        
        //then
        XCTAssertEqual(viewModel.state, .success(login: "test@test.com"))
        XCTAssertEqual(delegateMock.checkCredentialsCallCount, 1)
    }
    
    func testLogin_wrongPassword_setsFailureState() {
        //given
        let error = NSError(domain: AuthErrorDomain, code: AuthErrorCode.wrongPassword.rawValue)
        delegateMock.checkCredentialsResult = .failure(error)
        
        //when
        viewModel.login(email: "test@test.com", password: "wrong")
        
        //then
        XCTAssertEqual(viewModel.state, .failure(message: "Неверный пароль"))
    }
    
    func testLogin_userNotFound_triggersSignUp() {
        //given
        let notFoundError = NSError(domain: AuthErrorDomain, code: AuthErrorCode.userNotFound.rawValue)
        delegateMock.checkCredentialsResult = .failure(notFoundError)
        delegateMock.signUpResult = .success(())
        
        //when
        viewModel.login(email: "new@test.com", password: "123456")
        
        //then
        XCTAssertEqual(delegateMock.signUpCallCount, 1)
        XCTAssertEqual(viewModel.state, .success(login: "new@test.com"))
    }
}
