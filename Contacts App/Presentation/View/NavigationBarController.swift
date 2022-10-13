import UIKit

final class NavigationBarController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    private func configure () {
        view.backgroundColor = .white
        navigationBar.isTranslucent = false
        navigationBar.standardAppearance.titleTextAttributes = [.foregroundColor: Resources.Colors.titleGrey, .font: Resources.Fonts.hevletivcaRegular(with: 17)
        ]
    }
}
