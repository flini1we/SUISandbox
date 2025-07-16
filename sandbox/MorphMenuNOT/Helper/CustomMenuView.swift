import SwiftUI

struct CustomMenuView<Content: View>: View {
    
    @Binding var config: MenuConfig
    @ViewBuilder var content: Content
    @MenuActionBuilder var actions: [MenuAction]
    
    @State private var animateContent = false
    
    var body: some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay {
                Rectangle()
                    .fill(.bar)
                    .ignoresSafeArea()
                    .opacity(animateContent ? 1 : 0)
                    .allowsTightening(false)
            }
            .onChange(of: config.showMenu) { oldValue, newValue in
                withAnimation(.smooth) {
                    animateContent = newValue 
                }
            }
    }
}

struct MenuSourceButton<Content: View>: View {
    
    @Binding var config: MenuConfig
    @ViewBuilder var content: Content
    
    var body: some View {
        content
            .contentShape(.rect)
            .onTapGesture {
                config.sourceView = .init(content)
                config.showMenu.toggle()
            }
            .onGeometryChange(for: CGRect.self) {
                $0.frame(in: .global)
            } action: { newValue in
                config.sourceLocation = newValue
            }
            /// 
        }
}

struct MenuConfig {
    var symbolImage: String
    var sourceLocation: CGRect = .zero
    var showMenu = false
    var sourceView: AnyView = .init(EmptyView()) /// scaling effect
    var hideSourceView = false
}

struct MenuAction: Identifiable {
    var id: String {
        UUID().uuidString
    }
    var symbolImage: String
    var text: String
    var action: (() -> Void) = { }
}

@resultBuilder
struct MenuActionBuilder {
    static func buildBlock(_ components: MenuAction...) -> [MenuAction] {
        components.compactMap{ $0 }
    }
}
