//
//  ViewExtensions.swift
//  MatchMaking
//
//  Created by Nikhil1 Desai on 03/03/25.
//

import SwiftUI
import SDWebImageSwiftUI
import SwiftUI

// MARK: Color Extension
extension Color {
    static let baseColor = Color("shaadi_Base")
    static let primaryColor = Color("shaadi_Primary")
    static let secondaryColor = Color("shaadi_Secondary")
}

// MARK: Content Size Modifier
struct ContentSizeModifiers: ViewModifier {
    var size: CGSize
    var bgColor: Color
    var radius: CGFloat
    var padding: EdgeInsets
    func body(content: Content) -> some View {
        content
            .frame(width: size.width, height: size.height)
            .background(bgColor)
            .cornerRadius(radius)
            .padding(padding)
    }
}


extension View {
    func setContentBaseProperty(size: CGSize, bgColor: Color = .clear, radius: CGFloat = 0, padding: EdgeInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)) -> some View {
        self.modifier(ContentSizeModifiers(size: size, bgColor: bgColor, radius: radius, padding: padding))
    }
}

// MARK: Custom Text Modifier
struct CustomTextModifier: ViewModifier {
    var color: Color
    var font: Font
    var size: CGFloat

    func body(content: Content) -> some View {
        content
            .foregroundColor(color)
            .font(self.font)
    }
}


extension View {
    func customTextStyle(color: Color = .primary, font: Font = .body, size: CGFloat = 16) -> some View {
        self.modifier(CustomTextModifier(color: color, font: font, size: size))
    }
}

// MARK: Gradient Modifier
struct BottomToTopGradientModifier: ViewModifier {
    var colors: [Color]

    func body(content: Content) -> some View {
        content
            .background(
                LinearGradient(
                    gradient: Gradient(colors: colors),
                    startPoint: .bottom,
                    endPoint: .top
                )
            )
    }
}

extension View {
    func bottomToTopGradient(colors: [Color] = [.clear, .clear]) -> some View {
        self.modifier(BottomToTopGradientModifier(colors: colors))
    }
}


// MARK: Async Image View
struct WebImageView: View {
    var imageURL: String

    var body: some View {
        WebImage(url: URL(string: imageURL))
            .resizable()
            .indicator(.activity)
            .transition(.fade(duration: 0.3))
            .background(
                Image(systemName: "person.crop.circle")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.gray)
            )
    }
}


