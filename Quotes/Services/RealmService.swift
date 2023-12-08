//
//  RealmService.swift
//  Quotes
//
//  Created by Алексей Голованов on 12.11.2023.
//

import UIKit
import RealmSwift

final class CategoryModel: Object {
    @Persisted var name: String
    @Persisted var quotes = List<QuoteModel>()
}

final class QuoteModel: Object {
    @Persisted var category: CategoryModel?
    @Persisted var createdAt: String
    @Persisted var text: String
}

final class RealmService {
    static let shared = RealmService()
    let realm: Realm
    
    private init() {
        do {
            let key: [UInt8] = [0x20, 0x53, 0x75, 0x70, 0x65, 0x72, 0x50, 0x75, 0x70, 0x65, 0x72, 0x4b, 0x65, 0x79, 0x31, 0x2c, 0x20, 0x53, 0x75, 0x70, 0x65, 0x72, 0x50, 0x75, 0x70, 0x65, 0x72, 0x4b, 0x65, 0x79, 0x32, 0x2c, 0x20, 0x53, 0x75, 0x70, 0x65, 0x72, 0x50, 0x75, 0x70, 0x65, 0x72, 0x4b, 0x65, 0x79, 0x33, 0x2c, 0x20, 0x53, 0x75, 0x70, 0x65, 0x72, 0x50, 0x75, 0x70, 0x65, 0x72, 0x4b, 0x65, 0x79, 0x34, 0x20]
            let config = Realm.Configuration(encryptionKey: Data(key))
            self.realm = try Realm(configuration: config)
        } catch let error{
            fatalError(error.localizedDescription)
        }
    }
    
    func getCategories() -> [Category] {
        let categoriesModels = realm.objects(CategoryModel.self).sorted(byKeyPath: "name")
        var categories: [Category] = []
        categoriesModels.forEach({ categories.append(Category(name: $0.name)) })
        return categories
    }
    
    func addCategory(category: Category) {
        let categoriesModels = realm.objects(CategoryModel.self).filter("name == %@", category.name)
        if categoriesModels.count != 0 { return }
        let categoryModel = CategoryModel()
        categoryModel.name = category.name
        try! realm.write { realm.add(categoryModel) }
    }
    
    func addQuote(quote: Quote) {
        let quotesModels = realm.objects(QuoteModel.self).filter("text == %@", quote.text)
        if quotesModels.count != 0 { return }
        let quoteModel = QuoteModel()
        let category = realm.objects(CategoryModel.self).filter("name == %@", quote.category).first!
        quoteModel.createdAt = quote.createdAt
        quoteModel.text = quote.text
        quoteModel.category = category
        try! realm.write {
            category.quotes.append(quoteModel)
            realm.add(category)
        }
    }
    
    func getQuotes(sortedKey: String = "createdAt") -> [Quote] {
        let quotesModels = realm.objects(QuoteModel.self).sorted(byKeyPath: sortedKey)
        var quotes: [Quote] = []
        quotesModels.forEach({ quotes.append(Quote(quoteModel: $0)) })
        return quotes
    }
    
    func getQuotes(category: Category, sortedKey: String = "createdAt") -> [Quote] {
        let categoryModel = realm.objects(CategoryModel.self).filter("name == %@", category.name).first!
        let quotesModels = realm.objects(QuoteModel.self).filter("category == %@", categoryModel).sorted(byKeyPath: sortedKey)
        var quotes: [Quote] = []
        quotesModels.forEach({ quotes.append(Quote(quoteModel: $0)) })
        return quotes
    }
}

extension RealmService: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any { return self }
}
