//
//  SortedQuotesViewController.swift
//  Quotes
//
//  Created by Алексей Голованов on 12.11.2023.
//

import UIKit

final class SortedQuotesViewController: UIViewController {
    let coordinator: Coordinatable
    let quotesService = QuotesService.shared
    var quotes: [Quote]
    let isGroup: Bool
    
    private lazy var quotesTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    init(coordinator: Coordinatable, quotes: [Quote], isGroup: Bool = false, title: String = "Отсортированные цитаты") {
        self.coordinator = coordinator
        self.quotes = quotes
        self.isGroup = isGroup
        super.init(nibName: nil, bundle: nil)
        self.title = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(quotesTableView)
        quotesTableView.snp.makeConstraints { $0.top.leading.trailing.bottom.equalToSuperview() }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isGroup {
            quotes = quotesService.getQuotes(category: Category(name: title!))
        } else {
            quotes = quotesService.getQuotes()
        }
        quotesTableView.reloadData()
    }
}

extension SortedQuotesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { quotes.count }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        var content: UIListContentConfiguration = cell.defaultContentConfiguration()
        let quote = quotes[indexPath.row]
        content.text = quote.text
        content.secondaryText = quote.createdAt
        cell.contentConfiguration = content
        return cell
    }
}

extension SortedQuotesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {}
}
