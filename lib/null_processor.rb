class NullProcessor
  def initialize(*args)
    Rails.logger.warn "NullProcessor called with #{args.inspect}, please implement a processor for this"
  end

  def work
  end
end
