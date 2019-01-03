url_rn="$rn/reactnative_firebase"
cd $url_rn
code .

url_gm_tools="/opt/genymobile/genymotion/"
cd $url_gm_tools
./gmtool admin start "Google Nexus 5X"
wait $!

cd $url_rn
sudo react-native run-android && react-native start

# in case of failure kill the running service with these commands
#sudo lsof -nP -iTCP:8081
#sudo kill <process id>
