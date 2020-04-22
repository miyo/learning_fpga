---
title: "シミュレーション"
date: 2019-10-30T19:15:46+09:00
type: docs
draft: false
weight: -1600
---

# シミュレーション

この章では，**Lチカ** を題材に設計したデザインがどのように動いているのか，Vivado付属のシミュレータを使ったシミュレーションによって確認する方法を学びます．

## はじめに
実際の開発現場で不具合を解析するときにもシミュレーションは大変有用な手段です．

HDLで記述したアプリケーション回路をFPGA上で動作させるためには，合成や配置配線を実行してFPGA書き込み用のコンフィギュレーション情報のファイルを生成する必要があります．回路規模が大きくなると，コンフィギュレーション情報を作成するのにも長い時間が必要になります．しかし，シミュレーションの場合は簡単なコンパイルでおしまいです．デバッグなどで，何度もソース・コードを変更するような場合には，シミュレータで動作を確認できれば圧倒的に短時間で済みます．

また，FPGAで動作しているアプリケーション回路の各信号が，どのように変化しているか，外から観測するのはなかなか難しいものです．一方で，シミュレーションでは自由に記述したロジックの信号の変化を観察できます．

そのため，シミュレーションを使用した内部の信号の観測がHDLレベルでの論理的なデバッグに有効です．この章では，このHDLコードの動作をVivadoシミュレータでシミュレーションする方法を学びましょう．

## シミュレーションに必要なもの --- テスト・ベンチ
CPUを買ってきても，マザーボードがないとパソコンとして動かないように，FPGAも周辺部品の載った **マザーボード** がないと動きません．FPGAもFPGA単体では動作せず，MicroBoardやDE0 nanoに搭載されているような回路を駆動するクロック信号やリセット信号が必須です．

実際にFPGAを使ったシステムでは，クロックは外から与えられるものですが，シミュレーションでは，FPGAに実装したHDLモジュールが動作するのに必要なクロック信号やリセット信号なども自前で用意しなければなりません(図1)．

{{<figure src="../simulation_figures/test_bench_image.png" class="center" caption="図l: 設計したモジュールを実機で動作させる場合(a)とシミュレーションする場合(b)の違い．シミュレーションする場合にはテスト・ベンチを用意する必要がある．">}}

といっても，とりたてて新しく特別なことを覚える必要があるわけではありません．外から与えられるべきクロック信号やリセット信号もHDLで記述できます．これをシミュレーション・コードやテスト・ベンチと呼びます．シミュレーション対象のモジュールで必要となる信号は，すべてテスト・ベンチで生成します．テスト・ベンチの記述方法はHDLソースとほとんど同じで，違いは下記の3つになります．

 - エンティティの中身(モジュールの入出力信号)が空である 
 - 時間を表す構文を使って信号の振る舞いを規定する 
 - ハードウェアでは実現できない仮想的な機能を利用できる 

設計したHDLモジュールを動作させるのには必要な，マザーボードに相当する部分をすべて記述しなければなりません．逆にいうと，テスト・ベンチは外部との入出力があってはいけないということです．そのため，VHDLの場合はテスト・ベンチのエンティティの中身が，Verilog HDLの場合moduleの引数が空になるというわけです．

### テスト・ベンチでは **時間** を表現する必要がある
「スイッチを10秒押してから離す」や「50MHzの信号」などの振る舞いは時間を扱うので，HDLのビヘイビア・モデル（動作記述）を用いて記述します．

たとえば，「10nsの時間を待つ」という動作はHDLで次のように記述します．この記述はビヘイビア・モデルの基本中の基本です．
VHDLで記述する場合は，

{{< highlight vhdl "linenos=table" >}}
wait for 10ns;
{{< /highlight >}}

Verilog HDLで記述する場合には，初めに ``timescale`を使って，

{{< highlight vhdl "linenos=table" >}}
`timescale 1ns / 1ps
{{< /highlight >}}

