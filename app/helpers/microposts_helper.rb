module MicropostsHelper
  def current_user_react(micropost, user, type = 'love')
    return false if micropost.nil?
    current_react = micropost.reactions.find_by(user_id: user.id)
    return true if !current_react.nil? && current_react.reaction_type == type
  end
end

