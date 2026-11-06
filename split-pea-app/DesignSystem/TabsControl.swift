import UIKit

/// The three-way switch under a group title: Expenses | Balances | Members.
/// Also used for "S$ Dollars | ¥ Yen" and "Light | Auto | Dark".
final class TabsControl: UISegmentedControl {

    init(titles: [String], selected: Int = 0) {
        super.init(items: titles)
        selectedSegmentIndex = selected
        translatesAutoresizingMaskIntoConstraints = false

        backgroundColor = AppColor.segment
        selectedSegmentTintColor = AppColor.segmentSelected
        setTitleTextAttributes([
            .font: AppFont.button,
            .foregroundColor: AppColor.muted
        ], for: .normal)
        setTitleTextAttributes([
            .font: AppFont.button,
            .foregroundColor: AppColor.text
        ], for: .selected)

        heightAnchor.constraint(greaterThanOrEqualToConstant: 40).isActive = true
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError("init(coder:) is not used") }
}
