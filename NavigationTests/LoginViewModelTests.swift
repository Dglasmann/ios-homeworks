//
//  LoginViewModelTests.swift
//  Navigation
//
//  Created by Sasha Soldatov on 13.08.2026.
//

import XCTest
import FirebaseAuth
import LocalAuthentication
@testable import Navigation

@MainActor
final class LoginViewModelTests: XCTestCase {

    private var delegateMock: LoginViewControllerDelegateMock!
    private var biometricMock: BiometricServiceMock!
    private var sut: LoginViewModel!

    override func setUp() {
        super.setUp()
        delegateMock = LoginViewControllerDelegateMock()
        biometricMock = BiometricServiceMock()
        sut = LoginViewModel(
            loginDelegate: delegateMock,
            biometricService: biometricMock,
            coordinator: nil
        )
    }

    override func tearDown() {
        sut = nil
        biometricMock = nil
        delegateMock = nil
        super.tearDown()
    }

    // MARK: - Валидация

    func test_login_withEmptyEmail_setsFailureAndDoesNotCallDelegate() {
        sut.updateState(viewInput: .login(email: "", password: "123456"))

        XCTAssertEqual(sut.state, .failure(message: L10n.Login.emptyEmail))
        XCTAssertEqual(delegateMock.checkCredentialsCallCount, 0)
    }

    func test_login_withEmptyPassword_setsFailureAndDoesNotCallDelegate() {
        sut.updateState(viewInput: .login(email: "test@test.com", password: ""))

        XCTAssertEqual(sut.state, .failure(message: L10n.Login.emptyPassword))
        XCTAssertEqual(delegateMock.checkCredentialsCallCount, 0)
    }

    func test_login_withNilFields_setsFailure() {
        sut.updateState(viewInput: .login(email: nil, password: nil))

        XCTAssertEqual(sut.state, .failure(message: L10n.Login.emptyEmail))
    }

    // MARK: - Вход

    func test_login_whenCredentialsValid_setsSuccess() {
        delegateMock.checkCredentialsResult = .success(())

        sut.updateState(viewInput: .login(email: "test@test.com", password: "123456"))

        XCTAssertEqual(sut.state, .success(login: "test@test.com"))
        XCTAssertEqual(delegateMock.checkCredentialsCallCount, 1)
    }

    func test_login_withWrongPassword_setsFailure() {
        let error = NSError(domain: AuthErrorDomain, code: AuthErrorCode.wrongPassword.rawValue)
        delegateMock.checkCredentialsResult = .failure(error)

        sut.updateState(viewInput: .login(email: "test@test.com", password: "wrong"))

        XCTAssertEqual(sut.state, .failure(message: L10n.Login.wrongPassword))
        XCTAssertEqual(delegateMock.signUpCallCount, 0)
    }

    // MARK: - Автоматическая регистрация

    func test_login_whenUserNotFound_triggersSignUp() {
        let error = NSError(domain: AuthErrorDomain, code: AuthErrorCode.userNotFound.rawValue)
        delegateMock.checkCredentialsResult = .failure(error)
        delegateMock.signUpResult = .success(())

        sut.updateState(viewInput: .login(email: "new@test.com", password: "123456"))

        XCTAssertEqual(delegateMock.signUpCallCount, 1)
        XCTAssertEqual(sut.state, .success(login: "new@test.com"))
    }

    func test_login_withInvalidCredential_triggersSignUp() {
        let error = NSError(domain: AuthErrorDomain, code: AuthErrorCode.invalidCredential.rawValue)
        delegateMock.checkCredentialsResult = .failure(error)
        delegateMock.signUpResult = .success(())

        sut.updateState(viewInput: .login(email: "new@test.com", password: "123456"))

        XCTAssertEqual(delegateMock.signUpCallCount, 1)
        XCTAssertEqual(sut.state, .success(login: "new@test.com"))
    }

    func test_signUp_whenEmailAlreadyInUse_setsWrongPasswordFailure() {
        let notFound = NSError(domain: AuthErrorDomain, code: AuthErrorCode.userNotFound.rawValue)
        let inUse = NSError(domain: AuthErrorDomain, code: AuthErrorCode.emailAlreadyInUse.rawValue)
        delegateMock.checkCredentialsResult = .failure(notFound)
        delegateMock.signUpResult = .failure(inUse)

        sut.updateState(viewInput: .login(email: "existing@test.com", password: "wrong"))

        XCTAssertEqual(sut.state, .failure(message: L10n.Login.wrongPassword))
    }

    // MARK: - Биометрия

    func test_biometricLogin_whenAuthorized_setsSuccess() {
        biometricMock.stubbedResult = (true, nil)

        sut.updateState(viewInput: .biometricLogin)

        XCTAssertEqual(sut.state, .success(login: "admin"))
        XCTAssertEqual(biometricMock.authorizeCallCount, 1)
    }

    func test_biometricLogin_whenCancelled_setsFailure() {
        biometricMock.stubbedResult = (false, LAError(.userCancel))

        sut.updateState(viewInput: .biometricLogin)

        XCTAssertEqual(sut.state, .failure(message: L10n.Login.biometryCancelled))
    }

    func test_biometricLogin_whenNotEnrolled_setsFailure() {
        biometricMock.stubbedResult = (false, LAError(.biometryNotEnrolled))

        sut.updateState(viewInput: .biometricLogin)

        XCTAssertEqual(sut.state, .failure(message: L10n.Login.biometryNotEnrolled))
    }

    func test_biometryType_isTakenFromService() {
        biometricMock.stubbedBiometryType = .touchID

        XCTAssertEqual(sut.biometryType, .touchID)
    }
}