と，シミュレーションの単位時間を指定して，時間を挿入したい個所で

{{< highlight vhdl "linenos=table" >}}
#10
{{< /highlight >}}

と記述すると，指定した単位時間分の時間(この例では10ns)を作ることができます．

## テストベンチの書き方
またか!!という感も否めませんが，前章で利用した「LEDチカチカ」に再び登場してもらいましょう．

### シミュレーション用に(実験のために)修正
今回はシミュレーションの動作を知ることを目的にコードを少し修正します．実際の開発の際には，シミュレーションのために実装コードを変える，ということは基本的にはしないはずです．

#### resetの追加
回路を初期化するための入力信号としてresetを追加しています．

#### LEDに出力するbitを変更
実機ではカウンタの23bit目をledに接続しましたが，クロックの立ち上がりを8M回待つのは大変なので3bit目をledの出力に接続しています．

#### モジュールのタイプをRTLに変更
モジュールのタイプをBehaviorではなくRTLとしています．実際のところ今のVivadoでは，ここのキーワードは特に意味をなさないのですがシミュレーションのためのテストベンチをBehavior，合成してハードウェア化もするファイルはRTLと分けておくと見分けるのが容易になります．

{{< highlight vhdl "linenos=table" >}}
 library ieee;
 use ieee.std_logic_1164.all;
 use ieee.numeric_std.all;

 entity top is
    Port ( clk   : in std_logic;
           reset : in std_logic;
           led   : out std_logic
         );
 end top;

 architecture RTL of top is

  signal counter : unsigned(31 downto 0) := (others => '0');

 begin

  -- カウンタの3bit目をledに接続(実機では23bit目を使った)
  led <= std_logic(counter(3));

  process(clk) -- クロックの変化で動作するプロセス
  begin
    if rising_edge(clk) then -- クロックの立ち上がりであれば
      if reset = '1' then
        counter <= (others => '0');
      else
        counter <= counter + 1; -- カウンタをインクリメント
      end if;
    end if;
  end process;

 end RTL;
{{</ highlight >}}

FPGA上に実装する場合には，第3章で紹介したように，3つの入出力信号をFPGA上の適切なI/Oに接続しなければなりません．一方，ソフトウェアで動作をシミュレーションするためには，これらの信号テスト・ベンチで生成して外から与える，ことにします．

### クロックを生成するテスト・ベンチ
順序回路の要がクロック信号です．従って，クロック信号の生成はテスト・ベンチの基本中の基本です．

カウンタ・モジュールの動作をシミュレーションするために，
 `clk` に50MHzのクロック信号，すなわち10nsごとに `‘1’` と `‘0’` を繰り返す信号をテスト・ベンチで生成してみましょう．
記述方法は，次の通りです．

#### VHDLで記述する場合

信号 `clk_i` を定義し， `clk_i` に‘1’を代入して10ns待ちます．その10ns後 `clk_i` に‘0’を代入，その10n後に再び‘1’を `clk_i` に代入，…ということを繰り返すことで，10nsで周期的に0→1→0→1...と変化する信号，すなわち50MHzのクロック信号が生成できます．
VHDLのコードで素直に実装すると，「10ns待つ」処理に相当する「wait for 10ns」を使って，
{{< highlight vhdl "linenos=table" >}}
process begin
  clk_i <= '1';
  wait for 10ns;
  clk_i <= '0';
  wait for 10ns;
  clk_i <= '1';
  wait for 10ns;
  clk_i <= '0';
  wait for 10ns;
  ...
end process;
{{< /highlight >}}
となります．

この `process` 文には，きっかけになる信号なしで，シミュレーションの開始同時にすぐさま処理が開始されます．
もちろん，これでもよいのですが，実はプロセス文は最後まで到達すると，また先頭から開始されるので
{{< highlight vhdl "linenos=table" >}}
process begin
  clk_i <= '1'; wait for 10ns;
  clk_i <= '0'; wait for 10ns;
