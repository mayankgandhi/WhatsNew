//
//  ContentView.swift
//  WhatsNew
//
//  Created by Mayank Gandhi on 09/07/21.
//

import SwiftUI

struct ContentView: View {
  
  @StateObject var itemViewModel = ListItemViewModel(ListItem("Nigeria", "300"))
  @StateObject var viewModel = ListViewModel()
  
  @State var searchText = ""
  
  var body: some View {
    NavigationView {
      List {
        ForEach(viewModel.viewModels.filter({ item in
          item.title.hasPrefix(searchText)
        })) { listItem in
          HStack(spacing: 10) {
            Image(uiImage: listItem.thumbnail ?? UIImage())
              .resizable()
              .frame(width: 100, height: 100, alignment: .center)
            Text(listItem.title)
            Spacer()
          }
//          .onAppear(perform: listItem.fetchThumbnailWithCompletion)
//          .onAppear {
//            async {
//              await fetchThumbnailUsingAwait(for: listItem)
//            }
//          }
        }
      }
      .onAppear {
        async {
          await fetchAllThumbnailsUsingTaskGroup()
        }
      }
      .searchable(text: $searchText)
      .refreshable(action: fetchAllThumbnailsUsingTaskGroup)
      .navigationTitle("Countries in Africa")
    }
  }
  
  private func fetchThumbnailUsingAwait(for listItem: ListItemViewModel) async {
    do {
      try await listItem.asyncFetchThumbnail()
    } catch  {
      print(error.localizedDescription)
    }
  }
  
  private func fetchAllThumbnailsUsingTaskGroup() async {
    do {
      try await viewModel.fetchAllThumbnails()
    } catch  {
      print(error.localizedDescription)
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
