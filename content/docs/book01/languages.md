---
title: "VHDL/Veilog 入門"
date: 2019-10-30T19:15:46+09:00
type: docs
draft: false
weight: -1800
---

# はじめに

本章では，ハードウェア記述言語(HDL; Hardware Description Language)のうち，よく使用されるVHDLとVerilog HDLの二つのHDLの基本文法を説明します．ちょっとした違いを発見しながら読み進めると面白いでしょう．

ソフトウェア・プログラミングで使用するCやJava，コミュニケーションで使用する英語についても，正しく使用するために文法の知識は欠かせません．同じようにHDLで設計する際も文法の知識が必要です．ここで，基本文法をしっかり押さえましょう．

# ハードウェア記述言語の基本概念

プログラミング言語に多くの種類があるように，ハードウェア記述言語(HDL)にもさまざまな種類があります．その中でもよく利用されるのが，VHDLとVerilog HDLです．VHDLとVerilog HDLは，どちらも，ハードウェアを表現するための似たような概念を取り扱うことができる言語です．

ただし，似たような概念でもそれぞれの言語で使用する言葉が違うので注意が必要です．両方の言語に共通する概念と，言語の特徴について説明します．

## 構造の基本 --- エンティティ/モジュール

どの言語にも基本的な構造があります．たとえば，Cでは関数，Javaではクラスなどです．HDLでは，与えられた入力に対して出力を生成するブロックが基本的な単位です(図1)．このブロックをVHDLではエンティティ `entity` ，Verilog HDLではモジュール `module` と呼びます．ただし，この章では，特にVHDLやVerilog HDLに違いがない説明では，モジュールと呼ぶことにします．

{{<figure src="../languages_figures/design_unit.png" class="center" caption="図1: ハードウェア・プログラミングの基本的な単位">}}

通常のプログラミング言語とHDLの大きな違いは，エンティティ/モジュールは，最初から最後まで与えられた入力に対する出力を生成し続けるということです．Cなどで関数を呼び出す場合，mainプログラムからその関数内へ処理が移ります(図2)．処理を終えると戻り値を呼び出し元に返し，mainプログラムが再び動き始めます．つまり，mainプログラムは，呼び出した関数の処理が完了するまで待たされます．これは，プログラム・カウンタが，プログラムを順々に呼び出して実行するからです．

{{<figure src="../languages_figures/software_running_model.png" class="center" caption="図2: Cで記述した一般的なソフトウェア・プログラムの実行の様子">}}

一方，HDLで記述されたエンティティ/モジュールには，共通のプログラム・カウンタのような，複数の演算回路の動作を制御する仕組みはありません．(図3)．どのモジュールも常に存在し，独立して動作します．したがって，特定の入力を与えると出力を返すというよりも，入力されているデータに対して出力するデータを作り続けているというイメージになります．複数のモジュール間で制御が必要であれば自分で，そのように設計する必要があります．

{{<figure src="../languages_figures/hardware_instances.png" class="center" caption="図3: ハードウェアは常に存在し，演算回路の動作が制御されることはない(制御が必要なら自分で記述する必要がある)">}}

## 2種類の基本処理方法 --- 同時処理文と順次処理文
繰り返しになりますが，ハードウェア・プログラミングでは，独立して動作するモジュールを扱う必要があります．すなわちハードウェアを記述するための言語では，独立して動作する同時並行的な処理を記述できる必要があります．とはいえ，実現したい処理によっては，条件分岐のような依存関係のある処理の記述が望まれます．これらの要求を満たすため，VHDLとVerilog HDLのどちらも，同時処理文と順次処理文と呼ばれる二種類の記述方式をサポートしています．具体的な記述方法は後で説明しますが，それぞれの考え方を頭に入れておいてください．

#### 同時処理文
同時処理文とは，周りの処理に依存せず独立して動作する処理です．複数の同時処理文は，ある特定の時点で一斉に処理されます．そのため，記述順や各処理文の間には，構文的な順序が存在せず，「ある時点」で入力された値に従って出力が生成されます．出力が確定するまでの時間は，物理的にデバイスの中を電気が流れる速さや信号遅延に依存します．

#### 順次処理文
順次処理文は，複数の処理同士に構文などによって順序が規定された処理です．たとえば，ソフトウェアには欠かせない分岐などの制御文の表現には順序が必要になります．

## 使用できる変数 --- 数値と信号
プログラミング言語と同じようにHDLでも変数を利用できます．VHDLでもVerilog HDLでも，変数はすべて型を持ちます．ハードウェアとして，基本的な型は1本の信号線です．また，信号線を束ねた配列もサポートされます．このほかに，整数や自分で定義した型も利用できます．

変数は，英数字からなる名前を付けることができます．変数名の先頭は英字または「\_」で始める必要があり，末尾を「\_」にしてはいけません．Verilog HDLでは，大文字と小文字は区別されます．

## 演算の基本 --- 算術/論理減算，比較，代入
VHDLおよびVerilog HDLでは加減算や論理演算，比較などの演算子を利用することができます．ソフトウェア・プログラミングの場合は演算子を使って記述された処理はプロセッサに与える命令に変換されますが，HDLの場合は，その演算に相当するハードウェア・ロジックとしてLUTやFFなどの組み合わせに合成されます．FPGAの中には，小さなディジタルシグナルプロセッサや乗算器を持つものがあり，条件にうまく合致すると，それらが使用されます．

HDLでもソフトウェア・プログラミング同様に，演算した結果を代入演算を利用して，ほかの(あるいは同じ)変数に代入することができます．HDLの代入には，ブロッキング代入とノンブロッキング代入の2種類があります．ブロッキング代入は，その時点で値を代入して次に進む代入です．一方，ノンブロッキング代入は，複数の代入文において，それらの代入の同時実行を規定します．Cなどで記述した単一スレッドのソフトウェア・プログラムの代入は，HDLでいうところのブロッキング代入に相当します．

## 値の基本 --- '0'，'1'，'Z'，'X'
ハードウェアの値は'0'と'1'の値をとります．加えて，ハードウェアにはハイ・インピーダンスという，「抵抗が無限大」を意味する状態が存在します．VHDLやVerilog HDLでは'Z'で表されます．値として「抵抗が無限大」というのは，少しわかりにくいかもしれません．物理的には，図4のようにスイッチを切った状態をイメージしてください．複数の信号が一つにまとめられるとき，'Z'は，「ほかの値に影響を与えない」ということを意味します．

