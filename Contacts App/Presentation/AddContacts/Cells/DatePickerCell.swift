import UIKit

protocol DatePickerCellDelegate: AnyObject {
    func datePickerCellConvertDate(dateOnPicker: Date) -> String?
    func datePickerCellDateChanged(date: Date, row: UICollectionViewCell)
}

class DatePickerCell: UICollectionViewCell {
    
    weak var delegate: DatePickerCellDelegate?
    
    private lazy var dateTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.backgroundColor = UIColor.systemGray6
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 5
        textField.inputView = datePicker
        return textField
        
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.addTarget(self, action: #selector(handleDatePicker), for: .valueChanged)
        datePicker.maximumDate = Date()
        datePicker.minimumDate = Date() - 3600 * 24 * 365 * 200
        return datePicker
    }()
    
    // MARK: - viewDidLoad
    override init (frame: CGRect) {
        super.init(frame: frame)
        layoutDataPicker()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    func handleDatePicker(sender: UIDatePicker) {
        delegate?.datePickerCellDateChanged(date: datePicker.date, row: self)
        dateTextField.text = delegate?.datePickerCellConvertDate(dateOnPicker: datePicker.date)
    }
    
    func layoutDataPicker() {
        contentView.addSubview(dateTextField)
        NSLayoutConstraint.activate([
            dateTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            dateTextField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            contentView.trailingAnchor.constraint(equalTo: dateTextField.trailingAnchor, constant: 20),
            contentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func configure(with viewModel: ViewModel) {
        dateTextField.placeholder = viewModel.placeHolder
        dateTextField.text = viewModel.text
        if let errorColor = viewModel.errorColor {
            dateTextField.layer.borderColor = errorColor.cgColor
        }
    }
}

extension DatePickerCell {
    
    struct ViewModel {
        var text: String?
        let placeHolder: String
        var errorColor: UIColor?
    }
    
}
