import SwiftUI

struct Content: View {
    
    @State private var showExpandedContent = false
    
    var body: some View {
        NavigationStack {
            List {
                
            }
            .navigationTitle("Expand button sample")
        }
        .overlay(alignment: .bottomTrailing) {
            ExpandInteractionButton(
                bgColor: .black,
                showExpandedContent: $showExpandedContent) {
                    Image(systemName: "plus")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundStyle(.background)
                        .frame(width: 45, height: 45)
                } content: {
                    VStack(alignment: .leading) {
                        RowView("paperplane", "Send")
                        RowView("arrow.trianglehead.2.counterclockwise", "Swap")
                        RowView("arrow.down", "Receive")
                    }
                    .padding()
                } expandedContent: {
                    
                }
                .padding()
        }
    }
    
    @ViewBuilder
    func RowView(_ image: String, _ title: String) -> some View {
        HStack {
            Image(systemName: image)
                .font(.title2)
                .frame(width: 45, height: 45)
                .background(.background, in: .circle)
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.title3)
                    .foregroundStyle(.background)
                    .fontWeight(.semibold)
                
                Text("Thie is a sample text for description")
                    .font(.callout)
                    .foregroundStyle(.gray)
                    .lineLimit(2)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(10)
        .contentShape(.rect)
    }
}

struct ExpandInteractionButton<Label: View,
                               Content: View,
                               ExpandedContent: View>: View {
    var bgColor: Color
    @Binding var showExpandedContent: Bool
    
    @ViewBuilder var label: Label
    @ViewBuilder var content: Content
    @ViewBuilder var expandedContent: ExpandedContent
    
    @State private var showFullScreenCover = false
    @State private var animateContent = false
    @State private var viewPosition: CGRect = .zero
    var body: some View {
        label
            .background(bgColor)
            .clipShape(.circle)
            .contentShape(.circle)
            .onGeometryChange(for: CGRect.self, of: {
                $0.frame(in: .global)
            }, action: { newValue in
                viewPosition = newValue
            })
            .opacity(showFullScreenCover ? 0 : 1)
            .onTapGesture {
                toggleFullScreenCover(false, status: true)
            }
            .fullScreenCover(isPresented: $showFullScreenCover) {
                ZStack(alignment: .topLeading) {
                    if animateContent {
                        content
                            .transition(.blurReplace)
                    } else {
                        label
                            .transition(.blurReplace)
                    }
                }
                .geometryGroup()
                .clipShape(.rect(cornerRadius: 30, style: .continuous))
                .background {
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .fill(bgColor)
                }
                .frame(
                    maxWidth: .infinity,
                    maxHeight: .infinity,
                    alignment: animateContent ? .bottom : .topLeading
                )
                .padding(.horizontal, animateContent ? 15 : 0)
                .padding(.vertical, animateContent ? 5 : 0)
                .offset(
                    x: animateContent ? 0 : viewPosition.minX,
                    y: animateContent ? 0 : viewPosition.minY
                )
                .ignoresSafeArea(animateContent ? [] : .all)
                .background {
                    Rectangle()
                        .fill(.black.opacity(animateContent ? 0.05 : 0))
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation {
                                animateContent = false
                            } completion: {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    toggleFullScreenCover(false, status: false)
                                }
                            }
                        }
                }
                .task {
                    try? await Task.sleep(for: .seconds(0.05))
                    withAnimation {
                        animateContent = true
                    }
                }
            }
    }
    
    private func toggleFullScreenCover(_ withAnimation: Bool, status: Bool) {
        var transaction = Transaction()
        transaction.disablesAnimations = !withAnimation
        
        withTransaction(transaction) {
            showFullScreenCover = status
        }
    }
}

#Preview {
    Content()
}

