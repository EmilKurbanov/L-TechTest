//
//  PostCell.swift
//  L-Tech
//
//  Created by emil kurbanov on 16.05.2025.
//

import UIKit

final class PostCell: UITableViewCell {
    private let postImageView = UIImageView()
    private let titleLabel = UILabel()
    private let bodyLabel = UILabel()
    private let dateLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        postImageView.contentMode = .scaleAspectFill
        postImageView.clipsToBounds = true
        postImageView.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        bodyLabel.numberOfLines = 0
        bodyLabel.translatesAutoresizingMaskIntoConstraints = false

        dateLabel.font = .italicSystemFont(ofSize: 12)
        dateLabel.textColor = .gray
        dateLabel.numberOfLines = 1
        dateLabel.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(postImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(bodyLabel)
        contentView.addSubview(dateLabel)

        NSLayoutConstraint.activate([
            postImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            postImageView.widthAnchor.constraint(equalToConstant: 80),
            postImageView.heightAnchor.constraint(equalToConstant: 80),
            postImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor), // по центру вертикали

            titleLabel.leadingAnchor.constraint(equalTo: postImageView.trailingAnchor, constant: 10),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            bodyLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            bodyLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            bodyLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            dateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            dateLabel.topAnchor.constraint(equalTo: bodyLabel.bottomAnchor, constant: 4),
            dateLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            dateLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8)
        ])
    }

    func configure(with post: Post) {
        titleLabel.attributedText = attributedText(
            text: post.title,
            fontWeight: .semibold,
            fontSize: 15,
            letterSpacing: -0.24,
            lineHeight: 20
        )

        bodyLabel.attributedText = attributedText(
            text: post.text,
            fontWeight: .regular,
            fontSize: 15,
            letterSpacing: -0.24,
            lineHeight: 20
        )

        dateLabel.text = format(dateString: post.date)

        let baseURL = "http://dev-exam.l-tech.ru"
        let fullURLString: String

        if post.image.hasPrefix("http") {
            fullURLString = post.image
        } else {
            fullURLString = baseURL + post.image
        }

        if let encodedString = fullURLString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
           let url = URL(string: encodedString) {
            loadImage(from: url)
        } else {
            postImageView.image = nil
        }
    }

    private func attributedText(
        text: String,
        fontWeight: UIFont.Weight,
        fontSize: CGFloat,
        letterSpacing: CGFloat,
        lineHeight: CGFloat
    ) -> NSAttributedString {
        let font = UIFont.systemFont(ofSize: fontSize, weight: fontWeight)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = lineHeight
        paragraphStyle.maximumLineHeight = lineHeight

        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttributes([
            .font: font,
            .kern: letterSpacing,
            .paragraphStyle: paragraphStyle
        ], range: NSRange(location: 0, length: text.count))
        return attributedString
    }

    private func format(dateString: String) -> String {
        let inputFormatter = ISO8601DateFormatter()
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "d MMM yyyy, HH:mm"
        outputFormatter.locale = Locale(identifier: "ru_RU")

        if let date = inputFormatter.date(from: dateString) {
            return outputFormatter.string(from: date)
        } else {
            return dateString
        }
    }

    private func loadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil, let image = UIImage(data: data) else {
                DispatchQueue.main.async { self?.postImageView.image = nil }
                return
            }
            DispatchQueue.main.async {
                self?.postImageView.image = image
            }
        }.resume()
    }
}

