module MicropostsHelper
  def current_user_react(micropost, user, type = 'love')
    return false if micropost.nil?
    current_react = micropost.reactions.find_by(user_id: user.id)
    true if !current_react.nil? && current_react.reaction_type == type
  end

  def active_reaction_class(micropost, user)
    %w(love sad angry).find { |reaction| current_user_react(micropost, user, reaction) } || ''
  end

  def active_reaction_text(micropost, user)
    %w(Love Sad Angry).find { |reaction| current_user_react(micropost, user, reaction.downcase) }
  end

  def reaction_icon(reaction)
    case reaction
    when 'love' then 'grin-hearts'
    when 'sad' then 'frown'
    when 'angry' then 'angry'
    end
  end
end


