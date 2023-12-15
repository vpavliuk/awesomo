//
//  UserInputMergerProtocol.swift
//
//
//  Created by Vova on 15.12.2023.
//

import Combine

protocol UserInputMergerProtocol {
   func merge(publisher: some Publisher<some UserInput, Never>)
}
