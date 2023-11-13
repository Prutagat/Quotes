//
//  QuotesService.swift
//  Quotes
//
//  Created by Алексей Голованов on 12.11.2023.
//

import UIKit
import RealmSwift

struct Category {
    let name: String
}

struct Quote {
    let category: String
    let createdAt: String
    let text: String
    
    init(categoty: String, createdAt: String, text: String) {
        self.category = categoty
        self.createdAt = createdAt
        self.text = text
    }
    
    init(dictionary: [String: Any]) {
        let categories = dictionary["categories"] as! Array<String>
        self.category = categories[0]
        self.createdAt = dictionary["created_at"] as! String
        self.text = dictionary["value"] as! String
    }
    
    init(quoteModel: QuoteModel) {
        self.category = quoteModel.category?.name ?? ""
        self.createdAt = quoteModel.createdAt
        self.text = quoteModel.text
    }
}

final class QuotesService {
    static let shared = QuotesService()
    let realmService = RealmService.shared
    
    private init() {}
    
    func getRandomQuote(completion: @escaping (_ quote: Quote) -> Void) {
        var categories = realmService.getCategories()
        if categories.count == 0 {
            addAllCategories { newCategories in
                categories = newCategories
                self.requestQuote(category: categories.randomElement()!.name) { completion($0) }
            }
        } else {
            self.requestQuote(category: categories.randomElement()!.name) { completion($0) }
        }
    }
    
    private func addAllCategories(completion: @escaping (_ categories: [Category]) -> Void) {
        let url = URL(string: "https://api.chucknorris.io/jokes/categories")!
        let session = URLSession.shared
        let sessionDataTask = session.dataTask(with: url) { [weak self] data, response, error in
            if let error {
                print("Ошибка: \(error.localizedDescription)")
                return
            }
            
            if  let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 { return }
            
            guard let data else {
                print("Нет данных!")
                return
            }
            
            do {
                let jsonData = try JSONSerialization.jsonObject(with: data, options: [])
                if let array = jsonData as? NSArray {
                    DispatchQueue.main.async {
                        var categories: [Category] = []
                        array.forEach { value in
                            let category = Category(name: value as! String)
                            categories.append(category)
                            self?.realmService.addCategory(category: category)
                        }
                        completion(categories)
                    }
                }
            } catch {
                print("Ошибка обработки JSON: \(error.localizedDescription)")
            }
            
        }
        sessionDataTask.resume()
    }
    
    private func requestQuote(category: String, completion: @escaping (_ quote: Quote) -> Void) {
        let url = URL(string: "https://api.chucknorris.io/jokes/random?category=\(category)")!
        let session = URLSession.shared
        let sessionDataTask = session.dataTask(with: url) { [weak self] data, response, error in
            if let error {
                print("Ошибка: \(error.localizedDescription)")
                return
            }
            
            if  let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 { return }
            
            guard let data else {
                print("Нет данных!")
                return
            }
            
            do {
                let jsonData = try JSONSerialization.jsonObject(with: data, options: [])
                if let dictionary = jsonData as? [String: Any] {
                    DispatchQueue.main.async {
                        let quote = Quote.init(dictionary: dictionary)
                        self?.realmService.addQuote(quote: quote)
                        completion(quote)
                    }
                }
            } catch {
                print("Ошибка обработки JSON: \(error.localizedDescription)")
            }
            
        }
        sessionDataTask.resume()
    }
  
    func getQuotes() -> [Quote] {
        return realmService.getQuotes()
    }
    
    func getQuotes(category: Category) -> [Quote] {
        return realmService.getQuotes(category: category)
    }
    
    func getCategories() -> [Category] {
        return realmService.getCategories()
    }
    
}

extension QuotesService: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any { return self }
}
