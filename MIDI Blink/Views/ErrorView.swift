import SwiftUI

struct ErrorView: View {
    var body: some View {
        HStack {
            Image(systemName: "exclamationmark.triangle")
            Text("There was a MIDI error, so the information below may not be correct. Sorry!")
        }
        .padding()
        .frame(minWidth: 0, maxWidth: .infinity)
        .background(Color("WarningColor"))
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView()
    }
}
