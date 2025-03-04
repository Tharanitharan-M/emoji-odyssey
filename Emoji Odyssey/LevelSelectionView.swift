import SwiftUI

struct LevelSelectionView: View {
    var selectedGenre: String
    @ObservedObject var gameData = GameData()

    let levels = ["Level 1", "Level 2", "Level 3", "Level 4", "Level 5"]

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("\(selectedGenre) - Select a Level")
                    .font(.largeTitle)
                    .bold()

                ForEach(1..<6, id: \.self) { level in
                    let isUnlocked = level == 1 || gameData.isLevelCompleted(genre: selectedGenre, level: level - 1)

                    NavigationLink(
                        destination: isUnlocked ? GameView(selectedGenre: selectedGenre, level: level, gameData: gameData) : nil
                    ) {
                        Text("Level \(level)")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(isUnlocked ? Color.green : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .font(.title2)
                    }
                    .disabled(!isUnlocked)
                    .padding(.horizontal)
                }

                Spacer()
            }
            .padding()
        }
    }
}
