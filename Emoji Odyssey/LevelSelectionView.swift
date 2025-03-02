import SwiftUI

struct LevelSelectionView: View {
    var selectedGenre: String
    let levels = ["Level 1", "Level 2", "Level 3", "Level 4", "Level 5"]

    @State private var completedLevel: Int

    init(selectedGenre: String) {
        self.selectedGenre = selectedGenre
        _completedLevel = State(initialValue: UserDefaults.standard.integer(forKey: "completedLevel_\(selectedGenre)"))
    }

    var body: some View {
        VStack {
            Text("\(selectedGenre) - Select a Level")
                .font(.largeTitle)

            ForEach(0..<levels.count, id: \.self) { index in
                NavigationLink(destination: GameView(selectedGenre: selectedGenre, level: index + 1)) {
                    Text(levels[index])
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(index <= completedLevel ? Color.green : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                .disabled(index > completedLevel)
            }
        }
        .onAppear {
            completedLevel = UserDefaults.standard.integer(forKey: "completedLevel_\(selectedGenre)")
        }
    }
}
