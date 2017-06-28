# 画像投稿機能

## 作り方

## 1: rails appの作成
$ rails new PictureUploaderApp<br>
$ ls<br>
=> PictureUploaderApp<br>
$ cd PictureUploaderApp<br>

<strong>./Gemfile(デフォルトのGemファイルに必要な物を追加する)</strong><br>
<pre>
gem 'jquery-rails'
gem 'bootstrap-sass', '3.3.6'
gem 'faker',          '1.6.6'
gem 'will_paginate',          '3.1.0'
gem 'bootstrap-will_paginate', '0.0.10'
gem 'carrierwave',             '0.11.2'
gem 'mini_magick',             '4.5.1'
gem 'fog',                     '1.38.0'
</pre>

$ bundle install --without production --path vendor/bundle
<br><br><br>


## 2: コントローラーの作成
$ rails g controller posts index new edit show

### ./config/routes.rb
<pre>
Rails.application.routes.draw do
    <strong>resources :posts</strong>
end
</pre>

### ./app/controllers/posts/post_controller.rb
<pre>
class PostsController < ApplicationController<br>
  def index
  end

  def show
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
</pre>
<br><br><br>


## 3: モデルとPictureUploaderの作成
$ rails g uploader Picture<br>
$ rails g model Post content:text picture:string<br>
$ rails db:migrate<br>

### ./app/models/post.rb
<pre>
class Post < ApplicationRecord
  mount_uploader :picture, PictureUploader
  validates :content, presence: true, length: {maximum: 140}
  validate :picture_size

  private<br>
    def picture_size
      if picture.size > 5.megabytes
        erros.add(:picture, "5メガバイト以下のファイルを送信してください")
      end
    end
end<
</pre>

### ./app/uploaders/picture_uploader.rb
追加するもの1:<br>
&nbsp;  <strong>include CarrierWave::MiniMagick</strong><br>
追加するもの2:<br>
&nbsp;  <strong>process resize_to_limit: [400, 400]</strong><br>
追加するもの3:<br>
<strong>
    &nbsp;  def extension_white_list<br>
    &nbsp; &nbsp;     %w(jpg jpeg gif png)<br>
    &nbsp;  end<br>
</strong>
<br><br><br>


## 4: フォームの作成と、それに対応するコントローラーの作成

・newとeditアクションで共通となるformをpartialとして作成する<br>
$ touch ./app/views/posts/_form.html.erb
### ./app/views/posts/_form.html.erb

```
<div class="col-sm-6 col-sm-offset-3">
  <%= form_for(@post, html:{multipart: true}) do |f| %>
  <!-- エラーメッセージを表示するpartial viewの読み込み -->
    <%= render 'shared/error_messages', object: f.object %>
  <!-- 投稿内容 -->  
    <%= f.text_area :content, placeholder: "コメントどうぞ", class: "form-control", value: @post.content%>
  <!-- 画像ファイル -->   
    <%= f.file_field :picture, accept: 'image/jpeg,image/gif,image/png', class: "form-control", value: @post.picture %>
  <!-- 送信 -->
    <%= f.submit yield(:submit_button), class: "btn btn-primary", id: "submit"%>
  <% end %>
</div>
<script type="text/javascript">
  $('#post_picture').bind('change', function() {
    var size_in_megabytes = this.files[0].size/1024/1024;
    if (size_in_megabytes > 5) {
      alert('Maximum file size is 5MB. Please choose a smaller file.');
    }
  });
</script>
```

・エラーメッセージを表示するpartial viewを作成する<br>
$ touch ./app/views/shared/_error_messages.html.erb
### ./app/views/shared/_error_messages.html.erb

```
<% if object.errors.any? %>
  <div id="error-explanation">
    <div class="alert alert-danger">
      <p><%= object.errors.count %>個の入力情報が正しくありません。</p>
    </div>
    <ul id="error-messages">
      <% object.errors.full_messages.each do |msg| %>
        <li><%= msg %></li>
      <% end %>
    </ul>
  </div>
<% end %>
```