{{<figure src="../languages_figures/high_imp_image.png" class="center" caption="図4: HDLではハイ・インピーダンスでスイッチオフを記述できる．">}}

また，'0'でも'1'のどちらでもいい値として不定値という概念があります．これは，'X'と表現されます．

ソフトウェア・プログラミングでは，通常，'0'と'1'の2値をとる値をビットと呼びますが，'Z'と'X'も加えた4つの値をとる信号が便宜上ビットと呼ばれることが多くあります．

## 文末には「;」を付ける
VHDLもVerilog HDLも，演算処理や変数定義などの文の終わりには「;」(セミコロン)を付けます．ただし，両言語ともソフトウェアのプログラミング言語では少し首をかしげてしまうような，「;」を付けないケースが存在するので注意が必要です．

# VHDLの基本文法のルール

VHDLの基本的な文法を説明します．

## コメント
多くのソフトウェア・プログラミング言語と同様に，VHDLでもソースコード中にコメントを書くことができます．VHDLでは，「 `--` 」から行末までがコメントになります．

## モジュールの構成
図5に，VHDLで記述するモジュールの概要を示します．VHDLでは，対象とするモジュールを大きく `entity` と `architecture` に分けて記述します． `entity` には外部に接続される入出力ポートの宣言などの回路の外枠を， `architecture` には使用する関数の定義や処理内容など，回路の内部を定義します．

{{<figure src="../languages_figures/vhdl_module_overview.png" class="center" caption="図5: VHDLのモジュール定義はentityとarchitectureから構成される">}}

## 即値の表現方法
VHDLでは，ソース・コードの中に定数の値を記述できます(表1)．複数の信号線を束ねた値は，信号線の本数分だけ各信号に相当する値を並べて表現します(たとえば4bitなら `"0000"` など)．また，「 `X"01"`」と記述することで16進数で数を表記できます．よく用いられる代表的な定数表現には，表1のようなものがあります．

表1. VHDLで記述できる定数の例

  説明                       | 値の例
-----------------------------|-----------------------------------------------------
  1本の信号線がとる信号の値  | `'1'`，`'0'` ，`'Z'`，`'X'`
  複数の信号線がとる信号の値 | `"111"`，`"0100"` ，`X"10"`
  整数                       | `32`，`8` ，`1000`
  真偽値                     | `true`，`false`


## 型
VHDLの変数はすべて型を持ちます．たくさんの型が定義されており，また，独自の型も定義できます．よく使用される5つの型を表2に示します．基本的には，`std_logic`，`std_logic_vector`はハードウェアの信号に相当する型，`signed`や`unsigned`は加減算などの算術演算ができる値を表現するために用いる型，一般的な数値を表現できる`integer`です．

  型名                                    |説明
----------------------------------------|---------------------
  `std_logic`                           | 1bitの信号線
  `std_logic_vector(n-1 downto 0)` | n-bitの信号線
  `unsigned(n-1 downto 0)`           | n-bitの符号なしの算術演算可能な値
  `signed(n-1 downto 0)`             | n-bitの符号ありの算術演算可能な値
  `integer n to m`                     | nからmまでの整数
  
VHDLで用いられる型の例

### 1-bitの信号
`std_logic` は，VHDLの基本となる1bitの信号に相当する型です．`'0'`，`'1'`のほかに，ハイ・インピーダンスを示す`'Z'`，不定値を示す`'X'`を値としてとれます．これらの値は，ハードウェアにそのまま対応します．

### n-bitの信号
`std_logic_vector(n downto 0)`は，`std_logic`がn個並んだn-bitの信号線に相当する型です．n-bitの`std_logi_vector`型」と呼びます．`std_logic_vector`型の変数`a`の中の要素を，`a(3)`，`a(4 downto 2)`などとして取り出せます．前者は`std_logic`型，後者は3bitの`std_logic_vector`型です．「`downto`」は`std_logic`の並びに，MSBから降順で番号を付けることを意味します．つまり，`std_logic_vector(n-1 downto 0)`のビット列の場合，MSBが`std_logic_vector(n-1)`で，LSBが`std_logic_vector(0)`です．`to`を使うことで逆順に並べることもできます．その場合は，`std_logic_vector(n to 0)`のように書きます．

## モジュールの外枠の記述 --- entity
`entity`は，モジュールの外枠に相当し，モジュールの名前と入出力の信号で定義されます．たとえば，
次の記述は，入力信号にpClkとpReset，出力信号にQを持つ`test`という名前のモジュールの外枠の定義に相当します．

{{< highlight vhdl "linenos=table" >}}
entity test is
 port (
   pClk   : in std_logic;
   Q      : out std_logic;
   pReset : in std_logic -- 最後の一つの後には";"をつけない
 );
end entity;
{{< /highlight >}}

### ポートを定義する
ポートは，ハードウェア・モジュールの入出力です．`entity`の中の`port( 〜 );`の中に信号を方向と型を指定して定義します．信号の方向には`in`(入力)と`out`(出力)，`inout`(入出力)の3種類があります．各ポートは「名前 : 方向 型」で定義されます．たとえば，

{{< highlight vhdl "linenos=table" >}}
pClk : in std_logic
{{< /highlight >}}

という記述は，`pClk`という名前の型が`std_logic`の入力ポート(`in`)の定義に相当します．同じ方向，型の複数のポート名は「,」で並べて定義することもできます．たとえば，

{{< highlight vhdl "linenos=table" >}}
pR, pG, pB : in std_logic
{{< /highlight >}}

として，3つの入力信号`pR`，`pG`，`pB`をまとめて定義できます．

### 定数を定義する
`entity`の中にモジュールの中で使用する定数を定義できます．

{{< highlight vhdl "linenos=table" >}}
entity test is
  generic (
    width  : integer := 640;
    height : integer := 480
  );
  port (
    pClk : in std_logic;
    Q : out std_logic;
    pReset : in std_logic
  );
end test;
{{< /highlight >}}

ここでは，`width`という名前で値が640の`integer`型，すなわち整数の定数を定義しています．この定数は `entity` 内部，および内部処理を記述する `architecture` の中で使用できます．

## 内部処理の記述 --- architecture

VHDLでは， `architecture` にモジュールの処理内容を記述します．記述の基本的な流れは次の通りです．

