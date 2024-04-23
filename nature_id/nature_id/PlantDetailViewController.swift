import UIKit

class PlantDetailViewController: UIViewController {
    var suggestion: Suggestion?  // The suggestion data passed from the previous controller

    var scrollView: UIScrollView!
    var contentView: UIView!
    var imageView: UIImageView!
    var nameHeadingLabel: UILabel!
    var nameLabel: UILabel!
    var taxonomyHeadingLabel: UILabel!
    var taxonomyLabel: UILabel!
    var descriptionHeadingLabel: UILabel!
    var descriptionLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground  // Adaptive for light and dark mode
        setupUI()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        populateData()  // Populates data after the view has fully loaded and displayed
    }

    private func setupUI() {
        setupScrollView()
        setupImageView()
        setupSectionHeadings()
        setupLabels()
        setupConstraints()
    }

    private func setupScrollView() {
        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }

    private func setupImageView() {
        imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)
    }

    private func setupSectionHeadings() {
        nameHeadingLabel = createSectionHeadingLabel(text: "NAME")
        taxonomyHeadingLabel = createSectionHeadingLabel(text: "TAXONOMY")
        descriptionHeadingLabel = createSectionHeadingLabel(text: "DESCRIPTION")

        contentView.addSubview(nameHeadingLabel)
        contentView.addSubview(taxonomyHeadingLabel)
        contentView.addSubview(descriptionHeadingLabel)
    }

    private func setupLabels() {
        nameLabel = UILabel()
        nameLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        nameLabel.textColor = .label
        nameLabel.numberOfLines = 0
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(nameLabel)

        taxonomyLabel = UILabel()
        taxonomyLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        taxonomyLabel.textColor = .label
        taxonomyLabel.numberOfLines = 0
        taxonomyLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(taxonomyLabel)

        descriptionLabel = UILabel()
        descriptionLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        descriptionLabel.textColor = .label
        descriptionLabel.numberOfLines = 0
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(descriptionLabel)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 0.75),

            nameHeadingLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 30),
            nameHeadingLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            nameHeadingLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            nameLabel.topAnchor.constraint(equalTo: nameHeadingLabel.bottomAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            taxonomyHeadingLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 30),
            taxonomyHeadingLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            taxonomyHeadingLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            taxonomyLabel.topAnchor.constraint(equalTo: taxonomyHeadingLabel.bottomAnchor, constant: 10),
            taxonomyLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            taxonomyLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            descriptionHeadingLabel.topAnchor.constraint(equalTo: taxonomyLabel.bottomAnchor, constant: 30),
            descriptionHeadingLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            descriptionHeadingLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            descriptionLabel.topAnchor.constraint(equalTo: descriptionHeadingLabel.bottomAnchor, constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }

    private func createSectionHeadingLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }

    private func populateData() {
        guard let suggestion = suggestion else { return }

        if let urlString = suggestion.details.image?.value, let imageURL = URL(string: urlString) {
            imageView.loadImage(from: imageURL.absoluteString)
        } else {
            imageView.image = UIImage(named: "placeholder")  // Placeholder image if URL is nil
        }

        nameLabel.text = suggestion.details.commonNames?.joined(separator: ", ") ?? suggestion.name
        let taxonomyText = suggestion.details.taxonomy.map {
            """
            Genus: \($0.genus ?? "N/A")
            Order: \($0.order ?? "N/A")
            Family: \($0.family ?? "N/A")
            Phylum: \($0.phylum ?? "N/A")
            Kingdom: \($0.kingdom ?? "N/A")
            """
        } ?? "Taxonomy details unavailable"
        taxonomyLabel.text = taxonomyText
        descriptionLabel.text = suggestion.details.description?.value ?? "Description not available"
    }
}


