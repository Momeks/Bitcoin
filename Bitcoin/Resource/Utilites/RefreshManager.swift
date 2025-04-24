//
//  RefreshManager.swift
//  Bitcoin
//
//  Created by Mohammad Komeili on 4/25/25.
//

import Combine
import Foundation
import UIKit

protocol RefreshPublisher {
    var refresh: AnyPublisher<Void, Never> { get }
}

class RefreshManager: ObservableObject, RefreshPublisher {
    static let shared = RefreshManager()

    private var timerSubscription: AnyCancellable?
    private let refreshSubject = PassthroughSubject<Void, Never>()

    var refresh: AnyPublisher<Void, Never> {
        refreshSubject.eraseToAnyPublisher()
    }

    private init() {
        setupLifecycleObservers()
        startTimer()
    }

    private func startTimer() {
        timerSubscription = Timer
            .publish(every: 60, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.refreshSubject.send(())
            }
    }

    private func stopTimer() {
        timerSubscription?.cancel()
        timerSubscription = nil
    }
    
    private func setupLifecycleObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appDidEnterBackground),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appWillEnterForeground),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
    }

    @objc private func appDidEnterBackground() {
        stopTimer()
    }

    @objc private func appWillEnterForeground() {
        startTimer()
    }
}
