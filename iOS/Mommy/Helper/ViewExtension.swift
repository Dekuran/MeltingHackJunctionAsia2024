//
//  ViewExtension.swift
//  Mommy
//
//  Created by Kyubo Shim on 8/10/24.
//

import Foundation
import SwiftUI

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
