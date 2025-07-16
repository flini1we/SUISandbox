import SwiftUI

struct ResizableScrollHeader<
    Header: View,
    StickyHeader: View,
    Background: View,
    Content: View
>: View {
    
    var spacing: CGFloat = 10
    @ViewBuilder var header: Header
    @ViewBuilder var stickyHeader: StickyHeader
    @ViewBuilder var background: Background
    @ViewBuilder var content: Content
    
    var body: some View {
        ScrollView(.vertical) {
            content
        }
        .frame(maxWidth: .infinity)
        .safeAreaInset(edge: .top) {
            CombineHeaderView()
        }
    }
    
    @ViewBuilder
    func CombineHeaderView() -> some View {
        VStack(spacing: spacing) {
            header
            
            stickyHeader
        }
        .background {
            background
                .ignoresSafeArea()
        }
    }
}

struct ResizableScrollHeaderContent: View {
    var body: some View {
        ResizableScrollHeader {
            HStack(spacing: 12) {
                Button { } label: {
                    Image(systemName: "chevron.left")
                        .font(.title3)
                }
                
                Spacer(minLength: 0)
                
                Button { } label: {
                    Image(systemName: "magnifyingglass")
                        .font(.title3)
                }
                
                Button { } label: {
                    Image(systemName: "bubble")
                        .font(.title3)
                }
            }
            .overlay(content: {
                Text("Apple store")
                    .fontWeight(.semibold)
            })
            .foregroundStyle(.primary)
            .padding(.horizontal, 15)
            .padding(.top, 15)
        } stickyHeader: {
            HStack {
                Text("Total \(25)")
                    .fontWeight(.semibold)
                
                Spacer(minLength: 0)
                
                Button { } label: {
                    Image(systemName: "slider.vertical.3")
                        .font(.title3)
                }
            }
            .foregroundStyle(.primary)
            .padding(.horizontal, 15)
            .padding(.vertical, 10)
        } background: {
            Rectangle()
                .fill(.ultraThinMaterial)
                .overlay(alignment: .bottom) {
                    Divider()
                }
        } content: {
            VStack(spacing: 15) {
                ForEach(0..<100, id: \.self) { _ in
                    RoundedRectangle(cornerRadius: 15)
                        .fill(.gray.opacity(0.35))
                        .frame(height: 50)
                }
            }
            .padding(15)
        }
    }
}

#Preview {
    ResizableScrollHeaderContent()
}
