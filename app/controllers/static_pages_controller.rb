class StaticPagesController < ApplicationController
  def test
    render json: {
      Hahah: "oke"
    }
  end

  def home
  end
end
