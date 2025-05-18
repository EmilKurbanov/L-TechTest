//
//  PostDetailViewController.swift
//  L-Tech
//
//  Created by emil kurbanov on 16.05.2025.
//

import UIKit

final class PostDetailViewController: UIViewController {
    private let post: Post

    private let titleLabel = UILabel()
    private let imageView = UIImageView()
    private let bodyLabel = UILabel()
    private let dateLabel = UILabel()

    init(post: Post) {
        self.post = post
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = post.title
        setupViews()
        configure()
    }

    private func setupViews() {
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont(name: "SFProDisplay-Semibold", size: 20) ?? UIFont.boldSystemFont(ofSize: 20)
        titleLabel.numberOfLines = 2
        titleLabel.textAlignment = .left

        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.font = UIFont.systemFont(ofSize: 14)
        dateLabel.textColor = .gray
        dateLabel.textAlignment = .left

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true

        bodyLabel.translatesAutoresizingMaskIntoConstraints = false
        bodyLabel.numberOfLines = 0
        bodyLabel.font = UIFont(name: "SFProText-Regular", size: 17) ?? UIFont.systemFont(ofSize: 17)

       
        view.addSubview(dateLabel)
        view.addSubview(titleLabel)
        view.addSubview(imageView)
        view.addSubview(bodyLabel)

        NSLayoutConstraint.activate([
           
            dateLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            dateLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -16),

           
            titleLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            titleLabel.heightAnchor.constraint(equalToConstant: 48),

            
            imageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            imageView.heightAnchor.constraint(equalToConstant: 226),

          
            bodyLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            bodyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            bodyLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            bodyLabel.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }


    private func configure() {
        titleLabel.text = post.title
        bodyLabel.text = post.text

        let isoFormatter = ISO8601DateFormatter()
        if let date = isoFormatter.date(from: post.date) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateStyle = .medium
            outputFormatter.timeStyle = .none
            outputFormatter.locale = Locale(identifier: "ru_RU")

            dateLabel.text = outputFormatter.string(from: date)
        } else {
            dateLabel.text = "Дата недоступна"
        }

        let baseURL = "http://dev-exam.l-tech.ru"
        let imageURLString = post.image.hasPrefix("http") ? post.image : baseURL + post.image

        guard let encodedString = imageURLString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: encodedString) else {
            imageView.image = nil
            return
        }

        loadImage(from: url)
    }

    private func loadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let self = self,
                  let data = data,
                  error == nil,
                  let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    self?.imageView.image = nil
                }
                return
            }
            DispatchQueue.main.async {
                self.imageView.image = image
            }
        }.resume()
    }
}

