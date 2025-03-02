import SwiftUI

struct GameView: View {
    var selectedGenre: String
    var level: Int

    @State private var userGuess: [String]
    @State private var showMessage: String = ""
    @State private var isCorrect: Bool = false
    @State private var attemptsLeft: Int = 3
    @State private var navigateToLevelSelection = false
    @State private var showNextButton = false
    @State private var isLockedOut = false
    @State private var lockoutTimeRemaining = 0
    @FocusState private var focusedIndex: Int?

    @AppStorage("completedLevel_\(UUID().uuidString)") private var completedLevel: Int = 0

    let emojiPuzzles: [String: [[String: String]]] = [
        "Movies": [
            ["emoji": "🦁👑🐾", "answer": "THELIONKING"],
            ["emoji": "🚢❄️❤️", "answer": "TITANIC"],
            ["emoji": "🦇🔫🏙️", "answer": "THEDARKKNIGHT"],
            ["emoji": "🕷️🧑‍🎤", "answer": "SPIDERMAN"],
            ["emoji": "🦖🌋", "answer": "JURASSICPARK"]
        ],
        "Phrases": [
            ["emoji": "❄️🤝", "answer": "BREAKTHEICE"],
            ["emoji": "🐍🍎", "answer": "BITETHEBULLET"],
            ["emoji": "🎭😇", "answer": "ABLESSINGINDISGUISE"],
            ["emoji": "🌈🔚", "answer": "THEENDOFTHERAINBOW"],
            ["emoji": "🚀🌕", "answer": "SHOOTTOTHEMOON"]
        ]
    ]

    var currentQuestion: [String: String]

    init(selectedGenre: String, level: Int) {
        self.selectedGenre = selectedGenre
        self.level = level

        let questions = emojiPuzzles[selectedGenre] ?? []
        self.currentQuestion = questions.randomElement() ?? ["emoji": "❓", "answer": "UNKNOWN"]

        _userGuess = State(initialValue: Array(repeating: "", count: currentQuestion["answer"]!.count))

        if isLockedOut {
            startLockoutTimer() // ✅ Ensure lockout continues if user returns
        }
    }

    var body: some View {
        VStack {
            Button(action: { navigateToLevelSelection = true }) {
                HStack {
                    Image(systemName: "arrow.left")
                    Text("Back to Levels")
                }
            }
            .padding()

            Text("\(selectedGenre) - Level \(level)")
                .font(.largeTitle)

            Text(currentQuestion["emoji"] ?? "❓")
                .font(.system(size: 80))
                .padding(.bottom, 10)

            if isLockedOut {
                VStack {
                    Text("❌ Locked for \(lockoutTimeRemaining) seconds ❌")
                        .font(.headline)
                        .foregroundColor(.red)
                        .padding()
                    
                    ProgressView(value: Double(30 - lockoutTimeRemaining), total: 30) // ✅ Shows visual countdown
                        .progressViewStyle(LinearProgressViewStyle(tint: .red))
                        .padding(.horizontal, 40)
                        .onAppear {
                            startLockoutTimer()
                        }
                }
            } else {
                let answerLength = userGuess.count
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 5), count: 6), spacing: 10) {
                    ForEach(0..<answerLength, id: \.self) { index in
                        TextField("", text: Binding(
                            get: { userGuess[index] },
                            set: { newValue in
                                if newValue.count == 1 {
                                    userGuess[index] = newValue.uppercased()
                                    if index < answerLength - 1 {
                                        moveToNextField(currentIndex: index)
                                    }
                                } else {
                                    userGuess[index] = String(newValue.prefix(1)).uppercased()
                                }
                            }
                        ))
                        .frame(width: 45, height: 45)
                        .background(isLockedOut ? Color.gray.opacity(0.5) : Color.white) // ✅ Disable input if locked
                        .cornerRadius(8)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                        .multilineTextAlignment(.center)
                        .keyboardType(.alphabet)
                        .focused($focusedIndex, equals: index)
                        .disabled(isLockedOut) // ✅ Prevent typing if locked out
                    }
                }
                .padding(.horizontal, 20)

                Button(action: checkAnswer) {
                    Text("Submit")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(isLockedOut ? Color.gray : Color.blue) // ✅ Disable button if locked
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
                .disabled(isLockedOut) // ✅ Prevent button click if locked out
            }

            Text(showMessage)
                .font(.headline)
                .foregroundColor(isCorrect ? .green : .red)

            if showNextButton {
                Button(action: { navigateToLevelSelection = true }) {
                    Text("Next")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
            }

            Spacer()

            .navigationDestination(isPresented: $navigateToLevelSelection) {
                LevelSelectionView(selectedGenre: selectedGenre)
            }
        }
        .padding()
        .onAppear {
            focusedIndex = 0
        }
    }

    private func moveToNextField(currentIndex: Int) {
        DispatchQueue.main.async {
            if currentIndex < userGuess.count - 1 {
                focusedIndex = currentIndex + 1
            }
        }
    }

    func checkAnswer() {
        if isLockedOut { return } // ✅ Prevent retries while locked

        let correctAnswer = currentQuestion["answer"]?.uppercased().replacingOccurrences(of: " ", with: "") ?? ""
        let userAnswer = userGuess.joined().replacingOccurrences(of: " ", with: "")

        if userAnswer == correctAnswer {
            isCorrect = true
            showMessage = "🎉 Correct! Press Next!"
            if level >= completedLevel {
                completedLevel = level
                UserDefaults.standard.set(completedLevel, forKey: "completedLevel_\(selectedGenre)")
            }
            showNextButton = true
        } else {
            attemptsLeft -= 1
            showMessage = "❌ Wrong! Try again."
            clearInputBoxes()

            if attemptsLeft == 0 {
                startLockoutTimer()
            }
        }
    }

    private func clearInputBoxes() {
        for i in 0..<userGuess.count {
            userGuess[i] = ""
        }
        focusedIndex = 0
    }

    private func startLockoutTimer() {
        isLockedOut = true
        lockoutTimeRemaining = 30
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if lockoutTimeRemaining > 0 {
                lockoutTimeRemaining -= 1
            } else {
                timer.invalidate()
                isLockedOut = false
                attemptsLeft = 3
                clearInputBoxes()
                showMessage = "✅ You can try again!"
            }
        }
    }
}
