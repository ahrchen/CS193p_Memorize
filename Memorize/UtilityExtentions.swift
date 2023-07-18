//
//  UtilityExtentions.swift
//  Memorize
//
//  Created by Raymond Chen on 7/17/23.
//

import Foundation

/*
 In a Collection of Identifiables
 we often might want to find the element that has the same id
 as an Identifiable we already have in hand
 we name this index(matching:) instead of firstIndex(matching:)
 because we assume that someone creating a Collection of Identifiable
 is usually going to have only one of each IDentifiable thing in there
 though there's nothing to restrict them from doing so; it's just a naming choice)
 */

extension Collection where Element: Identifiable {
    func index(matching element: Element) -> Self.Index? {
        firstIndex(where: {$0.id == element.id})
    }
}
