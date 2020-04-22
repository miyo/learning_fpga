---
title: "クイックスタート"
date: 2019-10-30T19:15:46+09:00
type: docs
draft: false
weight: -1700
---

# クイックスタート

FPGA開発におけるHello World **Lチカ** を通して，開発の手順に慣れよう

## はじめに
この章では，FPGA開発におけるHello World，すなわち最初に試してみるサンプルとして **Lチカ** を題材に，開発の手順に慣れてみましょう． **Lチカ** とは，「LEDをチカチカさせる」の略です．

単にLEDとチカチカさせるだけ，なのですが，開発の手順を身につけるには十分です．また，実際多くの信号制御は何かしらの規則にしたがって信号をON/OFFしていることですから，すべての信号制御はLチカの応用にあるとも言えます．簡単ですが大事ですよ．

## プロジェクトの用意


{{<figure src="../quickstart_figures/VirtualBox_Windows10_19_03_2018_00_01_24.png" class="center" caption="図1: VivadoのFileメニューから，New Project...を選択する">}}

{{<figure src="../quickstart_figures/VirtualBox_Windows10_19_03_2018_00_01_32.png" class="center" caption="図2: プロジェクト作成ダイアログが開くので，Next>で次へ">}}

プロジェクト名と格納先を決めます．ここでは，ホームディレクトリの下のVivadoというフォルダの下にプロジェクトを格納することとし，名前をproject\_1としています．

{{<figure src="../quickstart_figures/VirtualBox_Windows10_19_03_2018_00_01_37.png" class="center" caption="図3: プロジェクト名と格納先を決めます">}}

{{<figure src="../quickstart_figures/VirtualBox_Windows10_19_03_2018_00_01_43.png" class="center" caption="図4: プロジェクトタイプの指定です．RTLプロジェクトを指定します">}}

{{<figure src="../quickstart_figures/VirtualBox_Windows10_19_03_2018_00_02_24.png" class="center" caption="図5: すでにソースコードがある場合にはここで追加できます．今回はないのでNext>で，そのまま次へ">}}

{{<figure src="../quickstart_figures/VirtualBox_Windows10_19_03_2018_00_02_30.png" class="center" caption="図6: すでに制約ファイルがある場合にはここで追加できます．今回はないのでNext>で，そのまま次へ">}}

{{<figure src="../quickstart_figures/VirtualBox_Windows10_19_03_2018_00_02_49.png" class="center" caption="図7: ターゲットとするFPGAの選択画面です．BoardタブをクリックしZybo Z7-20を選択してNext>で次へ">}}

{{<figure src="../quickstart_figures/VirtualBox_Windows10_19_03_2018_00_02_55.png" class="center" caption="図8: 確認画面です．Finishをクリックするとプロジェクトの作成は完了です">}}

{{<figure src="../quickstart_figures/VirtualBox_Windows10_19_03_2018_00_03_06.png" class="center" caption="図9: プロジェクト作成には少し時間がかかります">}}

これでプロジェクトの完成です．Product FamilyがZynq-7000に，Project Summaryの表示を見ると，Project partがZybo Z7-20と，Z7-20向けのプロジェクトができていることがわかります．

{{<figure src="../quickstart_figures/VirtualBox_Windows10_19_03_2018_00_03_17.png" class="center" caption="図10: プロジェクトができあがりました．">}}

## ファイルの作成

作成したプロジェクトで，LEDをチカチカさせるためのデザインを追加していきます．ここではVivadoのウィザードを使ってデザインファイルを用意する方法ですすめていきます．

{{<figure src="../quickstart_figures/VirtualBox_Windows10_19_03_2018_00_03_27.png" class="center" caption="図11: SourcesのDesign Sourceの上で右クリックし，Add Sources...を選択する">}}

{{<figure src="../quickstart_figures/VirtualBox_Windows10_19_03_2018_00_03_35.png" class="center" caption="図12: ファイル追加ダイアログが開く">}}

{{<figure src="../quickstart_figures/VirtualBox_Windows10_19_03_2018_00_03_42.png" class="center" caption="図13: 2番目のAdd or create design sources...にチェックをいれてNext>をクリック">}}

{{<figure src="../quickstart_figures/VirtualBox_Windows10_19_03_2018_00_03_54.png" class="center" caption="図14: ここで新しくファイルを作るので，Create Fileをクリック">}}

{{<figure src="../quickstart_figures/VirtualBox_Windows10_19_03_2018_00_04_01.png" class="center" caption="図15: 使用言語とモジュール名を決めます．ここではVHDLを使うこととし，名前をtopと決めてOKをクリック">}}

{{<figure src="../quickstart_figures/VirtualBox_Windows10_19_03_2018_00_04_44.png" class="center" caption="図16: 作成するファイルがリストに登録されたので，Finishをクリックします">}}

