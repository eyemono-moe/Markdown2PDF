# Markdown2PDF

1. `report.md`を編集して
2. `references.bib`を編集して
3. 使用画像を`./src/img`に入れて
4. `build.bat`を実行すると
5. PDFが出来ます

## Markdown形式と\LaTeX コマンドの対応

### 本文

```.md
ここは本文です。適当な文章が思いつかない。

これは上の文章とは別の段落です。本文の途中にわざと半角スペースを複数挿入すると→        ←改行されます。全角スペースを挿入した場合は→　　　　　　　　←こうなります。
```

↓Pandocで変換

```.tex
ここは本文です。適当な文章が思いつかない。

これは上の文章とは別の段落です。本文の途中にわざと半角スペースを複数挿入すると→
←改行されます。全角スペースを挿入した場合は→　　　　　　　　←こうなります。
```

### 見出し

```.md
# h1 見出し
## h2 見出し1 {#sec:h2_1}
## h2 見出し2 {-}
## h2 見出し3
### h3 見出し
#### h4 見出し
##### h5 見出し
###### h6 見出し
```

↓Pandocで変換

```.tex
\hypertarget{h1-ux898bux51faux3057}{%
\section{h1 見出し}\label{h1-ux898bux51faux3057}}

\hypertarget{h2-ux898bux51faux3057}{%
\subsection{h2 見出し}\label{h2-ux898bux51faux3057}}

\hypertarget{h3-ux898bux51faux3057}{%
\subsubsection{h3 見出し}\label{h3-ux898bux51faux3057}}

\hypertarget{h4-ux898bux51faux3057}{%
\paragraph{h4 見出し}\label{h4-ux898bux51faux3057}}

\hypertarget{h5-ux898bux51faux3057}{%
\subparagraph{h5 見出し}\label{h5-ux898bux51faux3057}}

h6 見出し
```

`h1`から順に
1. `\section{}`
2. `\subsection{}`
3. `\subsubsection{}`
4. `\paragraph{}`
5. `\subparagraph{}`

となっている。`h6`は変換されてないため`subparagraph`内文章として扱われている。トップレベルは変換時のオプション`--top-level-division={{トップレベル}}`で変更可能。
自動で`\hypertarget{}`が付与されるけど日本語がぐちゃぐちゃ。

### 強調構文

```.md
*これはイタリック体の文字*

**これは太文字**

~~取り消し線~~
```

↓Pandocで変換

```.tex
\emph{これはイタリック体の文字}

\textbf{これは太文字}

\sout{取り消し線}
```

### リンク

```.md
明示したリンク <https://trap.jp/post/1123/>
[タイトル付きのリンク](https://trap.jp/post/1123/ "タイトル")
自動リンク https://trap.jp/post/1123/
```

↓Pandocで変換

```.tex
明示したリンク \url{https://trap.jp/post/1123/}
\href{https://trap.jp/post/1123/}{タイトル付きのリンク}
自動リンク https://trap.jp/post/1123/
```

リンクは`<>`で囲んで上げないと認識されない。

### 引用

```.md
> これは引用文です
>> 引用のネストも可能
>>> さらなるネストもできます 
```

↓Pandocで変換

```.tex
\begin{quote}
これは引用文です \textgreater{} 引用のネストも可能
\textgreater\textgreater{} さらなるネストもできます
\end{quote}
```

引用は`quote`が使用されるが、引用のネストには対応していない。

### リスト

```.md
- リスト
- リスト
    - インデントしたリスト
    - インデントしたリスト
        - さらにインデント
    - インデント戻す
- リスト

1. 番号付きリスト
2. 番号付きリスト
    1. インデントした番号付きリスト
    2. インデントした番号付きリスト
    3. インデントした番号付きリスト
3. 番号付きリスト
    55. 任意の数字から始まるリスト
    301. 空気を読んでくれる番号付きリスト
99. 空気を読んでくれる番号付きリスト
```

↓Pandocで変換

```.tex
\begin{itemize}
\tightlist
\item
  リスト
\item
  リスト

  \begin{itemize}
  \tightlist
  \item
    インデントしたリスト
  \item
    インデントしたリスト

    \begin{itemize}
    \tightlist
    \item
      さらにインデント
    \end{itemize}
  \item
    インデント戻す
  \end{itemize}
\item
  リスト
\end{itemize}

\begin{enumerate}
\def\labelenumi{\arabic{enumi}.}
\tightlist
\item
  番号付きリスト
\item
  番号付きリスト

  \begin{enumerate}
  \def\labelenumii{\arabic{enumii}.}
  \tightlist
  \item
    インデントした番号付きリスト
  \item
    インデントした番号付きリスト
  \item
    インデントした番号付きリスト
  \end{enumerate}
\item
  番号付きリスト

  \begin{enumerate}
  \def\labelenumii{\arabic{enumii}.}
  \setcounter{enumii}{54}
  \tightlist
  \item
    任意の数字から始まるリスト
  \item
    空気を読んでくれる番号付きリスト
  \end{enumerate}
\item
  空気を読んでくれる番号付きリスト
\end{enumerate}
```

リストを挿入すると`\tightlist`というコマンドが使われる。が、これは\LaTeX には存在しないので適当なところで定義してあげる必要がある。私は`template.tex`で

```
\def\tightlist{\itemsep1pt\parskip0pt\parsep0pt}
```

と定義している。(参考:<https://qiita.com/Selene-Misso/items/6c27a4a0947f10af3119>)

### 表

```.md
| 変身前     | 変身後           | 声優       |
| :--------- | :--------------: | ---------: |
| 星空みゆき | キュアハッピー   | 福園美里   |
| 日野あかね | キュアサニー     | 田野アサミ |
| 黄瀬やよい | キュアピース     | 金元寿子   |
| 緑川なお   | キュアマーチ     | 井上麻里奈 |
| 青木れいか | キュアビューティ | 西村ちなみ |
: スマイルプリキュア！に登場するキャラクター {#tbl:precure}

[@tbl:precure]に、スマイルプリキュア！に登場するキャラクターを示す。
```

↓Pandocで変換

```.tex
\hypertarget{tbl:precure}{}
\begin{longtable}[]{@{}lcr@{}}
\caption{\label{tbl:precure}スマイルプリキュア！に登場するキャラクター}\tabularnewline
\toprule
変身前 & 変身後 & 声優\tabularnewline
\midrule
\endfirsthead
\toprule
変身前 & 変身後 & 声優\tabularnewline
\midrule
\endhead
星空みゆき & キュアハッピー & 福園美里\tabularnewline
日野あかね & キュアサニー & 田野アサミ\tabularnewline
黄瀬やよい & キュアピース & 金元寿子\tabularnewline
緑川なお & キュアマーチ & 井上麻里奈\tabularnewline
青木れいか & キュアビューティ & 西村ちなみ\tabularnewline
\bottomrule
\end{longtable}

表~\ref{tbl:precure}に、スマイルプリキュア！に登場するキャラクターを示す。
```

Pandocによる表の変換では`longtable`が使われる。Markdownで`:キャプション`のようにコロンで始まる行を追加することでキャプションをつけることができる。`{#tbl:hoge}`のように書くと`[@tbl:hoge]`で相互参照が可能。

### 水平線

```.md
___

---

***
```

↓Pandocで変換

```.tex

```

### 画像

```.md

```

↓Pandocで変換

```.tex

```

### 

```.md

```

↓Pandocで変換

```.tex

```
