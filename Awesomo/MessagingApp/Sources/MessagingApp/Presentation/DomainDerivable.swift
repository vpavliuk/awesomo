//
//  DomainDerivable.swift
//  
//
//  Created by Vova on 27.11.2023.
//

protocol DomainDerivable {
   associatedtype DomainState
   init(domainState: DomainState)
   static var defaultValue: Self { get }
}
