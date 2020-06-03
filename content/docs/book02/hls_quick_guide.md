---
title: "VivadoHLSを使ったCベース設計に挑戦"
date: 2019-10-30T19:15:46+09:00
type: docs
draft: false
weight: -1700
---

C/C++ベースのFPGA開発をはじめるにあたって，まずはVivado HLSの使い方をFPGAで動作するビットストリームの作り方まで一通り学んでしまいましょう．この章では，とりあえずVivado HLSを使った開発ができるようになるために，ツールを一通り使ってC/C++で書いたコードからFPGAで動作するビットストリームを生成する作業までを一通り体験してみることにします．習うより慣れろ，ですね．

## 例題
VivaoHLSでは，基本的な制御構文のC/C++コードをHDLモジュールにすることができます．ここでは，簡単なプログラムをハードウェア化してみましょう．

{{< highlight c "linenos=table" >}}
int bitcount(int a)
{
  int i;
  int s = 0;
  int tmp = a;
  for(i = 0; i < 32; i++){
    if((tmp & 0x01) == 0x01){
      s++;
    }
    tmp = tmp >> 1;
  }
  return s;
}
{{< /highlight >}}

## Vivado HLSプロジェクトの作成

{{<figure src="../hls_quick_guide_figures/VirtualBox_Windows10_19_03_2018_23_09_20.png" class="center" caption="Vivado HLSを起動したところ．Vivado HLSはデスクトップのショートカットアイコンやスタートメニューから起動する．">}}

{{<figure src="../hls_quick_guide_figures/VirtualBox_Windows10_19_03_2018_23_10_00.png" class="center" caption="プロジェクト名と格納フォルダを指定．ここでは．ホームの下のVivadoの下に格納することとし，名前をhls_test_1とした">}}

{{<figure src="../hls_quick_guide_figures/VirtualBox_Windows10_19_03_2018_23_10_06.png" class="center" caption="既存の設計ソースコードがあれば，ここで追加．ないのでNextで次へ．">}}

{{<figure src="../hls_quick_guide_figures/VirtualBox_Windows10_19_03_2018_23_10_10.png" class="center" caption="既存のテストベンチ用のソースコードがあれば，ここで追加．ないのでNextで次へ．">}}

{{<figure src="../hls_quick_guide_figures/VirtualBox_Windows10_19_03_2018_23_10_19.png" class="center" caption="ターゲットFPGAを選択する．Part Selectionの中の...ボタンをクリック">}}

{{<figure src="../hls_quick_guide_figures/VirtualBox_Windows10_19_03_2018_23_10_34.png" class="center" caption="FPGAの型番を選択．xc7z020clg400-1を選択する．検索フィールドにxc7z020と入力していくと楽に探せる．">}}

{{<figure src="../hls_quick_guide_figures/VirtualBox_Windows10_19_03_2018_23_10_39.png" class="center" caption="FPGAを選択し終えたらFinish．">}}

{{<figure src="../hls_quick_guide_figures/VirtualBox_Windows10_19_03_2018_23_11_08.png" class="center" caption="プロジェクトの作成が完了した">}}

## Vivado HLS上での設計

{{<figure src="../hls_quick_guide_figures/VirtualBox_Windows10_19_03_2018_23_11_14.png" class="center" caption="左ペインのSourcesアイコンの上で右クリック，New File...をクリック">}}

{{<figure src="../hls_quick_guide_figures/VirtualBox_Windows10_19_03_2018_23_11_22.png" class="center" caption="開いたファイル選択ダイアログに，作成するファイル test.c と入力して保存をクリック">}}

{{<figure src="../hls_quick_guide_figures/VirtualBox_Windows10_19_03_2018_23_13_38.png" class="center" caption="作成したtest.cの中身として，先のソースコードを入力する．">}}

{{<figure src="../hls_quick_guide_figures/VirtualBox_Windows10_19_03_2018_23_13_47.png" class="center" caption="動作確認のために，テストベンチ用のソースコードを追加する．今度はTest Benchアイコンの上で右クリック，New File...をクリック ">}}

{{<figure src="../hls_quick_guide_figures/VirtualBox_Windows10_19_03_2018_23_14_03.png" class="center" caption="今度はtest_tb.cというファイルを作成することにする．ファイル名を入力して保存をクリック">}}

