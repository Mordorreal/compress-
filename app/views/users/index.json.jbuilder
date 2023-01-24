json.users do
  json.array! @users do |user|
    json.id user.id
    json.email user.email

    json.images do
      json.array! user.images, cache: true do |image|
        json.id image.id
        json.status image.status
        json.download_url image.download_url
      end
    end
  end
end
