json.array! @users.each do |user|
  json.id user.id
  json.name "#{user.first_name} #{user.last_name}"
end