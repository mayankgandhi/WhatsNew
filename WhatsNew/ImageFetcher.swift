//
//  ImageFetcher.swift
//  WhatsNew
//
//  Created by Mayank Gandhi on 09/07/21.
//

import Foundation
import UIKit

final class ImageFetcher {
  
  func thumbnailURLRequest(for id: String) -> URLRequest {
    let url =  URL(string: "https://picsum.photos")!
      .appendingPathComponent("/300")
    return URLRequest(url: url)
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
