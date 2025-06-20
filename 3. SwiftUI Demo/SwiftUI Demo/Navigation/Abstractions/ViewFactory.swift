import SwiftUI

protocol ViewFactory {
    func makeView() -> AnyView
}
