import UIKit

protocol InputCollectionCellSizeDelegate: AnyObject {
    func inputInTextView(text: String, cell: UICollectionViewCell)
}

class NotesTextcollectionView: UICollectionViewCell {
    
    weak var delegate: InputCollectionCellSizeDelegate?
    
    private enum Constants {
        static let textEmpty = ""
        static let leadingTrailingConstant: CGFloat = 20
        static let topConstant: CGFloat = 20
        static let bottomConstant: CGFloat = 10
    }
    
    static var horizontalSpasing: CGFloat {
        Constants.leadingTrailingConstant * 2 + 10
    }
    static var verticalSpacing: CGFloat {
        Constants.topConstant + Constants.bottomConstant + 16
    }
    
    private lazy var plaiceholderForTextView: UILabel = {
    let textLabelForNotesText = UILabel()
        textLabelForNotesText.backgroundColor = UIColor.systemGray6
        textLabelForNotesText.text = "notes"
        textLabelForNotesText.translatesAutoresizingMaskIntoConstraints = false
        textLabelForNotesText.textColor = .systemGray2
        textLabelForNotesText.sizeToFit()
        return textLabelForNotesText
    }()
    
    private lazy var textViewNotes: UITextView = {
    let notesText = UITextView()
        notesText.addSubview(plaiceholderForTextView)
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
            delegate?.inputInTextView(text: textViewNotes.text, cell: self)
            textDidChange()
            return
        }
        
    }

    func textDidChange() {
        
        if textViewNotes.text != Constants.textEmpty {
            plaiceholderForTextView.isHidden = true
        } else if textViewNotes.text == Constants.textEmpty {
            plaiceholderForTextView.isHidden = false
        }
        textDidChangeHandler?()
    }
    
    var textDidChangeHandler: (() -> Void)?
    
    func layoutNotesText() {
        contentView.addSubview(textViewNotes)
        contentView.addSubview(plaiceholderForTextView)
        NSLayoutConstraint.activate([
            textViewNotes.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: Constants.leadingTrailingConstant
            ),
            textViewNotes.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: Constants.topConstant
            ),
            contentView.trailingAnchor.constraint(
                equalTo: textViewNotes.trailingAnchor,
                constant: Constants.leadingTrailingConstant),
            contentView.bottomAnchor.constraint(
                equalTo: textViewNotes.bottomAnchor,
                constant: Constants.bottomConstant),
            plaiceholderForTextView.leadingAnchor.constraint(
                equalTo: textViewNotes.leadingAnchor,
                constant: 5),
            plaiceholderForTextView.topAnchor.constraint(
                equalTo: textViewNotes.topAnchor,
                constant: 5)
        ])
    }
    
    func configure(with viewModel: ViewModel) {
        textViewNotes.text = viewModel.text
    }
}

extension NotesTextcollectionView {
    struct ViewModel {
        var text: String
    }
}

extension NotesTextcollectionView: UITextViewDelegate {
    
}
