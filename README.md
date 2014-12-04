﻿◆ 測光センサーでトイレの利用状態を把握したい！

事務所にある男性用トイレの交通整理のために、トイレの利用状態を確認する
簡単なアプリケーションを用意したいのです。

◆どうやって把握するの？

ドアの開閉、人の動作等、色々確認方法がありますが、今回は一番
わかりやすい（テストもしやすい）トイレの明かりの点滅で利用状態を
確認する方法で攻めたいと思います。

◆ 何をどうするの？

トイレは電源が取れない可能性が高いです。また、作業部屋の外に
あり、有線での確認は難しいため、乾電池でも動く省電力の無線
モジュール付マイコンTWE-Liteを利用して、点滅を確認する事にしました。

超小型ZigBee無線モジュール　ワイヤレスエンジン　TWE-Lite（トワイライト）
http://tocos-wireless.com/jp/products/TWE-001Lite.html

トイレに置いた無線モジュール（子機）で測光結果を取得し、親機では定期的に
クロールしてデータを取得、PCでデータを加工して作業部屋で利用可能なデータに
変換したいと思います。

TWE-Liteは色々なモデルがありますが、親機、子機は以下の機材を
利用します。

無線LANセンサ（子機）
TWE-Lite DIP
http://tocos-wireless.com/jp/products/TWE-Lite-DIP/index.html

無線LANセンサ（親機）
ToCoStick（トコスティック）
http://tocos-wireless.com/jp/products/TWE-Lite-USB/

子機の置き場所は、扉の上の空き空間を想定してます。

◆ 作ってみる！

◆ 測光用モジュールを組み立てる

測光用にTWE-Lite-DIPを設定します。

子機の配線はできていて、以下の図の「可変抵抗」を測光センサで置き換えます。
http://tocos-wireless.com/jp/products/TWE-Lite-DIP/TWE-Lite-DIPS1-2.jpg

測光センサは光の強さをアナログデータとして取得します。
親機はPCに接続するとシリアル接続で通信可能です。
子機のハンドル方法、取得可能なデータと形式は以下で確認可能です。

http://tocos-wireless.com/jp/products/TWE-Lite-USB/monitor.html

子機から送られたセンサデータはアナログ入力（AI）の値で取得可能です。

◆ LED点灯用モジュールを設定する

(1)LED点灯用にTWE-Lite-DIPを設定します。
(2) blink(1) mk2にデータを送ってみます。

◆ 測光データ取得してLED点滅用データに加工する

測光用モジュールから取得した光量情報（アナログデータ）を切り出して点灯中かどうか判断し、
LED点滅用のTWE-Lite-DIPに点滅を指示する情報（デジタルデータ）を作成します。

◆ 設置する

基盤を裸のまま置き去りにするのは発火の心配があったり錆びたり壊れたり、色々と問題が多いので
とりあえずカバーを用意します。
LEDも単独の点灯は見過ごされがちなのでカバーをつけて発行領域を広くします。

