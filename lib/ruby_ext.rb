# A couple of Ruby extensions

class Date
  # Returns the date formatted with the format defined in Serious.date_format
  # and extended with the %o flag for ordinal day names.
  def formatted
    strftime(Serious.date_format.gsub("%o", day.ordinal))
  end
end

class Fixnum
  # Taken from toto
  def ordinal
    # 1 => 1st
    # 2 => 2nd
    # 3 => 3rd
    # ...
    case self % 100
      when 11..13; "#{self}th"
    else
      case self % 10
        when 1; "#{self}st"
        when 2; "#{self}nd"
        when 3; "#{self}rd"
        else "#{self}th"
      end
    end
  end
end

class String
  def slugize
    self.downcase.gsub(/[^a-z0-9\-]/, '-').squeeze('-').gsub(/^\-/, '').gsub(/\-$/, '')
  end
end
