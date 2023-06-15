import SwiftUI

struct LightView: View {
    var isOn: Bool = false
    
    var body: some View {
        Rectangle()
            .frame(width: 30, height: 30)
            .border(Color.primary, width: 2)
            .padding(5)
            .foregroundColor(isOn ? .green : .clear)
    }
}

struct LightView_Previews: PreviewProvider {
    static var previews: some View {
        LightView()
            .previewDisplayName("Off")
        LightView(isOn: true)
            .previewDisplayName("On")
    }
}