{{< highlight vhdl "linenos=table" >}}
architecture RTL of test is
  (ここに変数の定義などを書く)
begin
  (ここに処理内容を記述する)
end RTL;
{{< /highlight >}}

上記は， `test` という名前のモジュールの中身を記述するためのブロックです．

## 変数の定義

{{< highlight vhdl "linenos=table" >}}
signal 名前 : 型 := 初期値;
{{< /highlight >}}

たとえば，10ビットの配列は下記のように定義します．

{{< highlight vhdl "linenos=table" >}}
signal counter : std_logic_vector(9 downto 0);
{{< /highlight >}}

また， `generic` で定義した値である `width` を使用して，幅widthの `std_logic_vector` 型の信号を次のように定義できます．ここで「 `width−1` 」の値は合成時に決定されます．

{{< highlight vhdl "linenos=table" >}}
signal counter : std_logic_vector(width-1 downto 0);
{{< /highlight >}}

## 演算子と演算
代表的な演算子を表3にまとめます．論理演算子を `std_logic_vector` 型に定義した場合は，対応する各ビットの値同士に論理演算を適用した結果を返します．たとえば，「 `"10" and "11"` 」は「 `"10"` 」になり，「 `"10" or "11"` 」は「 `"11"` 」になります．比較演算の結果は， `true` か `false` の真偽値になります．よくあるプログラミング言語に備わっている演算が備わっていることがわかります．ただし，表3の説明に(*1)をつけている，算術演算や数値の大小を比較する演算では `unsigned` 型， `signed` 型あるいは `integer` の変数や定数，あるいは数値に相当する即値にしか利用できません．

  種類      | 演算子         | 説明
  ----------|---------------|--------
  論理演算  |  a and b  | 論理積．aとbが `'1'` なら `'1'` ．さもなければ `'0'` ．
            |  a or b   | 論理和．aとbのどちらか又は両方が `'1'` なら `'1'` ．さもなければ `'0'` ．
            |  a xor b  | 排他的論理積．aとbの一方だけが `'1'` なら `'1'` ．さもなければ `'0'` ．
            |  not a    | 否定．aが `'0'` なら `'1'` ． `'1'` なら`'0'`
  比較演算  |  a = b    | aとbが等しい場合 `true` ．さもなければ `false` 
            |  a /= b   | aとbが等しくなければ場合 `true` ．さもなければ `false`
            |  a > b    | aがbがより大きいなら `true` ．さもなければ `false` ．(*1)
         |  a < b    | aとbがより小さいなら `true` ．さもなければ `false` ．(*1)
         |  a >= b   | aとb以上なら `true` ．さもなければ `false` ．(*1)
         |  a <= b   | aとb以下なら `true` ．さもなければ `false` ．(*1)
  算術演算  |  a + b    | aとbの足し算 (*1)
            |  a - b    | aとbの引き算 (*1)
            |  a * b    | aとbの引き算 (*1)
            |  a / b    | aとbの割り算 (*1)
            |  a ** b   | aのb乗 (*1)
   配列操作 |  a & b    | aとbをこの順に並べた信号線の束を作る
            |  a(b)     | aのb番目の信号を取り出す
            |  a(b downto c)   | aのb番目からc番目の信号線の束を取り出す

### 演算結果の代入

演算の結果は代入文でほかの(あるいは同じ)変数へ代入できます．代入にはブロッキング代入とノンブロッキング代入があります．

{{< highlight vhdl "linenos=table" >}}
:= ブロッキング代入
<= ノンブロッキング代入
{{< /highlight >}}

たとえば，

{{< highlight vhdl "linenos=table" >}}
Q <= counter(width-1);
{{< /highlight >}}

という記述は， `std_logic_vector` 型の変数 `counter` の `(width-1)` 番目を取り出し， `Q` に代入するハードウェアの記述に相当します．VHDLでは， `signal` 変数には，初期化時以外でブロッキング代入を使用することはできません．

### 型の変換
VHDLは型の制約が強い言語で．代入は同じ型の変数同士でしか認められません．また演算子も適用可能な型があらかじめ決められています．そのため，幅の違う `std_logic_vector` 同士で値を定義する場合には，ビット幅を削る/足すなどして同じ幅にしなければいけません．たとえば，aとbが，それぞれ幅16-bit，8-bitの `std_logic_vector` 型であれば，

{{< highlight vhdl "linenos=table" >}}
a <= "00000000" & b; -- 足りない8bitを8bitの0(="00000000")で埋めている
b <= a(7 downto 0); -- aの下位8bitだけをbに代入している
{{< /highlight >}}

などとする必要があります．

型の変換には専用の関数を利用します．たとえば， `std_logic_vector` を `unsigned` 型あるいは `signed` 型に変換するためには，それぞれ `unsigned` 関数あるいは `signed` を用います．

{{< highlight vhdl "linenos=table" >}}
unsigned(c);
{{< /highlight >}}

と記述すると `std_logic_vector` 型の変数 `c` を `unsigned` 型に変換できます．

逆に， `unsigned` 型や `singed` 型の変数を `std_logic_vector` 型に変換する場合には， `std_logic_vector` 関数を用います．

{{< highlight vhdl "linenos=table" >}}
std_logic_vector(d);
{{< /highlight >}}

と記述すると `unsigned` 型の変数 `d` を `std_logic_vector` 型に変換できます．

 `integer` 型の変数を `unsigned` 型や `signed` 型に変換する場合には， `to_unsigned` あるいは `to_signed` を使います．たとえば， `integer` 型の変数 `k` をn-bitの `unsigned` 型に変換する場合は，2番目の引数にビット数 `n` を指定して，

{{< highlight vhdl "linenos=table" >}}
to_unsigned(k, n);
{{< /highlight >}}

と記述します．

一般に，VHDLでは， `std_logic_vector` 型の変数に対して算術演算は記述できません．そのため， `std_logic_vector` と定数の加減算や比較演算する場合には，一度 `unsigned` 型に変換して演算する必要があります．たとえば，幅nの `std_logic_vector` の変数counterに定数 `1` を加算する場合には，次のように，一度 `unsigned` 型に変換して演算した後で `std_logic_vector` 型に戻す必要があります．

{{< highlight vhdl "linenos=table" >}}
counter <= std_logic_vector(unsigned(counter) + 1);
{{< /highlight >}}

