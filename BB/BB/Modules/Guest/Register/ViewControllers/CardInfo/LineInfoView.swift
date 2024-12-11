//
//  LineInfoView.swift
//  BB
//

import UIKit
import SnapKit

class LineInfoView: UIView {
    var containerStackView: UIStackView = UIStackView()
    var titleLabel: BaseLabel = BaseLabel()
    var contentLabel: BaseLabel = BaseLabel()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    func setupView() {
        addSubview(containerStackView)
        containerStackView.axis = .horizontal
        containerStackView.spacing = 12
        containerStackView.addArrangedSubview(titleLabel)
        containerStackView.addArrangedSubview(contentLabel)
        contentLabel.makeBorder(radius: 5, width: 1, color: AppColor.baseGrey100)
        
        containerStackView.snp.makeConstraints { make in
            make.top.equalTo(0)
            make.bottom.equalTo(0)
            make.leading.equalTo(18)
            make.trailing.equalTo(-18)
        }
        
        titleLabel.setFontColor(AppFont.baseSubheadlineMedium, color: AppColor.baseGrey900)
        titleLabel.snp.makeConstraints { make in
            make.width.equalTo(120)
        }
    }
    
    func setData(title: String, content: String) {
        titleLabel.text = title
        contentLabel.text = content
    }
}
