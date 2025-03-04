import SwiftUI

struct GenreSelectionView: View {
    let genres = ["Movies", "Famous People", "Phrases"]

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Select a Genre")
                    .font(.largeTitle)
                    .bold()

                ForEach(genres, id: \.self) { genre in
                    NavigationLink(destination: LevelSelectionView(selectedGenre: genre)) {
                        Text(genre)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .font(.title2)
                    }
                    .padding(.horizontal)
                    .onTapGesture {
                        SoundManager.playSound("navigate")
                    }
                }

                Spacer()
            }
            .padding()
        }
    }
}