### シフト演算
VHDLには，ソフトウェア・プログラミング言語で一般的なシフト演算子に相当する演算子がありません．VHDLでは配列操作の演算を用いて似たような操作ができます．たとえば，幅n-bitの `std_logic_vector` 型の変数counterを右に1つシフトしたい場合には，次のように記述します．

{{< highlight vhdl "linenos=table" >}}
counter <= '0' & counter(n-1 downto 1);
{{< /highlight >}}

左に2つシフトしたい場合には，

{{< highlight vhdl "linenos=table" >}}
counter <= counter(n-3 downto 0) & "00";
{{< /highlight >}}

となります．

## 同時処理文

{{< highlight vhdl "linenos=table" >}}
c <= a and b;
e <= c and d;
{{< /highlight >}}

と書いても，

{{< highlight vhdl "linenos=table" >}}
e <= c and d;
c <= a and b;
{{< /highlight >}}

と書いても，同じように図6の回路が合成されます．

{{<figure src="../languages_figures/parallel_vhdl.png" class="center" caption="図6: 同時処理文は，記述順によらず解析・合成される">}}

## 順次処理文 --- process文
順次処理文では記述された順序に従って意味が解析され，回路が合成されます．そのため，複雑な制御構文を使用できます．VHDLでは， `architecture` 中で `process` を使って順次処理文を記述するためのブロックを作ることができます． `process` 文の基本的な構文を次に示します．

{{< highlight vhdl "linenos=table" >}}
process(a, b)
begin
  c <= a and b;
  d <= a or b;
end process;
{{< /highlight >}}

ここで， `process()` の「 `()` 」内の変数のリストをセンシティビティ・リストといいます．このリストに列挙した変数の信号が変化すると `process` の中の回路が動作し出力値が変更されます．ノンブロッキング代入は，process内の記述が順に解釈された後で，同時に信号が確定します．このprocess文は，図7のような回路を生成します．あくまで文が順に解釈されるだけで，順に処理される回路が生成できるわけではない，ことに注意する必要があります．

{{<figure src="../languages_figures/process_example.png" class="center" caption="図7: 順次処理文中の複数のノンブロッキング文は順に解釈され，最後に値が同時に確定する">}}

 `process` 文の中にでてくる入力変数(式の右辺にでてくる変数)がすべてセンシティビティ・リストに列挙されている場合，入力が変化する度に回路が動作し，出力変数(式の左辺)の値が変更されます．つまり，その `process` 文から生成される回路では，何も状態を保存する必要がありません．そのため，図8のような記憶素子を必要としない組み合わせ回路として構成されます．

センシティビティ・リストにない変数が右辺に使われる．次のようなprocess文を考えてみます．

{{< highlight vhdl "linenos=table" >}}
process(a)
begin
  c <= a and b;
  d <= a or b;
end process;
{{< /highlight >}}

ここでは，センシティビティ・リストに「b」がなく，入力変数が全部列挙されていません．この回路では，bの値が変化しても出力先であるcとdの値は変化しません．つまり，図8のように，入力であるaとbを出力のcとdに直接接続することができず，cとdの値を保存する機構，記憶素子が必要となり，組み合わせ回路として合成されません．「同じように記述したつもりでも違う回路になるかもしれない」ということを覚えておいてください．

VHDLの `process` 文では，ブロッキング代入可能な `variable` 変数を利用できます． `variable` 変数は，順次処理文において便宜的に一時的な値を格納しておくためのものです．長く複雑な演算を行う場合に，ソース・コードの見通しをよくできます．
たとえば，次のように使います．

{{< highlight vhdl "linenos=table" >}}
process(a,b)
  variable tmp0 : std_logic;
  variable tmp1 : std_logic;
begin
  tmp0 := a and b;
  tmp1 := a or b;
  c <= tmp0 xor tmp1;
end process;
{{< /highlight >}}

ここでは，tmp0とtmp1がvariable変数です．ブロッキング代入における演算の結果がそれぞれ代入されています．ブロッキング代入のため，合成ツールがこの構文に出会ったところで，tmp0の値は(a and b)に，tmp1の値は(a or b)にすぐさま置き換わります．つまり，これは， `c <= (a and b) xor (a or b)` という回路として合成されます．

## 制御構文
VHDLでは，まるでソフトウェアを記述するように，条件分岐やCの `switch` 文のような制御構文が使えます．多くの制御構文は， `process` 文の中でのみ使用ができます．代表的なものを紹介します．

### when 〜 else
同時処理文中で記述可能な制御構文です．条件に従って出力する値を選択できます．下記は， `a` と `b` の値が等しい場合は `X` を，等しくない場合には `Y` を `c` に代入する例です．

{{< highlight vhdl "linenos=table" >}}
c <= X when a = b else Y;
{{< /highlight >}}

制御構文というよりは，Cなどで， `c = (a==b) ? X : Y` と書く3項演算子に近いイメージですね．

### if 〜 then 〜 elsif 〜 else 〜 end if --- 条件分岐構文
 `process` 文の中でのみ使用できる条件分岐構文です．
次は， `a` より `b` が大きい場合は処理文Xが，それ以外の場合は処理文Yが有効になります．また，処理文の中で `if` をネスト(入れ子に)することもできます．

{{< highlight vhdl "linenos=table" >}}
if a > b then
  処理文X
else
  処理文Y
end if;
{{< /highlight >}}

また， `elsif` を使うと， `else` 節に重ねて次の条件を記述できます．

{{< highlight vhdl "linenos=table" >}}
if a > b then
  処理文X
elsif a < b then
  処理文Y
else
  処理文Z
end if;
{{< /highlight >}}

VHDLでは，単に信号の値に対する条件だけでなく，信号が変化するタイミングを使用した条件式が書けます．
たとえば，変数clkが変化するタイミングはclk'eventと書きますので，これを使って，

{{< highlight vhdl "linenos=table" >}}
if clk'event and clk = '1' then
  処理文
end if;
{{< /highlight >}}

のような条件文を作ることができます．この例では，「clkが変化し，かつ，clkが1」のときに処理文が実行されます．ハードウェアとしては，clk信号が立ち上がった瞬間に相当します．それ意外のタイミングでは，処理文は動作せず，値が保存し続けられます．これは，決まったタイミングで処理を実行する順序同期回路の設計に欠かせない表現です．

