//
//  FocusedEventStreamer.swift
//  CoreMessaging
//
//  Created by Volodymyr Pavliuk on 09.04.2020.
//  Copyright © 2020 Volodymyr Pavliuk. All rights reserved.
//

import Combine

public protocol FocusedEventStreamer {

   associatedtype Output
   associatedtype OutputPublisher: Publisher where
         OutputPublisher.Output == Self.Output,
         OutputPublisher.Failure == Never
   var publisher: OutputPublisher { get }
}
