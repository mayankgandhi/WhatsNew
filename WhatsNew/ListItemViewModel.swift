//
//  ListItemViewModel.swift
//  WhatsNew
//
//  Created by Mayank Gandhi on 09/07/21.
//

import Foundation
import SwiftUI
import UIKit

enum FetchError: Error {
  case badID, badImage
}

public class ListItemViewModel: ObservableObject, Identifiable {
  
  @Published var thumbnail: UIImage?
  /// Identifier used for `List` and for fetching unique images.
  public let id: String
  /// `title` of the ListItem
  public let title: String
  
  init(_ title: String, _ id: String) {
    self.title = title
    self.thumbnail = nil
    self.id = id
  }
  
  private func thumbnailURLRequest(for id: String) -> URLRequest {
    let url =  URL(string: "https://picsum.photos")!
      .appendingPathComponent("/300")
    print(url)
    return URLRequest(url: url)
  }
  
  func fetchThumbnail() {
    fetchThumbnail(for: id) { image, error in
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
    async let thumbnailImage = try fetchThumbnail(for: id)
    self.thumbnail = try await thumbnailImage
  }
  
  func fetchThumbnail(
    for id: String,
    completion: @escaping (UIImage?, Error?) -> Void
  ) {
    let request = thumbnailURLRequest(for: id)
    let task = URLSession.shared
      .dataTask(with: request) { data, response, error in
        if let error = error {
          completion(nil, error)
        } else if (response as? HTTPURLResponse)?.statusCode != 200 {
          completion(nil, FetchError.badID)
        } else {
          guard let image = UIImage(data: data!) else {
            completion(nil, FetchError.badImage)
            return
          }
          image.prepareThumbnail(of: CGSize(width: 40, height: 40)) { thumbnail in
            guard let thumbnail = thumbnail else {
              completion(nil, FetchError.badImage)
              return
            }
            completion(thumbnail, nil)
          }
        }
      }
    task.resume()
  }
  
  func fetchThumbnail(for id: String) async throws -> UIImage {
    let request = thumbnailURLRequest(for: id)
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