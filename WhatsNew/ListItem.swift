//
//  ListItem.swift
//  WhatsNew
//
//  Created by Mayank Gandhi on 09/07/21.
//

import Foundation

struct ListItem: Identifiable {
  /// Identifier used for `List` and for fetching unique images.
  public let id: String
  /// `title` of the ListItem
  public let title: String
  
  init(_ title: String, _ id: String) {
    self.title = title
    self.id = id
  }
  
}
