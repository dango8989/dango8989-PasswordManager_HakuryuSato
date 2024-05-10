#!/bin/sh
#APPRENTICE提出QUEST パスワードマネージャー

# ユーザーから入力された以下の情報をFileNameに保存する
#  ・サービス名
#  ・ユーザー名
#  ・パスワード


#データ取得用関数
#   引数
#   第1引数：ユーザーに表示するテキスト
#   第2引数：ユーザーから取得するテキスト
GetData(){
    echo "$1"
    read "$2"
}


#データ保存用関数
#   引数
#   第1~3引数:保存するデータ
#   第4引数  :保存するファイル名
AddData(){
    echo "$1:$2:$3" >> "$4"
}


#メイン関数
Main(){
    FileName="PassWord.txt"

    echo "パスワードマネージャーへようこそ！"
    GetData "サービス名を入力してください：" ServiceName
    GetData "ユーザー名を入力してください：" UserName
    GetData "パスワードを入力してください：" PassWord


    AddData $ServiceName $UserName $PassWord $FileName
    echo "Thank you!"
}


Main