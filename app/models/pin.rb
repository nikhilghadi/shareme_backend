
SEARCH_ATTRS = %i[name about category ]

class Pin < ApplicationRecord
  scope :search_query, lambda { |query| self.class.search(query) }


  belongs_to :user
  has_many :comments, as: :commentable

  def self.search(search)
    results = []
    SEARCH_ATTRS.each do |attr|
      results += self.where("#{attr} ILIKE ?", search.to_s).includes(:user).map{|a| a.as_json.merge({user_info:a.user,path:a.get_url})}
    end
    return results
  end

  def upload_pin(main_path,path,file_name)
    s3 = Aws::S3::Resource.new
    b = s3.bucket('shareme-images')
    b.object('images'+main_path+file_name).upload_file(path)
  end
  
  def get_url
    signer = Aws::S3::Presigner.new
    url, headers = signer.presigned_request(
      :get_object, bucket: "shareme-images", key: self.path
    )
    url
  end

end
