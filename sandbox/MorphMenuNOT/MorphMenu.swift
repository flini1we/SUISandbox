import SwiftUI

struct MorphMenu: View {
    
    @State private var config: MenuConfig = .init(symbolImage: "plus")
    
    var body: some View {
        CustomMenuView(config: $config) {
            NavigationStack {
                ScrollView(.vertical) {
                    
                }
                .navigationTitle("IMessage")
                .safeAreaInset(edge: .bottom) {
                    BottomBar()
                }
            }
        } actions: {
            MenuAction(symbolImage: "camera", text: "Camera")
            MenuAction(symbolImage: "photo", text: "Photos")
            MenuAction(symbolImage: "video", text: "Videos")
            MenuAction(symbolImage: "mic", text: "Record Audio")
            MenuAction(symbolImage: "doc", text: "Documents")
            MenuAction(symbolImage: "folder", text: "Folders")
            MenuAction(symbolImage: "trash", text: "Trash")
            MenuAction(symbolImage: "square.and.arrow.up", text: "Share")
            MenuAction(symbolImage: "square.and.pencil", text: "Edit")
            MenuAction(symbolImage: "gearshape", text: "Settings")
            MenuAction(symbolImage: "lock", text: "Lock")
            MenuAction(symbolImage: "bell", text: "Notifications")
            MenuAction(symbolImage: "bookmark", text: "Bookmarks")
            MenuAction(symbolImage: "magnifyingglass", text: "Search")
            MenuAction(symbolImage: "questionmark.circle", text: "Help")
        }
    }
    
    @ViewBuilder
    func BottomBar() -> some View {
        HStack(spacing: 12) {
            MenuSourceButton(config: $config) {
                Image(systemName: "plus")
                    .font(.title3)
                    .frame(width: 35, height: 35)
                    .background {
                        Circle()
                            .fill(.gray.opacity(0.25))
                            .background(.background)
                    }
            }
            
            TextField("Message me", text: .constant(""))
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .background {
                    Capsule()
                        .stroke(.gray.opacity(0.3), lineWidth: 1.5)
                }
        }
        .padding(.horizontal)
        .padding(.bottom, 10)
    }
}

#Preview {
    MorphMenu()
}
