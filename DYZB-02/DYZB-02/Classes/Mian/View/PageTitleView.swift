//
//  PageTitleView.swift
//  DYZB-02
//
//  Created by 伏文东 on 2017/12/18.
//  Copyright © 2017年 伏文东. All rights reserved.
//

import UIKit

// MARK:- 定义协议
protocol pageTitleViewDelegate : class {
    func pageTitleView(titleView: PageTitleView, selectedIndex index: Int)
}
class PageTitleView: UIView {
    
    // MARK:- 定义常量
    private let kScrollLineH: CGFloat = 2
    private let kNormalColor : (CGFloat, CGFloat, CGFloat) = (85,85,85)
    private let kSelectedColor : (CGFloat, CGFloat, CGFloat) = (255,128,0)

    // MARK:- 定义属性
    private var titles: [String]
    private var currentIndex: Int = 0
    weak var delegate: pageTitleViewDelegate?
    
    // MARK:- 懒加载属性
    private lazy var titleLabels : [UILabel] = [UILabel]()
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        scrollView.bounces = false
        return scrollView
    }()
    
    private lazy var scrollLine: UIView = {
        let scrollLine = UIView()
        scrollLine.backgroundColor = UIColor.orange
        return scrollLine
    }()
    
    // MARK:- 自动以构造函数
    init(frame: CGRect, titles: [String]) {
        self.titles = titles
        
        super.init(frame: frame)
        
        // 设置UI界面
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK:- 设置UI界面
extension PageTitleView {
    private func setupUI() {
        
        // 1.添加scrollView
        addSubview(scrollView)
        scrollView.frame = bounds
        // 2.设置title对应Label
        setupTitleLabel()
        
        // 3.设置底线和滚动滑块
        setupBottomAndScrollLine()
        
    }
    
    private func setupTitleLabel() {
        //0. 确定lable的一些值
        let labelW : CGFloat = frame.width / CGFloat(titles.count)
        let labelH : CGFloat = frame.height - kScrollLineH
        let labelY : CGFloat = 0
        
        for (index, title) in titles.enumerated() {
            // 1. 创建UILabel
            let label = UILabel()
            // 2.设置Label 属性
            label.text = title
            label.textColor = UIColor(r: kNormalColor.0, g: kNormalColor.1, b: kNormalColor.2)
            label.font = UIFont.systemFont(ofSize: 16)
            label.textAlignment = .center
            label.tag = index
            
            // 3. 设置Label的Frame
            let labelX : CGFloat = labelW * CGFloat(index)
            label.frame = CGRect(x: labelX, y: labelY, width: labelW, height: labelH)
            
            // 4. 将Label添加到scrollView中
            scrollView.addSubview(label)
            titleLabels.append(label)
            
            // 5. 给label添加手势
            label.isUserInteractionEnabled = true
            let tapGes = UITapGestureRecognizer(target: self, action: #selector(titleLabelClick(tapGes:)))
            label.addGestureRecognizer(tapGes)
        }
    }

    private func setupBottomAndScrollLine() {
        // 添加底线
        let bottomLine = UIView()
        bottomLine.backgroundColor = UIColor.lightGray
        let lineH : CGFloat = 0.5
        bottomLine.frame = CGRect(x: 0, y: frame.height - lineH, width: frame.width, height: lineH)
        addSubview(bottomLine)
        
        // 2. 添加scrollLine
        // 2.1 获取第一个label
        guard let firstLabel = titleLabels.first else { return }
        firstLabel.textColor = UIColor(r: kSelectedColor.0, g: kSelectedColor.1, b: kSelectedColor.2)
        scrollView.addSubview(scrollLine)
        scrollLine.frame = CGRect(x: firstLabel.frame.origin.x, y: frame.height - kScrollLineH, width: firstLabel.frame.width, height: kScrollLineH)
    }

}

// MARK:- 监听Label的点击
extension PageTitleView {
    @objc private func titleLabelClick(tapGes: UITapGestureRecognizer) {
        // 1.获取当前点击的label
        guard let currectLabel = tapGes.view as? UILabel else { return }
        // 2.获取之前的label
        let oldLabel = titleLabels[currentIndex]
        // 3.切换文字颜色
        currectLabel.textColor = UIColor(r: kSelectedColor.0, g: kSelectedColor.1, b: kSelectedColor.2)
        oldLabel.textColor = UIColor(r: kNormalColor.0, g: kNormalColor.1, b: kNormalColor.2)
        // 4.保留最新label下标值
        currentIndex = currectLabel.tag
        
        // 5.滚动条位置发送改变
        let scrollLineX = CGFloat(currentIndex) * scrollLine.frame.width
        UIView.animate(withDuration: 0.2) {
            self.scrollLine.frame.origin.x = scrollLineX
        }
        // 6.通知代理做事情
        delegate?.pageTitleView(titleView: self, selectedIndex: currentIndex)
    }
}

// MARK:- 对外暴露的方法
extension PageTitleView {
    func setTitleWithProgress(progress: CGFloat, sourceIndex: Int, targetIndex: Int)  {
        // 1.取出sourceLabel/targetLabel
        let sourceLabel = titleLabels[sourceIndex]
        let targetLabel = titleLabels[targetIndex]
        
        // 2.处理滑块逻辑
        let moveTotalx = targetLabel.frame.origin.x - sourceLabel.frame.origin.x
        let moveX = moveTotalx * progress
        scrollLine.frame.origin.x = sourceLabel.frame.origin.x + moveX
        
        // 3.颜色渐变
        // 3.1 取出变化进度
        let colorDelte = (kSelectedColor.0 - kNormalColor.0, kSelectedColor.1 - kNormalColor.1,kSelectedColor.2 - kNormalColor.2)
        sourceLabel.textColor = UIColor(r: kSelectedColor.0 - colorDelte.0 * progress, g: kSelectedColor.1 - colorDelte.1 * progress, b: kSelectedColor.2 - colorDelte.2 * progress)
        
        targetLabel.textColor = UIColor(r: kNormalColor.0 + colorDelte.0 * progress, g: kNormalColor.1 + colorDelte.1 * progress, b: kNormalColor.2 + colorDelte.2 * progress)
        // 记录新的index
        currentIndex = targetIndex
    }
}
























