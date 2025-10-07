struct CapsuleView: View {
    var text: String
    var value: Int

    init(_ text: String, _ value: Int) {
        self.text = text
        self.value = value
    }

    var body: some View {
        HStack(spacing: 20) {
            Text(text)
                .fontWeight(.semibold)
                .foregroundColor(Color(red: 0.22, green: 0.29, blue: 0.34))

            Text(String(value))
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(Color(red: 0.53, green: 0.41, blue: 1))
                .background {
                    Circle()
                        .frame(width: 32, height: 32)
                        .foregroundStyle(
                            LinearGradient(
                                stops: [
                                    Gradient.Stop(
                                        color: Color(
                                            red: 0.96,
                                            green: 0.95,
                                            blue: 1
                                        ),
                                        location: 0.58
                                    ),
                                    Gradient.Stop(
                                        color: Color(
                                            red: 0.96,
                                            green: 0.95,
                                            blue: 1
                                        ).opacity(0),
                                        location: 1.00
                                    ),
                                ],
                                startPoint: UnitPoint(x: 0.5, y: 0),
                                endPoint: UnitPoint(x: 0.5, y: 1.06)
                            )
                        )
                }
        }
        .padding(
            EdgeInsets(top: 8 + 7, leading: 16, bottom: 8 + 7, trailing: 12 + 7)
        )
        .glassEffect()
        .overlay(
            RoundedRectangle(cornerRadius: .infinity, style: .continuous)
                .strokeBorder(.white, lineWidth: 2)
        )
    }
}
