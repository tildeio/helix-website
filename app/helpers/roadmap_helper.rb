module RoadmapHelper
  def progress_bar(done, total)
    percentage = done * 100.0 / total

    content_tag :div, class: "progress-bar-container" do
      content_tag :div, class: "progress-bar", style: "width: #{number_to_percentage(percentage)}" do
        number_to_percentage(percentage, precision: 0)
      end
    end
  end
end