end process;
{{< /highlight >}}
という記述で，ずっとクロック信号を作り続けることができます．

#### Verilog HDLで記述する場合
Verilog HDLでは，「単位時間XXが経過」を「 `#XX` 」で表現できますから， `clk_i` に'1'を代入したあと，
「単位時間10が経過」の後 `clk_i` に'0'を代入して，また「単位時間10が経過」の後 `clk_i` に'1'を代入...
と繰り返すことで，1→0→1→...というシーケンスが定義できます．

Verilog HDLでは，initial文で，シミュレーション実行開始時に一度だけ処理されるブロックを定義できます．
すなわち，次のコード片で，シミュレーション開始後から単位時間10毎に信号を反転させる処理，つまり50MHzのクロック信号を生成できます．
{{< highlight vhdl "linenos=table" >}}
initial begin
  clk_i = 0; #10;
  clk_i = 1; #10;
  ...
  forever #10 clk_i = !clk_i;
end
{{< /highlight >}}

ずっと繰り返す処理を意味する `forever` を使って，
{{< highlight vhdl "linenos=table" >}}
initial begin
  clk_i = 0;
  forever #10 clk_i = !clk_i;
end
{{< /highlight >}}
と記述することもできます．

### 必要な入力信号を生成する

図\ref{fig:target_list}に示したリストの動作をシミュレーションするにはクロック信号clk以外に，人間が「えいやっ」とリセット・ボタンを押すことに相当するreset信号もテスト・ベンチで生成しなければいけません．

ところで，人間がリセット・ボタンを押すのは，いつ，どのくらいの時間でしょうか？「リセット・ボタンは電源投入の5秒後に10ミリ秒間押される」などと決められるわけではありません．

従って，テスト・ベンチでは，シミュレーション対象の回路に対して，それらしい信号を想定して生成する必要があります．リセット・ボタンが押されるタイミング，であれば，特に制約があるわけではありませんので，電源投入後の適当な時刻に検知できる時間だけの信号が与えられる，という想定で十分でしょう．

リセット信号を生成する方法は，

 1. クロックと同じプロセス・ブロックで記述する
 1. 別のプロセスのブロック内で記述する
 
の2種類が考えられます．

ここでは，クロックとは別のプロセス・ブロック内で，変数 `reset_i` の値を0→1→0と変化させることで，リセット・ボタンが押されたことに相当する信号を生成することにします．Verilog HDLであれば，リセットに相当するレジスタ変数 `reset_i` が適当なタイミングで変化するように記述できます．
{{< highlight vhdl "linenos=table" >}}
initial begin
  reset_i <= '0'; -- 最初はリセット信号は'0'
  wait for 5ns;
  reset_i <= '1'; -- 5n秒後にリセット信号を'1'に
  wait for 100ns;
  reset_i <= '0'; -- しばらくしたら(100n秒後)，リセット信号を'0'に
  wait; -- 以降は何もしない
end
{{< /highlight >}}

### テスト・ベンチとシミュレーション対象のモジュールを接続する
FPGA上に書き込んだ回路に信号を与えるためには，物理的にクロックやスイッチの端子を配線することになります．
シミュレーションする場合には，シミュレーション対象のモジュールとテスト・ベンチで生成した信号をHDL的に接続する必要があります．

一般的には，テスト・ベンチをトップ・モジュールとして，
その中でカウンタ・モジュールをサブモジュールとして呼び出すことにします．
これはマザー・ボードがあって，その中にFPGAがあって回路が動いている，という物理的な構造に上手くマッチします．
VHDLもVerilog HDLも，モジュールを階層的に定義する仕組みをもっています．

VHDLでは，

 1. LEDチカチカ回路のインターフェースを宣言
 1. LEDチカチカ回路のインスタンスを生成する

の2段階で，サブモジュールとして回路を呼び出すことができます．

