if [ $# -eq 0 ]; then
    echo Useage: notify title_str message_str
    exit 1
fi
pushd ~/Development/Applications
pwd
./terminal-notifier.app/Contents/MacOS/terminal-notifier -title $1 -message $2 -activate com.apple.iChat
popd
