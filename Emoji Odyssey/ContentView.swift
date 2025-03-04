import SwiftUI

struct ContentView: View {
    @State private var name: String = ""
    @State private var age: String = ""
    @State private var isSignedIn = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Emoji Odyssey")
                    .font(.largeTitle)
                    .bold()

                TextField("Enter your name", text: $name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .disableAutocorrection(true)

                TextField("Enter your age", text: $age)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .keyboardType(.numberPad)

                Button(action: {
                    if !name.isEmpty && !age.isEmpty {
                        isSignedIn = true
                        SoundManager.playSound("click")
                    }
                }) {
                    Text("Sign In")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
            }
            .padding()
            .navigationDestination(isPresented: $isSignedIn) {
                GenreSelectionView()
            }
        }
    }
}
