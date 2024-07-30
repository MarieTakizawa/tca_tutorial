import ComposableArchitecture
import SwiftUI

// 処理を実行
@Reducer
struct CounterFeature {
    @ObservableState // SwiftUIによって監視
    // 機能がそのジョブを実行するために必要な状態を保持する
    struct State {
        var count = 0
        
    }
    
    // ユーザーが機能で実行できる全てのアクションを保持
    enum Action {
        case decrementButtonTapped // 命名はユーザーがUIで実際に行う操作がベスト
        case incrementButtonTapped
    }
    
    // 状態を次の値に変更し、機能が外部の世界で実行したい効果を返す。ロジック
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .decrementButtonTapped:
                state.count -= 1
                return .none
                
            case .incrementButtonTapped:
                state.count += 1
                return .none
            }
            
        }
    }
}

struct CounterView: View {
    let store: StoreOf<CounterFeature> // store内のデータはobservableStateマクロによって自動的に監視が行われる
    
    var body: some View {
        VStack {
            Text("\(store.count)")
                .font(.largeTitle)
                .padding()
                .background(Color.black.opacity(0.1))
                .cornerRadius(10)
            HStack {
                Button("-") {
                    store.send(.decrementButtonTapped)
                }
                .font(.largeTitle)
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(10)
                
                Button("+") {
                    store.send(.incrementButtonTapped)
                }
                .font(.largeTitle)
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(10)
            }
        }
    }
}

#Preview {
    CounterView(
        store: Store(initialState: CounterFeature.State()) {
            CounterFeature()
        }
    )
}
