#!/bin/bash

# 프로젝트 이름 입력
read -p "📄 프로젝트 이름을 입력해주세요 (기본값: MyReactNativeApp): " PROJECT_NAME < /dev/tty
PROJECT_NAME=${PROJECT_NAME:-MyReactNativeApp} # 기본값 설정

# React Native 버전 입력
read -p "👉 사용할 React Native 버전을 입력하세요 (기본값: 0.77): " RN_VERSION < /dev/tty
RN_VERSION=${RN_VERSION:-0.77} # 기본값 설정

# 프로젝트 생성
echo "🚀 React Native $RN_VERSION 버전으로 '$PROJECT_NAME' 프로젝트를 생성합니다"
( npx @react-native-community/cli@latest init $PROJECT_NAME --version $RN_VERSION )

echo "🏃 프로젝트 생성 완료!"

# 후속 작업 실행
read -p "👀 프로젝트 세팅을 계속해서 진행할까요? (y/n): " confirm < /dev/tty
if ["$confirm" != "y"]; then
  echo "프로젝트 세팅을 취소합니다."
  exit()
fi

# 동일한 저장소에 존재하는 후속 스크립트 실행
# 프로젝트 디렉토리로 이동
cd $PROJECT_NAME || { echo "프로젝트 디렉토리로 이동 실패"; exit 1; }
echo "🧙 프로젝트 세팅 시작!"
curl -sL https://raw.githubusercontent.com/milli-e/native-knot-setup/refs/heads/main/project-setup.sh | bash

