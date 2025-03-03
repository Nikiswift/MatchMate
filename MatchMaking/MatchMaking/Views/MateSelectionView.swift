//
//  MateSelectionView.swift
//  MatchMaking
//
//  Created by Nikhil1 Desai on 03/03/25.
//

import SwiftUI

enum SelectionOption {
    case like
    case cancel
    case skip
    case none
}

struct MateSelectionView: View {
    @State private var selectedAction: SelectionOption = .none
    @State private var showText: Bool = false
    @State private var backgroundColor: Color = .clear
    @Namespace private var animation
    var imageSize: CGFloat = 70
    var handleAnimation: Bool = true
    var handleDetailsScreen: Bool = false
    var mateData: Results
    var onSelection: ((_ selectionOption: SelectionOption) -> Void)
    var body: some View {
        HStack(spacing: 16) {
            Spacer()
            Image("cancel")
                .resizable()
                .foregroundColor(.red)
                .setContentBaseProperty(size: .init(width: imageSize/2, height: imageSize/2))
                .opacity(self.checkSelectionPresent() ? 0 : selectedAction == .none ? 1 : selectedAction == .skip ? 1 : 0)
                .onTapGesture {
                    self.performAction(.cancel)
                }
            Image("like")
                .resizable()
                .foregroundColor(.shaadiPrimary)
                .setContentBaseProperty(size: .init(width: imageSize, height: imageSize))
                .opacity(self.checkSelectionPresent() ? 0 : selectedAction == .none ? 1 : selectedAction == .skip ? 1 : 0)
                .onTapGesture {
                    self.performAction(.like)
                }
            Image("next")
                .resizable()
                .foregroundColor(.shaadiSecondary)
                .setContentBaseProperty(size: .init(width: imageSize/2, height: imageSize/2))
                .opacity(self.checkSelectionPresent() ? 0 : selectedAction == .skip ? 1 : 1)
                .onTapGesture {
                    self.performAction(.skip)
                }
            Spacer()
        }.overlay {
            if checkSelectionPresent() && !handleDetailsScreen {
                Color.shaadiPrimary
                    .clipped()
                    .animation(.easeInOut(duration: 0.3), value: backgroundColor)
            } else if handleDetailsScreen {
                Color.clear
            } else {
                backgroundColor
            }
            if showText || mateData.selectionType == 0 || mateData.selectionType == 1 {
                if handleDetailsScreen {
                    Text((mateData.selectionType == 0 || selectedAction == .cancel) ? "Rejected" : (mateData.selectionType == 1 || selectedAction == .like) ? "Accepted" : "")
                        .customTextStyle(color: .shaadiPrimary.opacity(0.7), font: .system(.largeTitle, design: .rounded, weight: .bold))
                } else {
                    Text((mateData.selectionType == 0 || selectedAction == .cancel) ? "Rejected" : (mateData.selectionType == 1 || selectedAction == .like) ? "Accepted" : "")
                        .customTextStyle(color: .white.opacity(0.7), font: .system(.largeTitle, design: .rounded, weight: .bold))
                }
            }
        }
        
    }
    
    private func checkSelectionPresent() -> Bool {
        return (mateData.selectionType == 1 || mateData.selectionType == 0)
    }
    
    private func performAction(_ action: SelectionOption) {
        if handleAnimation {
            withAnimation {
                selectedAction = action
                showText = true
                backgroundColor = (action == .like) ? .shaadiPrimary : (action == .cancel) ? .red : .clear
                onSelection(action)
            }
        } else if handleDetailsScreen {
            selectedAction = action
            showText = true
            backgroundColor = (action == .like) ? .shaadiPrimary : (action == .cancel) ? .red : .clear
            onSelection(action)
        } else {
            self.selectedAction = action
            onSelection(action)
        }
        
        // Provide haptic feedback
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
        
    }
}
