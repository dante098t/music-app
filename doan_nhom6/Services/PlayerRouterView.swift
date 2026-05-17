import SwiftUI

struct PlayerRouterView: View {

    let song: Song
    let songs: [Song]

    @State private var role: UserRole = .user

    var body: some View {

        Group {

            switch role {

            case .premium:

                PlayerPremiumView(
                    song: song,
                    songs: songs
                )

            default:

                PlayerView(
                    song: song,
                    songs: songs
                )
            }
        }
        .task {

            role = await AuthService
                .shared
                .fetchRole()

            print("🎭 PLAYER ROLE:",
                  role.rawValue)
        }
    }
}
