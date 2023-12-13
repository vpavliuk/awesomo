//
//  DomainDerivable.swift
//  
//
//  Created by Vova on 27.11.2023.
//

protocol DomainDerivable {
   associatedtype DomainState
   static func fromDomainState(_ domainState: DomainState) -> Self
}
