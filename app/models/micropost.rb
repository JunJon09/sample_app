class Micropost < ApplicationRecord
  belongs_to :user
  #マイクロポスト１件につき１つまで写真を乗せられる。
  has_one_attached :image
  default_scope -> { order(created_at: :desc) } #投稿を新しい順で行う
  validates :user_id, presence: true #user_idが空ではないことをからならflaseを返す。
  validates :content, presence: true, length: { maximum: 140 } #contentが空でないそしてマックス140文字以内。
  validates :image,   content_type: { in: %w[image/jpeg image/gif image/png],
                                      message: "有効な画像なものを入力してください" },
                      size:         { less_than: 5.megabytes,
                                      message: "画像のサイズを5MBより小さくしてください" }
                                      

  # 表示用のリサイズ済み画像を返す
  def display_image
    image.variant(resize_to_limit: [500, 500])
  end
end
