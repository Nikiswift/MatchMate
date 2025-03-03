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
                    }
                }).bottomToTopGradient(colors: [.shaadiBase, .shaadiBase, .white])
            }
        }.refreshable {
            self.fetchResponse(paging: 10)
            print("Refresh")
        }.onAppear(perform: {
            self.fetchResponse(paging: 10)
        })
    }
    private func fetchResponse(paging: Int) {
        Task {
            await viewModel.getMatesData(page: paging, loadLoacal: false)
        }
    }
    
}

#Preview {
    ContentView()
}

