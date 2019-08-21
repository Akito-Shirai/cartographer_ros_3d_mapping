# cartographer_ros_3d_mapping
----
###実行環境
 * ubuntu 18.04 LTS
 * ROS melodic
 * CPU : Intel corei7 7700
 * HDD : 4TB
 * RAM : 48GB
 * SENSOR : vlp16, adis(IMU)
----
###使用目的
つくばチャレンジで使用するための三次元地図作成

----
##注意事項
google cartographerを用いた三次元地図生成は、LiDARとIMUに依存します。
本パラメータは、我々が使用している機体「ORNEα」に合わせて最適化しているため、他の機体で同じ挙動は期待できません。
また、約2Kmの地図を作るにあたって、非常に重い処理がかかります。低スペックPCでの実行は、環境を壊す危険性があるため、十分に注意してください。
以上を踏まえて、本パラメータを実行の際には一切の責任を負いませんので、ご理解ください。

----
###実行方法
 * cartographer実行
 $ roslaunch cartographer_ros demo_orne_alpha.launch bag_filename:=~/..full_pass
 * 終了時
 $ rosservice call /finish_trajectory 0
 * pbstreamで保存
 $ rosservice call /wite_state ${HOME}/.../filename.bag.pbstream

----
###pcd or ply 変換
(※)お使いの機体に合わせてasset_writerのパラメータを設定してください。
 * asset_writer実行
 $ roslaunch cartographer_ros {launchファイル名}.launch bag_filenames:=${HOME}/..full_pass pose_graph_filename:=${HOME}/..full_pass

----
###Lab
 * [open-rdc](https://github.com/open-rdc/)
----
###LICENSE
See the LICENSE file for details.
