#!/bin/sh
#APPRENTICE提出QUEST パスワードマネージャー
#ユーザーから入力された情報をファイルに書き込む

#パスワードマネージャーへようこそ！
# サービス名を入力してください：
# ユーザー名を入力してください：
# パスワードを入力してください：
# # 入力が完了したら
# Thank you!


#データ取得用関数
#   第一引数：ユーザーに表示するテキスト
#   第二引数：ユーザーから取得するテキスト
GetData(){
    echo "$1"
    read "$2"
}


#データ保存用関数
AddData(){
    echo "$1:$2:$3" >> "PassWord.txt"
}


#メイン関数
Main(){
    echo "パスワードマネージャーへようこそ！"

    GetData "サービス名を入力してください：" ServiceName
    GetData "ユーザー名を入力してください：" UserName
    GetData "パスワードを入力してください：" PassWord

    AddData 
    echo "Thank you!"
}


Main