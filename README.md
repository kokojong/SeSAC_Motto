![SeSAC_Motto_all](https://user-images.githubusercontent.com/61327153/155879672-27cad77e-673f-4cd3-8d7c-9ab74707e4b6.png)

# 모의로또 - 모또

새싹 첫 개인 출시 프로젝트 모또 입니다.
[앱 스토어에서 구경하기](https://apps.apple.com/kr/app/%EB%AA%A8%EB%98%90-%EB%AA%A8%EC%9D%98-%EB%A1%9C%EB%98%90/id1597847167)

- 동행복권 API를 이용한 최신 당첨 정보 제공
- Realm을 이용해 당첨 결과,구매 데이터 저장 및 활용
- '내가 놓친 1등 번호' 기능 제공

</br>


## 개발 기간 및 사용 기술

- 개발 기간: 2021.11.15 ~ 2022.12.05 (3주) - 기획 및 디자인, 개발, 앱 출시 등
- 세부 개발 기간

| 진행 사항 | 진행 기간 | 세부 내역 |
| ------ | ------ | ------ |
| 기획 및 디자인(초안) | 2021.11.15~2021.11.21 | 앱 아이디어 구상, 기존 앱 비교 분석, 기초 UI 구상, 전체 일정 구상, 기획 발표 |
| 홈 탭 구현, Realm 도입 | 2021.11.22~2021.11.24 | 홈 화면 UI 및 기능 구현, Realm 도입 및 데이터 스키마 구상, API 호출 메서드 구현 |
| 모또 구매 탭 구현, 기록 탭 구현, 디자인 적용 | 2021.11.25~2021.11.28 | (반)자동, 수동 모또 구매 기능 구현, 내가 놓친 1등 기능 구현, 디자인 적용 |
| 버그 수정, 앱 출시 준비, 심사 | 2021.11.29~2021.12.01 | 버그 수정, mock up 이미지 준비, 앱 설명 등 준비, 개인정보 처리방침 준비 |
| Reject 처리 | 2021.12.02~2021.12.05| 앱 출시 소명, 앱 문구 전면 수정 |



- 사용 기술: `Storyboard`, `UIKit`, `Alamofire`, `Toast`, `Realm`, `Codable`, `SwiftyJSON`, `Firebase Crashlytics`, `MVC`
 
 </br>

## 새로 배운 것

- 앱 기획부터 출시까지의 경험
- 오토레이아웃을 통한 기기 대응(iPhone8 및 iPhone11 이상 대응)
- Alamofire를 이용한 비동기 네트워크 통신
- Realm을 이용한 데이터 저장 및 활용, 데이터 스키마 구성
- MVC 패턴의 기초 이해


</br>

## 이슈

- '가상 도박'이 포함된 이유로 **Reject** -> 가상 도박이 아님을 소명, 문제가 될 수 있는 '구매'에 관련한 단어 전면 수정
<img width="815" alt="스크린샷 2022-02-28 오전 2 19 47" src="https://user-images.githubusercontent.com/61327153/155892552-a446f366-f495-463e-b6ff-1610ea789a2e.png">

> 한 줄로 요약하면 '가상 도박이 포함 되어있다'라고 체크했기 때문에 한국에서는 출시가 제한된다.
</br>

- CollectionView selectItem 토글 형식 처리 -> didDeselectItemAt을 사용
```swift
  func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
      if collectionView == includeCollectionView {
          if includedNumberList.contains(indexPath.row + 1){
              if let index = includedNumberList.firstIndex(of: indexPath.row + 1) {
                  includedNumberList.remove(at: index)
              }
          }
      }
      ...
  }
```
```swift
class ManualBuyCollectionViewCell: UICollectionViewCell {

    static let identifier = "ManualBuyCollectionViewCell"
    
    @IBOutlet weak var numberLabel: UILabel!
    
    override var isSelected: Bool{
        didSet {
            if isSelected {
                numberLabel.textColor = .white
                self.backgroundColor = .myOrange
            } else {
                numberLabel.textColor = .lightGray
                self.backgroundColor = .clear
            }
        }
    }
```

- 과도한 API 호출로 인한 지연 -> 최신 회차의 정보부터 받아오고 이전 회차 정보는 비동기로 realm에 저장
```swift
func loadAllDrawData(drawNo: Int) {
    ...

    if self.drawResults.filter(predicate).count == 0  { // 가장 최근 회차 정보가 없다면
        self.saveResult(drawResult: result)
    }

}

func saveResult(drawResult: DrawResult){

    try! self.localRealm.write {
        localRealm.add(drawResult)
    }
    if drawResult.drwNo == recentDrawNo {
        updateUIByRecentDrawNo(recentDrawNo: recentDrawNo)
        updateBottomViewByRecentDrawNo()
    }
}
    

```

</br>

## 기획 아이디어

로또 1등을 꿈꾸지만 구매하기에는 부담스럽기 때문에 모의로 구매하는 아이디어에서 출발했습니다

다른 기능으로는 모의로 구매한 번호 중 이전 회차의 1등 번호와 비교하는 '아깝게 놓친 1등' 기능이 있습니다.

 </br>

## UI 초안

<!-- ![UI초안](https://user-images.githubusercontent.com/61327153/142159927-5d04c31a-4d7c-4014-ab39-ce98db63df9a.jpeg) -->

<img src="https://user-images.githubusercontent.com/61327153/142159927-5d04c31a-4d7c-4014-ab39-ce98db63df9a.jpeg" width="600"/>

기획이 개발 과정 중 수정 되었지만, 초안은 위와 같습니다.

 </br>

## UI

| (반)자동 모또 추가하기 | 수동 모또 추가하기 | 아깝게 놓친 1등 확인하기 |
| ------ | ------ | ------ |
| ![motto_auto_add](https://user-images.githubusercontent.com/61327153/155891400-5c73be86-c536-42c1-8ea4-8e4b3e3d8758.gif) | ![motto_manually_add](https://user-images.githubusercontent.com/61327153/155891402-312bae32-784d-4644-bb3e-c94659a25203.gif) | ![motto_missed_prize](https://user-images.githubusercontent.com/61327153/155891403-578b0313-01cc-434a-933f-3df14903af59.gif) |

 </br>

## 출시 정보

### v1.0
- 2021.12.03 출시

### v1.1
- 2022.02.11 업데이트
- Firebase Crashlytics, Firebase Analytics 적용
- 불필요한 코드 제거
