import Combine
import SwiftUI
import Foundation

final class Router: ObservableObject {

    public enum Destination: Codable, Hashable {
        case scanFood
    }

    @Published var navPath = NavigationPath()

    func navigate(to destination: Destination) {
        navPath.append(destination)
    }

    func navigateBack() {
        navPath.removeLast()
    }

    func navigateToRoot() {
        navPath.removeLast(navPath.count)
    }
}
