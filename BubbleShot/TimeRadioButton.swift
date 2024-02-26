//
//  TimeRadioButton.swift
//  BubbleShot
//
//  Created by unboxers on 2/26/24.
//

import Foundation
import UIKit

class TimeRadioButton: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UISegmentedControl 생성
        let segmentedControl = UISegmentedControl(items: ["Option 1", "Option 2", "Option 3"])
        
        // 선택 사이의 간격 조정 (선택 사이의 간격을 동일하게 할 때)
        segmentedControl.apportionsSegmentWidthsByContent = true
        
        // 초기 선택 항목 설정
        segmentedControl.selectedSegmentIndex = 0
        
        // 액션 설정
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        
        // 레이아웃 설정
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(segmentedControl)
        
        // 제약 조건 설정
        NSLayoutConstraint.activate([
            segmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            segmentedControl.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        // 라디오 버튼이 선택되었을 때의 동작 처리
        print("Selected segment index: \(sender.selectedSegmentIndex)")
    }
}
