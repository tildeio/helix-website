module Demos
  class LinePointController < ApplicationController

    def create
      @p1 = Point.new(params[:x1].to_f, params[:y1].to_f)
      @p2 = Point.new(params[:x2].to_f, params[:y2].to_f)
      @line = @p1.join(@p2)

      render :show
    end

  end
end
