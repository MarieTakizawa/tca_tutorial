import ComposableArchitecture
import XCTest

@testable import tca_tutorial

@MainActor
final class AppFeatureTest: XCTestCase {
    func  testIncrementInFirstTab() async {
        let store = TestStore(initialState: AppFeature.State()) {
            AppFeature()
        }
        
        await store.send(\.tab1.incrementButtonTapped) {
            $0.tab1.count = 1
        }
        
    }
}
