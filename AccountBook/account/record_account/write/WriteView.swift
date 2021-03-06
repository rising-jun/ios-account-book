//
//  WriteView.swift
//  AccountBook
//
//  Created by 김동준 on 2021/11/08.
//

import SnapKit
import MapKit

final class WriteView: BaseView{
    
    lazy var nameLabel: UILabel = {
       let label = UILabel()
        label.text = "상호명"
        
        label.textAlignment = .center
        return label
    }()
    
    lazy var nameTF: UITextField = {
        let tf = UITextField()
        tf.textAlignment = .left
        tf.layer.addBorder(edge: .bottom, color: .black, thickness: 2.0)
        return tf
    }()
    
    lazy var priceLabel: UILabel = {
       let label = UILabel()
        label.text = "금액"
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    lazy var priceTF: UITextField = {
        let tf = UITextField()
        tf.textAlignment = .left
        tf.layer.addBorder(edge: .bottom, color: .black, thickness: 2.0)
        return tf
    }()
    
    lazy var categoryLabel: UILabel = {
       let label = UILabel()
        label.text = "카테고리"
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    lazy var categoryPicker = UIPickerView()
    
    lazy var dateLabel: UILabel = {
       let label = UILabel()
        label.text = "시용일자"
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .automatic
            datePicker.datePickerMode = .dateAndTime
        } else {
            // Fallback on earlier versions
        }
        return datePicker
    }()
    
    lazy var mapLabel: UILabel = {
       let label = UILabel()
        label.text = "위치"
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.mapType = .standard
        return mapView
    }()
    
    lazy var setLocModeButton: UIButton = {
        let button = UIButton()
        button.setTitle("직접설정", for: .normal)
        button.titleLabel!.font = UIFont.systemFont(ofSize: 18)
        return button
    }()
    
    lazy var pointAnnotaion = MKPointAnnotation()
    
    override func setup() {
        super.setup()
        backgroundColor = .white
        
        addSubViews(nameLabel, nameTF, priceLabel, priceTF, categoryLabel, categoryPicker, dateLabel, datePicker, mapLabel, mapView, setLocModeButton)
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(self).offset(104)
            make.leading.equalTo(self).offset(20)
            make.height.equalTo(40)
            make.width.equalTo(60)
        }
        
        nameTF.snp.makeConstraints { make in
            make.top.equalTo(self).offset(104)
            make.leading.equalTo(nameLabel.snp.trailing).offset(20)
            make.trailing.equalTo(self).offset(-20)
            make.height.equalTo(40)
        }

        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(15)
            make.leading.equalTo(self).offset(20)
            make.height.equalTo(40)
            make.width.equalTo(60)
        }
        
        priceTF.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(15)
            make.leading.equalTo(priceLabel.snp.trailing).offset(20)
            make.trailing.equalTo(self).offset(-20)
            make.height.equalTo(40)
        }
        
        categoryLabel.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(20)
            make.leading.equalTo(self).offset(20)
            make.height.equalTo(60)
            make.width.equalTo(80)
        }
        
        categoryPicker.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(20)
            make.leading.equalTo(categoryLabel.snp.trailing).offset(20)
            make.trailing.equalTo(self).offset(-20)
            make.height.equalTo(80)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(categoryLabel.snp.bottom).offset(20)
            make.leading.equalTo(self).offset(20)
            make.height.equalTo(60)
            make.width.equalTo(80)
        }
        
        datePicker.snp.makeConstraints { make in
            make.top.equalTo(categoryLabel.snp.bottom).offset(20)
            make.leading.equalTo(dateLabel.snp.trailing).offset(20)
            make.trailing.equalTo(self).offset(-20)
            make.height.equalTo(80)
        }
        
        mapLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(20)
            make.leading.equalTo(self).offset(20)
            make.height.equalTo(40)
            make.width.equalTo(60)
        }
        
        mapView.snp.makeConstraints { make in
            make.top.equalTo(mapLabel.snp.bottom).offset(5)
            make.leading.equalTo(self).offset(20)
            make.trailing.equalTo(self).offset(-20)
            make.height.equalTo(300)
        }
        
        setLocModeButton.backgroundColor = .blue
        setLocModeButton.snp.makeConstraints { make in
            make.top.equalTo(mapView.snp.bottom).offset(10)
            make.leading.equalTo(mapView.snp.leading)
            make.width.equalTo(80)
            make.height.equalTo(40)
        }
    }
    
    func availableUI(){
        priceTF.layer.borderColor = UIColor.gray.cgColor
        priceTF.reomoveErrorImg()
    }
    
    func unavailableUI(){
        priceTF.layer.borderColor = UIColor.red.cgColor
        priceTF.setError()
    }
    
    func mapViewInitSet(coordi: CLLocationCoordinate2D){
        mapView.showsUserLocation = true
        mapView.showsBuildings = true
        mapView.isPitchEnabled = true
        let lat = coordi.latitude
        let long = coordi.longitude
        let camera = MKMapCamera()
        camera.centerCoordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        pointAnnotaion.coordinate = coordi
        pointAnnotaion.title = "여기!"
        camera.pitch = 80.0
        camera.altitude = 100.0
        mapView.setCamera(camera, animated: false)
    }
    
    func setMapMode(mapMode: LocationSetMode){
        if mapMode == .auto{
            mapView.showsUserLocation = true
            mapView.removeAnnotation(pointAnnotaion)
        }else{
            mapView.showsUserLocation = false
            mapView.addAnnotation(pointAnnotaion)
        }
    }
}
