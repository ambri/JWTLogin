//
// Created by Ati on 2019-05-14.
// Copyright (c) 2019 Ati. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxViewController

class RouterViewController: UIViewController {
    var viewModel: PRouterViewModel!
    
    var disposeBag = DisposeBag()
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Observable.combineLatest(viewModel.refreshToken().asObservable(), self.rx.viewDidAppear)
            .flatMapLatest { _ -> Observable<Bool> in
                return Observable.just(self.viewModel.refreshResult)
            }
            .subscribe(onNext: { result in
                self.performSegue(withIdentifier: result ? "HomeSegue" : "LoginSegue", sender: nil)
            })
            .disposed(by: disposeBag)
    }
}
