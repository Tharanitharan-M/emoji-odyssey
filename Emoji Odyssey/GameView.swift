import SwiftUI

struct GameView: View {
    var selectedGenre: String
    var level: Int
    @ObservedObject var gameData: GameData
    @State private var userGuess: [String]
    @State private var isCorrect: Bool = false
    @State private var showHint: Bool = false
    @State private var attempts: Int = 3
    @State private var lockoutTime: Int? = nil
    @FocusState private var focusedIndex: Int?
    @State private var navigateToNextLevel = false
    @Environment(\.dismiss) var dismiss  // ✅ Properly dismiss GameView to go back to LevelSelectionView

    let emojiPuzzles: [String: [[String: String]]] = [
                "Movies": [
                    ["emoji": "🦁👑🐾", "answer": "THELIONKING"],
                    ["emoji": "🚢❄️❤️", "answer": "TITANIC"],
                    ["emoji": "🦇🤵", "answer": "BATMAN"],
                    ["emoji": "🦖🏝️", "answer": "JURASSICPARK"],
                    ["emoji": "👻🚫", "answer": "GHOSTBUSTERS"],
                    ["emoji": "🕷️🦸", "answer": "SPIDERMAN"],
                    ["emoji": "🧙‍♂️⚡", "answer": "HARRYPOTTER"],
                    ["emoji": "🐟🔍", "answer": "FINDINGNEMO"],
                    ["emoji": "🤠🐍", "answer": "INDIANAJONES"],
                    ["emoji": "🐉👊", "answer": "KUNGFUPANDA"],
                    ["emoji": "🎩🐇✨", "answer": "NOWYOUSEE ME"],
                    ["emoji": "🎭🤡🎈", "answer": "IT"],
                    ["emoji": "🚗⚡🏁", "answer": "CARS"],
                    ["emoji": "🏴‍☠️⚓", "answer": "PIRATESOFTHECARIBBEAN"],
                    ["emoji": "🐧🎤", "answer": "HAPPYFEET"],
                    ["emoji": "🐍👀", "answer": "SNAKESONAPLANE"],
                    ["emoji": "🌌⚔️", "answer": "STARWARS"],
                    ["emoji": "🎬🎼🎤", "answer": "LA LA LAND"],
                    ["emoji": "👩‍🚀🚀🌕", "answer": "GRAVITY"],
                    ["emoji": "🐼🥋", "answer": "KUNGFUPANDA"]
                ],
                "Famous People": [
                    ["emoji": "🎸👑", "answer": "ELVIS"],
                    ["emoji": "💡🔬", "answer": "EINSTEIN"],
                    ["emoji": "🏀🐍", "answer": "KOBEBRYANT"],
                    ["emoji": "🎤👑", "answer": "BEYONCE"],
                    ["emoji": "⚽🐐", "answer": "MESSI"],
                    ["emoji": "🇮🇳🎓", "answer": "GANDHI"],
                    ["emoji": "🚀🌍", "answer": "NEILARMSTRONG"],
                    ["emoji": "🖖🛸", "answer": "SPOCK"],
                    ["emoji": "🕶️🔫", "answer": "JAMESBOND"],
                    ["emoji": "🎩🦸", "answer": "HUGHJACKMAN"],
                    ["emoji": "📖🖋️", "answer": "SHAKESPEARE"],
                    ["emoji": "🏊‍♂️🥇", "answer": "MICHAELPHELPS"],
                    ["emoji": "🎤🕺", "answer": "MICHAELJACKSON"],
                    ["emoji": "🚴‍♂️🏆", "answer": "LANCEARMSTRONG"],
                    ["emoji": "🎥💀", "answer": "ALFREDHITCHCOCK"],
                    ["emoji": "🦷🔬", "answer": "MARIECURIE"],
                    ["emoji": "🌊🏄", "answer": "KELLYSLATER"],
                    ["emoji": "🎭😆", "answer": "ROBINWILLIAMS"],
                    ["emoji": "💻📡", "answer": "BILLGATES"],
                    ["emoji": "📚🎓", "answer": "STEPENHAWKING"]
                ],
                "Phrases": [
                    ["emoji": "🍎👩‍⚕️", "answer": "ANAPPLEADAY"],
                    ["emoji": "🤐🔒", "answer": "ZIPYOURLIPS"],
                    ["emoji": "🐦🛑🌵", "answer": "BIRDSONAWIRE"],
                    ["emoji": "💦🥛", "answer": "CRYOVERSPILLED MILK"],
                    ["emoji": "🐷💨", "answer": "WHENPIGSFLY"],
                    ["emoji": "🌈🦄", "answer": "CHASETHERAINBOW"],
                    ["emoji": "🐟🆚🌊", "answer": "FISHOUTOFWATER"],
                    ["emoji": "🐢🏁", "answer": "SLOWANDSTEADY"],
                    ["emoji": "🔥🏠", "answer": "FIREINTHEHOLE"],
                    ["emoji": "💀☠️", "answer": "DEADASADOORNAIL"],
                    ["emoji": "👂👀", "answer": "KEEPANEYEOUT"],
                    ["emoji": "💸💰", "answer": "MONEYDOESNTGROWONTREES"],
                    ["emoji": "🚀💨", "answer": "BLASTOFF"],
                    ["emoji": "🎭🖤", "answer": "WOLFIN SHEEPSCLOTHING"],
                    ["emoji": "🕰️🐢", "answer": "TAKEYOURTIME"],
                    ["emoji": "👃💡", "answer": "SMELLARAT"],
                    ["emoji": "🎤💥", "answer": "MICDROP"],
                    ["emoji": "🚀🔥", "answer": "BURNINGUP"],
                    ["emoji": "🦸‍♂️👿", "answer": "HEROVSVILLAIN"],
                    ["emoji": "💡✨", "answer": "BRIGHTIDEA"]
                ]
            ]