ただし，2018年現在では，多くの場合，直接「クロックの立ち上がり」を表す， `rising_edge` という関数を使って，

{{< highlight vhdl "linenos=table" >}}
if rising_edge(clk) then
  処理文
end if;
{{< /highlight >}}

という記述が好まれます．

### case〜when --- 選択
CやJavaでいうところの `switch` 構文です．次に示す例では， `std_logic_vector` 型の変数aの値によって処理文X，Y，Zのどれかが実行されます．0，1，2という整数と一致させられるように， `to_integer` を使って `a` を `integer` 型に変換しています．ここで，VHDLの `case ~ when` 構文では，どれかの `when` に必ず該当するように記述する必要があることに注意しなければいけません．すべての `when` を列挙する代わりに「 `others` 」で残りすべての条件にマッチする場合を表現できます．

{{< highlight vhdl "linenos=table" >}}
case to_integer(unsigned(a))
  when 0 =>
    処理文X
  when 1 =>
    処理文Y
  when 2 =>
    処理文Z
  when others => --そのほかのすべての場合
    処理文W
end case;
{{< /highlight >}}

### for 〜 in 〜 loop --- 繰り返し
VHDLにおける繰り返し処理は，単に似たような処理を繰り返して記述する代わりに簡単に書けるようにするための構文です．実際には，合成時に繰り返し回数分のハードウェア回路が生成されます．

たとえば，下記に示す処理は，5bitの `std_logic_vector` 型の変数 `a` と `std_logic` 型の変数 `b` が定義されているときに，

{{< highlight vhdl "linenos=table" >}}
process
  variable i : integer := 0;
  variable tmp : std_logic;
begin
  tmp := '0'
  for i in 0 to 4 loop
    tmp := tmp or a(i);
  end loop;
  b <= tmp
end process;
{{< /highlight >}}

という記述は，次のような記述を簡単に記述したことに相当します．

{{< highlight vhdl "linenos=table" >}}
process
  variable i : integer := 0;
  variable tmp : std_logic;
begin
  tmp := '0'
  tmp := tmp or a(0);
  tmp := tmp or a(1);
  tmp := tmp or a(2);
  tmp := tmp or a(3);
  tmp := tmp or a(4);
  b <= tmp
end process;
{{< /highlight >}}

作成した回路が動作する時ではなく，回路を作成する時点で繰り返し処理が解釈されることに注意してください．

## 組み合わせ回路のサブモジュール
VHDLでは，複雑な組み合わせ回路を生成するために， `function` というサブモジュールを記述できます． `function` は順次処理文で， `if` や `case` などの条件文を記述できますが，ノンブロッキング代入を用いることはできません． `function` は，次のように定義します．

{{< highlight vhdl "linenos=table" >}}
function f (a : in std_logic; b : in std_logic)
  return std_logic is
  variable Q : std_logic;
begin
  if (a = b) then
    Q := '1';
  else
    Q := '0';
  end if;
  return Q;
end f;
{{< /highlight >}}

これは，1ビットの変数である `a` と `b` を入力とする名前 `f` の `function` の定義です．入力された二つの値が等しいときに1を，異なるときに0を出力する関数です．

呼び出し側では，

{{< highlight vhdl "linenos=table" >}}
x <= f(x, y)
{{< /highlight >}}

などとします．xとyは，関数呼び出しに対する実引き数になります．

また次のように，配列型の変数を入力あるいは出力する関数を定義できます．

{{< highlight vhdl "linenos=table" >}}
   function g (x : in std_logic_vector(1 downto 0))
    return std_logic_vector is
    variable Q : std_logic_vector(1 downto 0);
  begin
    Q(0) := x(1);
    Q(1) := x(0);
    return Q;
  end g;
{{< /highlight >}}

Cなどのソフトウェア・プログラミング言語の関数とは違い，関数の計算が終了するまで呼び出し側の処理が待たされるということはありません．
複雑な組み合わせ回路を見通しよく記述できる書き方です．

## おまじない
実は，ここまで説明してきた `std_logic` などを利用するには，これらの機能が実装されたライブラリなどを読み込む必要があります．
VHDLソース・コードの先頭に以下を記述します．

{{< highlight vhdl "linenos=table" >}}
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
{{< /highlight >}}

# Verilog HDLの基本文法のルール
Verilog HDLの基本的な文法を説明します．

## コメント
多くのソフトウェア・プログラミング言語と同様に，Verilog HDLでもソースコード中にコメントを書くことができます．Verilog HDLでは，C++と同じように  `/* 〜 */`  で囲んだ部分や  `//`  から行末までがコメントになります．

## モジュールの構成
図9に，Verlog HDLで記述するモジュールの概要を示します．VHDLでは，外枠の定義 `entity` と内部の定義 `architecture` が区別されていたのに対し，Verilog HDLにはそのような区別はありません． `module` の中に，外部と接続されるポートや関数内で使用する変数の宣言，処理内容などを記述します．

{{<figure src="../languages_figures/verilog_module_overview.png" class="center" caption="図9: Verilog HDLのモジュール定義の概要">}}

## 値の表現方法
Verilog HDLでは，必要とするビット幅( `w` )と基数( `f` )を付けて「 `w'f値` 」という形式で即値を記述します．ビット幅は10進数で記述します．ビット幅と基数を省略すると10進数，32bitの値になります．表\ref{tbl:verilog_value}に，基数と記号と表現される数の関係を示します．

  基数(w) | 基数記号(f) | 例            | 10進数表記での値
  --------|-----------|-------------|------------------
  2       |  `b`     |  `8'b10`   | 2
  10      |  `d`     |  `10'd10`  | 10
          |             |  `10`      | 10
  16      |  `h`     |  `8'h10`   | 16

## 型 --- ネット型変数とレジスタ変数
Verilog HDLの変数には，ネット変数とレジスタ変数があります．どちらも1bitの信号に相当する変数と，複数bitの信号を束にした配列変数を作れます．ネット変数とレジスタ変数の違いは，ハードウェアに則したワイヤ(配線)とレジスタ(記憶素子)を想起させるものですが，後で説明するように使える場面と使い方に違いがあります．表\ref{tbl:verilog_types}に，変数の型を示します．

  型名               | 説明
  ----------------|---------------------
   `wire`         | 1-bitのネット変数
   `wire[n-1:0]`  | n-bitのネット変数
   `reg`          | n-bitのレジスタ変数
   `reg[n-1:0]`   | n-bitのレジスタ変数

