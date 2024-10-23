module UsersHelper
  def gravatar_for(user, options = { size: 20 })
    gravatar_url = "https://cdn.pixabay.com/photo/2021/11/12/03/04/woman-6787784_1280.png"
    image_tag(gravatar_url, size: 30, alt: user.name, class: "gravatar")
  end
end
