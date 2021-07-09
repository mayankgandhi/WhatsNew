//
//  ContentView.swift
//  WhatsNew
//
//  Created by Mayank Gandhi on 09/07/21.
//

import SwiftUI

struct ContentView: View {
  
  @ObservedObject var viewModels = ListItemViewModel("Ghana", "300")

//  [
//    ListItemViewModel("Ghana", "300"),
//    ListItemViewModel("Ethiopia", "302"),
//    ListItemViewModel("Egypt", "303"),
//    ListItemViewModel("Ghana", "304"),
//    ListItemViewModel("Ghana", "305")
//  ]
  
  func fetchThumbnailUsingAwait(for viewModel: ListItemViewModel) async {
    do {
      try await viewModel.asyncFetchThumbnail()
    } catch  {
      print(error.localizedDescription)
    }
  }
  
    var body: some View {
      NavigationView {
        List {
          ForEach([viewModels]) { viewModel in
            HStack(spacing: 10) {
              Image(uiImage: viewModel.thumbnail ?? UIImage())
                .resizable()
                .frame(width: 100, height: 100, alignment: .center)
              Text(viewModel.title)
              Spacer()
            }
//            .onAppear(perform: viewModel.fetchThumbnail)
            .onAppear(perform: {
              async {
                await fetchThumbnailUsingAwait(for: viewModel)
              }
            })
          }
        }
      }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
