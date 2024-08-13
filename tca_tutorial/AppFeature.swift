import ComposableArchitecture
import SwiftUI

@Reducer
struct AppFeature {
    struct State: Equatable {
        var tab1 = CounterFeature.State()
        var tab2 = CounterFeature.State()
    }
    
    enum Action {
        case tab1(CounterFeature.Action)
        case tab2(CounterFeature.Action)
    }
    
    // ①親であるAppFeatureReducerでReducerを合成。
    // ②次に、Scope Reducerを使用して、親のサブドメインにフォーカスして子reducerを実行する
    
    var body: some ReducerOf<Self> {
        Scope(state: \.tab1, action: \.tab1) {
            CounterFeature()
        }
        Scope(state: \.tab2, action: \.tab2) {
            CounterFeature()
        }
        Reduce { state, action in
            return .none
        }
    }
    
}

struct AppView: View {
    let store: StoreOf<AppFeature>

    var body: some View {
        TabView {
            // ③次に、viewでscopeを使用して親から子ストアを派生し、その子ストアを子viewに渡す
            CounterView(store: store.scope(state: \.tab1, action: \.tab1))
                .tabItem {
                    Text("counter 1")
                }
            
            CounterView(store: store.scope(state: \.tab2, action: \.tab2))
                .tabItem {
                    Text("counter 2")
                }
        }
    }
}

#Preview {
    AppView(
        store: Store(initialState: AppFeature.State()) {
            AppFeature()
        }
    )
}
