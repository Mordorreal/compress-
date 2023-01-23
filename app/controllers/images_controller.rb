class ImagesController < ApplicationController
  # GET /images
  def index
    # Can be improved by using a pagination and caching warm up but this is not in requirements
    @images = []
    Image
      .includes(:user)
      .joins(:user)
      .find_each(batch_size: 50_000) { |image| @images << image }
  end

  # GET /images/1/download
  def download
    @image = Image.find(params[:id])

    if @image.compressed?
      redirect_to @image.download_url, format: json, status: :ok
    else
      head status: :not_found
    end
  end

  # POST /images/compress
  def compress
    CompressJob.perform_later(image_params)
    head status: :ok
  end

  private

  # Only allow a list of trusted parameters through.
  def image_params
    params.require(:image).permit(:user_id, :file)
  end
end
