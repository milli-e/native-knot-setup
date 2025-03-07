#!/bin/bash

# 프로젝트 이름 입력
read -p "📄 프로젝트 이름을 입력해주세요 (기본값: MyReactNativeApp): " PROJECT_NAME </dev/tty
PROJECT_NAME="${PROJECT_NAME:-MyReactNativeApp}" # 기본값 설정

# React Native 버전 입력
read -p "👉 사용할 React Native 버전을 입력하세요 (기본값: 0.77): " RN_VERSION </dev/tty
RN_VERSION="${RN_VERSION:-0.77}" # 기본값 설정

# 프로젝트 생성
echo "🚀 React Native $RN_VERSION 버전으로 '$PROJECT_NAME' 프로젝트를 생성합니다"
npx @react-native-community/cli@latest init $PROJECT_NAME --version $RN_VERSION

# 프로젝트 디렉토리로 이동
cd $PROJECT_NAME

# 필수 라이브러리 설치
echo "📦 라이브러리 설치 중..."
npm install @react-navigation/native @react-navigation/stack @react-navigation/native-stack react-native-gesture-handler react-native-safe-area-context react-native-screens axios @reduxjs/toolkit @react-native-masked-view/masked-view react-native-fast-image react-native-permissions react-native-reanimated react-native-mmkv

# 폴더 구조 설정
echo "📂 폴더 구조 생성 중..."
mkdir -p src/{models,api,assets/{images,fonts},components,customHook,routes,screens,store,utils}

echo "🧑‍💻 공용 코드 작성 중..."
cat <<EOF > src/components/Text.tsx
import React from 'react';
import { Text as RNText } from 'react-native';

const Text = ({ ...props }) => {
  return (
    <RNText {...props} allowFontScaling={false}>
      {props.children}
    </RNText>
  );
};

export default Text;
EOF

# 기본 설정 추가
echo "🎨 기본 설정 중..."
cat > .prettierrc <<EOL
{
  singleQuote: true,
  tabWidth: 2,
  printWidth: 100,
}
EOL

# tsconfig.json 에 path alias 설정 추가
cat <<EOF > tsconfig.json
{
  "extends": "@react-native/typescript-config/tsconfig.json",
  "compilerOptions": {
    "baseUrl": "./src",
    "paths": {
      "@/*": ["/"],
      "@models/*": ["models/*"],
      "@api/*": ["api/*"],
      "@assets/*": ["assets/*"],
      "@components/*": ["components/*"],
      "@hooks/*": ["customHook/*"]
      "@routes*/": ["routes/*"],
      "@screens/*": ["screens/*"],
      "@store/*": ["store/*"],
      "@utils/*": ["utils/*"],
      
    }
  },
  "exclude": ["node_modules", "babel.config.js", "metro.config.js", "jest.config.js"]
}
EOF

# babel.config.js 파일에 path alias 추가
cat <<EOF > babel.config.js
module.exports = {
  presets: ['module:@react-native/babel-preset'],
  plugins: [
    [
      'module-resolver',
      {
        root: ['./src'],
        extensions: ['.js', '.jsx', '.ts', '.tsx', '.json'],
        alias: {
          '@': './src',
          '@models': './src/models',
          '@api': './src/api',
          '@assets': './src/assets',
          '@components': './src/components',
          '@hooks': './src/customHook',
          '@routes': './src/routes',
          '@screens': './src/screens',
          '@store': './src/store',
          '@utils': './src/utils',
          
        },
      },
    ],
    ['react-native-reanimated/plugin'],
  ],
};
EOF

echo "🎉🎉 빰바바밤! 프로젝트 '$PROJECT_NAME' 생성 및 세팅 완료! 🎉🎉"