{{<figure src="../quickstart_figures/VirtualBox_Windows10_19_03_2018_00_04_59.png" class="center" caption="図17: 新たに作成したtopモジュールのポートなどを定義することができます．あとで自分で書いてもいいのですが，入力ポートのclkと出力ポートのledを追加しましょう．OKをクリックします">}}

{{<figure src="../quickstart_figures/VirtualBox_Windows10_19_03_2018_00_05_13.png" class="center" caption="図18: 作成したtopモジュールがプロジェクトに組み込まれました">}}

{{<figure src="../quickstart_figures/VirtualBox_Windows10_19_03_2018_00_06_55.png" class="center" caption="図19: 組み込まれたtopをダブルクリックするとファイルを編集することができます">}}

## デザインの修正
ウィザードで作成したtopモジュールは雛形でしかないので，このままでは，もちろん所望の動作はしません．次の内容で書き変えてください．スペースの都合上，作成されたコメントは取り除いています．ファイルを編集するときには気をつけてください．また，リスト中のコメントは説明上のものですので，実際には入力する必要はありません．

{{< highlight vhdl "linenos=table" >}}
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all; -- 追加する．数値演算に必要(1)．

entity top is
  Port ( clk : in STD_LOGIC;
         led : out STD_LOGIC); -- このPortはウィザードで作成された
end top;

architecture Behavioral of top is

  -- 次の行を追加．カウンタ変数の定義(2)．
  signal counter : unsigned(31 downto 0) := (others => '0'); 

  begin
  -- 追加，ここから(3)
  led <= std_logic(counter(23)); -- カウンタの23bit目をledに接続

  process(clk) -- クロックの変化で動作するプロセス
  begin
    if rising_edge(clk) then -- クロックの立ち上がりであれば
      counter <= counter + 1; -- カウンタをインクリメント
    end if;
  end process;
  -- 追加，ここまで
end Behavioral;
{{< /highlight >}}

追加箇所は多くないので，少し詳しくみてみましょう．

### 追加箇所(1)
数値演算に必要なライブラリ，今回の場合でいうと``+''演算を利用するために `use ieee.numeric_std.all` という前置きをしています．

### 追加箇所(2)
LEDチカチカの，``チカチカ''というタイミングを制御するためのカウンタ変数を定義です．+演算を利用したいので `unsigned` 型で定義しています．

### 追加箇所(3)
いわば処理の本体です．一行目の代入文は，定義したcounter変数の23bit目を出力ポートであるledに接続することを意味しています． `unsigned` の1bitですので `std_logic` に型変換しています．次のprocess文では，clkが立ち上がることにcounterに1を足すことを意味しています．すなわち，(3)で追加した部分では，clkの立ち上がり8M回毎にledの'1'と'0'が反転する回路を定義していることになります．


## まずは合成してみる
ファイルの編集がおわったら合成してみましょう．といっても，左サイドにあるFlow Navigatorの中にあるRun Synthesisをクリックするだけです．

{{<figure src="../quickstart_figures/VirtualBox_Windows10_19_03_2018_00_07_02.png" class="center" caption="図20: Run Synthesisをクリックすると合成開始ダイアログが開く．OKをクリックして合成を開始">}}

{{<figure src="../quickstart_figures/VirtualBox_Windows10_19_03_2018_00_07_16.png" class="center" caption="図21: 合成中は，Running Synth\_designの横に，ぐるぐるアニメーションが表示される">}}

{{<figure src="../quickstart_figures/VirtualBox_Windows10_19_03_2018_00_08_08.png" class="center" caption="図22: 合成が完了した">}}

## I/Oの設定
合成が完了したことでデザインがVivadoに受け付けられることが確認できました．しかし，これでそのままFPGAでデザインが動くわけではありません．I/Oピンの設定をしていないからです．HDLのデザイン上は，入力ポートclkと出力ポートのledを定義しましたが，Vivadoは，このポートをFPGAのどのピンに割り当てていいか分かりません．FPGAを使った開発では人手でこの割り当てを決める必要があります．

ピンの割当ては合成結果を下敷にGUIで行なうことができます．まずは，合成結果を表示します．

{{<figure src="../quickstart_figures/VirtualBox_Windows10_19_03_2018_00_08_14.png" class="center" caption="図23: 合成後のダイアログで，``Open Synthesized Design''を選択し，OKをクリックする">}}

もし，うっかり合成後のダイアログを閉じてしまったり，ピン配置を指定しないまま次のステップにすすんでしまった場合には，Flow Navigatorの中にあるOpen Synthesized Designをクリックしましょう．

合成結果が表示できたら，LayoutのI/O PlanningをクリックしてI/O設定用のモードに変更します．

{{<figure src="../quickstart_figures/VirtualBox_Windows10_19_03_2018_00_09_32.png" class="center" caption="図24: LayoutのI/O PlanningをクリックしてI/O設定用のモードに変更">}}

画面下のI/O割当て表でピン配置を決定します．clkとledのPackage pinを，それぞれ，K17とM14に決め，どちらもI/O stdをLVCMOS33を選択します．

