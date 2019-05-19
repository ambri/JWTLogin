//
//  LoginViewController.swift
//  JWTLogin
//
//  Created by Ati on 2019. 05. 14..
//  Copyright © 2019. Ati. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift
import RxViewController

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var showPassSwitch: UISwitch!
    @IBOutlet weak var loadingView: UIView!

    var disposeBag: DisposeBag = DisposeBag()
    var viewModel: PLoginViewModel!

    override func viewDidAppear(_ animated: Bool) {
        usernameField.rx.text.orEmpty <-> self.viewModel.username => self.disposeBag
        passwordField.rx.text.orEmpty <-> self.viewModel.password => self.disposeBag
        loginBtn.rx.tap --> self.viewModel.loginRequest => self.disposeBag
        viewModel.isLoading.map {
            !$0
        }.bind(to: self.loadingView.rx.isHidden) => self.disposeBag
        viewModel.loginBtnEnabled.bind(to: self.loginBtn.rx.isEnabled) => self.disposeBag

        viewModel.loginRequestCompleted
                .skip(1)
                .subscribe(onNext: { result in
                    if result {
                        self.performSegue(withIdentifier: "HomeSegue", sender: nil)    
                    } else {
                        self.showAlert(with: "Unexpected error.")
                    }
                }).disposed(by: disposeBag)

        showPassSwitch.rx.isOn.asObservable()
                .subscribe(onNext: { isOn in
                    self.passwordField.isSecureTextEntry = !isOn
                }).disposed(by: disposeBag)

        viewModel.showError.asObservable()
            .subscribe(onNext: { msg in
                self.showAlert(with: msg)
            }).disposed(by: disposeBag)
    }

    private func showAlert(with msg: String) {
        let alert = UIAlertController(title: "", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
}
