class Post < ApplicationRecord
  mount_uploader :picture, PictureUploader
  validates :content, presence: true, length: {maximum: 140}
  validate :picture_size

  private
    def picture_size
      if picture.size > 5.megabytes
        erros.add(:picture, "5メガバイト以下のファイルを送信してください")
      end
    end
end