{{<figure src="../hls_quick_guide_figures/VirtualBox_Windows10_19_03_2018_23_15_37.png" class="center" caption="テストベンチの中身を記述する．テストベンチは単なるCプログラムなのでstdio.hやprintf関数が使える">}}

{{<figure src="../hls_quick_guide_figures/VirtualBox_Windows10_19_03_2018_23_15_45.png" class="center" caption="メニューのProjectからProject Settings...をクリックして，プロジェクトの設定をする">}}

{{<figure src="../hls_quick_guide_figures/VirtualBox_Windows10_19_03_2018_23_15_58.png" class="center" caption="Synthesisをみると，Top Functionが指定されていないことが確認できる">}}

{{<figure src="../hls_quick_guide_figures/VirtualBox_Windows10_19_03_2018_23_16_05.png" class="center" caption="Browse...ボタンをクリックすると候補がでる．今回は一つだけ．候補に表示されたtest関数を選択してOKをクリック">}}

{{<figure src="../hls_quick_guide_figures/VirtualBox_Windows10_19_03_2018_23_16_10.png" class="center" caption="合成するトップの関数がtestであることを指定できた">}}

## Vivado HLSでの動作確認

{{<figure src="../hls_quick_guide_figures/VirtualBox_Windows10_19_03_2018_23_16_35.png" class="center" caption="まずはCレベルでの動作を確認するため，メニューのProjectからRun C Simulationをクリックする">}}

{{<figure src="../hls_quick_guide_figures/VirtualBox_Windows10_19_03_2018_23_16_40.png" class="center" caption="特にオプションは指定せずにOKをクリック">}}

{{<figure src="../hls_quick_guide_figures/VirtualBox_Windows10_19_03_2018_23_17_17.png" class="center" caption="しばらくすると結果が表示される．たとえば0xaの立っているビットは2個で答えが正しいことが確認できた">}}

{{<figure src="../hls_quick_guide_figures/VirtualBox_Windows10_19_03_2018_23_17_41.png" class="center" caption="ツールバーの再生ボタンアイコンをクリックしてCからHDLの合成を開始する">}}

{{<figure src="../hls_quick_guide_figures/VirtualBox_Windows10_19_03_2018_23_18_16.png" class="center" caption="しばらく待つと合成が完了する．ここでは生成された回路のクリティカルパス遅延が3.92nsであると表示されている．また，ひとつの答えを得るために33サイクル必要であることも確認できる．">}}

{{<figure src="../hls_quick_guide_figures/VirtualBox_Windows10_19_03_2018_23_18_47.png" class="center" caption="合成したHDLの動作検証を行う．テストベンチはCシミュレーションのときと同じ">}}

{{<figure src="../hls_quick_guide_figures/VirtualBox_Windows10_19_03_2018_23_18_57.png" class="center" caption="特にオプションは指定せずにOKをクリック">}}

{{<figure src="../hls_quick_guide_figures/VirtualBox_Windows10_19_03_2018_23_19_18.png" class="center" caption="シミュレーションにXSIM(RTLシミュレータ)が使用されていることがわかる">}}

{{<figure src="../hls_quick_guide_figures/VirtualBox_Windows10_19_03_2018_23_20_14.png" class="center" caption="RTLシミュレーションでも望み通りの答えがえられることが確認できた">}}

## IPコアの生成

{{<figure src="../hls_quick_guide_figures/VirtualBox_Windows10_19_03_2018_23_20_28.png" class="center" caption="ツールバーの荷物のようなアイコンをクリックしてIPコアを生成する">}}

{{<figure src="../hls_quick_guide_figures/VirtualBox_Windows10_19_03_2018_23_21_04.png" class="center" caption="IPコア生成に関する設定ダイアログが開いたところ．特に変更の必要はないのでOKをクリック">}}

{{<figure src="../hls_quick_guide_figures/VirtualBox_Windows10_19_03_2018_23_21_59.png" class="center" caption="しばらく待つと，Vivadoで利用可能なIPコアが生成される．">}}

{{<figure src="../hls_quick_guide_figures/VirtualBox_Windows10_20_03_2018_00_22_51.png" class="center" caption="生成されたリソースやファイルはsolution1の下のimplの下に格納されていて自由に確認することができる">}}

## 生成したモジュールをFPGAプロジェクトで利用する

