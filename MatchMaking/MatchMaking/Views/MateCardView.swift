//
//  MateCardView.swift
//  MatchMaking
//
//  Created by Nikhil1 Desai on 03/03/25.
//
import SwiftUI
import SDWebImage
import SDWebImageSwiftUI

struct MateCardView: View {
    var mateData: Results
    var height: CGFloat = MateSharedManager.shared.screenBounds.height / 3
    var onSelection: ((_ id: String?, _ selectionOption: Int) -> Void)
    var body: some View {
        ZStack(alignment: .top) {
            WebImageView(imageURL: mateData.picture?.large ?? "")
                .frame(height: height)
            ProfileDetailsView(mateData: mateData).padding()
                .bottomToTopGradient(colors: [.black.opacity(0.5),.clear,.clear]).padding(.bottom, 70)
            MateSelectionView(mateData: mateData, onSelection: { selection in
                switch selection {
                case .cancel:
                    onSelection(mateData.id?.value, 0)
                case .like:
                    onSelection(mateData.id?.value, 1)
                case .skip:
                    print("Skip")
                    onSelection(mateData.id?.value, 3)
                case .none:
                    print("Unkown")
                }
            }).frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        }.frame(maxWidth: .infinity).frame(height: height + 70).background(.shaadiBackGround)
    }
    
}


struct ProfileDetailsView: View {
    var baseColor: Color = .white
    var handleTopSpacer: Bool = true
    var mateData: Results
    var body: some View {
        VStack(alignment: .leading) {
            if handleTopSpacer {
                Spacer()
            }
            HStack {
                Text(MateSharedManager.shared.generateName(from: mateData))
                    .customTextStyle(color: baseColor, font: .system(.headline, design: .rounded, weight: .bold))
                if let gender = mateData.gender {
                    Image(gender)
                        .resizable()
                        .foregroundColor(baseColor)
                        .setContentBaseProperty(size: .init(width: 12, height: 12))
                }
            }
            HStack {
                Image(systemName: "mappin.and.ellipse")
                    .setContentBaseProperty(size: .init(width: 24, height: 24))
                    .foregroundColor(baseColor)
                    .padding(.leading, -4)
                Text(MateSharedManager.shared.generateLocation(from: mateData))
                    .customTextStyle(color: baseColor, font: .system(.subheadline, design: .rounded, weight: .bold))
                Spacer()
                Text(MateSharedManager.shared.generateAge(from: mateData))
                    .customTextStyle(color: baseColor, font: .system(.subheadline, design: .rounded, weight: .bold))
            }
        }
    }
}

