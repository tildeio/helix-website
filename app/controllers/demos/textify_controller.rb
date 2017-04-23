module Demos
  class TextifyController < ApplicationController
    before_action :prepare

    def create
      case params[:mode]
      when "widen"
        @widen_text = TextTransform.widen(@widen_text)
        @widened = true
      when "narrowen"
        @widen_text = TextTransform.narrowen(@widen_text)
        @widened = false
      when "flip"
        @flip_text = TextTransform.flip(@flip_text)
      end

      render :show
    end

    private

    def prepare
      @widen_text = params[:widen_text] || "Hello world!"
      @widened = !!params[:widened]

      @flip_text = params[:flip_text] || "ZOMG whattt"
    end
  end
end
