# frozen_string_literal: true

# Base class for ViewComponent previews
class ComponentPreview < ViewComponent::Preview
  # Return examples list with 'default' at the beginning so that it always
  # comes first as it is the...default
  def self.examples
    super.sort_by { |example| [example == 'default' ? 0 : 1, example] }
  end

  def self.preview_source(example) # rubocop:disable Metrics/AbcSize
    source = instance_method(example.to_sym).source.split("\n")
    return '' if source.size < 2

    method_body = source[1...(source.size - 1)]
    return '' if method_body.nil? || method_body.empty?

    min_indent = method_body.map { |line| line.match(/^\s*/)[0].length }.min
    cleaned_lines = method_body.map { |line| line[min_indent..] || line }

    cleaned_lines.map do |line|
      line.gsub(/render\s*\(/, 'render ')
    end.join("\n")
  end
end

