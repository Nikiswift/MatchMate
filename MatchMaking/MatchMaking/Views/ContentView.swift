//
//  ContentView.swift
//  MatchMaking
//
//  Created by Nikhil1 Desai on 28/02/25.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var viewModel: MateViewModel
    @State private var selectedIndex: Int? = nil
    var initialPagining: Int = 10
    var body: some View {
        NavigationStack {
            ScrollViewReader { proxy in
                ScrollView(.vertical, content: {
                    HeaderView(onBack: {})
                    LazyVStack {
                        if !viewModel.responseData.isEmpty {
                            ForEach(Array($viewModel.responseData.enumerated()), id: \.offset) { index, content in
                                NavigationLink(destination: MateProfileDetails(mateData: content.wrappedValue, mateResponseData: viewModel.responseData, currentIndex: index, onSelection: { id, selectionType in
                                    viewModel.updateSelectionValue(with: id, selection: selectionType)
                                })) {
                                    MateCardView(mateData: content.wrappedValue, onSelection: { id, selection in
                                        if selection == 0 || selection == 1 {
                                            viewModel.updateSelectionValue(with: id, selection: selection)
                                        }
                                        if index + 1 < viewModel.responseData.count {
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                                withAnimation {
                                                    selectedIndex = index + 1
                                                    proxy.scrollTo(selectedIndex, anchor: .top)
                                                }
                                            }
                                        }
                                    })
                                    .onAppear {
                                        //MARK: Trigger Pagination when reaching the last item
                                        if index == viewModel.responseData.count - 1 {
                                            self.fetchResponse(paging: viewModel.responseData.count + 10)
                                        }
                                    }.cornerRadius(16).padding().shadow(color: .gray.opacity(0.4),radius: 2).id(index)
                                }
                            }
                        } else {
                            self.defaultView()
                                .frame(maxWidth: .infinity)
                                .frame(height: MateSharedManager.shared.screenBounds.height/2)
                        }
                    }
                }).bottomToTopGradient(colors: [.shaadiBase, .shaadiBase, .white])
            }
        }.refreshable {
            self.fetchResponse(paging: initialPagining)
            print("Refresh")
        }.onAppear(perform: {
            if self.viewModel.responseData.isEmpty {
                Task {
                    await viewModel.getMatesData(page: initialPagining, loadLoacal: true)
                }
            }
            self.fetchResponse(paging: initialPagining)
        })
    }
    private func fetchResponse(paging: Int) {
        Task.detached {
            await viewModel.getMatesData(page: paging, loadLoacal: false)
        }
    }
    
    @ViewBuilder
    func defaultView() -> some View {
        VStack(alignment: .center){
                Image("ShaadiLogo")
                    .resizable()
                    .opacity(0.5)
                    .scaledToFit()
                    .frame(width: 100, height: 100)

                Button(action: {
                    self.fetchResponse(paging: initialPagining)
                }, label: {
                    Text("Get Your Matches")
                        .foregroundColor(.shaadiPrimary.opacity(0.5))
                        .customTextStyle(font: .system(.largeTitle, design: .rounded, weight: .heavy))
                })
            }
    }
}

#Preview {
    ContentView()
}

