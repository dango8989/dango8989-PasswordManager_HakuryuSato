#!/bin/sh
#APPRENTICE提出QUEST パスワードマネージャー


GetData(){
    echo "$1"
    read "$2"
}




#メイン関数
Main(){
    echo "パスワードマネージャーへようこそ！"

    GetData "サービス名を入力してください：" ServiceName
    GetData "ユーザー名を入力してください：" UserName
    GetData "パスワードを入力してください：" PassWord

    echo "Thank you!"
}


Main()