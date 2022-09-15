지문인식을 위한 이미지 전처리 과정을 수행하였다. 크게 환경 세팅, 이진화, 세선화 순으로 수행한다.

## 1. 환경 세팅
본격적인 실습에 앞서 먼저 지문 이미지를 가져오기 위해 드라이브를 마운트 하고, 전처리를 위한 모듈을 설치한다. 그리고 사용할 지문 이미지를 변수에 저장해 둔다.
 ![image](https://user-images.githubusercontent.com/79822913/190295526-b4ee8e43-3cab-464f-b021-f68f122716b7.png)

이진화를 수행하기에 앞서 먼저 입력된 지문 이미지를 흑백으로 변환하였다.
 ![image](https://user-images.githubusercontent.com/79822913/190295536-59b36107-0403-43f9-b855-868bc36d895f.png)


## 2. 이진화
이후, 회색으로 변환한 이미지에 대해 이진화를 수행하였다. 이를 위해 원본 파일 크기 256*256과 동일한 크기를 가진 배열을 새로 생성하였다.
 
![image](https://user-images.githubusercontent.com/79822913/190295548-5a51c053-6359-439c-81d8-48453f1cb157.png)
  
  
그 결과 다음과 같은 이미지가 나온다. 하지만 이때, y 좌표 기준 [0:100]은 융선과 골이 제대로 분리되지 않은 모습이 보인다. 골에 해당하는 검정색 부분이 많이 끊어져 있다. 반면, y 좌표 기준 [150:256]을 확인해보면 [0:100] 구간에 비해 융선의 굵기가 너무 얇고 제대로 이어지지 않는 형태를 보인다. 따라서 우선, 해당 이미지의 전처리를 시도하고자 하였다.

첫 번째로 접근한 방법은 이미지 하단의 융선의 굵기를 굵게 해주기 위해 dilate(팽창) 연산을 수행해 보았다. 
 ![image](https://user-images.githubusercontent.com/79822913/190295579-0baa1dd8-be15-455c-9ba8-192b266423d1.png)

문제가 되었던 밑부분의 융선의 굵기는 굵어진 것이 보이지만, 이로 인해 상단의 융선 굵기까지 굵어져 융선과 골을 제대로 인식할 수 없어지는 문제가 생겼다. 

같은 맥락으로 이번엔 img_gray 상단 부분의 융선과 골을 분리시키기 위해 erode(침식) 연산도 수행해보았다.
 ![image](https://user-images.githubusercontent.com/79822913/190295585-f24d94cc-6ea4-49d7-9278-0c929715520c.png)

상단의 융선과 골이 분리되는 모습을 보이지만 이 경우 하단의 융선이 너무 얇아지는 문제가 생긴다.

이는, 그림 Figure 2 에서 확인할 수 있듯, 애초에 입력된 이미지 자체의 밝기가 다르기 때문에 발생한 문제이다. 위 경우는 이미지의 상단이 하단에 비해 더 선명하며 하단은 밝기가 밝아 상단에 비해 흐릿한 모습을 보인다. 하나의 이미지에 대해 고정된 임계치 값을 사용하기 때문에 형상의 밝기가 균일하지 않으면 이진화가 균일하게 수행되지 않는다. 

따라서 threshold 함수를 이용하여 지역 이진화를 수행하였다. 
 ![image](https://user-images.githubusercontent.com/79822913/190295598-90c1ec06-fbe6-4691-b214-1dab4dafdb6e.png)

가로 세로 16등분을 하여 등분한 각 이미지 별로 하나의 임계값을 적용한다. cv2.threshold에 argument가 총 4개 입력된다. 첫 번째는 원본이미지, 위 경우 16등분한 이미지 중 하나를 의미한다. 두번째는 임계값, 세번째는 임계값 이상일 경우 바꿀 최대값(보통 흰색인 255이다)을 넣었다. 네번째 아규먼트로 THRESH_BINARY를 사용하여 픽셀 값이 임계값보다 클 경우, 최대값(255, 흰색)으로 하고, 픽셀값이 임계값보다 작은 경우 0(검정색)으로 이진화를 하였다. 그리고 dst_로 출력값을 내도록 하였다.

결과적으로 나온 이미지는 다음과 같다. 이전에 비해 더 뚜렷하게 융선과 골이 분리되었음을 확인할 수 있다.
 
![image](https://user-images.githubusercontent.com/79822913/190295609-ade3ead6-872d-465f-a6c2-9a8719d13a01.png)

그리고 세선화를 위해 해당 이미지를 다시 이진화(흑, 백 반전) 시켰다. 
 ![image](https://user-images.githubusercontent.com/79822913/190295617-de547eb9-640b-43f4-8f24-d67ec63185a1.png)



## 3. 세선화
세선화를 위해 openCv의 morphology 연산을 시도하였다. 하지만 dilate(팽창)연산을 적용한 이미지에서erosion(침식)연산을 적용한 이미지를 빼 경계 픽셀을 얻는 방식이기에 융선이 한 줄로 세선화 되는 것이 아니라 두 줄로 표현되는 문제가 발생하였다. 

 ![image](https://user-images.githubusercontent.com/79822913/190295624-934e0a7c-246b-4d37-8a58-1231068734a5.png)


따라서 Zhang-Suen의 세선화 알고리즘을 사용하였다. 
 
 ![image](https://user-images.githubusercontent.com/79822913/190295636-bd881b50-99a2-4a35-b8e5-a2170f671bb1.png)

 ![image](https://user-images.githubusercontent.com/79822913/190295648-7c1cce7b-8cca-44b2-bc54-101fbddd9a1e.png)
![image](https://user-images.githubusercontent.com/79822913/190295654-ef69da96-04ec-49d6-9af0-2b145584a462.png)

결과는 다음과 같다. 
 ![image](https://user-images.githubusercontent.com/79822913/190295658-5db3a533-3842-4283-a725-0e414a616cee.png)

융선의 세선화가 성공적으로 수행되었음을 확인할 수 있다. 하지만, 지문의 가장자리에 바깥으로 뻗어나가는 선이 생성되는 문제가 생겨 이 부분에 대해서는 더 고안해보아야 할 것 같다.

## 4. 최종 결과
1. 001_00.png
    ![image](https://user-images.githubusercontent.com/79822913/190295675-555759b7-9d28-4afd-8ab8-30c57451b7ce.png)
![image](https://user-images.githubusercontent.com/79822913/190295686-be5c0f8b-0e6f-4887-b733-022dc11f6c9d.png)
![image](https://user-images.githubusercontent.com/79822913/190295695-877dac47-b181-4746-a045-d8c33a4bbbb5.png)

2. 002_00.png
    
![image](https://user-images.githubusercontent.com/79822913/190295703-9191d7c9-5447-4233-9fa1-56b19999cd1b.png)
![image](https://user-images.githubusercontent.com/79822913/190295711-9aa1a071-8d92-4306-897b-8657845b5c9e.png)
![image](https://user-images.githubusercontent.com/79822913/190295719-3179a992-d908-462b-af9b-4cc1f3d6ad36.png)

