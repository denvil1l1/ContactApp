import UIKit

protocol NotesTextCollectionViewDelegate: AnyObject {
    func notesTextCellChanged(text: String, cell: UICollectionViewCell)
}

class NotesTextcollectionView: UICollectionViewCell {
    
    weak var delegate: NotesTextCollectionViewDelegate?
    
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
        
        let textLabelForNotesText = UILabel()
        textLabelForNotesText.backgroundColor = UIColor.systemGray6
        textLabelForNotesText.text = "notes"
        textLabelForNotesText.translatesAutoresizingMaskIntoConstraints = false
        textLabelForNotesText.textColor = .systemGray2
        return textLabelForNotesText
    }()
    
    private lazy var textView: UITextView = {
        let notesText = UITextView()
        notesText.addSubview(placeholderLabel)
        notesText.translatesAutoresizingMaskIntoConstraints = false
        notesText.backgroundColor = UIColor.systemGray6
        notesText.layer.cornerRadius = 5
        notesText.layer.borderWidth = 0.3
        notesText.layer.borderColor = .init(gray: 140 / 225, alpha: 1)
        notesText.delegate = self
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
        if textView.text != Constants.textEmpty {
            placeholderLabel.isHidden = true
        } else if textView.text == Constants.textEmpty {
            placeholderLabel.isHidden = false
        }
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
        textView.text = viewModel.text
    }
}

extension NotesTextcollectionView {
    
    struct ViewModel {
        var text: String
    }
}

extension NotesTextcollectionView: UITextViewDelegate {
    
}
