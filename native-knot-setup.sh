#!/bin/bash



# 프로젝트 생성
echo "🚀 React Native $RN_VERSION 버전으로 '$PROJECT_NAME' 프로젝트를 생성합니다"
bash -c "npx @react-native-community/cli@latest init $PROJECT_NAME --version $RN_VERSION"