{{<figure src="../hls_quick_guide_figures/VirtualBox_Windows10_19_03_2018_23_23_11.png" class="center" caption="まずはVivadoプロジェクトを作成する">}}

{{<figure src="../hls_quick_guide_figures/VirtualBox_Windows10_19_03_2018_23_23_20.png" class="center" caption="プロジェクト作成ダイアログ．Nextで次へ">}}

{{<figure src="../hls_quick_guide_figures/VirtualBox_Windows10_19_03_2018_23_23_26.png" class="center" caption="プロジェクト名をproject_3として，ホーム下のVivadoフォルダの下に保存することにする">}}

{{<figure src="../hls_quick_guide_figures/VirtualBox_Windows10_19_03_2018_23_23_30.png" class="center" caption="作成するプロジェクトはRTLプロジェクトを選択．">}}

{{<figure src="../hls_quick_guide_figures/VirtualBox_Windows10_19_03_2018_23_23_35.png" class="center" caption="特にここで追加するファイルはないのでNextで次へ">}}

{{<figure src="../hls_quick_guide_figures/VirtualBox_Windows10_19_03_2018_23_23_39.png" class="center" caption="特にここで追加するファイルはないのでNextで次へ">}}

{{<figure src="../hls_quick_guide_figures/VirtualBox_Windows10_19_03_2018_23_23_52.png" class="center" caption="プロジェクトの開発ターゲットはボードリストからZybo Z7-20を選択">}}

{{<figure src="../hls_quick_guide_figures/VirtualBox_Windows10_19_03_2018_23_23_58.png" class="center" caption="設定内容を確認してFinishをクリック．ウィザードを終了する．">}}

{{<figure src="../hls_quick_guide_figures/VirtualBox_Windows10_19_03_2018_23_24_25.png" class="center" caption="PROJECT NAVIGATORのSettingsをクリックして設定画面を呼び出す">}}

{{<figure src="../hls_quick_guide_figures/VirtualBox_Windows10_19_03_2018_23_24_37.png" class="center" caption="リストのIPを展開し，Repositriesを選択する">}}

{{<figure src="../hls_quick_guide_figures/VirtualBox_Windows10_19_03_2018_23_24_43.png" class="center" caption="ここにVivado HLSで作成したIPコアのフォルダを指定すれば利用できるようになる．+アイコンをクリック．">}}

{{<figure src="../hls_quick_guide_figures/VirtualBox_Windows10_19_03_2018_23_25_42.png" class="center" caption="IPコア検索用のフォルダとしてVivado HLSで作成したプロジェクトフォルダ(hls\_test\_1)の下の，solusion1\yen ipを選択して，Selectをクリック">}}

{{<figure src="../hls_quick_guide_figures/VirtualBox_Windows10_19_03_2018_23_25_53.png" class="center" caption="追加したリポジトリ情報が表示される．TestというIPコアが含まれていれば設定は正しい．OKでダイアログを閉じる">}}

{{<figure src="../hls_quick_guide_figures/VirtualBox_Windows10_19_03_2018_23_25_58.png" class="center" caption="リポジトリに追加できたので，OKで設定ダイアログを閉じる">}}

{{<figure src="../hls_quick_guide_figures/VirtualBox_Windows10_19_03_2018_23_26_09.png" class="center" caption="IP Catalogを選択してIPを呼び出す">}}

{{<figure src="../hls_quick_guide_figures/VirtualBox_Windows10_19_03_2018_23_26_21.png" class="center" caption="IP Catalogの中にVivado HLSで作成したTestがあるので，ダブルクリックする">}}

{{<figure src="../hls_quick_guide_figures/VirtualBox_Windows10_19_03_2018_23_26_31.png" class="center" caption="IPコアの設定画面が開くが，することもない．OKを押してダイアログを閉じる">}}

{{<figure src="../hls_quick_guide_figures/VirtualBox_Windows10_19_03_2018_23_26_49.png" class="center" caption="Vivadoプロジェクト内にIPコア保存用のフォルダを作る確認を求められる．OKをクリック">}}

{{<figure src="../hls_quick_guide_figures/VirtualBox_Windows10_19_03_2018_23_26_56.png" class="center" caption="IPコア関連のファイルをVivadoに生成させるためGenerateをクリック">}}

