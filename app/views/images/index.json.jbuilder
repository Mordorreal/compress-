json.images do
  json.array! @images, cache: true do |image|
    json.id image.id
    json.status image.status
    json.download_url image.download_url

    json.user do
      json.id image.user.id
      json.email image.user.email
    end
  end
end
