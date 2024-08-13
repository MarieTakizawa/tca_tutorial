import ComposableArchitecture
import SwiftUI

@main
struct TCA_tutorialApp: App {
    // 1回だけ作成することに注意
    static let store = Store(initialState: AppFeature.State()) {
        AppFeature()
            ._printChanges() // Reducerが処理する全てのアクションがコンソールに出力
    }
    
    var body: some Scene {
        WindowGroup {
            AppView(store: TCA_tutorialApp.store)
        }
    }
}
