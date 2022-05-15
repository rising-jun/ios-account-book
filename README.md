# ios-account-book
## 가계부
   - 지출 내역 리스트 화면
   - 소비 지도 화면
   - 카테고리 별 소비 차트 화면
   - 총 지출 금액 화면

## 앱 구조

  RxSwift + MVVM을 사용하였습니다.
  <img width="1132" alt="스크린샷 2021-12-02 오후 4 44 38" src="https://user-images.githubusercontent.com/62687919/144379303-a4d588ba-33db-40c5-a769-0720adb2c1da.png">
  
  - View는 하나의 ViewModel과 Binding되어 있습니다.
  - View에서의 Action들은 input을 통하여 ViewModel로 전달됩니다.
  - ViewModel은 전달받은 Action에 맞는 로직을 한 후 State를 업데이트 합니다. 
  - Firebase등 네트워크가 필요한 작업은 그에 맞는 Model에게 요청합니다. 
  - ViewController는 ViewModel의 State를 구독하여 변경되는 값이 있다면 Binding을 통하여 View를 업데이트 합니다. ( RxCocoa 사용 )
  - RxCocoa의 Drive를 사용하였습니다. ( MainSchedular에서의 실행 보장. UI변경작업. )
  
## 앱 화면
     
   <img width="344" alt="스크린샷 2021-12-02 오후 4 55 59" src="https://user-images.githubusercontent.com/62687919/144380728-afe156bc-3eb4-4f37-a026-4804cb3291e6.png"><img width="325" alt="스크린샷 2021-12-02 오후 4 58 20" src="https://user-images.githubusercontent.com/62687919/144381024-02e9ac1d-3a32-4f28-a3f5-a7ff795c8a79.png"><img width="323" alt="스크린샷 2021-12-02 오후 4 59 14" src="https://user-images.githubusercontent.com/62687919/144381122-8ddaf6db-0afc-4a12-ba92-5f864a011b60.png">
   
## 사용 라이브러리
     
https://github.com/rising-jun/ios-account-book/wiki/%EA%B0%80%EA%B3%84%EB%B6%80%EC%95%B1-%EC%82%AC%EC%9A%A9-%EA%B8%B0%EC%88%A0-%EC%A0%95%EB%A6%AC.
