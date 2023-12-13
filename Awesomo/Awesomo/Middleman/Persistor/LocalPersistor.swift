//
//  LocalPersistor.swift
//  Awesomo
//
//  Created by Vova on 13.12.2023.
//

import Foundation

final class LocalPersistor: Persistor {
    func save(_ data: Data) async {
        try! data.write(to: pathToStore)
    }

    private let pathToStore = URL(fileURLWithPath: "/Users/cort/Desktop/store")
}
