import AVFoundation

class SoundManager {
    static var audioPlayer: AVAudioPlayer?

    static func playSound(_ soundName: String) {
        if let path = Bundle.main.path(forResource: soundName, ofType: "wav") {  // ✅ Changed from "mp3" to "wav"
            let url = URL(fileURLWithPath: path)
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.play()
            } catch {
                print("❌ Error playing sound: \(error.localizedDescription)")
            }
        } else {
            print("❌ Sound file not found: \(soundName)")
        }
    }
}