{{<figure src="../hls_quick_guide_figures/VirtualBox_Windows10_19_03_2018_23_26_56.png" class="center" caption="IPコア関連のファイルをVivadoに生成させるためGenerateをクリック">}}

{{<figure src="../hls_quick_guide_figures/VirtualBox_Windows10_19_03_2018_23_27_16.png" class="center" caption="合成がかかる旨のメッセージが表示されたらOKで閉じる">}}

{{<figure src="../hls_quick_guide_figures/VirtualBox_Windows10_19_03_2018_23_27_29.png" class="center" caption="呼びだしたIPコアのインスタンスを持つためのトップモジュールを作成する．モジュールの作成は，Design Sourcesの上で右クリックしてAdd Sources...選択すればよい">}}

{{<figure src="../hls_quick_guide_figures/VirtualBox_Windows10_19_03_2018_23_27_35.png" class="center" caption="今回はデザインファイルを作るので，Add or create design sourcesを選択">}}

{{<figure src="../hls_quick_guide_figures/VirtualBox_Windows10_19_03_2018_23_27_41.png" class="center" caption="Create Fileをクリック．">}}

{{<figure src="../hls_quick_guide_figures/VirtualBox_Windows10_19_03_2018_23_27_50.png" class="center" caption="VHDLで，topという名前のモジュールを作ることにしてOKをクリック．">}}

{{<figure src="../hls_quick_guide_figures/VirtualBox_Windows10_19_03_2018_23_28_00.png" class="center" caption="作成したモジュールがリストに追加されたのでFinishで終了．">}}

{{<figure src="../hls_quick_guide_figures/VirtualBox_Windows10_19_03_2018_23_33_30.png" class="center" caption="topモジュールの入出力ポートの生成ウィザードが開くので，clkと入出力用のポートを定義してOKをクリックする(あとでテキストで記述してもよいので無視してOKをクリックしても構わない)．">}}

{{<figure src="../hls_quick_guide_figures/VirtualBox_Windows10_19_03_2018_23_34_16.png" class="center" caption="生成したトップモジュールをVivadoのエディタで開いたところ">}}

top.vhdの内容は次の内容で書きかえる．

{{< highlight vhdl "linenos=table" >}}
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top is
    Port ( clk : in STD_LOGIC;
           a : in STD_LOGIC_VECTOR (3 downto 0);
           q : out STD_LOGIC_VECTOR (3 downto 0));
end top;

architecture Behavioral of top is

 component test_0
  port (
        ap_clk : in std_logic;
        ap_rst : in std_logic;
        ap_start : in std_logic;
        ap_done : out std_logic;
        ap_idle : out std_logic;
        ap_ready : out std_logic;
        a : in std_logic_vector(31 downto 0);
        ap_return : out std_logic_vector(31 downto 0)
  );
  end component;
  
  attribute mark_debug : string; -- 動作確認のためにmark_debugアトリビュートを使う
  
  signal q_i : std_logic_vector(31 downto 0);
  
begin

 q <= q_i(3 downto 0);

 U : test_0
  port map(
        ap_clk => clk,
        ap_rst => '0',
        ap_start => '1',
        ap_done => ap_done,
        ap_idle => ap_idle,
        ap_ready => ap_ready,
        a(31 downto 4) => (others => '0'),
        a(3 downto 0) => a,
        ap_return => q_i
  );

end Behavioral;
{{< /highlight >}}

{{<figure src="../hls_quick_guide_figures/VirtualBox_Windows10_19_03_2018_23_35_01.png" class="center" caption="コードを正しく記述し終えると，top→test_0というデザインツリーが作られる">}}

{{<figure src="../hls_quick_guide_figures/VirtualBox_Windows10_19_03_2018_23_35_12.png" class="center" caption="PROJECT NAVIGATORのRun Synthesisをクリックして合成を開始．ダイアログはOKで閉じてステップを進める．">}}

{{<figure src="../hls_quick_guide_figures/VirtualBox_Windows10_19_03_2018_23_36_43.png" class="center" caption="合成を終えたら，一度Open Synthesized Designで合成結果を開く">}}

{{<figure src="../hls_quick_guide_figures/VirtualBox_Windows10_19_03_2018_23_37_20.png" class="center" caption="メニューのLayoutからI/O Planningをクリックしてピン配置設定モードを呼び出す">}}

