//
//  GTCommentModel.swift
//  GTRead
//
//  Created by YangJie on 2021/4/23.
//

import UIKit

struct GTCommentModel: Codable{
    var cnt: Int
    var lists: [GTCommentItem]?
    enum CodingKeys: String, CodingKey {
        case cnt
        case lists
    }
}

struct GTCommentItem: Codable {
    var timestamp: Int
    var author: Dictionary<String, String>?
    var commentContent: String?
    var childCnt: Int
    var commentId: Int
    var childComments: [GTCommentItem]?
    var unfold: Bool = false
    enum CodingKeys: String, CodingKey {
        case timestamp
        case author
        case commentContent
        case childCnt
        case childComments
        case commentId
    }
}