### ネット変数 --- wire
モジュールやゲート同士を接続する配線に名前を付けた変数が，ネット変数 `wire` です．ネット変数自身は値を保持することはできず，他から代入された値を次に伝達する役目を担う変数です．ハードウェアの配線そのものに相当します．

### レジスタ変数 --- reg
レジスタ変数 `reg` は，値を保存する記憶素子になることができ，変数自身が値を保持できます．組み合わせ回路も順序回路も構成できます．

### 配列変数
配列変数 `wire[n-1:0]` ， `reg[n-1:0]` は，それぞれ `wire` あるいは `reg` からなるn-bitの変数に相当します．幅 `n` のネット変数

{{< highlight verilog "linenos=table" >}}
wire[n-1:0] a;
reg[n-1:0] b;
{{< /highlight >}}

と定義された変数aの各要素をa[0]，a[2:0]などとして取り出すことができます．前者はwire，後者はwire[2:0]の変数です．

## モジュールの外枠の記述 --- module
Verilog HDLでは， `module` でハードウェア・モジュールの外枠を定義します．モジュールの名前と入出力の信号名を定義します．

{{< highlight verilog "linenos=table" >}}
module test(pClk, pReset, Q);
{{< /highlight >}}

この文では， `pClk` ， `pReset` ， `Q` という名前の入出力信号を持つ `test` という名前のモジュールを定義しています．
Verilog HDLでは，この `module` 文から

{{< highlight verilog "linenos=table" >}}
endmodule
{{< /highlight >}}

というキーワードまでがモジュールの定義に相当します．
moduleの末尾には‘;’(セミコロン)が必要ですが，endmoduleには付けないことに注意してください．
ポート名だけを列挙する場合には，後で，各ポートの入出力方向と幅を定義する必要があります．

少し前のVerilog-95


{{< highlight verilog "linenos=table" >}}
module test(pClk, pReset, Q);
{{< /highlight >}}

### ポートの定義
ポートとは，モジュールの入出力信号のことです．ポートの名前は，モジュール名に続く()の中に記述します．
それぞれのポートの入出力は，モジュールの中で，「方向 型 変数名;」で宣言します．
方向には， `input` (入力)と `output` (出力)， `inout` (入出力)の3種類があります．
 `module` 文の `()` 内に与えた信号線の型と入出力方向はモジュールの内部で定義します．
たとえば， `pClk` と `pReset` が1bitの入力， `Q` が1bitの出力信号であれば，

{{< highlight verilog "linenos=table" >}}
module test(pClk, pReset, Q);
  input   wire pClk;
  input   wire pReset;
  output  wire Q;

  // 以降，モジュールの内部処理を記述する

endmodule
{{< /highlight >}}

と記述されます．

通常Verilog HDLでは，1bitのwire変数は定義せずに使えるため，wireが省略されることがあります．
もちろん，n-bitのポートを定義することもでます．Qが幅n-bitの出力ポートであれば，

{{< highlight verilog "linenos=table" >}}
output wire[n-1:0] Q
{{< /highlight >}}

と書けます．

Verilog-2001以降をサポートする処理系の場合には，VHDLのように信号名の定義に型と変数を付けることができます．

{{< highlight verilog "linenos=table" >}}
module test(
  input wire pClk, 
  input wire pReset,
  output wire Q
);

  // 以降，モジュールの内部処理を記述する

endmodule
{{< /highlight >}}

と記述できます．

### 定数を定義する
module宣言の後に，各モジュール内で有効な定数をparameter文で定義できます．

{{< highlight verilog "linenos=table" >}}
module test(pClk, pReset, Q);
parameter width  = 640;
parameter height = 480;
{{< /highlight >}}

上記に示したモジュールtestの中では，widthを640という値として利用できます．

## 内部処理の記述

ポートの宣言に引き続いて，内部で使用する変数の宣言および処理本体を記述します．

## 変数の定義

処理に必要な変数をあらかじめ定義しておく必要があります．変数は，ネット接続型あるいはレジスタ型の型を伴って定義されます．

{{< highlight verilog "linenos=table" >}}
wire a;
reg[15:0] b;
{{< /highlight >}}

これは，ネット変数 `a` と幅16ビットのレジスタ変数 `b` を定義しています．

また， `parameter` で定義した定数 `width` を用いて，次のように変数を定義することもできます．

{{< highlight verilog "linenos=table" >}}
reg[width-1:0] c;
{{< /highlight >}}

## 演算子と演算
代表的な演算子を表\ref{tbl:verilog_operator}にまとめました．
論理演算における真と偽は，ネット変数やレジスタ変数の場合は `'1'` と `'0'` に対応します．
n-bitの配列変数 `wire[n-1:0]` あるいは `reg[n-1:0]` の場合には，配列中に一つでも `'1'` である要素があれば真，さもなければ偽として判定されます．ビット論理演算子を配列変数に適用する場合は，対応する各要素同士について演算が適用されます．

  種類           | 演算子           | 説明
  --------------|-------------------|--------------------
  論理演算       |  a && b     | 論理積．aとbが共に真なら真．さもなければ偽．
                 |  a \|\| b    | 論理和．aとbのどちらか又は両方が真なら真．さもなければ偽．
                 |  !a         | 否定．aが真なら偽．偽なら真
  ビット論理演算 |  a & b      | 論理積．aとbが共に'1'なら'1'．さもなければ'0'．
                 |  a \|  b     | 論理和．aとbのどちらか又は両方が'1'なら'1'．さもなければ'0'．
                 |  a ^ b      | 排他的論理和．aとbのどちらか一方が'1'なら'1'．さもなければ'0'．
                 |  ~a         | 論理否定．aが'1'なら'0'．さもなければ'1'．
  比較演算       |  a == b     | aとbが等しい場合 `true` ．さもなければ `false`
                 |  a != b     | aとbが等しくなければ場合 `true` ．さもなければ `false`
                 |  a > b      | aがbがより大きいなら `true` ．さもなければ `false` ．(*1)
                 |  a < b      | aとbがより小さいなら `true` ．さもなければ `false` ．(*1)
                 |  a >= b     | aとb以上なら `true` ．さもなければ `false` ．(*1)
                 |  a <= b     | aとb以下なら `true` ．さもなければ `false` ．(*1)
  算術演算       |  a + b      | aとbの足し算
                 |  a - b      | aとbの引き算
                 |  a * b      | aとbの引き算
                 |  a / b      | aとbの割り算
                 |  a % b      | aとbの割り算の余り
   シフト演算    |  a >> b     | aとbビット，右にシフト 
                 |  a << b     | aをbビット，左にシフト 
   条件演算      |  a ? b : c  | aが真の時b，偽のときc 
   配列操作      |  {a,b,c}    | aとbとcをこの順に並べた信号線の束を作る 
              |  a[b]       | aのb番目の信号を取り出す
              |  a[b:c]     | aのb番目からc番目の信号線の束を取り出す
