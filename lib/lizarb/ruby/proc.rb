# frozen_string_literal: true

class Proc
  def relative_source
    absolute_source
      .sub("#{Lizarb.app_dir}/", "")
      .sub("#{Lizarb.root}/", "")
  end

  def absolute_source
    sl = source_location
    "#{sl[0]}:#{sl[1]}"
  end
end