{{<figure src="../hls_quick_guide_figures/VirtualBox_Windows10_19_03_2018_23_39_38.png" class="center" caption="クロック(K17)，入力4bit(T16，W13，P15，G15)，出力4bit(D18，G14，M15，M14)を設定．電圧は，すべてLVCMOS33に設定．">}}

{{<figure src="../hls_quick_guide_figures/VirtualBox_Windows10_19_03_2018_23_39_45.png" class="center" caption="設定を終えたらGenerate Bitstreamをクリック">}}

{{<figure src="../hls_quick_guide_figures/VirtualBox_Windows10_19_03_2018_23_39_50.png" class="center" caption="設定したピン配置を保存していいか聞いてくるので，Saveで保存">}}

{{<figure src="../hls_quick_guide_figures/VirtualBox_Windows10_19_03_2018_23_39_55.png" class="center" caption="設定の保存でSynthesisが無効になる可能性があるという案内がでたら．OKでステップを進める">}}

{{<figure src="../hls_quick_guide_figures/VirtualBox_Windows10_19_03_2018_23_40_00.png" class="center" caption="制約保存用のファイルがないので作成ダイアログに従って作成．名前をtopとしてOKをクリックして完了">}}

{{<figure src="../hls_quick_guide_figures/VirtualBox_Windows10_19_03_2018_23_40_06.png" class="center" caption="Synthesisからやりなおすことの許可を求められるのでYesでステップをすすめる">}}

{{<figure src="../hls_quick_guide_figures/VirtualBox_Windows10_19_03_2018_23_40_11.png" class="center" caption="合成の開始．パラメタはそのままでOKで次へ．">}}

{{<figure src="../hls_quick_guide_figures/VirtualBox_Windows10_19_03_2018_23_45_09.png" class="center" caption="しばらく待つと合成，配置配線が完了してFPGA用のビットストリームが生成される．Open Hardware Managerを選択してOKをクリック．">}}

{{<figure src="../hls_quick_guide_figures/VirtualBox_Windows10_19_03_2018_23_45_17.png" class="center" caption="Hardware Managerが開いたところ．Open targetをクリック．">}}

{{<figure src="../hls_quick_guide_figures/VirtualBox_Windows10_19_03_2018_23_45_23.png" class="center" caption="Auto ConnectでFPGAボードと接続する">}}

{{<figure src="../hls_quick_guide_figures/VirtualBox_Windows10_19_03_2018_23_45_56.png" class="center" caption="Program deviceで生成したbitファイルをFPGAに書き込む">}}

## 実機で動作を確認

実機での動作を確認できます．DIPスイッチをON/OFFしたときにONの個数がカウントできていることがわかります．が，残念ながらよくみてみると，DIPスイッチを2つONにした状態，つまり1bit目のLEDのみが点灯すべきケースで，0bit目のLEDが若干点灯していることがわかります．これはバグなので原因を探してみましょう．

{{<figure src="../hls_quick_guide_figures/IMG_0011.JPG" class="center" caption="LEDが一つだけ点灯するはずが0bit目のLEDが若干明るい">}}

ここでは，ILAを使って，実機で動作を確認してみます．まず，topモジュールを次のように書き変えて，いくつかの信号をILAで観測できるようにしましょう．

{{< highlight vhdl "linenos=table" >}}
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top is
    Port ( clk : in STD_LOGIC;
           a : in STD_LOGIC_VECTOR (3 downto 0);
           q : out STD_LOGIC_VECTOR (3 downto 0));
end top;

architecture Behavioral of top is

 component test_0
  port (
        ap_clk : in std_logic;
        ap_rst : in std_logic;
        ap_start : in std_logic;
        ap_done : out std_logic;
        ap_idle : out std_logic;
        ap_ready : out std_logic;
        a : in std_logic_vector(31 downto 0);
        ap_return : out std_logic_vector(31 downto 0)
  );
  end component;
  
  attribute mark_debug : string; -- 動作確認のためにmark_debugアトリビュートを使う
  
  signal q_i : std_logic_vector(31 downto 0);
  attribute mark_debug of q_i : signal is "true"; -- mark_debugに指定
  
  -- ステータス信号を引出しILAで観測するために追加
  signal ap_done : std_logic;  
  signal ap_idle : std_logic;
  signal ap_ready : std_logic;
  attribute mark_debug of ap_done : signal is "true";
  attribute mark_debug of ap_idle : signal is "true";
  attribute mark_debug of ap_ready : signal is "true";
  -- ステータス信号を引出しILAで観測するために追加，ここまで
  
