import SwiftUI

struct ContentView: View {
    private let habbits: [Habbit] = Habbit.mock()
    private let habbitHeight = UIScreen.main.bounds.height / 3.5
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: [
                    GridItem(.flexible(minimum: 0, maximum: .infinity)),
                    GridItem(.flexible(minimum: 0, maximum: .infinity)),
                ], alignment: .center, spacing: 0) {
                    ForEach(habbits, id: \.self) { habbit in
                        HabbitView(habbit: habbit)
                            .frame(height: habbitHeight)
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal, 5)
                            .padding(.vertical, 10)
                    }
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .scrollIndicators(.hidden)
            .navigationTitle("Rabbit Habbit")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    struct HabbitView: View {
        @State var habbit: Habbit
        
        var body: some View {
            ZStack(alignment: .bottom) {
                RoundedRectangle(cornerRadius: .itemCornerRadius)
                    .fill(.ultraThinMaterial)
                
                LinearGradient(
                    colors: [.clear, habbit.color], startPoint: .center, endPoint: .bottom
                )
                .opacity(habbit.currentCompleted >= habbit.completionAim ? 0.25 : 0)
                .clipShape(
                    RoundedRectangle(cornerRadius: .itemCornerRadius)
                )
                
                VStack {
                    HStack(alignment: .bottom) {
                        CompletionIndicatorView(
                            color: habbit.color,
                            currentCompleted: habbit.currentCompleted,
                            completionAim: habbit.completionAim,
                            width: UIScreen.main.bounds.width / 8
                        )
                        
                        Spacer()
                        
                        VStack {
                            VStack {
                                HStack(alignment: .center) {
                                    Text("\(habbit.currentCompleted)")
                                        .fontWeight(.semibold)
                                        .foregroundStyle(.primary)
                                        .shadow(color: .secondary, radius: 1.75)
                                    
                                    if habbit.currentCompleted <= habbit.completionAim {
                                        Text("/ \(habbit.completionAim)")
                                            .foregroundStyle(.secondary)
                                    }
                                }
                                
                                Text("sessions")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            .font(.title2)
                            .offset(y: -30)
                            
                            Button {
                                habbit.complete()
                            } label: {
                                Circle()
                                    .fill(habbit.color.gradient)
                                    .frame(width: UIScreen.main.bounds.width / 8)
                                    .overlay {
                                        Image(systemName: "plus")
                                            .foregroundStyle(.white)
                                    }
                                    .shadow(color: habbit.color, radius: 4)
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    HStack {
                        Image(systemName: habbit.systemImage)
                            .shadow(color: .secondary, radius: 2)
                        
                        Text("\(habbit.titlle)")
                            .bold()
                    }
                }
                .animation(.bouncy(duration: 0.5, extraBounce: 0.1), value: habbit.currentCompleted)
                .padding(.vertical)
            }
        }
    }
    
    private struct CompletionIndicatorView: View {
        var color: Color
        var currentCompleted: Int
        var completionAim: Int
        var width: CGFloat
        
        private let brightnesConstant = -0.07
        private let maxLevels = 4
        
        var body: some View {
            ZStack(alignment: .bottom) {
                RoundedRectangle(cornerRadius: width / 2)
                    .fill(Color(uiColor: .systemGray5))
                    .frame(width: width * 1.1, height: width * 3 * 1.025)
                    .shadow(color: Color(uiColor: .systemGray5), radius: 10)
                
                RoundedRectangle(cornerRadius: width / 2)
                    .fill(color)
                    .frame(width: width, height: 3 * width * CGFloat(min(currentCompleted, completionAim)) / CGFloat(completionAim))
                        
            
                ForEach(1..<maxLevels, id: \.self) { level in
                    RoundedRectangle(cornerRadius: width / 2)
                        .fill(color)
                        .brightness(brightnesConstant * Double(level))
                        .frame(
                            width: width,
                            height: width * 3 / 2 + 3 * width * CGFloat(min(max(currentCompleted - level * completionAim, 0), completionAim)) / CGFloat(completionAim) / 2
                        )
                        .opacity(currentCompleted + 1 > level * completionAim ? 1 : 0)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}

struct Habbit: Hashable {
    var color: Color
    var titlle: String
    var systemImage: String
    var currentCompleted: Int
    var completionAim: Int
    
    mutating func complete() {
        self.currentCompleted += 1
    }
}

private extension Habbit {
    static func mock() -> [Self] {
        [
            .init(
                color: .blue,
                titlle: "Drink water",
                systemImage: "drop.fill",
                currentCompleted: 0,
                completionAim: 3
            ),
            .init(
                color: .green,
                titlle: "Walk",
                systemImage: "figure.walk",
                currentCompleted: 1,
                completionAim: 5
            ),
            .init(
                color: .orange,
                titlle: "Read book",
                systemImage: "book.fill",
                currentCompleted: 2,
                completionAim: 7
            ),
            .init(
                color: .purple,
                titlle: "Meditate",
                systemImage: "brain.head.profile",
                currentCompleted: 0,
                completionAim: 1
            ),
            .init(
                color: .pink,
                titlle: "Workout",
                systemImage: "bolt.heart.fill",
                currentCompleted: 3,
                completionAim: 4
            ),
            .init(
                color: .red,
                titlle: "No sugar",
                systemImage: "heart.slash.fill",
                currentCompleted: 5,
                completionAim: 7
            ),
            .init(
                color: .teal,
                titlle: "Journal",
                systemImage: "pencil.and.outline",
                currentCompleted: 1,
                completionAim: 3
            ),
            .init(
                color: .indigo,
                titlle: "Sleep early",
                systemImage: "bed.double.fill",
                currentCompleted: 2,
                completionAim: 5
            )
        ]
    }
}

private extension CGFloat {
    static let itemCornerRadius: CGFloat = 25
}
