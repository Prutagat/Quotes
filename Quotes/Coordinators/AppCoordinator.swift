//
//  AppCoordinator.swift
//  Quotes
//
//  Created by Алексей Голованов on 12.11.2023.
//

import UIKit

enum Controller {
    case randomQuote
    case sortedQuotes
}

final class AppCoordinator: Coordinatable {
    var navigationController: UINavigationController
    let quotesService = QuotesService.shared
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        navigationController.navigationBar.isHidden = true
        let tabBarController = UITabBarController()
        let randomQuoteNavigationController = getNavigationController(controller: .randomQuote)
        let sortedQuotesNavigationController = getNavigationController(controller: .sortedQuotes)
        let groupedQuotesCoordinator = GroupedQuotesCoordinator(navigationController: UINavigationController())
        groupedQuotesCoordinator.start()
        tabBarController.viewControllers = [randomQuoteNavigationController, sortedQuotesNavigationController, groupedQuotesCoordinator.navigationController]
        navigationController.pushViewController(tabBarController, animated: true)
    }
    
    func getNavigationController(controller: Controller) -> UINavigationController {
        let navigationController = UINavigationController()
        var viewController = UIViewController()
        
        switch controller {
        case .randomQuote:
            viewController = RandomQuoteViewController(coordinator: self)
            navigationController.tabBarItem = UITabBarItem(
                title: viewController.title,
                image: UIImage(systemName: "doc.questionmark.fill"),
                tag: 0)
        case .sortedQuotes:
            viewController = SortedQuotesViewController(coordinator: self, quotes: quotesService.getQuotes())
            navigationController.tabBarItem = UITabBarItem(
                title: viewController.title,
                image: UIImage(systemName: "list.clipboard.fill"),
                tag: 0)
        }
        navigationController.pushViewController(viewController, animated: true)
        return navigationController
    }
}