Verilog HDLで用いられる演算の例

### 演算結果の代入
演算の結果をネット変数あるいはレジスタ変数に代入できます．
ネット型変数への代入には `assign` 命令を使用して，下記のように記述します．

{{< highlight verilog "linenos=table" >}}
assign c = a & b;
{{< /highlight >}}

これは，ハードウェア的には，演算の結果を信号線に接続することに相当します．
ネット変数の代入は後述の同時処理文としてしか記述できません．

一方，レジスタ変数への代入では，ブロッキング代入とノンブロッキング代入の両方が使えます．
Verilog HDLでは，それぞれ下記のように記述します．

{{< highlight verilog "linenos=table" >}}
=  // ブロッキング代入
<= // ノンブロッキング代入
{{< /highlight >}}

たとえば， `a + b` の演算結果をノンブロッキング代入する場合には，

{{< highlight verilog "linenos=table" >}}
c <= a + b;
{{< /highlight >}}

のように記述します．
レジスタ変数への値の代入は，ブロッキング代入とノンブロッキング代入のどちらも，
後で説明する順次処理文内でのみ使えます．

### 型の変換
VHDLが型に対して厳格であるのに対して，Verilog HDLでは暗黙のうちに型が変換されます．
意識せずに異なるビット幅の変数を演算，代入できます．

### シフト演算
VHDLと異なり，Verilog HDLにはシフト演算子がありますが，シフト演算は大きな回路になってしまいます．
定数分のシフトを行いたい場合は，配列の結合演算を用いて実装する方が小さな回路として実現できます．
たとえば，配列変数reg[n-1:0]のcounterを右に1bitシフトしたい場合は，下記のようになります．

