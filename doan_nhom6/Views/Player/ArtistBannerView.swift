import SwiftUI

struct ArtistBannerView: View {

    // MARK: DATA FROM SUPABASE

    let artist: Artist

    var onTap: () -> Void

    var body: some View {

        Button {

            onTap()

        } label: {

            ZStack(alignment: .bottomLeading) {

                // MARK: BACKGROUND IMAGE

                AsyncImage(

                    url: URL(

                        string: artist.avatar_url ?? ""

                    )

                ) { phase in

                    switch phase {

                    case .success(let image):

                        image

                            .resizable()

                            .scaledToFill()

                            .frame(maxWidth: .infinity)

                            .clipped()

                    case .empty:

                        ZStack {

                            RoundedRectangle(

                                cornerRadius: 24

                            )

                            .fill(

                                Color.white.opacity(0.06)

                            )

                            ProgressView()

                        }

                    case .failure:

                        ZStack {

                            RoundedRectangle(

                                cornerRadius: 24

                            )

                            .fill(

                                Color.white.opacity(0.08)

                            )

                            Image(

                                systemName:

                                    "music.mic"

                            )

                            .font(.system(size: 42))

                            .foregroundColor(

                                .white.opacity(0.4)

                            )

                        }

                    @unknown default:

                        EmptyView()

                    }

                }

                .frame(height: 190)

                .clipShape(

                    RoundedRectangle(

                        cornerRadius: 24

                    )

                )

                // MARK: DARK OVERLAY

                LinearGradient(

                    colors: [

                        .clear,

                        .black.opacity(0.2),

                        .black.opacity(0.88)

                    ],

                    startPoint: .top,

                    endPoint: .bottom

                )

                .clipShape(

                    RoundedRectangle(

                        cornerRadius: 24

                    )

                )

                // MARK: CONTENT

                VStack(

                    alignment: .leading,

                    spacing: 10

                ) {

                    // BADGE

                    HStack(spacing: 6) {

                        Image(

                            systemName:

                                "music.microphone"

                        )

                        .font(

                            .caption.bold()

                        )

                        Text("FEATURED ARTIST")

                            .font(

                                .caption.bold()

                            )

                    }

                    .foregroundColor(.white)

                    .padding(.horizontal, 10)

                    .padding(.vertical, 6)

                    .background(

                        Color.white.opacity(0.12)

                    )

                    .clipShape(Capsule())

                    // NAME

                    Text(

                        artist.name

                    )

                    .font(

                        .system(

                            size: 28,

                            weight: .bold

                        )

                    )

                    .foregroundColor(.white)

                    .lineLimit(1)

                    .minimumScaleFactor(0.7)

                    // BIO

                    Text(

                        artist.bio

                        ?? "Tap to view artist profile"

                    )

                    .font(.subheadline)

                    .foregroundColor(

                        .white.opacity(0.78)

                    )

                    .lineLimit(2)

                    // FOOTER

                    HStack {

                        Spacer()

                        Image(

                            systemName:

                                "arrow.up.right"

                        )

                        .font(

                            .title3.bold()

                        )

                        .foregroundColor(.white)

                    }

                }

                .padding(20)

            }

            .frame(maxWidth: .infinity)

            .overlay(

                RoundedRectangle(

                    cornerRadius: 24

                )

                .stroke(

                    Color.white.opacity(0.08),

                    lineWidth: 1

                )

            )

            .shadow(

                color: .black.opacity(0.35),

                radius: 18,

                y: 10

            )

        }

        .buttonStyle(.plain)

    }

}
