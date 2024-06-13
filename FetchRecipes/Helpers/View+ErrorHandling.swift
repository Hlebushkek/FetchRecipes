//
//  View+ErrorHandling.swift
//  FetchRecipes
//
//  Created by Hlib Sobolevskyi on 2024-06-12.
//

import SwiftUI

struct ErrorHandlingViewModifier: ViewModifier {
    var error: Error?

    func body(content: Content) -> some View {
        Group {
            if let error = error {
                Text(error.localizedDescription)
            } else {
                content
            }
        }
    }
}

extension View {
    func errorHandling(error: Error?) -> some View {
        self.modifier(ErrorHandlingViewModifier(error: error))
    }
}