{{< highlight verilog "linenos=table" >}}
{1'b0, counter[n-1:1]};
{{< /highlight >}}

また，左に2つシフトしたい場合には，

{{< highlight verilog "linenos=table" >}}
{counter［n-3:0］, 2'b00};
{{< /highlight >}}

のように記述します．

## 同時処理文
ネット型変数の演算結果の代入は，同時処理文を記述します．
記述されたすべての同時処理文は，合成ツールにより同時に解析され，回路として合成されます．
つまり，記述された内容は，その順序に依存しません．たとえば，

{{< highlight verilog "linenos=table" >}}
assign c = a & b;
assign e = c & d;
{{< /highlight >}}

という同時処理文の列も，

{{< highlight verilog "linenos=table" >}}
assign e = c & d;
assign c = a & b;
{{< /highlight >}}

の列も，同じように図8の回路が合成されます．

## 順次処理文〜always文
 `always` 文は，順次処理文を記述するためのブロックを作るものです．順次処理文では，記述された順序に従って意味が解析され，
回路が合成されます．そのため，複雑な制御構文を使用できます．
基本的な構文を下記に示します．変数 `c` ， `d` は `reg` 変数です．

{{< highlight verilog "linenos=table" >}}
always @(a, b) begin
  c <= a & b;
  d <= a | b;
end
{{< /highlight >}}

ここで， `always @()` の「 `()` 」内の変数のリストをセンシティビティ・リストといいます．
このリストに列挙した変数が変化すると，プロセス文の中の回路の値が変更されます．
ノンブロッキング代入は，always内の処理の解釈がすべて完了したタイミングで，同時更新されることに注意してください．
このalways文は，図10のような回路になります．

 `always` 文の中にある入力変数(式の右辺にでてくる変数)がすべてセンシティビティ・リストに列挙されている場合，
入力が変化する度に回路が動作し，出力変数(式の左辺)の値が変更されます．
つまり，その `always` 文は，何も状態を保存する必要がありません．
そのため，記憶素子を必要としない組み合わせ回路として構成されます．
ここで，入力に対して常に出力が生成されない場合とは，条件分岐などによって，
入力信号の値によって値の代入が発生しない出力信号がある場合です．

次のような `always` 文を考えてみます．

{{< highlight verilog "linenos=table" >}}
always @(a) begin
  c <= a & b;
  d <= a | b;
end
{{< /highlight >}}

ここでは，センシティビティ・リストに「 `b` 」がなく，入力変数が全部列挙されていません．
この回路では，bの値が変化しても出力先であるcとdの値は変化しません．
つまり，図10のように，入力であるaとbを出力のcとdに直接接続することができず，
 `c` と `d` の値を保存する機構，記憶素子が必要となり，組み合わせ回路としては合成されません．
「同じように記述したつもりでも違う回路になるかもしれない」ということを覚えておいてください．

 `always` の中では， `reg` 変数にブロッキング代入することもできます．
ブロッキング代入では， `always` 中のほかの代入に関係なく，その時点で代入が発生し値が置き換わります．
たとえば，次のような `always` 文を考えます．ここで， `tmp0` ， `tmp1` ， `c` はすべて `reg` 変数とします．

{{< highlight verilog "linenos=table" >}}
always @(a,b) begin
  tmp0 = a & b;
  tmp1 = a | b;
  c <= tmp0 ^ tmp1;
end
{{< /highlight >}}

この場合， `tmp0` と `tmp1` ともに，ブロッキング代入で演算の結果が代入されています．
ブロッキング代入なので，合成ツールがこの構文に出会ったところで， `tmp0` は `(a & b)` に，
 `tmp1` は `(a \`  b)|にすぐさま置き換わます．つまり，これは単に `c <= (a & b) ^ (a \`  b)|という回路に合成されます．

センシティビティ・リストには， `@(a and b)` という条件式が記述できます．
これはaとbのどちらかが変化した場合ではなく， `(a and b)` が変化した場合に `always` の中の処理を実行できるようにします．
条件式には，信号の立ち上がり，あるいは立ち下がり条件を使用することもできます．
立ち上がりは「posedge」，立ち下がりは「negedge」というキーワードを使います．

{{< highlight verilog "linenos=table" >}}
alwasy @(posedge clk) begin
  処理文
end
{{< /highlight >}}

これは，「clkの立ち上がり」のときに処理文が実行されることを意味します．
ハードウェア的には，clk信号が立ち上がった瞬間に相当し，それ意外のタイミングでは，処理文は動作せず，値が保存し続けられます．
これは，決まったタイミングで処理を実行する順序同期回路の設計に欠かせない表現です．

## 制御構文
ソフトウェア・プログミングのように，条件分岐のifやCでいう `switch` 構文のような制御構文が使えます．
多くの制御構文は， `always` 文の中でのみ使用することができます．代表的なものを次に説明します．

### if 〜 begin 〜 end else begin 〜 end --- 条件分岐構文
 `always` 文の中でのみ使用できる条件分岐構文です．
次に示す例では， `a` が `b` より大きければ処理文 `X` が，それ以外の場合は処理文 `Y` が実行されます．
また，処理文の中で，ifをネスト(入れ子)にすることもできます．

{{< highlight verilog "linenos=table" >}}
if (a > b) begin
  処理文X
end else begin
  処理文Y
end
{{< /highlight >}}

### case --- 選択
CやJavaでいうところのswitch構文です．
次に示す例では，変数 `a` の値によって処理文X，Y，Zに分岐しています．
 `case` 構文では，どれかのケースに該当するように記述しましょう．
もちろん，すべての条件を列挙してもよいのですが，「 `default` 」でどんな値にもマッチする場合を記述できます．

{{< highlight verilog "linenos=table" >}}
case(a)
  0 :
    処理文X
  1 :
    処理文Y
  2 :
    処理文Z
  default :
    処理文W
endcase
{{< /highlight >}}

### 繰り返し構文 --- for
Verilog HDLにおける繰り返し処理は，単に似たような処理を繰り返して記述する代わりに簡単に書けるようにするための構文です．
実際には，繰り返し回数分のハードウェア回路が生成されます．
たとえば，下記に示す処理ですが，

{{< highlight verilog "linenos=table" >}}
tmp = 1'b0;
for (i = 0; i < 5; i = i + 1) begin
  tmp = tmp | a[i];
end
b <= tmp;
{{< /highlight >}}

これは，次のような代入文を記述することに相当します．

{{< highlight verilog "linenos=table" >}}
tmp = 1'b0;
tmp = tmp | a[0];
tmp = tmp | a[1];
tmp = tmp | a[2];
tmp = tmp | a[3];
tmp = tmp | a[4];
b <= tmp;
{{< /highlight >}}

## 組み合わせ回路のサブモジュール
Verilog HDLでは，複雑な組み合わせ回路を生成するために， `function` というサブモジュールを記述できます．
 `function` は順次処理文で， `if` や `case` などの条件文を記述できますが，
ノンブロッキング代入を用いることはできません． `function` は，次のように定義します．

{{< highlight verilog "linenos=table" >}}
function f;
  input a;
  input b;
  begin
    if(a == b) begin
      f = 1'b1;
    end else begin
      f = 1'b0;
    end
  end
endfunction
{{< /highlight >}}

これは，1ビットのネット型信号である `a` と `b` を入力とする名前 `f` の `function` の定義です．
 `function` の中で `f` に値を代入すると，関数の返り値としてセットされます．
この例は，入力された二つの値が等しいときに'1'を，異なるときに'0'を出力する関数です．

呼び出し側では，

{{< highlight verilog "linenos=table" >}}
assign x = f(x, y)
{{< /highlight >}}

または，always文で

{{< highlight verilog "linenos=table" >}}
x <= f(x, y)
{{< /highlight >}}

などとして呼び出せます．ここで，xとyは，関数呼び出しに対する実引数になります．

また，次のように，配列型の変数を入力あるいは出力する関数を定義できます．

{{< highlight verilog "linenos=table" >}}
function [1:0] g; 
  input [1:0] x;
  begin
    g[0] = x[1];
    g[1] = x[0];
  end
endfunction
{{< /highlight >}}

ここで定義した `function` は，Cの関数とは違い，関数の計算が終了するまで呼び出し側の処理が待たされるような制御を伴うことはなく，
複雑な組み合わせ回路を見通し良く記述するための書き方です．

# まとめ
ハードウェア記述言語であるVHDLとVerilog HDLの基本について説明しました．
どちらも一般のソフトウェア・プログラミング言語ではなじみの薄い，

 - ノンブロッキング代入とブロッキング代入
 - 同時処理文や順次処理文
 
といった，ハードウェアを設計するための特有の特徴をもっています．
とはいえ，分岐構文などを使うと，ハードウェアで実装したい処理をソフトウェア的に設計できます．

今回は，基本的な文法の説明をかけあしで紹介しました．
ソフトウェア・プログラミングを習得する際にはある程度，文法を覚えたあとは，
他人の書いたコードをたくさん読むことで，言語をスムーズに習得できます．
ハードウェアを設計するためのHDLプログラミングでも同じです．
たとえば，OpenCores.orgには，さまざまなHDLコードが投稿されており，
また，米国Sun Microsystems社からは，SPARCプロセッサのHDLコードが公開されています．
習うより慣れろで，どんどん読み書きしてみましょう．

# 参考文献
 1. Douglas L.Perry(著)，メンター・グラフィックス・ジャパン株式会社(翻訳)；VHDL(Ascii software science—Language)，1996年10月，アスキー．
 1. Bhasker(著)，デザインウェーブ企画室(翻訳)；VHDL言語入門—ハードウェア記述言語によるロジック設計マスタリング(C\&E TUTORIAL)，1995年7月，CQ出版社．
 1. 長谷川 裕恭；VHDLによるハードウェア設計入門—言語入力によるロジック回路設計手法を身につけよう，2004年4月，CQ出版社．
 1. 小林 優；入門Verilog HDL記述—ハードウェア記述言語の速習\&実践 改訂，2004年5月，CQ出版社．
 1. 井倉 将実；FPGAボードで学ぶVerilog HDL，2007年2月，CQ出版社．
 