begin

 q <= q_i(3 downto 0);

 U : test_0
  port map(
        ap_clk => clk,
        ap_rst => '0',
        ap_start => '1',
        ap_done => ap_done,
        ap_idle => ap_idle,
        ap_ready => ap_ready,
        a(31 downto 4) => (others => '0'),
        a(3 downto 0) => a,
        ap_return => q_i
  );

end Behavioral;
{{< /highlight >}}

{{<figure src="../hls_quick_guide_figures/VirtualBox_Windows10_19_03_2018_23_52_03.png" class="center" caption="コードを書き変えたらRun Synthesisをクリックして合成を行なう">}}

{{<figure src="../hls_quick_guide_figures/VirtualBox_Windows10_19_03_2018_23_55_12.png" class="center" caption="合成がおわったらOpen Synthesized Designで合成結果を開く">}}

{{<figure src="../hls_quick_guide_figures/VirtualBox_Windows10_19_03_2018_23_55_41.png" class="center" caption="ILAの設定をしたいので，メニューのLayoutからDebugを選択">}}

{{<figure src="../hls_quick_guide_figures/VirtualBox_Windows10_19_03_2018_23_55_50.png" class="center" caption="虫のアイコンをクリックしてILA設定ウィザードを開く">}}

{{<figure src="../hls_quick_guide_figures/VirtualBox_Windows10_19_03_2018_23_55_56.png" class="center" caption="ILA設定ウィザードの開始">}}

{{<figure src="../hls_quick_guide_figures/VirtualBox_Windows10_19_03_2018_23_56_09.png" class="center" caption="観測したい信号のクロックをみつけることができずundefinedになっている">}}

{{<figure src="../hls_quick_guide_figures/VirtualBox_Windows10_19_03_2018_23_56_17.png" class="center" caption="クロックを設定したいアイテムの上で右クリックしてSelect Clock Domeinを選ぶ">}}

{{<figure src="../hls_quick_guide_figures/VirtualBox_Windows10_19_03_2018_23_56_29.png" class="center" caption="Global_CLOCKがないという案内が表示されるがOKで閉じる">}}

{{<figure src="../hls_quick_guide_figures/VirtualBox_Windows10_19_03_2018_23_56_30.png" class="center" caption="Global_CLOCKのかわりにALL_CLOCKを選択するとclk_IBUFが見つかるので選択，OKをクリックする">}}

{{<figure src="../hls_quick_guide_figures/VirtualBox_Windows10_19_03_2018_23_56_44.png" class="center" caption="同様の手順で全ての信号のClock Domainをclk_IBUFに設定したらNextで次へ">}}

{{<figure src="../hls_quick_guide_figures/VirtualBox_Windows10_19_03_2018_23_56_52.png" class="center" caption="サンプル数や利用機能はデフォルトのままでよいのでNextで次へ">}}

{{<figure src="../hls_quick_guide_figures/VirtualBox_Windows10_19_03_2018_23_58_59.png" class="center" caption="サマリを確認したらFinishでウィザードを閉じる">}}

{{<figure src="../hls_quick_guide_figures/VirtualBox_Windows10_19_03_2018_23_59_22.png" class="center" caption="ILAの挿入ができたので，あらためてGenerate Bitstreamで合成と配置配線を行なう">}}

{{<figure src="../hls_quick_guide_figures/VirtualBox_Windows10_19_03_2018_23_59_29.png" class="center" caption="ILAに関する設定を保存するか確認を求められたらSaveをクリック">}}

{{<figure src="../hls_quick_guide_figures/VirtualBox_Windows10_20_03_2018_00_20_08.png" class="center" caption="しばらく待つとILAを仕込んだビットストリームが生成される．Open Hardware Managerを選択してOKをクリック">}}

{{<figure src="../hls_quick_guide_figures/VirtualBox_Windows10_20_03_2018_00_20_15.png" class="center" caption="新しく作ったビットストリームを書き込むためにProgram Deviceをクリック">}}