具体的には，はじめに，次のように，
{{< highlight vhdl "linenos=table" >}}
-- サブ・モジュールであるtestの素性を記述
component test
  port (
    clk   : in std_logic;
    reset : in std_logic;
    led   : out std_logic
);
end component;
{{< /highlight >}}
 `component` として，使用するモジュールの素性を宣言したあとで，次のように
{{< highlight vhdl "linenos=table" >}}
-- サブ・モジュールをインスタンス化する
U: test port map(
     clk   => clk_i,
     reset => reset_i
     led   => led,
   );
{{< /highlight >}}
このモジュールのインスタンスを生成，配線関係を記述します．

プログラミング言語Cでも，関数を呼び出す時には，関数の素性を明らかにするために「プロトタイプ宣言」をした上で，
関数呼び出し文を書きますよね．VHDLでも同じようなものだな，と考えてもらえればよいでしょう．

### テスト・ベンチの全容

説明が長くなりましたが，図\ref{fig:target_list}のリストをシミュレーションするためのテスト・ベンチの全容は，
図\ref{fig:simulation_list}のようになります．

{{< highlight vhdl "linenos=table" >}}
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity top_sim is
end top_sim;
architecture Behavioral of top_sim is
  -- シミュレーション対象のモジュールを宣言
  component top
    Port ( clk   : in std_logic;
           reset : in std_logic;
           led   : out std_logic
           );
  end component top;
  -- シミュレーション対象のモジュールの信号用の変数を宣言
  signal clk_i   : std_logic := '0';
  signal reset_i : std_logic := '0';
  signal led_i   : std_logic := '0';
begin
  -- シミュレーション対象のモジュールのインスタンス生成
  U : top port map(
    clk => clk_i,
    reset => reset_i,
    led => led_i
    );
  -- クロックを生成
  process
  begin
    clk_i <= '1'; wait for 10ns;
    clk_i <= '0'; wait for 10ns;
  end process;
  -- リセット信号の生成
  process
  begin
    reset_i <= '0';
    wait for 5ns;
    reset_i <= '1';
    wait for 100ns;
    reset_i <= '0';
    wait;
  end process;
end Behavioral;
{{</ highlight >}}

## シミュレーションの実行手順

シミュレーションのテスト用に新しくプロジェクトを作成しましょう．
プロジェクト名は， `project_2` としました．

{{<figure src="../simulation_figures/VirtualBox_Windows10_19_03_2018_11_59_40.png" class="center" caption="新しく作成したプロジェクト" >}}

前章と同様にtopモジュールを作成・追加してプロジェクトを作成したら，
topモジュールの中身を図\ref{fig:target_list}のように変更しておきます．

以降の手順は次の通りです．

{{<figure src="../simulation_figures/VirtualBox_Windows10_19_03_2018_11_59_46.png" class="center" caption="Sourcesの中のSimulation Sourcesの上で右クリックしてAdd Sourcesを選択" >}}

{{<figure src="../simulation_figures/VirtualBox_Windows10_19_03_2018_11_59_52.png" class="center" caption="**Add or create simulation sources**にチェックが入っていることを確認してNextをクリック" >}}
{{<figure src="../simulation4_figures/VirtualBox_Windows10_19_03_2018_12_00_00.png" class="center" caption="ファイル追加ダイアログで，Create Fileを選択" >}}

{{<figure src="../simulation_figures/VirtualBox_Windows10_19_03_2018_12_01_34.png" class="center" caption="VHDLファイルとして，top\_simという名前のモジュールを作成する" >}}

{{<figure src="../simulation_figures/VirtualBox_Windows10_19_03_2018_12_01_42.png" class="center" caption="リストに追加された" >}}

{{<figure src="../simulation_figures/VirtualBox_Windows10_19_03_2018_12_01_49.png" class="center" caption="ポートの指定ダイアログ．今回は何もせずにOKをクリック" >}}

{{<figure src="../simulation_figures/VirtualBox_Windows10_19_03_2018_12_01_54.png" class="center" caption="変更ないことを確認されるのでYesをクリックして，作業ステップをすすめる" >}}

