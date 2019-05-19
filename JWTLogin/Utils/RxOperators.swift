//
//  RxOperators.swift
//  NAXT Mobile Data Entity Framework
//
//  Created by Papp Imre on 2019. 01. 18..
//  Copyright © 2019. XAPT Kft. All rights reserved.
//

import RxSwift
import RxCocoa

precedencegroup RxBindingPrecedence {
    associativity: left
    higherThan: RxDisposePrecedence
}

precedencegroup RxDisposePrecedence {
    associativity: left
    lowerThan: AssignmentPrecedence
}

infix operator <->: RxBindingPrecedence
infix operator -->: RxBindingPrecedence
infix operator =>: RxDisposePrecedence

//infix operator += //not needed because the operator already exists

public func <-><T>(property: ControlProperty<T>, variable: BehaviorRelay<T>) -> Disposable {
    return Disposables.create(variable.asObservable().bind(to: property), property.asObservable().bind(to: variable))
}

public func <-><T>(variable: BehaviorRelay<T>, property: ControlProperty<T>) -> Disposable {
    return property <-> variable
}

public func --><T>(event: ControlEvent<T>, variable: PublishRelay<T>) -> Disposable {
    return event.asObservable().bind(to: variable)
}

public func --><T>(variable: BehaviorRelay<T>, property: Binder<T>) -> Disposable {
    return variable.asObservable().bind(to: property)
}

public func +=<E>(event: ControlEvent<E>, block: @escaping (E) -> Void) -> Disposable {
    return event.subscribe(onNext: block)
}

public func +=<E>(event: PublishRelay<E>, block: @escaping (E) -> Void) -> Disposable {
    return event.subscribe(onNext: block)
}

public func +=<E>(event: BehaviorRelay<E>, block: @escaping (E) -> Void) -> Disposable {
    return event.subscribe(onNext: block)
}

public func +=<E>(event: Observable<E>, block: @escaping (E) -> Void) -> Disposable {
    return event.subscribe(onNext: block)
}

public func =>(subject: Disposable, bag: DisposeBag) {
    subject.disposed(by: bag)
}
