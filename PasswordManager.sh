#!/bin/sh
#APPRENTICE提出QUEST パスワードマネージャー

#グローバル変数
FileName="PassWord.txt"
EncryptedFileName="PassWord.gpg"


#各データ入力用関数
# 第1引数のテキストを表示し、第2引数の変数へ入力値を格納する
InputData(){
    echo "$1"
    read "$2"
}

#保存用関数
# 渡された3つの引数をFileNameに保存する
#   保存するテキストの形式
#       第1引数:第2引数:第3引数
#       サービス名:ユーザー名:パスワード
AddPassword(){
    InputData "サービス名を入力してください：" ServiceName
    InputData "ユーザー名を入力してください：" UserName
    InputData "パスワードを入力してください：" PassWord

    echo "$ServiceName:$UserName:$PassWord" >> gpg --output "$EncryptedFileName" --encrypt
    echo "パスワードの追加は成功しました。"
}





#データ表示用関数
# 渡されたサービス名と一致するデータをFileNameから抽出し、表示する
GetPassword(){
    InputData "表示するサービス名を入力してください。" ServiceName

    Found=False

    while IFS=":" read -r serviceName userName passWord; do #サービス名と一致するテキストを抽出
        if [ "$ServiceName" = "$serviceName" ]; then
            echo "サービス名：$serviceName"
            echo "ユーザー名：$userName"
            echo "パスワード：$passWord"
            Found=True
        fi
    done < "$FileName"

    if [ "$Found" = False ]; then #サービス名が見つからなかった場合
        echo "そのサービスは登録されていません。"
    fi

    }



#モード選択用関数
# 入力されたテキストに応じてモードを選択し実行する
SelectMode(){
    ExitFrag=False

    while [ "$ExitFrag" = False ]; do #"Exit"が入力される(ExitFragがTrueになる)まで繰り返す
        InputData "Add Password/Get Password/Exit から入力してください。" mode
        case "$mode" in
            "Add Password")
                AddPassword
                ;;
            "Get Password")
                GetPassword
                ;;
            "Exit")
                ExitFrag=True
                ;; 
            *)
                echo "入力が間違えています。Add Password/Get Password/Exit から入力してください。"
                SelectMode
                ;;
        esac
    done


}


#メイン関数
Main(){
    echo "パスワードマネージャーへようこそ！"
    SelectMode
    echo "Thank you!"
}

Main