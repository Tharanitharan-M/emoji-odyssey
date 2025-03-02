//
//  GenreSelectionView.swift
//  Emoji Odyssey
//
//  Created by Tharanitharan Muthuthirumaran on 3/1/25.
//

import SwiftUI

struct GenreSelectionView: View {
    let genres = ["Movies", "Famous People", "Phrases"]  // Available genres
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = true  // Tracks login state

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Select a Genre")
                    .font(.largeTitle)
                    .bold()

                // Genre Selection Buttons
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
                }

                Spacer()

                // Logout Button
                Button(action: {
                    isLoggedIn = false  // ✅ Log out and return to Sign-Up
                }) {
                    Text("Logout")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .font(.title2)
                }
                .padding(.horizontal)
            }
            .padding()
        }
    }
}
