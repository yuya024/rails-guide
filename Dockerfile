# ベースイメージの設定
FROM ruby:2.7.4

RUN dpkg --add-architecture amd64 && apt-get update && apt-get install -y libc6:amd64 libncurses5:amd64 libstdc++6:amd64

# 必要なパッケージのインストール
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs

RUN gem install bundler:1.16.6

# 作業ディレクトリの設定
RUN mkdir /myapp
WORKDIR /myapp

# ホスト側のGemfileとGemfile.lockをコンテナにコピー
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock

# Gemのインストール
RUN bundle install

# ホスト側のアプリケーションコードをコンテナにコピー
COPY . /myapp

# コンテナー起動時に毎回実行されるスクリプトを追加
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

# ポート番号の指定
EXPOSE 3000

# サーバーの起動
CMD ["rails", "server", "-b", "0.0.0.0"]