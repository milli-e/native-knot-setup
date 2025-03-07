#!/bin/bash

# 현재 디렉토리에서 package.json을 확인하여 React Native 프로젝트 디렉토리임을 검증
if [ ! -f "package.json" ]; then
  echo "🫠 현재 디렉토리가 React Native 프로젝트가 아닌 것 같아요!"
  exit 1
fi

# script 추가
# jq 설치 확인 (없으면 설치)
if ! command -v jq &> /dev/null; then
    echo "🔧 'jq'가 설치되어 있지 않습니다. 설치 중..."
    brew install jq  # Mac 사용자의 경우 (Linux는 apt 또는 yum 사용)
fi

# package.json에 스크립트 추가
echo "✏️ package.json에 스크립트 작성 중..."
jq '.scripts += {
  "start": "npx react-native start --reset-cache",
  "reset-cache": "npm cache verify",
  "android:bundle": "npx react-native bundle --platform android --dev false --entry-file index.js --bundle-output android/app/src/main/assets/index.android.bundle --assets-dest android/app/src/main/res/"
}' package.json > tmp.json && mv tmp.json package.json

# 필수 라이브러리 설치
echo "📦 라이브러리 설치 중..."
npm install @react-navigation/native @react-navigation/stack @react-navigation/native-stack react-native-gesture-handler react-native-safe-area-context react-native-screens axios @reduxjs/toolkit @react-native-masked-view/masked-view react-native-fast-image react-native-permissions react-native-reanimated react-native-mmkv

# iOS pod 세팅
echo "🥥 iOS pod install 중..."
cd ios
bundle install # you need to run this only once in your project.
bundle exec pod install
cd ..

# 폴더 구조 설정
echo "📂 폴더 구조 생성 중..."
mkdir -p src/{models,api,assets/{images,fonts},components,hooks,routes,screens,store,utils}

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
# Prettier 설정 
cat <<EOF > .prettierrc.js
module.exports = {
  singleQuote: true,
  tabWidth: 2,
  printWidth: 100,
};
EOF

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
      "@hooks/*": ["hooks/*"],
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
          '@hooks': './src/hooks',
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

echo "🎉🎉 빰바바밤! 프로젝트 '$PROJECT_NAME' 세팅 완료! 🎉🎉"