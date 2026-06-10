class CpfValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.blank?

    digits = value.to_s.gsub(/\D/, "")
    return if valid_cpf?(digits)

    record.errors.add(attribute, options[:message] || "não é válido")
  end

  private

  def valid_cpf?(digits)
    return false unless digits.match?(/\A\d{11}\z/)
    return false if digits.chars.uniq.length == 1

    first_check = cpf_check_digit(digits, 9)
    second_check = cpf_check_digit(digits, 10)

    digits[9].to_i == first_check && digits[10].to_i == second_check
  end

  def cpf_check_digit(digits, position)
    sum = (0...position).sum { |index| digits[index].to_i * (position + 1 - index) }
    remainder = (sum * 10) % 11
    remainder == 10 ? 0 : remainder
  end
end
