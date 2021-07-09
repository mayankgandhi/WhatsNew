//
//  ListViewModel.swift
//  WhatsNew
//
//  Created by Mayank Gandhi on 09/07/21.
//

import Foundation
import SwiftUI
import Resolver

class ListViewModel: ObservableObject {
  
  @Published var viewModels = [ListItemViewModel]()
  @Injected var imageFetcher: ImageFetcher
  
  let items: [ListItem]
  
  init() {
    self.items = [
      ListItem("Nigeria", "201"),
      ListItem("Egypt", "202"),
      ListItem("Ghana", "203"),
      ListItem("Kenya", "204")
    ]
    items.forEach {
      viewModels.append(ListItemViewModel($0))
    }
  }
  
  /// An Example of Structured Concurrency where the Asynchronous Task Handling is done at Compile time
  func fetchAllThumbnails() async throws {
    await withThrowingTaskGroup(of: Void.self) { group in
      for viewModel in viewModels {
        group.async {
          try await viewModel.asyncFetchThumbnail()
        }
      }
    }
    DispatchQueue.main.async {
      self.viewModels.shuffle()
    }
  }
 
}
