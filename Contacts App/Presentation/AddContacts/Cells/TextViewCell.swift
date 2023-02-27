import UIKit

protocol TextViewCellDelegate: AnyObject {
    func notesTextCellChanged(text: String, cell: UICollectionViewCell)
}

class TextViewCell: UICollectionViewCell {
    
    weak var delegate: TextViewCellDelegate?
    
    private enum Constants {
        static let textEmpty = ""
        static let leadingTrailingConstant: CGFloat = 20
        static let topConstant: CGFloat = 20
        static let bottomConstant: CGFloat = 10
        static let placeholderConstant: CGFloat = 5
    }
    
    static var horizontalSpasing: CGFloat {
        Constants.leadingTrailingConstant * 2 + 10
    }
    static var verticalSpacing: CGFloat {
        Constants.topConstant + Constants.bottomConstant + 16
    }
    
    private lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.systemGray6
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemGray2
        return label
    }()
    
    private lazy var textView: UITextView = {
        let notesText = UITextView()
        notesText.addSubview(placeholderLabel)
        notesText.translatesAutoresizingMaskIntoConstraints = false
        notesText.backgroundColor = UIColor.systemGray6
        notesText.layer.cornerRadius = 5
        notesText.layer.borderWidth = 1
        notesText.layer.borderColor = .init(gray: 140 / 225, alpha: 1)
        notesText.font = .systemFont(ofSize: 15)
        notesText.isSelectable = true
        notesText.isScrollEnabled = false
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(textDidChangeNotification),
            name: UITextView.textDidChangeNotification, object: nil
        )
        return notesText
    }()
    
    override init (frame: CGRect) {
        super.init(frame: frame)
        layoutNotesText()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    func textDidChangeNotification (_ notif: Notification) {
        guard self == notif.object as? UITextView else {
            delegate?.notesTextCellChanged(text: textView.text, cell: self)
            textDidChange()
            return
        }
    }
    
    func textDidChange() {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
    
    func layoutNotesText() {
        contentView.addSubview(textView)
        contentView.addSubview(placeholderLabel)
        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: Constants.leadingTrailingConstant
            ),
            textView.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: Constants.topConstant
            ),
            contentView.trailingAnchor.constraint(
                equalTo: textView.trailingAnchor,
                constant: Constants.leadingTrailingConstant),
            contentView.bottomAnchor.constraint(
                equalTo: textView.bottomAnchor,
                constant: Constants.bottomConstant),
            placeholderLabel.leadingAnchor.constraint(
                equalTo: textView.leadingAnchor,
                constant: Constants.placeholderConstant),
            placeholderLabel.topAnchor.constraint(
                equalTo: textView.topAnchor,
                constant: Constants.placeholderConstant)
        ])
    }
    
    func configure(with viewModel: ViewModel) {
        if !viewModel.text.isEmpty {
            placeholderLabel.isHidden = true
        }
        if let errorColor = viewModel.errorColor {
            textView.layer.borderColor = errorColor.cgColor
        }
        textView.text = viewModel.text
        placeholderLabel.text = viewModel.placeholder
    }
}

extension TextViewCell {
    
    struct ViewModel {
        var text: String
        var placeholder: String
        var errorColor: UIColor?
    }
    
}

