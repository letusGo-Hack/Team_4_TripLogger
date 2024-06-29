//
//  ArticleRepository.swift
//  TripLogger
//
//  Created by 현기엽 on 6/29/24.
//

import SwiftData

@MainActor
protocol ArticleRepository {
    func insertArticle(_ article: Article) throws
    
    func fetchArticles() throws -> [Article]?
}

extension ArticleRepository {
    func locations() throws -> [Location]? {
        try fetchArticles()?
            .map { article in
                Location(latitude: article.latitude, longitude: article.longitude)
            }
    }
}

final class ArticleArrayRepository: ArticleRepository {
    private var articles: [Article] = []
    
    func insertArticle(_ article: Article) throws {
        articles.append(article)
    }
    
    func fetchArticles() throws -> [Article]? {
        return self.articles
    }
}


//@MainActor
//final class ArticleRepositoryImpl: ArticleRepository {
//    private let container: ModelContainer
//
//    init() throws {
//        container = try ModelContainer(for: Article.self)
//    }
//    
//    func insertArticle(_ article: Article) throws {
//        try articles()?.forEach {
//            container.mainContext.delete($0)
//        }
//        container.mainContext.insert(article)
//        try container.mainContext.save()
//        try print(articles()?.first?.content)
//    }
//    
//    func articles() throws -> [Article]? {
//        let descriptor = FetchDescriptor<Article>()
//        return try container.mainContext.fetch(descriptor)
//    }
//}
