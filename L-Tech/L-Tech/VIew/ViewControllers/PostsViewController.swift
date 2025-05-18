//
//  PostsViewController.swift
//  L-Tech
//
//  Created by emil kurbanov on 16.05.2025.
//

import UIKit

final class PostsViewController: UIViewController {
    private var posts: [Post] = []
    private var sortedPosts: [Post] = []
    private let tableView = UITableView()

    private enum SortMode {
        case bySort
        case byDate
    }

    private var currentSortMode: SortMode = .bySort

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Посты"
        view.backgroundColor = .white

        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(closeTapped)
        )

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Сортировка",
            style: .plain,
            target: self,
            action: #selector(sortTapped)
        )

        setupTableView()
        loadPosts()
    }

    @objc private func closeTapped() {
        dismiss(animated: true, completion: nil)
    }

    @objc private func sortTapped() {
        switch currentSortMode {
        case .bySort:
            currentSortMode = .byDate
        case .byDate:
            currentSortMode = .bySort
        }
        sortAndReload()
    }

    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(PostCell.self, forCellReuseIdentifier: "PostCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100

        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }

    private func loadPosts() {
        API.fetchPosts { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let posts):
                    self?.posts = posts
                    self?.sortAndReload()
                case .failure(let error):
                    print("Ошибка загрузки постов: \(error)")
                }
            }
        }
    }

    private func sortAndReload() {
        switch currentSortMode {
        case .bySort:
            sortedPosts = posts.sorted(by: { $0.sort < $1.sort })
            navigationItem.rightBarButtonItem?.title = "По дате"
        case .byDate:
            let formatter = ISO8601DateFormatter()
            sortedPosts = posts.sorted {
                guard let d1 = formatter.date(from: $0.date),
                      let d2 = formatter.date(from: $1.date) else { return false }
                return d1 > d2 
            }
            navigationItem.rightBarButtonItem?.title = "По умолчанию"
        }
        tableView.reloadData()
    }
}

extension PostsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sortedPosts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostCell
        let post = sortedPosts[indexPath.row]
        cell.configure(with: post)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = sortedPosts[indexPath.row]
        let detailVC = PostDetailViewController(post: post)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