{{<figure src="../hls_quick_guide_figures/VirtualBox_Windows10_20_03_2018_00_20_20.png" class="center" caption="ビットストリームとILA用の定義ファイルがセットされていることを確認してProgramをクリック">}}

{{<figure src="../hls_quick_guide_figures/VirtualBox_Windows10_20_03_2018_00_20_58.png" class="center" caption="二重三角マークをクリックすると内部信号が確認できる">}}

{{<figure src="../hls_quick_guide_figures/VirtualBox_Windows10_20_03_2018_00_22_19.png" class="center" caption="ap_doneが'1'でない間に値がふらふらしていることが確認できた．">}}

## Vivado HLSのシミュレーション結果を詳細に確認する

実はILAを挿入するまでもなく，Vivado HLSのC/RTL協調シミュレーションの結果を注意深く確認することで，今回のバグは防ぐことができます．試してみましょう．

{{<figure src="../hls_quick_guide_figures/VirtualBox_Windows10_20_03_2018_00_23_02.png" class="center" caption="Vivado HLSでC/RTLシミュレーションを再度実行する">}}

{{<figure src="../hls_quick_guide_figures/VirtualBox_Windows10_20_03_2018_00_23_15.png" class="center" caption="シミュレーション実行パラメタのDump Traceでallを選択してOKをクリック">}}

{{<figure src="../hls_quick_guide_figures/VirtualBox_Windows10_20_03_2018_00_27_29.png" class="center" caption="シミュレーションが完了すると，ツールバーのOpen Wave Viewerをクリックする">}}

{{<figure src="../hls_quick_guide_figures/VirtualBox_Windows10_20_03_2018_00_30_04.png" class="center" caption="しばらく待つとVivadoシミュレータの波形ビューワが開く．ここでC/RTLシミュレータの結果を確認できる．">}}

{{<figure src="../hls_quick_guide_figures/VirtualBox_Windows10_20_03_2018_00_31_28.png" class="center" caption="結果の信号やap_doneなどを波形ビューワに追加してみたところ．ap_doneが'1'でない場合に値が確定していないため注意しなければならない，ということがみてとれる．">}}

## 再度実機での動作確認
バグ修正を反映して，もう一度，実機で動作を確認してみましょう．

{{< highlight vhdl "linenos=table" >}}
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top is
    Port ( clk : in STD_LOGIC;
           a : in STD_LOGIC_VECTOR (3 downto 0);
           q : out STD_LOGIC_VECTOR (3 downto 0));
end top;

architecture Behavioral of top is

 component test_0
  port (
        ap_clk : in std_logic;
        ap_rst : in std_logic;
        ap_start : in std_logic;
        ap_done : out std_logic;
        ap_idle : out std_logic;
        ap_ready : out std_logic;
        a : in std_logic_vector(31 downto 0);
        ap_return : out std_logic_vector(31 downto 0)
  );
  end component;
  
  attribute mark_debug : string;
  
  signal q_i : std_logic_vector(31 downto 0);
  attribute mark_debug of q_i : signal is "true";
  
  signal ap_done : std_logic;
  signal ap_idle : std_logic;
  signal ap_ready : std_logic;
  attribute mark_debug of ap_done : signal is "true";
  attribute mark_debug of ap_idle : signal is "true";
  attribute mark_debug of ap_ready : signal is "true";
  
begin
 -- バグ修正のために追加
 process(clk)
 begin
   if rising_edge(clk) then
     if ap_done = '1' then
       q <= q_i(3 downto 0);
     end if;
   end if;
 end process;
 -- バグ修正のために追加，ここまで

 U : test_0
  port map(
        ap_clk => clk,
        ap_rst => '0',
        ap_start => '1',
        ap_done => ap_done,
        ap_idle => ap_idle,
        ap_ready => ap_ready,
        a(31 downto 4) => (others => '0'),
        a(3 downto 0) => a,
        ap_return => q_i
  );

end Behavioral;
{{< /highlight >}}

{{<figure src="../hls_quick_guide_figures/VirtualBox_Windows10_20_03_2018_00_32_36.png" class="center" caption="コードを書き変えたらGenerate Bitstreamをクリックして，再度ビットストリームを生成する">}}

{{<figure src="../hls_quick_guide_figures/IMG_0015.JPG" class="center" caption="再び実機で動作を確認したところ．LEDが正しく一つだけ点灯していることがわかる．">}}
