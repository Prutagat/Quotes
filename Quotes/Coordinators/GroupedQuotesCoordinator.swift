//
//  GroupedQuotesCoordinator.swift
//  Quotes
//
//  Created by Алексей Голованов on 12.11.2023.
//

import UIKit

final class GroupedQuotesCoordinator: Coordinatable {
    var navigationController: UINavigationController
    let quotesService = QuotesService.shared
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController = GroupedQuotesViewController(coordinator: self, categories: quotesService.getCategories())
        navigationController.tabBarItem = UITabBarItem(
            title: viewController.title,
            image: UIImage(systemName: "rectangle.3.group.fill"),
            tag: 0)
        navigationController.pushViewController(viewController, animated: true)
        navigationController.navigationBar.topItem!.title = "Назад"
    }
    
    func openCategory(category: String) {
        let viewController = SortedQuotesViewController(coordinator: self, quotes: quotesService.getQuotes(category: Category(name: category)), isGroup: true, title: category)
        navigationController.pushViewController(viewController, animated: true)
    }
}
