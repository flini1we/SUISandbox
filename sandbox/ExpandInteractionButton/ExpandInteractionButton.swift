import SwiftUI

struct ExpandedInteractionButtonContent: View {
    
    @State private var showExpandedContent = false
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            NavigationStack {
                List {
                    
                }
                .navigationTitle("Expand button")
            }
            
            ExpandInteractionButton()
        }
    }
}

struct ExpandInteractionButton: View {
    
    @State private var isCollapsed = true
    @State private var isBulletVisible = false
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Rectangle()
                .fill(.black.opacity(isCollapsed ? 0 : 0.005))
                .frame(
                    maxWidth: .infinity,
                    maxHeight: .infinity
                )
                .onTapGesture {
                    if !isCollapsed {
                        isCollapsed.toggle()
                    }
                }
                .ignoresSafeArea()
            
            RoundedRectangle(
                cornerRadius: 25,
                style: .continuous
            )
            .frame(height: isCollapsed ? 50 : 240)
            .frame(maxWidth: isCollapsed ? 50 : .infinity,)
            .padding(.horizontal)
            .overlay(alignment: isCollapsed ? .center : .bottom) {
                if isCollapsed {
                    Image(systemName: "plus")
                        .foregroundStyle(.background)
                        .font(.title2)
                } else {
                    VStack(alignment: .leading) {
                        RowView("paperplane", "Send")
                        RowView("arrow.trianglehead.2.counterclockwise", "Swap")
                        RowView("arrow.down", "Receive")
                    }
                    .transition(.identity)
                    .opacity(isBulletVisible ? 1 : 0)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                    .onAppear {
                        withAnimation(.easeIn.delay(0.25)) {
                            isBulletVisible = true
                        }
                    }
                    .onDisappear {
                        var transaction = Transaction()
                        transaction.disablesAnimations = true
                        withTransaction(transaction) {
                            isBulletVisible = false
                        }
                        /// withAnimation(nil) is also useful
                    }
                }
            }
            .onTapGesture {
                if isCollapsed {
                    isCollapsed.toggle()
                }
            }
            .animation(.smooth, value: isCollapsed)
        }
    }
    
    @ViewBuilder
    func RowView(_ image: String, _ title: String) -> some View {
        HStack(spacing: 10) {
            Image(systemName: image)
                .font(.title2)
                .frame(width: 45, height: 45)
                .background(.background, in: .circle)
            
            VStack(alignment: .leading, spacing: 10) {
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


#Preview {
    ExpandedInteractionButtonContent()
}

