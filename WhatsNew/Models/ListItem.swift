//
//  ListItem.swift
//  WhatsNew
//
//  Created by Mayank Gandhi on 09/07/21.
//

import Foundation
import UIKit
import Resolver

struct ListItem: Identifiable {
  /// Identifier used for `List` and for fetching unique images.
  public let id: String
  /// `title` of the ListItem
  public let title: String
  
  public var thumbnail: UIImage {
    get async throws {
      try await fetchThumbnail(for: id)
    }
  }
  
  init(_ title: String, _ id: String) {
    self.title = title
    self.id = id
  }
  
  func fetchThumbnail(for id: String) async throws -> UIImage {
    @Injected var imageFetcher: ImageFetcher
    
    let request = imageFetcher.thumbnailURLRequest(for: id)
    let (data, response) = try await URLSession.shared.data(for: request)
    guard (response as? HTTPURLResponse)?.statusCode == 200 else {
      throw FetchError.badID
    }
    let maybeImage = UIImage(data: data)
    guard let thumbnail = maybeImage else {
      throw FetchError.badImage
    }
    return thumbnail
  }
}
