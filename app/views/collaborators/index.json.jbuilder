json.array! @collaborators.each do |collaborator|
  json.id collaborator.id
  json.name "#{collaborator.first_name} #{collaborator.last_name}"
end