//
//  MateProfileDetails.swift
//  MatchMaking
//
//  Created by Nikhil1 Desai on 03/03/25.
//

import SwiftUI
import SDWebImage
import SDWebImageSwiftUI

struct MateProfileDetails: View {
    @Environment(\.dismiss) private var dismiss
    var mateData: Results
    var mateResponseData: [Results]
    @State var currentIndex: Int
    var onSelection: ((_ id: String?, _ selectionOption: Int) -> Void)
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                HeaderView(handleBottomView: false, handleTrailingImage: false, handleBack: true, onBack: {
                    dismiss()
                }).background(.shaadiBase)
                ScrollView(.horizontal, content: {
                    TabView(selection: $currentIndex) {
                        ForEach(Array(mateResponseData.enumerated()), id: \.offset) { index, content in
                            VStack(spacing: 16){
                                WebImageView(imageURL: content.picture?.large ?? "")
                                    .frame(height: MateSharedManager.shared.screenBounds.height / 3)
                                    .cornerRadius(16)
                                ProfileDetailsView(baseColor: .black, handleTopSpacer: false, mateData: content)
                                HStack {
                                    Text("You & \(MateSharedManager.shared.generateName(from: content))\n have \(Int.random(in: 0...100))% of Match")
                                        .customTextStyle(color: .shaadiBase, font: .system(.headline, design: .rounded, weight: .bold))
                                        .padding(.leading, 8)
                                    Spacer(minLength: 120)
                                }.frame(height: 80).background(.shaadiSecondary).cornerRadius(16).overlay(alignment: .trailing) {
                                    Image("target")
                                        .resizable()
                                        .setContentBaseProperty(size: .init(width: 110, height: 110))
                                }.padding(.top, 24)
                                Spacer()
                                MateSelectionView(imageSize: 100, handleAnimation: false, handleDetailsScreen: true, mateData: content, onSelection: { selection in
                                    switch selection {
                                    case .cancel:
                                        onSelection(mateResponseData[currentIndex].id?.value, 0)
                                    case .like:
                                        onSelection(mateResponseData[currentIndex].id?.value, 1)
                                    case .skip:
                                        withAnimation {
                                            if currentIndex < mateResponseData.count - 1 {
                                                currentIndex += 1
                                            } else {
                                                currentIndex = 0
                                            }
                                        }
                                    case .none:
                                        print("Unkown")
                                    }
                                })
                            }.padding()
                        }.frame(width: MateSharedManager.shared.screenBounds.width).frame(maxHeight: .infinity)
                    }.frame(width: MateSharedManager.shared.screenBounds.width).frame(maxHeight: .infinity)
                        .tabViewStyle(.page)
                })
                .bottomToTopGradient(colors: [.white, .white,.shaadiBase, .shaadiBase])
            }
        }.toolbar(.hidden, for: .navigationBar)
    }
}

