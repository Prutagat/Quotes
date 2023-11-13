//
//  GroupedQuotesViewController.swift
//  Quotes
//
//  Created by Алексей Голованов on 12.11.2023.
//

import UIKit

final class GroupedQuotesViewController: UIViewController {
    let coordinator: GroupedQuotesCoordinator
    let quotesService = QuotesService.shared
    var categories: [Category]
    
    private lazy var categoryTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    init(coordinator: GroupedQuotesCoordinator, categories: [Category]) {
        self.coordinator = coordinator
        self.categories = categories
        super.init(nibName: nil, bundle: nil)
        self.title = "Сгруппированные цитаты"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(categoryTableView)
        categoryTableView.snp.makeConstraints { $0.top.leading.trailing.bottom.equalToSuperview() }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        categories = quotesService.getCategories()
        categoryTableView.reloadData()
    }
}

extension GroupedQuotesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { categories.count }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        var content: UIListContentConfiguration = cell.defaultContentConfiguration()
        let category = categories[indexPath.row]
        let quotesCount = quotesService.getQuotes(category: category).count
        content.text = category.name
        content.secondaryText = "Цитат в категории: " + String(quotesCount)
        cell.contentConfiguration = content
        if quotesCount != 0 { cell.accessoryType = .disclosureIndicator }
        return cell
    }
}

extension GroupedQuotesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = categories[indexPath.row]
        let quotesCount = quotesService.getQuotes(category: category).count
        if quotesCount == 0 { return }
        coordinator.openCategory(category: category.name)
    }
}
