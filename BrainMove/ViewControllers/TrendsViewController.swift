//
//  TrendsViewController.swift
//  BrainMove
//
//  Created by Heriberto Ureña madrigal on 6/28/20.
//  Copyright © 2020 Heriberto Ureña Madrigal. All rights reserved.
//

import Foundation
import UIKit
import Charts
import TinyConstraints
import RxSwift

class TrendsViewController : UIViewController, ChartViewDelegate {
    
    lazy var lineChartView: LineChartView = {
        let chartView = LineChartView()
        return chartView
    }()
    
    @IBOutlet weak var valuesContainer: UIView!
    @IBOutlet weak var titleContainer: UIView!
    @IBOutlet weak var chartContainer: UIView!
    @IBOutlet weak var weightButton: UIButton!
    @IBOutlet weak var bmiButton: UIButton!
    @IBOutlet weak var bodyFatButton: UIButton!
    @IBOutlet weak var fatFreeBodyButton: UIButton!
    @IBOutlet weak var subcutaneousFatButton: UIButton!
    @IBOutlet weak var visceralFatButton: UIButton!
    @IBOutlet weak var bodyWaterButton: UIButton!
    @IBOutlet weak var skeletalMusscleButton: UIButton!
    @IBOutlet weak var boneMassButton: UIButton!
    @IBOutlet weak var musscleMassButton: UIButton!
    @IBOutlet weak var proteinButton: UIButton!
    @IBOutlet weak var bmrButton: UIButton!
    @IBOutlet weak var metabolicalAgeButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var highlitedMeasureValue: UILabel!
    @IBOutlet weak var highlitedMeasureDate: UILabel!
    @IBOutlet weak var emptyContainer: UIView!
    @IBOutlet weak var infoContainer: UIView!
    
    var spinner: LoadingView?
    let viewModel = TrendsViewModel()
    let disposeBag = DisposeBag()
    
