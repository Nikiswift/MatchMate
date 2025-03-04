//
//  HeaderView.swift
//  MatchMaking
//
//  Created by Nikhil1 Desai on 03/03/25.
//

import SwiftUI

struct HeaderView: View {
    var handleBottomView: Bool = true
    var handleTrailingImage: Bool = true
    var handleBack: Bool = false
    var onBack: (() -> Void)
    var body: some View {
        LazyVStack(spacing: 8){
            HeaderTopView(leadImageName: MateSharedManager.shared.projectLogo, trailImageName: MateSharedManager.shared.headerTrailImage, title: MateSharedManager.shared.projectName, handleTrailingImage: handleTrailingImage, handleBack: handleBack, onBack: {
                onBack()
            })
            if handleBottomView {
                HeaderBottomView(title: MateSharedManager.shared.headerHeading)
            }
        }.padding(.horizontal)
    }
}

struct HeaderTopView: View {
    let leadImageSize: CGSize = .init(width: 40, height: 40)
    let trailImageSize: CGSize = .init(width: 30, height: 30)
    var leadImageName: String
    var trailImageName: String
    var title: String
    var handleTrailingImage: Bool = true
    var handleBack: Bool = false
    var onBack: (() -> Void)
    var body: some View {
        HStack {
            if handleBack {
                Image(systemName: "chevron.backward")
                    .foregroundColor(.shaadiPrimary)
                    .setContentBaseProperty(size: trailImageSize)
                    .onTapGesture {
                        onBack()
                    }
            }
            Image(leadImageName)
                .resizable()
                .setContentBaseProperty(size: leadImageSize)
            Text(title)
                .customTextStyle(color: .black, font: .system(.title, design: .rounded, weight: .bold))
            Spacer()
            if handleTrailingImage {
                Image(systemName: trailImageName)
                    .resizable()
                    .foregroundColor(.shaadiPrimary)
                    .setContentBaseProperty(size: trailImageSize)
            }
        }
    }
}

struct HeaderBottomView: View {
    var title: String
    var body: some View {
        Text(title)
            .customTextStyle(color: .black.opacity(0.7), font: .system(.title2, design: .rounded, weight: .medium))
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
}

