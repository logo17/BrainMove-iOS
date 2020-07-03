//
//  MeasurementsViewController.swift
//  BrainMove
//
//  Created by Heriberto Ureña madrigal on 6/19/20.
//  Copyright © 2020 Heriberto Ureña Madrigal. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class MeasurementsViewController : UIViewController {
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var displayNameLabel: UILabel!
    @IBOutlet weak var dateTextView: UILabel!
    @IBOutlet weak var weightView: MeasurementsView!
    @IBOutlet weak var bmiView: MeasurementsView!
    @IBOutlet weak var bodyFatView: MeasurementsView!
    @IBOutlet weak var fatFreeBodyWeightView: MeasurementsView!
    @IBOutlet weak var subcutaneousFatView: MeasurementsView!
    @IBOutlet weak var visceralFatView: MeasurementsView!
    @IBOutlet weak var corporalWaterView: MeasurementsView!
    @IBOutlet weak var skeletalMuscleView: MeasurementsView!
    @IBOutlet weak var muscleMassView: MeasurementsView!
    @IBOutlet weak var boneMassView: MeasurementsView!
    @IBOutlet weak var proteinView: MeasurementsView!
    @IBOutlet weak var bmrView: MeasurementsView!
    @IBOutlet weak var metabolicalAgeView: MeasurementsView!
    
    enum ImagePickerType : Int {
        case camera = 0, album
    }
    
    let viewModel = MeasurementsViewModel()
    var disposeBag = DisposeBag()
    var spinner: LoadingView?
    var imageData: Data!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        bindListeners()
        initViews()
        viewModel.getMeasures()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    private func initViews() {
        userImageView.rounded()
        dateTextView.toPrimaryRounded()
        weightView.labelText.text = "Peso".uppercased()
        bmiView.labelText.text = "BMI".uppercased()
        bodyFatView.labelText.text = "Grasa corporal".uppercased()
        fatFreeBodyWeightView.labelText.text = "Peso corporal sin grasa".uppercased()
        subcutaneousFatView.labelText.text = "Grasa subcutánea".uppercased()
        visceralFatView.labelText.text = "Grasa visceral".uppercased()
        corporalWaterView.labelText.text = "Agua corporal".uppercased()
        skeletalMuscleView.labelText.text = "Músculo esquelético".uppercased()
        muscleMassView.labelText.text = "Masa muscular".uppercased()
        boneMassView.labelText.text = "Masa ósea".uppercased()
        proteinView.labelText.text = "Proteína".uppercased()
        bmrView.labelText.text = "BMR".uppercased()
        metabolicalAgeView.labelText.text = "Edad metabólica".uppercased()
    }
    
    private func bindListeners() {
        viewModel.output.measurement
            .drive(onNext:{ [weak self] measures in
                if (measures.weight > 0) {
                    self?.fillData(measurement: measures)
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.output.imageURL
            .drive(onNext:{ [weak self] urlImage in
                if let parseURL = URL.init(string: urlImage) {
                    self?.userImageView.load(url: parseURL)
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.output.userName
            .drive(onNext:{ [weak self] name in
                self?.displayNameLabel.text = name
            })
            .disposed(by: disposeBag)
        
        viewModel.output.isLoading
            .drive(onNext:{ [weak self] isLoading in
                self?.handleLoadingSpinner(isLoading: isLoading)
            })
            .disposed(by: disposeBag)
        
        viewModel.output.showError
            .drive(onNext:{ [weak self] showError in
                self?.showAlert(title: self?.getLocalizedString(key: "general_error_title") ?? "", description: self?.getLocalizedString(key: "general_measurements_error_description") ?? "", completion: nil)
            })
            .disposed(by: disposeBag)
    }
    
    private func fillData(measurement: Measurement) {
        self.weightView.setValueData(value: "\(measurement.weight) kg")
        self.bmiView.setValueData(value: "\(measurement.bmi)")
        self.bodyFatView.setValueData(value: "\(measurement.bodyFat) %")
        self.fatFreeBodyWeightView.setValueData(value: "\(measurement.fatFreeBody) kg")
        self.subcutaneousFatView.setValueData(value: "\(measurement.subcutaneousFat) %")
        self.visceralFatView.setValueData(value: "\(measurement.visceralFat)")
        self.corporalWaterView.setValueData(value: "\(measurement.bodyWater) %")
        self.skeletalMuscleView.setValueData(value: "\(measurement.skeletalMuscle) %")
        self.muscleMassView.setValueData(value: "\(measurement.muscleMass) kg")
        self.boneMassView.setValueData(value: "\(measurement.boneMass) kg")
        self.proteinView.setValueData(value: "\(measurement.protein) %")
        self.bmrView.setValueData(value: "\(measurement.bmr) kcal")
        self.metabolicalAgeView.setValueData(value: "\(measurement.metabolicalAge)")
        self.dateTextView.backgroundColor = UIColor.init(hexString: "#00a19a")
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "EEEE, dd MMMM, yyyy"
        dateFormatterPrint.locale = Locale(identifier: "ES")
        self.dateTextView.text = dateFormatterPrint.string(from: measurement.date).capitalized
    }
    @IBAction func logoutClicked(_ sender: Any) {
        performSegue(withIdentifier: "showSettings", sender: self)
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
    @IBAction func pickAnImage(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
       
       func uploadImage() {
        handleLoadingSpinner(isLoading: true)
           let imageUploader = ImageUploader()
           imageUploader.uploadImage(data: imageData, completion: { [weak self] result in
            self?.handleLoadingSpinner(isLoading: false)
            if (!result.isEmpty) {
                if let parseURL = URL.init(string: result) {
                    self?.userImageView.load(url: parseURL)
                }
            }
           })
       }
}
