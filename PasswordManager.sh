#!/bin/sh
#APPRENTICE提出QUEST パスワードマネージャー

#グローバル変数
FileName="PassWord.txt"
DecryptedFileName=$FileName".gpg"
GPGUserName="Hakuryu"

#拡張子除外関数
ExtractFileName(){
    local FileNameWithExtension="$1"
    local OnlyFileName="${FileNameWithExtension%.*}"
    echo "$OnlyFileName"
}

#各データ入力用関数
# 第1引数のテキストを表示し、第2引数の変数へ入力値を格納する
InputData(){
    echo "$1"
    read "$2"
}

#ファイル暗号化用関数
# 引数として渡されたファイルを暗号化してから保存し、暗号化前のファイルを削除する
# 暗号化されたファイルの拡張子は FileName + ".gpg" となる
EncryptFile(){
    gpg --encrypt -r "$GPGUserName" "$1"
    rm "$2"
}

#ファイル復号化用関数
# 引数として渡されたファイルを復号化する
# 復号化するファイル名は FileName + ".gpg" となる
DecryptFile(){
    gpg --decrypt "$1"
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

    #もし既に保存用ファイルがある場合：復号化してから追記する、一時ファイルを使用する
    if [ -e "$DecryptedFileName" ]; then
        DecryptFileTmp="$DecryptedFileName.tmp" #一時ファイル名

        #復号化したファイルを一時ファイルに保存
        DecryptFile "$DecryptedFileName" > $DecryptFileTmp 

        #一時ファイルに追記
        echo "$ServiceName:$UserName:$PassWord" >> $DecryptFileTmp 

        #一時ファイルを元ファイルに上書き
        mv $DecryptFileTmp "$FileName"
        rm $DecryptFileTmp #一時ファイルを削除

        #一時ファイルを暗号化
        EncryptFile "$FileName" "FileName
 

    #もしファイルがない場合：新たに作成し、暗号化する
    else
        echo "$ServiceName:$UserName:$PassWord" >> "$FileName"
        EncryptFile "$FileName"
                
    fi

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
    done < <(DecryptFile "$FileName")

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