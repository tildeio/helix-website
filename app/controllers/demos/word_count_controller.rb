module Demos
  class WordCountController < ApplicationController
    before_action :prepare
    skip_before_action :verify_authenticity_token

    def create
      if @dataset == 'upload' && create_params[:upload]
        path = create_params[:upload].path
      elsif @dataset == 'default'
        path = File.expand_path("../../../../public/shakespeare-plays.csv", __FILE__)
      else
        @dataset = nil
      end

      if path
        meth = @method == 'ruby' ? :ruby_search : :search
        start = Time.now
        @word_count = WordCount.send(meth, path, create_params[:search])
        @elapsed_time = Time.now - start
      end

      render :show
    end

    private

      def create_params
        params.permit('dataset', 'upload', 'search', 'method')
      end

      def prepare
        @allow_pure_ruby = Rails.env.development? || ENV['PURE_RUBY_WORD_COUNT']
        @dataset = create_params[:dataset] || 'default'
        @search = create_params[:search]
        @method = create_params[:method] == 'ruby' && @allow_pure_ruby ? 'ruby' : 'helix'
      end

  end
end