    var measurements = Array<Measurement>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initViews()
        bindListeners()
        viewModel.getMeasures()
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        valuesContainer.isHidden = false
        let result = getSpecificMeasureInfo(index: Int(entry.x - 1))
        highlitedMeasureDate.text = result.0
        highlitedMeasureValue.text = result.1
    }
    
    private func initViews() {
        chartContainer.addSubview(lineChartView)
        lineChartView.backgroundColor = .white
        lineChartView.delegate = self
        lineChartView.centerInSuperview()
        lineChartView.width(to: chartContainer)
        lineChartView.heightToWidth(of: chartContainer)
        lineChartView.xAxis.gridColor = .clear
        lineChartView.rightAxis.gridColor = .clear
        lineChartView.leftAxis.gridColor = .clear
        lineChartView.leftAxis.enabled = false
        lineChartView.xAxis.drawAxisLineEnabled = false
        lineChartView.xAxis.drawLabelsEnabled = false
        lineChartView.legend.enabled = false
        titleContainer.toRounded(radius: 16)
        titleContainer.backgroundColor = UIColor.init(hexString: "#f39200")
        valuesContainer.toRounded(radius: 10)
        valuesContainer.backgroundColor = UIColor.init(hexString: "#f39200")
        titleLabel.text = chartTitles[0]
        
        weightButton.isSelected = true
        weightButton.setBackgroundImage(UIImage.init(named: "peso_desac"), for: .normal)
        weightButton.setBackgroundImage(UIImage.init(named: "peso_act"), for: .selected)
        bmiButton.setBackgroundImage(UIImage.init(named: "bmi_desac"), for: .normal)
        bmiButton.setBackgroundImage(UIImage.init(named: "bmi_act"), for: .selected)
        bodyFatButton.setBackgroundImage(UIImage.init(named: "grasa_corporal_desac"), for: .normal)
        bodyFatButton.setBackgroundImage(UIImage.init(named: "grasa_corporal_act"), for: .selected)
        fatFreeBodyButton.setBackgroundImage(UIImage.init(named: "peso_corp_sin_desac"), for: .normal)
        fatFreeBodyButton.setBackgroundImage(UIImage.init(named: "peso_corp_sin_act"), for: .selected)
        subcutaneousFatButton.setBackgroundImage(UIImage.init(named: "grasa_sub_desac"), for: .normal)
        subcutaneousFatButton.setBackgroundImage(UIImage.init(named: "grasa_sub_act"), for: .selected)
        visceralFatButton.setBackgroundImage(UIImage.init(named: "grasa_viseral_desac"), for: .normal)
        visceralFatButton.setBackgroundImage(UIImage.init(named: "grasa_viseral_act"), for: .selected)
        bodyWaterButton.setBackgroundImage(UIImage.init(named: "agua_corporal_desac"), for: .normal)
        bodyWaterButton.setBackgroundImage(UIImage.init(named: "agua_corporal_act"), for: .selected)
        skeletalMusscleButton.setBackgroundImage(UIImage.init(named: "musculo_esqueletico_desac"), for: .normal)
        skeletalMusscleButton.setBackgroundImage(UIImage.init(named: "musculo_esqueletico_act"), for: .selected)
        boneMassButton.setBackgroundImage(UIImage.init(named: "masa_osea_desac"), for: .normal)
        boneMassButton.setBackgroundImage(UIImage.init(named: "masa_osea_act"), for: .selected)
        musscleMassButton.setBackgroundImage(UIImage.init(named: "masa_muscular_desac"), for: .normal)
        musscleMassButton.setBackgroundImage(UIImage.init(named: "masa_muscular_act"), for: .selected)
        proteinButton.setBackgroundImage(UIImage.init(named: "proteina_desac"), for: .normal)
        proteinButton.setBackgroundImage(UIImage.init(named: "proteina_act"), for: .selected)
        bmrButton.setBackgroundImage(UIImage.init(named: "bmr_desac"), for: .normal)
        bmrButton.setBackgroundImage(UIImage.init(named: "bmr_act"), for: .selected)
        metabolicalAgeButton.setBackgroundImage(UIImage.init(named: "edad_metabolica_desac"), for: .normal)
        metabolicalAgeButton.setBackgroundImage(UIImage.init(named: "edad_metabolica_act"), for: .selected)
    }
    
    private func bindListeners() {
        viewModel.output.measurements
            .drive(onNext:{ [weak self] measures in
                self?.emptyContainer.isHidden = !measures.isEmpty
                self?.infoContainer.isHidden = measures.isEmpty
                self?.measurements = measures
                self?.setChartData(yValues: self?.getChartDataEntryFromMeasures(tag: 0) ?? [])
            })
            .disposed(by: disposeBag)
        
        viewModel.output.isLoading
            .drive(onNext:{ [weak self] isLoading in
                self?.handleLoadingSpinner(isLoading: isLoading)
            })
            .disposed(by: disposeBag)
        
        viewModel.output.showError
            .drive(onNext:{ [weak self] showError in
                self?.showAlert(title: self?.getLocalizedString(key: "general_error_title") ?? "", description: self?.getLocalizedString(key: "general_trends_error_description") ?? "", completion: nil)
            })
            .disposed(by: disposeBag)
    }
    
    func setChartData(yValues:[ChartDataEntry]) {
        let format = NumberFormatter()
        format.numberStyle = .decimal
        let formatter = DefaultValueFormatter(formatter: format)
        
        let set = LineChartDataSet(entries: yValues)
        set.valueFormatter = formatter
        set.circleRadius = 4
        set.setCircleColor(.black)
        set.circleHoleRadius = 2
        set.circleHoleColor = UIColor.white
        set.mode = .cubicBezier
        set.setColor(UIColor.black)
        set.drawHorizontalHighlightIndicatorEnabled = false
        set.highlightColor = UIColor.black
        
        //gradient
        let gradient = getGradientFilling()
        set.fill = Fill.fillWithLinearGradient(gradient, angle: 90.0)
        set.drawFilledEnabled = true
        
        
        let data = LineChartData(dataSet: set)
        lineChartView.data = data
    }
    
    /// Creating gradient for filling space under the line chart
    private func getGradientFilling() -> CGGradient {
        // Setting fill gradient color
        let coloTop = UIColor(hexString: "#f39200").cgColor
        let colorBottom = UIColor(hexString: "#FFFFFF").cgColor
        // Colors of the gradient
        let gradientColors = [coloTop, colorBottom] as CFArray
        // Positioning of the gradient
        let colorLocations: [CGFloat] = [0.7, 0.0]
        // Gradient Object
        return CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations)!
    }
    
    
    @IBAction func onTrendItemClicked(_ sender: Any) {
        if let button = sender as? UIButton {
            titleLabel.text = chartTitles[button.tag]
            handleButtonsState(button)
            valuesContainer.isHidden = true
            setChartData(yValues: getChartDataEntryFromMeasures(tag: button.tag))
        }
    }
    
    private func handleButtonsState(_ sender: UIButton) {
        weightButton.isSelected = false
        bmiButton.isSelected = false
        bodyFatButton.isSelected = false
        fatFreeBodyButton.isSelected = false
        subcutaneousFatButton.isSelected = false
        visceralFatButton.isSelected = false
        bodyWaterButton.isSelected = false
        skeletalMusscleButton.isSelected = false
        boneMassButton.isSelected = false
        musscleMassButton.isSelected = false
        proteinButton.isSelected = false
        bmrButton.isSelected = false
        metabolicalAgeButton.isSelected = false
        
        switch sender.tag {
            case 0:
                weightButton.isSelected = true
            case 1:
                bmiButton.isSelected = true
            case 2:
                bodyFatButton.isSelected = true
            case 3:
                fatFreeBodyButton.isSelected = true
            case 4:
                subcutaneousFatButton.isSelected = true
            case 5:
                visceralFatButton.isSelected = true
            case 6:
                bodyWaterButton.isSelected = true
            case 7:
                skeletalMusscleButton.isSelected = true
            case 8:
                boneMassButton.isSelected = true
            case 9:
                musscleMassButton.isSelected = true
            case 10:
                proteinButton.isSelected = true
            case 11:
                bmrButton.isSelected = true
            case 12:
                metabolicalAgeButton.isSelected = true
            default:
                weightButton.isSelected = true
        }
    }
    
    private func getChartDataEntryFromMeasures(tag: Int) -> [ChartDataEntry] {
        var result = [ChartDataEntry]()
        
        for (index, element) in measurements.enumerated() {
            switch tag {
                case 0:
                    result.append(ChartDataEntry(x: Double(index + 1), y: element.weight))
                case 1:
                    result.append(ChartDataEntry(x: Double(index + 1), y: element.bmi))
                case 2:
                    result.append(ChartDataEntry(x: Double(index + 1), y: element.bodyFat))
                case 3:
                    result.append(ChartDataEntry(x: Double(index + 1), y: element.fatFreeBody))
                case 4:
                    result.append(ChartDataEntry(x: Double(index + 1), y: element.subcutaneousFat))
                case 5:
                    result.append(ChartDataEntry(x: Double(index + 1), y: element.visceralFat))
                case 6:
                    result.append(ChartDataEntry(x: Double(index + 1), y: element.bodyWater))
                case 7:
                    result.append(ChartDataEntry(x: Double(index + 1), y: element.skeletalMuscle))
                case 8:
                    result.append(ChartDataEntry(x: Double(index + 1), y: element.boneMass))
                case 9:
                    result.append(ChartDataEntry(x: Double(index + 1), y: element.muscleMass))
                case 10:
                    result.append(ChartDataEntry(x: Double(index + 1), y: element.protein))
                case 11:
                    result.append(ChartDataEntry(x: Double(index + 1), y: element.bmr))
                case 12:
                    result.append(ChartDataEntry(x: Double(index + 1), y: Double(element.metabolicalAge)))
                default:
                    result.append(ChartDataEntry(x: Double(index + 1), y: 0.0))
            }
        }
        return result
    }
    
    let chartTitles:[String] = ["PESO", "BMI", "GRASA CORPORAL", "PESO CORPORAL SIN GRASA", "GRASA SUBCUTÁNEA", "GRASA VISCERAL", "AGUA CORPORAL", "MÚSCULO ESQUELÉTICO", "MASA ÓSEA", "MASA MUSCULAR", "PROTEÍNA", "BMR", "EDAD METABÓLICA"]
    
    private func getSpecificMeasureInfo(index: Int) -> (String, String) {
        let measureIndex = chartTitles.firstIndex(of: titleLabel.text ?? "")
        let currentMeasure = measurements[index]
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd/MM/YYYY"
        dateFormatterPrint.locale = Locale(identifier: "ES")
        let dateResult = dateFormatterPrint.string(from: currentMeasure.date)
        
        var measurementResult = ""
        switch measureIndex {
            case 0:
                measurementResult = "\(currentMeasure.weight) kg"
            case 1:
                measurementResult = "\(currentMeasure.bmi)"
            case 2:
                measurementResult = "\(currentMeasure.bodyFat) %"
            case 3:
                measurementResult = "\(currentMeasure.fatFreeBody) kg"
            case 4:
                measurementResult = "\(currentMeasure.subcutaneousFat) %"
            case 5:
                measurementResult = "\(currentMeasure.visceralFat)"
            case 6:
                measurementResult = "\(currentMeasure.bodyWater) %"
            case 7:
                measurementResult = "\(currentMeasure.skeletalMuscle) %"
            case 8:
                measurementResult = "\(currentMeasure.muscleMass) kg"
            case 9:
                measurementResult = "\(currentMeasure.boneMass) kg"
            case 10:
                measurementResult = "\(currentMeasure.protein) %"
            case 11:
                measurementResult = "\(currentMeasure.bmr) kcal"
            case 12:
                measurementResult = "\(currentMeasure.metabolicalAge)"
            default:
                measurementResult = "\(currentMeasure.weight) kg"
        }
        
        return (dateResult, measurementResult)
    }
    
    private func handleLoadingSpinner(isLoading: Bool) {
        if (isLoading) {
            spinner = self.showSpinner(onView: self.view)
        } else {
            if let spinner = self.spinner {
                self.removeSpinner(spinner: spinner)
            }
        }
    }
}
