# frozen_string_literal: true

module ValidateAssertions
  attr_writer :subject

  def assert_valid(attrs = {})
    return assert_validation_errors([], attrs) if attrs.present?

    subject.validate

    assert_empty subject.errors.full_messages
  end

  def assert_invalid(*message, attrs)
    assert_validation_errors(message, attrs)
  end

  private

  def subject(attrs = {})
    @subject ||= build_subject(attrs)
  end

  def build_subject(attrs = {})
    subject_class.new(attrs)
  end

  def subject_class
    self.class.name.gsub(/Test\z/, '').constantize
  end

  def assert_base_invalid(*messages, attrs)
    subject.attributes = attrs
    subject.validate

    assert_equal messages, subject.errors[:base]
  end

  def assert_validation_errors(messages, attrs)
    subject.attributes = attrs
    subject.validate

    attrs.each_key do |attribute_name|
      assert_equal messages, subject.errors[attribute_name]
    end
  end
end
