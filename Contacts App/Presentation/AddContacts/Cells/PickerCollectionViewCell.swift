import UIKit

protocol PickerCellDelegate: AnyObject {
    func pickerRowSelected(at: Int, cell: UICollectionViewCell)
    func pickerText(at: Int) -> String?
}

class PickerCollectionViewCell: UICollectionViewCell, UIPickerViewDataSource {
    
    weak var delegate: PickerCellDelegate?
    var dataSource: [String] = []
    
    private lazy var pickerSex: UIPickerView = {
        let pickerSex = UIPickerView()
        pickerSex.dataSource = self
        pickerSex.delegate = self
        return pickerSex
    }()
    
    private lazy var textFieldForPickerView: UITextField = {
        var textFieldForPickerView = UITextField()
        textFieldForPickerView.borderStyle = UITextField.BorderStyle.roundedRect
        textFieldForPickerView.backgroundColor = UIColor.systemGray6
        textFieldForPickerView.translatesAutoresizingMaskIntoConstraints = false
        textFieldForPickerView.inputView = pickerSex
        return textFieldForPickerView
        
    }()
    
    override init (frame: CGRect) {
        super.init(frame: frame)
        layoutTextFieldPickerView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layoutTextFieldPickerView() {
        contentView.addSubview(textFieldForPickerView)
        NSLayoutConstraint.activate([
            textFieldForPickerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            textFieldForPickerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            contentView.trailingAnchor.constraint(equalTo: textFieldForPickerView.trailingAnchor, constant: 20),
            contentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func configure(with viewModel: ViewModel) {
        textFieldForPickerView.placeholder = viewModel.placeholder
        textFieldForPickerView.text = viewModel.text
        dataSource = viewModel.pickerData
        pickerSex.reloadAllComponents()
    }
}

extension PickerCollectionViewCell {
    
    struct ViewModel {
        var text: String?
        let placeholder: String
        let pickerData: [String]
    }
    
}

extension PickerCollectionViewCell {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataSource.count
    }
    
}

extension PickerCollectionViewCell: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        textFieldForPickerView.text = delegate?.pickerText(at: row)
        delegate?.pickerRowSelected(at: row, cell: self)
      }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataSource[row]
    }

}
