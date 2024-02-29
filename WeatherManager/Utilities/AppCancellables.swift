//
//  AppCancellables.swift
//  WeatherManager
//
//  Created by Austen Radigk on 2/28/24.
//

import Combine

class AppCancellables {
    @Published var cancellables: Set<AnyCancellable> = []

    func store(_ cancellable: AnyCancellable) {
        cancellables.insert(cancellable)
    }

    func cancelAll() {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
}
