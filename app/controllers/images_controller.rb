class ImagesController < ApplicationController
  # GET /images
  def index
    # Can be improved by using a pagination, caching warm up and
    # faster json serializer (for example, jsonapi-serializer but this will need to use a different json
    # format for the response)
    @images = Image.includes(:user).joins(:user).find_each(batch_size: 50_000)
  end

  # GET /images/1/download
  def download
    @image = Image.find_by(id: params[:id])

    if @image&.compressed?
      redirect_to @image.download_url, allow_other_host: true, status: :ok
    else
      head :not_found
    end
  end

  # POST /images/compress
  def compress
    user = User.find_by(id: image_params[:user_id])

    if user
      image = user.images.create(status: :uploaded)

      # can be improved by uploading to S3 directly from the client which is preferable way accoding to AWS docs
      image_url = ::UploadFileToS3Service.call(image_params[:file])

      compress_image_async(image.id, image_url)
      head :ok
    else
      no_user_error
    end
  end

  private

  # Only allow a list of trusted parameters through.
  def image_params
    params.require(:image).permit(:user_id, :file)
  end

  def no_user_error
    render json: { error: 'User does not exist' }, status: :unprocessable_entity
  end

  def compress_image_async(image_id, image_url)
    CompressJob.perform_async({ image_id:, image_url: }.stringify_keys)
  end
end