    init(selectedGenre: String, level: Int, gameData: GameData) {
        self.selectedGenre = selectedGenre
        self.level = level
        self.gameData = gameData
        let questions = emojiPuzzles[selectedGenre] ?? []
        let selectedQuestion = questions[level % questions.count]
        let answerLength = selectedQuestion["answer"]!.count
        self._userGuess = State(initialValue: Array(repeating: "", count: answerLength))
    }

    var body: some View {
        VStack {
            // ✅ Corrected Back Button to Always Return to Levels Page
            HStack {
                Button(action: {
                    dismiss()  // ✅ Ensures we go back to LevelSelectionView
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                    .foregroundColor(.blue)
                }
                .padding()
                
                Spacer()
            }

            Text("\(selectedGenre) - Level \(level)")
                .font(.largeTitle)

            let currentQuestion = emojiPuzzles[selectedGenre]![level % emojiPuzzles[selectedGenre]!.count]

            Text(currentQuestion["emoji"]!)
                .font(.system(size: 80))
                .padding(.bottom, 10)

            // ✅ **Two-line layout for long movie names (Centered)**
            let maxPerRow = 7
            let firstLine = userGuess.prefix(maxPerRow)
            let secondLine = userGuess.count > maxPerRow ? userGuess.suffix(from: maxPerRow) : []

            VStack(spacing: 10) {
                HStack {
                    ForEach(0..<firstLine.count, id: \.self) { index in
                        TextField("", text: $userGuess[index])
                            .frame(width: 40, height: 40)
                            .border(Color.black, width: 1)
                            .multilineTextAlignment(.center)
                            .focused($focusedIndex, equals: index)
                            .keyboardType(.asciiCapable)
                            .onChange(of: userGuess[index]) { newValue in
                                if newValue.count > 1 {
                                    userGuess[index] = String(newValue.prefix(1))
                                }
                                if newValue.count == 1 && index < userGuess.count - 1 {
                                    focusedIndex = index + 1
                                }
                            }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)

                if secondLine.count > 0 {
                    HStack {
                        ForEach(0..<secondLine.count, id: \.self) { index in
                            TextField("", text: $userGuess[index + maxPerRow])
                                .frame(width: 40, height: 40)
                                .border(Color.black, width: 1)
                                .multilineTextAlignment(.center)
                                .focused($focusedIndex, equals: index + maxPerRow)
                                .keyboardType(.asciiCapable)
                                .onChange(of: userGuess[index + maxPerRow]) { newValue in
                                    if newValue.count > 1 {
                                        userGuess[index + maxPerRow] = String(newValue.prefix(1))
                                    }
                                    if newValue.count == 1 && index + maxPerRow < userGuess.count - 1 {
                                        focusedIndex = index + maxPerRow + 1
                                    }
                                }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }
            }

            Button(action: {
                checkAnswer()
            }) {
                Text("Submit")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(attempts > 0 ? Color.blue : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .disabled(attempts == 0)

            if isCorrect {
                Text("🎉 Correct! Press Next!")
                    .foregroundColor(.green)
                    .padding()

                NavigationLink(destination: GameView(selectedGenre: selectedGenre, level: level + 1, gameData: gameData), isActive: $navigateToNextLevel) {
                    EmptyView()
                }

                Button(action: {
                    navigateToNextLevel = true
                }) {
                    Text("Next")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
            } else if lockoutTime != nil {
                Text("Locked! Wait \(lockoutTime!) seconds")
                    .foregroundColor(.red)
                    .padding()
            } else {
                Text("Attempts left: \(attempts)")
                    .foregroundColor(.gray)
            }

            Spacer()
        }
        .padding()
        .navigationBarBackButtonHidden(true)
    }

    func checkAnswer() {
        let currentQuestion = emojiPuzzles[selectedGenre]![level % emojiPuzzles[selectedGenre]!.count]
        let answer = currentQuestion["answer"]!.uppercased()

        if userGuess.joined() == answer {
            isCorrect = true
            gameData.markLevelCompleted(genre: selectedGenre, level: level)
            SoundManager.playSound("success")
        } else {
            attempts -= 1
            SoundManager.playSound("wrong")
            if attempts == 0 {
                lockoutTime = 30
                startLockoutTimer()
            } else {
                userGuess = Array(repeating: "", count: answer.count)  // Clear input boxes on wrong answer
            }
        }
    }

    func startLockoutTimer() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if lockoutTime! > 0 {
                lockoutTime! -= 1
            } else {
                timer.invalidate()
                attempts = 3
                lockoutTime = nil
            }
        }
    }
}
