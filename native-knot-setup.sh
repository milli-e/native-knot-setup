#!bin/bash

# 프로젝트 이름 입력
read -p "📄 프로젝트 이름을 입력해주세요 (기본값: MyReactNativeApp): " PROJECT_NAME < /dev/tty
PROJECT_NAME=${PROJECT_NAME:-MyReactNativeApp} # 기본값 설정

# React Native 버전 입력
read -p "👉 사용할 React Native 버전을 입력하세요 (기본값: 0.77): " RN_VERSION < /dev/tty
RN_VERSION=${RN_VERSION:-0.77} # 기본값 설정

# export로 환경 변수 지정
export PROJECT_NAME
export RN_VERSION

# native-knot-setup.sh를 curl로 원격 실행 (이 명령이 완료되지 않아도 프로세스는 마스터 스크립트에 종속되지 않음)
curl -sL https://raw.githubusercontent.com/milli-e/native-knot-setup/refs/heads/main/react-native-setup.sh | bash

# 프로젝트가 생성되었는지 폴링 (예: package.json 파일이 생성될 때까지)
COUNTER=0
  while [ $COUNTER -lt 60 ]; do
    if [ -f "${PROJECT_NAME}/package.json" ]; then
      echo "🏃 프로젝트 생성 완료!"
      break
    fi
    sleep 2
    COUNTER=$((COUNTER+1))
done

# 프로젝트 디렉토리로 이동
cd $PROJECT_NAME || { echo "🫠 프로젝트 디렉토리로 이동 대실패"; exit 1; }

# 후속 작업 실행
read -p "👀 프로젝트 세팅을 계속해서 진행할까요? (Y/n): " CONFIRM < /dev/tty
CONFIRM=${CONFIRM:-y} # 기본값 설정
CONFIRM=$(echo "$CONFIRM" | tr [:upper:] [:lower:])
if [ "$CONFIRM" != "y" ]; then
  echo "🫠 프로젝트 세팅을 취소합니다. pod install 은 진행됩니다."
  echo "🥥 iOS pod install 중..."
  cd ios
  bundle install # you need to run this only once in your project.
  bundle exec pod install
  cd ..
  exit 0
fi

# 동일한 저장소에 존재하는 후속 스크립트 실행
echo "🧙 프로젝트 세팅 시작!"
curl -sL https://raw.githubusercontent.com/milli-e/native-knot-setup/refs/heads/main/project-setup.sh | bash