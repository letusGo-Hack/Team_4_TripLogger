//
//  ArticleRepository.swift
//  TripLogger
//
//  Created by 현기엽 on 6/29/24.
//

import SwiftData

@MainActor
protocol ArticleRepository {
    func insertArticle(_ article: Article)
    
    func articles() throws -> [Article]?
}

extension ArticleRepository {
    func locations() throws -> [Location]? {
        try articles()?
            .map { article in
                Location(latitude: article.latitude, longitude: article.longitude)
            }
    }
}

@MainActor
final class ArticleRepositoryImpl: ArticleRepository {
    private let container: ModelContainer

    init() throws {
        container = try ModelContainer(for: Article.self)
    }
    
    func insertArticle(_ article: Article) {
        container.mainContext.insert(article)
    }
    
    func articles() throws -> [Article]? {
        let descriptor = FetchDescriptor<Article>()
        return try container.mainContext.fetch(descriptor)
    }
}
