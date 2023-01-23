require 'rails_helper'

RSpec.describe ImagesController do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/images').to route_to('images#index')
    end

    it 'routes to #download' do
      expect(get: '/images/1/download').to route_to('images#download', id: '1')
    end

    it 'routes to #compress' do
      expect(post: '/images/compress').to route_to('images#compress')
    end
  end
end
