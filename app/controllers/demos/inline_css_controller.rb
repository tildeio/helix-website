module Demos
  class InlineCssController < ApplicationController
    before_action :prepare

    def create
      @inlined = InlineCSS.inline(@html, @css)
      render :show
    end

    private
    def prepare
      @html = params[:html] || <<~HTML
        <p class="note">NOTE</p>
        <p class="warn">WARNING</p>
      HTML

      @css = params[:css] || <<~CSS
        p.note {
          color: yellow;
        }

        p.warn {
          color: orange;
        }
      CSS
    end
  end
end
