import ComposableArchitecture
import SwiftUI

// 処理を実行
@Reducer
struct CounterFeature {
    @ObservableState // SwiftUIによって監視
    // 機能がそのジョブを実行するために必要な状態を保持する
    struct State {
        var count = 0
        var fact: String?
        var isLoading = false
    }
    
    // ユーザーが機能で実行できる全てのアクションを保持
    enum Action {
        case decrementButtonTapped // 命名はユーザーがUIで実際に行う操作がベスト
        case incrementButtonTapped
        // effectからの情報をReducerにfeedbackするためにアクション追加
        // stringはネットワークから取得された文字列の値
        case factResponse(String)
        case factButtonTapped
    }
    
    // 状態を次の値に変更し、機能が外部の世界で実行したい効果を返す。ロジック
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .decrementButtonTapped:
                state.count -= 1
                state.fact = nil
                return .none
                
            case .incrementButtonTapped:
                state.count += 1
                state.fact = nil
                return .none
                
            case .factButtonTapped:
                state.fact = nil
                state.isLoading = true
                
                return .run { [count = state.count] send in
                    let (data, _) = try await URLSession.shared
                        .data(from: URL(string: "http://numbersapi.com/\(count)")!)
                    let fact = String(decoding: data, as: UTF8.self)
                    await send(.factResponse(fact))
                }
                
            case let .factResponse(fact):
                state.fact = fact
                state.isLoading = false
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
            Button("Fact") {
                store.send(.factButtonTapped)
            }
            .font(.largeTitle)
            .padding()
            .background(Color.blue.opacity(0.1))
            .cornerRadius(10)
            
            if store.isLoading {
                ProgressView()
            } else if let fact = store.fact {
                Text(fact)
                    .font(.largeTitle)
                    .multilineTextAlignment(.center)
                    .padding()
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
