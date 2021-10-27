//
//  mainViewController.swift  //
//  Created by system on 2021/09/23.
//
import UIKit
import MapKit
import Firebase
import FirebaseAuth

class mainViewController: UIViewController, UITextFieldDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    //for saving firebase
    let db = Firestore.firestore()
    let emailAddress = (Auth.auth().currentUser?.email)!
    let date = Date()
    var pinTitle: String = ""
    
    var textWrittenByUser: String = ""
    var userName: String = ""
    
    var textsWrittenByUser: [String] = []
    var userNames: [String] = []
    var placeNames: [String] = []
    
   //値渡し用
    var nameHolder = ""
    
    //from searchPlaceVC
    var lonSearched: CLLocationDegrees?
    var latSearched: CLLocationDegrees?
    
    //in viewForAnnotation
    var usedNames: [String] = []
    var usedTexts: [String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let mapView = mapView else {
            return
        }
        mapView.delegate = self
        
        //for hiding navigationBar
        navigationController?.navigationBar.isHidden = true
        
        //for zoom
        mapView.isZoomEnabled = true
        
        //for searchPlaceVC
        if latSearched != nil && lonSearched != nil{
            findPin(latitude: latSearched!, longitude: lonSearched!)
        }
        loadLocation()
    }
    
    @IBAction func addPlaceButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "toSeachPlaceVC", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let searchPlaceVC = segue.destination as? searchPlaceViewController
        searchPlaceVC?.nameHolder = self.nameHolder
    }
    
    @IBAction func pinchGestureRecognized(_ sender: UIPinchGestureRecognizer) {
        mapView.transform = CGAffineTransform(scaleX: sender.scale, y: sender.scale)
    }
    
    //指定したピンのみを消したい
    @IBAction func pressMap(_ sender: UILongPressGestureRecognizer) {
        
        let location:CGPoint = sender.location(in: mapView)
        if (sender.state == UIGestureRecognizer.State.began){
            //タップした位置を緯度、経度の座標に変換する。
            let mapPoint:CLLocationCoordinate2D = mapView.convert(location,toCoordinateFrom: mapView)
            
            //ピンを作成してマップビューに登録する。
            let annotation = ViewMKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2DMake(mapPoint.latitude, mapPoint.longitude)
            
        }
    }
    
    //緯度経度からピンを取得
    func findPin(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        
        let pin = ViewMKPointAnnotation()
        
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        pin.coordinate = coordinate
        
        self.mapView.region = MKCoordinateRegion(
            center: coordinate,
            latitudinalMeters: 500.0,
            longitudinalMeters: 500.0
        )
        
        pin.title = self.pinTitle
        pin.subtitle = emailAddress
        
        savePin(latitude: String(latitude),
                longitude: String(longitude),
                placeName: self.pinTitle,
                userEmail: emailAddress,
                userText: textWrittenByUser,
                userName: userName
        )
        userNames.append(userName)
        textsWrittenByUser.append(textWrittenByUser)
        placeNames.append(self.pinTitle)
    }
    
    
    //ピンをデータベースに保存
    func savePin(latitude: String, longitude: String, placeName: String, userEmail: String, userText: String, userName: String) {
        
        let pin = Pin()
        pin.latitude = latitude
        pin.longitude = longitude
        pin.title = placeName
        pin.subtitle = userEmail
        
        db.collection("location").addDocument(data: [
            "latitude": pin.latitude,
            "longitude": pin.longitude,
            "placeName": pin.title,
            "email": pin.subtitle,
            "date": date,
            "userText": userText,
            "userName": userName
            
        ]) { (error) in
            if let e = error {
                print("There was a issue saving data to firestore, \(e)")
            } else {
                print("Succecessfully saved data")
            }
        }
        
    }
    
    //fireStoreから値を取り出す
    func loadLocation() {
        print("-loadLocation-")
        db.collection("location").getDocuments { [self] (querySnapshot, error) in
            if let e = error {
                print("There was an issue retrieving data from Firestore. \(e)")
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let longitude = data["longitude"] as? String,
                           let latitude = data["latitude"] as? String,
                           let placeName = data["placeName"] as? String,
                           let email = data["email"] as? String,
                           let userText = data["userText"] as? String,
                           let userName = data["userName"] as? String
                        {
                            let pin = Pin()
                            
                            pin.longitude = longitude
                            pin.latitude = latitude
                            
                            let coordinate = CLLocationCoordinate2D(
                                latitude: CLLocationDegrees(pin.latitude)!,
                                longitude: CLLocationDegrees(pin.longitude)!)
                            
                            let mkPin = ViewMKPointAnnotation()
                            mkPin.coordinate = coordinate
                            
                            self.userNames.append(userName)
                            self.textsWrittenByUser.append(userText)
                            self.placeNames.append(placeName)
                            
                            
                            mkPin.title = placeName
                            mkPin.subtitle = email
                            self.mapView.addAnnotation(mkPin)
                            
                            //self.coordinates.append(coordinate)
                            
                        } else {
                            print("There was an issue")
                        }
                    }
                }
            }
        }
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "MyMarker")
        if self.emailAddress == annotation.subtitle {
            annotationView.pinTintColor = UIColor.systemGreen
        } else {
            annotationView.pinTintColor = UIColor.systemBlue
        }
        //吹き出しに表示するスタックビューを生成する。
        let stackView = UIStackView()
        stackView.axis = NSLayoutConstraint.Axis.vertical
        stackView.alignment = UIStackView.Alignment.leading
        
        //"userName"と"textWrittenByUser"をviewに追加
        var i = 0
        
        for placeName in placeNames {
            if placeName == annotation.title {
                //スタックビューにユーザーネームを追加する。
                let username = userNames[i]
                let text = "👤: \(username)"
                let userName:UILabel = UILabel()
                userName.frame = CGRect(x: 0, y: 0, width: 200, height: 0)
                userName.sizeToFit()
                userName.text = text
                stackView.addArrangedSubview(userName)
                usedNames.append(username)
                
                //スタックビューにフリーテキストを追加する。
                let textwrittenbyuser = textsWrittenByUser[i]
                let freeText = "📝: \(textwrittenbyuser)"
                let testLabel:UILabel = UILabel()
                testLabel.frame = CGRect(x: 0, y: 0, width: 200, height: 0)
                testLabel.numberOfLines = 0
                testLabel.sizeToFit()
                testLabel.text = freeText
                stackView.addArrangedSubview(testLabel)
                usedTexts.append(textwrittenbyuser)
            }
            i += 1
        }
        //ピンの吹き出しにスタックビューを設定する。
        annotationView.detailCalloutAccessoryView = stackView
        
        //吹き出しを表示可能にする。
        annotationView.canShowCallout = true
        print("-viewForAnnotation-")
        return annotationView
    }
    
    //吹き出しアクササリー押下時の呼び出しメソッド
    func mapView(_ mapView: MKMapView,
                 annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl
    ) {
        if(control == view.leftCalloutAccessoryView) {
            
            //左のボタンが押された場合はピンの色をランダムに変更する。
            if let pinView = view as? MKPinAnnotationView {
                pinView.pinTintColor = UIColor(red: CGFloat(drand48()),
                                               green: CGFloat(drand48()),
                                               blue: CGFloat(drand48()),
                                               alpha: 1.0)
            }
        } else {
            
            //右のボタンが押された場合はピンを消す。
            mapView.removeAnnotation(view.annotation!)
        }
    }
}
