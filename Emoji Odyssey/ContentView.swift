import SwiftUI

struct ContentView: View {
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false  // Stores login state
    @AppStorage("playerName") private var playerName: String = ""
    @AppStorage("playerAge") private var playerAge: String = ""

    @State private var name: String = ""  // Stores player name (temporary)
    @State private var age: String = ""   // Stores player age (temporary)

    var body: some View {
        NavigationStack {
            if isLoggedIn {
                GenreSelectionView()  // ✅ Navigate to Genre Selection after signing in
            } else {
                VStack(spacing: 20) {
                    Text("Emoji Quest")
                        .font(.largeTitle)
                        .bold()

                    // Name Input Field
                    TextField("Enter your name", text: $name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .disableAutocorrection(true)

                    // Age Input Field
                    TextField("Enter your age", text: $age)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        #if os(iOS)
                        .keyboardType(.numberPad)  // ✅ Works only for iOS
                        #endif

                    // Sign-Up Button
                    Button(action: {
                        if !name.isEmpty && !age.isEmpty {
                            playerName = name
                            playerAge = age
                            isLoggedIn = true  // ✅ Store login state
                        }
                    }) {
                        Text("Sign Up")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding()
                }
                .padding()
            }
        }
    }
}