{{<figure src="../ckstart_figures/VirtualBox_Windows10_19_03_2018_00_45_27.png" class="center" caption="図25: I/Oのピン割り当てを決める">}}

## 合成・配置配線
ピン配置がおわったので，FPGA向けの書き込みファイルを作成します．Flow Navigatorの中にあるGenerate bitstreamをクリックするだけです．

{{<figure src="../quickstart_figures/VirtualBox_Windows10_19_03_2018_00_15_52.png" class="center" caption="図26: Flow Navigatorの中にあるGenerate bitstreamをクリックする．必要な合成・配置配線は一気通貫に実行される \label{fig:file_save_dialog}">}}

### 制約ファイルの保存
おそらく先のピン配置の変更が保存されていないので，図\ref{fig:file_save_dialog}のダイアログが開くことでしょう．もちろん保存してください．

{{<figure src="../quickstart_figures/VirtualBox_Windows10_19_03_2018_00_15_59.png" class="center" caption="図27: ピン配置の変更が保存されてないために表示されるダイアログ．Saveをクリック． \label{fig:file_save_dialog}">}}

{{<figure src="../quickstart_figures/VirtualBox_Windows10_19_03_2018_00_16_26.png" class="center" caption="図28: ファイル保存すると合成の結果が無効になるよという警告．OKで閉じる．">}}

### 制約ファイルの指定(最初だけ)
はじめは，保存先のファイルが用意されていないので，図\ref{fig:xdc_config}のダイアログが開きます．ここでは，HDLモジュールと同じ名前のtopというファイル名にします．なお，拡張子はxdcで自動的に付与されます．

{{<figure src="../quickstart_figures/VirtualBox_Windows10_19_03_2018_00_16_35.png" class="center" caption="図29: ピン配置を保存するファイルの作成を促すダイアログ．topという名前にしてOKをクリック \label{fig:xdc_config}">}}

### 合成・配置配線の開始
指定したピン配置の設定によって合成からやりなおしになります．``Yes''をクリックしてフローをすすめます．

{{<figure src="../quickstart_figures/VirtualBox_Windows10_19_03_2018_00_16_41.png" class="center" caption="図30: 合成からやりなおし">}}

{{<figure src="../quickstart_figures/VirtualBox_Windows10_19_03_2018_00_16_46.png" class="center" caption="図31: 合成開始ダイアログ．OKで合成を開始．">}}

{{<figure src="../quickstart_figures/VirtualBox_Windows10_19_03_2018_00_20_45.png" class="center" caption="図32: 合成が無事に完了した．メインウインドウにCompleteという文字と緑のチェックマークがついている \label{fig:completed}">}}

## 配置配線結果の確認

配置配線後，どのようにFPGA上に回路が配置されたかを確認することができます．今回は指定していませんが，動作クロックの指定を行った場合などには，正しくクロックの指定ができているか，その指定にあった回路ができているか，を確認する必要があります．

今回は，まず雰囲気だけみてみましょう．合成後の図\ref{fig:completed}のダイアログで，Open Implementation DesignにチェックをいれてOKをクリックするか，Navigator FlowでOpen Implemnetation Designをクリックします．

{{<figure src="../quickstart_figures/VirtualBox_Windows10_19_03_2018_00_21_16.png" class="center" caption="図33: 配置配線結果を開いてみたところ．右側の水色部分が使用しているハードウェアリソース">}}

{{<figure src="../quickstart_figures/VirtualBox_Windows10_19_03_2018_00_22_24.png" class="center" caption="図34: 接続パスを表示し，拡大してみたところ">}}


## 実機での動作確認

できあがったデータをFPGAボードにダウンロードして動作させてみましょう．

まずは，FPGAとパソコンをUSBケーブルで接続します．ここで，JP5のジャンパをJTAGに，JP16のジャンパをUSB側にセットしておいてください．

{{<figure src="../quickstart_figures/IMG_0002.JPG" class="center" caption="図35: FPGAとパソコンをUSBケーブルで接続．JP5とJP16の位置にも注意">}}

書き込みの手順は次の通りです．

{{<figure src="../quickstart_figures/VirtualBox_Windows10_19_03_2018_00_34_35.png" class="center" caption="図36: Navigator FlowでOpen Hardwareをクリックしたところ">}}

{{<figure src="../quickstart_figures/VirtualBox_Windows10_19_03_2018_00_34_45.png" class="center" caption="図37: Open Targetをクリックし，Auto Connectをクリック">}}

{{<figure src="../quickstart_figures/VirtualBox_Windows10_19_03_2018_00_51_49.png" class="center" caption="図38: FPGAボードと接続できたら，Program Deviceをクリック．開いたファイルダイアログでOKをクリック．">}}

これでFPGAボード上のLED LD0が点滅するはずです．

## 課題

 1. 点滅の間隔を変えてみよう
 1. FPGA上のほかのLEDも点滅させてみよう
