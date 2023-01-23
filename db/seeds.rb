# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

puts 'Start seeding...'
start_time = Time.now

User.create!(email: Faker::Internet.unique.email) until User.count == 2

User.find_each do |user|
  puts "Start to prepare images for user: #{user.id}.."
  time = Time.now.getutc

  Image.copy_from_client %i[
                           status
                           download_url
                           user_id
                           created_at
                           updated_at
                         ] do |copy|
    1_000_000.times do
      copy << [
        Image.statuses.values.sample,
        'https://example.com/image.jpg',
        user.id,
        time,
        time,
      ]
    end
  end

  puts "1 000 000 images copied for user: #{user.id}..."
end

puts "Seeding finished in #{Time.now - start_time} seconds."
