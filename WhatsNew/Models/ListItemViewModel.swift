//
//  ListItemViewModel.swift
//  WhatsNew
//
//  Created by Mayank Gandhi on 09/07/21.
//

import Foundation
import SwiftUI
import UIKit
import Resolver

enum FetchError: Error {
  case badID, badImage
}

public class ListItemViewModel: ObservableObject, Identifiable {
  
  @Published var thumbnail: UIImage?
  @Injected var imageFetcher: ImageFetcher
  
  let item: ListItem
  
  public var title: String {
    item.title
  }
  
  init(_ item: ListItem) {
    self.item = item
    self.thumbnail = nil
  }
  
  func fetchThumbnailWithCompletion() {
    imageFetcher.fetchThumbnail(for: item.id) { image, error in
      guard error == nil else {
        print(error!)
        return
      }
      DispatchQueue.main.async {
        self.thumbnail = image
      }
    }
  }
  
  func asyncFetchThumbnail() async throws {
    async let thumbnailImage = try imageFetcher.fetchThumbnail(for: item.id)
    let image = try await thumbnailImage
    DispatchQueue.main.async {
      self.thumbnail = image
      print(self.thumbnail)
    }
  }
  
  
  
}