{{<figure src="../simulation_figures/VirtualBox_Windows10_19_03_2018_12_02_05.png" class="center" caption="シミュレーション用のモジュールがプロジェクトに追加された" >}}

{{<figure src="../simulation_figures/VirtualBox_Windows10_19_03_2018_12_06_25.png" class="center" caption="シミュレーションコードをtop\_simに反映したところ．top\_simからtopのモジュールがUという名前でインスタンス化されている様子が階層化されて表示される．" >}}

{{<figure src="../simulation_figures/VirtualBox_Windows10_19_03_2018_12_06_33.png" class="center" caption="Flow NavigatorのRun Simulationでシミュレーションの開始" >}}

{{<figure src="../simulation_figures/VirtualBox_Windows10_19_03_2018_12_06_40.png" class="center" caption="Run Behavioral Simultaionを選択" >}}

{{<figure src="../simulation_figures/VirtualBox_Windows10_19_03_2018_12_06_45.png" class="center" caption="シミュレーション開始には少し時間がかかる" >}}

{{<figure src="../simulation_figures/VirtualBox_Windows10_19_03_2018_12_07_37.png" class="center" caption="シミュレーションが開始された" >}}

{{<figure src="../simulation_figures/VirtualBox_Windows10_19_03_2018_12_07_58.png" class="center" caption="シミュレーション時間を指定して，シミュレーションステップをすすめる" >}}

指定した時間のシミュレーションが終わるとストップします．いつまでもストップしない場合には，一時停止アイコンをクリックして，強制的に止めることができます．

{{<figure src="../simulation_figures/VirtualBox_Windows10_19_03_2018_12_08_05.png" class="center" caption="指定した時間のシミュレーションが終了" >}}

{{<figure src="../simulation_figures/VirtualBox_Windows10_19_03_2018_12_08_09.png" class="center" caption="波形表示画面に全シミュレーション結果を表示(FIT)させたところ" >}}

{{<figure src="../simulation_figures/VirtualBox_Windows10_19_03_2018_12_08_29.png" class="center" caption="一部分を拡大した様子．3bit目をledに接続しているため8クロック毎にledがON/OFFしている様子がみてとれる" >}}

{{<figure src="../simulation_figures/VirtualBox_Windows10_19_03_2018_12_08_38.png" class="center" caption="内部モジュール(今回でいうとtopの中身を確認することもできる)" >}}

{{<figure src="../simulation_figures/VirtualBox_Windows10_19_03_2018_12_08_48.png" class="center" caption="topモジュールのcounterを波形表示画面に追加．ただし，内部の値の多くは非表示状態では保存されていないので，そのままでは値の変化を確認できない" >}}

{{<figure src="../simulation_figures/VirtualBox_Windows10_19_03_2018_12_08_52.png" class="center" caption="シミュレーションを一度リセット" >}}

{{<figure src="../simulation_figures/VirtualBox_Windows10_19_03_2018_12_08_58.png" class="center" caption="再度シミュレーション．今度は時間指定なくシミューレションしてみる" >}}

{{<figure src="../simulation_figures/VirtualBox_Windows10_19_03_2018_12_09_04.png" class="center" caption="いつまでも終わらないので一時停止アイコンでシミュレーションをストップ" >}}

{{<figure src="../simulation_figures/VirtualBox_Windows10_19_03_2018_12_09_10.png" class="center" caption="ストップした箇所のソースコードが表示される" >}}

{{<figure src="../simulation_figures/VirtualBox_Windows10_19_03_2018_12_09_39.png" class="center" caption="波形を確認してみると，内部のcounterがclkにあわせてインクリメントしていること，counterの3bit目がledの'0'/'1'と同じであることが確認できる" >}}

## 課題

 1. 点滅の間隔を変えてみたときの様子をシミュレーションしてみよう
 1. resetを適当なタイミングで変化させてみて，counterやledの振る舞いを観察してみよう
