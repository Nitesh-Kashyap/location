class CopyLocationJob < ApplicationJob
  queue_as :urgent

  def perform(location_id, user_id)
    location = Location.find_by(id: location_id)
    copy_location = location.dup
    copy_location.name = copy_location.name.prepend('Copy of ')
    copy_location.user_id = user_id
    location.image.each do |i|
      copy_location.image.attach \
      :io           => StringIO.new(i.download),
      :filename     => i.filename,
      :content_type => i.content_type
    end
    copy_location.save
  end
end
