
import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.2)
                .ignoresSafeArea()
            ProgressView()
             .progressViewStyle(CircularProgressViewStyle())
             .scaleEffect(2)
             .padding()
        }
    }
}
