//
//  AppError.swift
//
//
//  Created by Vova on 15.01.2024.
//

enum AppError: Error {
   case couldNotFindHandlerForInputEvent(any InputEvent)
   case wrongHandlerForInputEvent(any InputEvent, any InputEventHandler)
}
